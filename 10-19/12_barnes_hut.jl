using Plots

struct Point
    x::Float64
    y::Float64
    mass::Float64
end

get_x(p) = p.x
get_y(p) = p.y

# will denote those trees that have not been initialized yet
block_point = Point(-1,-1,-1)
G = 6.674*10^(-1) # gravitational constant


mutable struct QuadTree
    squares::Dict{String, Union{QuadTree, Nothing}}
    point::Union{Point, Nothing}

    width::Float64
    height::Float64

    v_start::Float64
    h_start::Float64

    barycenter::Point
end

plane_base = Dict{String, Union{QuadTree, Nothing}}(
    "ul" => nothing,
    "ur" => nothing,
    "dl" => nothing,
    "dr" => nothing
)

squares = ["ul", "ur", "dl", "dr"]

function barycenter(quad::Union{QuadTree, Nothing})
    # when a quad tree has not even been intizialized
    if isnothing(quad)
        return nothing
    end

    # this is when a quad tree has not been used
    if isnothing(quad.point)
        return true
    end

    top = float.([0, 0])
    bot = 0
    for i in eachindex(squares)
        if isnothing(quad.squares[squares[i]])
            # println("HERE")
            continue
        end

        barycenter(quad.squares[squares[i]])
        println(quad.squares[squares[i]].barycenter)
        println(quad.squares[squares[i]].point)
        if quad.squares[squares[i]].barycenter.x != -1
            position = [quad.squares[squares[i]].barycenter.x, quad.squares[squares[i]].barycenter.y]
            top[1] += position[1] * quad.squares[squares[i]].barycenter.mass
            top[2] += position[2] * quad.squares[squares[i]].barycenter.mass
            bot += quad.squares[squares[i]].barycenter.mass
        end
    end

    # if none of the squares has any quad trees, we simply use the point
    if bot == 0
        # println("setting barycenter")
        quad.barycenter = quad.point
        return quad.point
    end

    position = top / bot
    # println("setting barycenter 2")
    quad.barycenter = Point(position[1], position[2], bot)
    return quad.barycenter
end


function get_lr(quad::QuadTree, point::Point)
    if point.x < quad.h_start + quad.width/2
        return "l"
    else
        return "r"
    end
end

function get_ud(quad::QuadTree, point::Point)
    if point.y < quad.v_start + quad.height/2
        return "d"
    else
        return "u"
    end
end

function get_bounding_box(quad::QuadTree, ud::String, lr::String)
    start_ud = ud == 'u' ? quad.v_start : quad.v_start+quad.height/2
    start_lf = lr == 'l' ? quad.h_start : quad.h_start+quad.width/2

    width = quad.width/2
    height = quad.height/2
    return [width, height, start_ud, start_lf]
end

function set_new_quad_tree(quad::QuadTree, point::Point, ud::String,lr::String)
    box = get_bounding_box(quad, ud, lr)
    empty_dict = copy(plane_base)

    quad.squares[ud*lr] = QuadTree(empty_dict, nothing, box[1], box[2], box[3], box[4], block_point)
    println("inserting into new quad tree")
    quad.squares[ud*lr].point = point
end

# l = 0
function insert(quad::QuadTree, point::Point)
    # very first point
    # If the quad tree does not include a point and the point parameter, it means
    # that the point can be placed here, instead of having to recurse downwards.
    if isnothing(quad.point)
        # println("inserting into nothing")
        # println(point)
        quad.point = point
        return true
    end

    # otherwise, we will need to create a new quad tree to accommodate our new point
    # we first decide where in the current quad tree the upper point must go into, by
    # getting each letter of the current point in the wuad tree
    ud_p = get_ud(quad, point)
    lr_p = get_lr(quad, point)

    println(ud_p*lr_p)
    # we check if the sub tree already exists. If it doesn't, we place it there
    if isnothing(quad.squares[ud_p*lr_p])
        # println("setting new tree")
        set_new_quad_tree(quad, point, ud_p, lr_p)
        return
    else
        # otherwise, we need to recurse into the next quad tree to do the same procedure
        # println("recurse")
        # println(point)
        insert(quad.squares[ud_p*lr_p], quad.point)
    end

    ud = get_ud(quad, point)
    lr = get_lr(quad, point)

    if isnothing(quad.squares[ud*lr])
        # println(point)
        set_new_quad_tree(quad, point, ud, lr)
        return
    else
        # println("recurse there")
        # println(point)
        insert(quad.squares[ud*lr], point)
    end

    # global l -= 1
    # if l = 100
    #     print("l: $l")
    #     exit()
    # end
end

function euclidean_dis(p1, p2)
    return sqrt((p1.x - p2.x)^2 + (p1.y - p2.y)^2)
end

function attractive_force(p1::Point, p2::Point, dis::Float64)
    # normalize distances for x and y for unit vector
    # println(p1)
    # println(p2)
    x = (p2.x - p1.x)/dis
    y = (p2.y - p1.y)/dis

    # Newton's law of gravitation
    force = (G * p1.mass * p2.mass)/(dis^2)
    # println(force)
    # println([force*x, force*y])
    # exit()
    return [force*x, force*y]
end

function is_in_quadtree(quadTree::QuadTree, point::Point)
    return (quadTree.v_start < point.y && ((quadTree.v_start + quadTree.height) > point.y) &&
            quadTree.h_start < point.x && ((quadTree.h_start + quadTree.width) > point.x))
end

function smartprint(setter, val)
    if setter == true
        println("smartprint: $val")
    end
end
function compute_forces(points::Array{Point}, quadTree::QuadTree, threshold::Float64)
    forces_points = []
    for p in eachindex(points)
        println("computing point $p")
        sum_forces = [0.0, 0.0]
        # if p == 3 && setter == false
        #     setter = true
        # end
        # println("here: $p")
        # println(squares)
        distance = euclidean_dis(points[p], quadTree.barycenter)

        if distance < threshold
            # println(i)
            force = attractive_force(points[p], quadTree.barycenter, distance) 

             sum_forces[1] += force[1][1]
             sum_forces[2] += force[1][2]
             push!(forces_points, sum_forces)
            continue
        end

        
        for i in eachindex(squares)
            # we make sure that the quad tree has been initialized
            if isnothing(quadTree.squares[squares[i]])
                println("isnothing")
                continue
            end

            distance = euclidean_dis(points[p], quadTree.squares[squares[i]].barycenter)

            print(distance)
            if distance == 0
                continue
            end
            if distance < threshold # && !is_in_quadtree(quadTree, quadTree.point)
                # we split the tree, and recurse into this tree
                # println(setter, "----")
                # println(i, setter, distance)
                # println("GOING IN")
                # println(i)
                force = compute_forces([points[p]], quadTree.squares[squares[i]], threshold)
                # println(p, force)
                #  println(force)
                #  println(i)
                 sum_forces[1] += force[1][1]
                 sum_forces[2] += force[1][2]

            else
                # block point means there is no point there
                if quadTree.squares[squares[i]].barycenter.x != -1
                    force = attractive_force(points[p], quadTree.squares[squares[i]].barycenter, distance) 
                    # println(i)
                    # println(i, "RIGHT HERE MY FRIEND")
                    # println("lalallaa")
                    # println(points[p])
                    # println(quadTree.squares[squares[i]].barycenter)
                    # println(force)
                    # println(i)
                    # println(p, force)
                    sum_forces[1] += force[1]
                    sum_forces[2] += force[2]
                end 
            end
        end

        push!(forces_points, sum_forces)
    end

    return forces_points
end

function simulate_movement(points, forces)
    new_points = Point[]
    for i in eachindex(points)
        new_point = Point(points[i].x + forces[i][1], points[i].y + forces[i][2], points[i].mass)
        push!(new_points, new_point)
    end
    return new_points
end

function add_forces(forces, new_forces)
    for i in eachindex(forces)
        # println(forces[i])
        # println(new_forces[i])
        forces[i] += new_forces[i]
    end
    return forces
end
# ----------------------------------------------------
size = 100

number_of_simulation_iterations = 1
width = size
height = size
theta = size/2

plane_base = Dict{String, Union{QuadTree, Nothing}}(
    "ul" => nothing,
    "ur" => nothing,
    "dl" => nothing,
    "dr" => nothing
)


# Create a new points
p1 = Point(20, 80, 20)
p2 = Point(20, 70, 20)
p3 = Point(90, 80, 20)
p4 = Point(40, 10, 20)


temp_quad_tree = nothing
temp_points = [p1, p3]
temp_forces = [[0.0, 0.0] for i in eachindex(temp_points)]
points_of_points = []

for i in eachindex(1:number_of_simulation_iterations)
    global temp_points
    global temp_quad_tree
    global temp_forces
    # println(plane_base)
    # exit()
    println("iteration: $i")
    # println(block_point)
    temp_quad_tree = QuadTree(copy(plane_base), nothing, width, height, 0, 0, block_point)
    # println("1")
    # println(length(temp_points))
    for j in eachindex(temp_points)
        if temp_points[j].x > 100 || temp_points[j].y > 100
            println("out of bounds. exiting")
            exit()
        end
        # println("inserting $j")
        insert(temp_quad_tree, temp_points[j])
    end
    # println(temp_quad_tree.point)
    # println(temp_quad_tree.squares["ur"].point)
    # exit()
    # gif(anim, "tutorial_anim_fps30.gif", fps = 30)
    # now let's calculate all barycenters
    barycenter(temp_quad_tree)
    # println("2")
    # compute the forces acting on every single point, and create new points out of them
    forces = compute_forces(temp_points, temp_quad_tree, theta)

    temp_forces .+= forces 
    # println("3")
    # WE ARE HERE
    # we apply the forces on our points, so we get a new set of points
    temp_points = simulate_movement(temp_points, temp_forces)
    # println("temp_points")
    println(temp_points)
    exit()
    push!(points_of_points, (map(get_x, temp_points), map(get_y, temp_points)))
    # println("at end of loop")
    # println(i)
end

println("made it")
# println(points_of_points)
println(points_of_points[1])
# println(points_of_points[1])

anim = @animate for i = 1:number_of_simulation_iterations
    # println(points_of_points)
    scatter(points_of_points[i][1], points_of_points[i][2], legend=false, )
    xlims!(0, 100)
    ylims!(0, 100)
end

gif(anim, "barnes_hut_1.gif", fps = 15)

# for i in 1:eachindex(new_points)
#     insert(new_quad_tree, new_points[i])
# println(forces)
# save as into a gif. Repeat

# https://jheer.github.io/barnes-hut/