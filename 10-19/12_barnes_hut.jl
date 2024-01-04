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
end

squares = ["ul", "ur", "dl", "dr"]

function barycenter(quad::QuadTree)
    if quad.point == nothing
        return true
    end
    top = float.([0, 0])
    bot = 0
    for i in eachindex(squares)
        if quad.squares[squares[i]] != nothing
            barycenter(quad.squares[squares[i]])

            if quad.squares[squares[i]].point != nothing
                position = [quad.squares[squares[i]].point.x, quad.squares[squares[i]].point.y]
                top[1] += position[1] * quad.squares[squares[i]].point.mass
                top[2] += position[2] * quad.squares[squares[i]].point.mass
                bot += quad.squares[squares[i]].point.mass
            end
        end
    end

    if bot == 0
        return quad.point
    end

    position = top / bot
    quad.point = Point(position[1], position[2], bot)
    return quad.point
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
    empty_dict = Dict{String, Union{QuadTree, Nothing}}(
        "ul" => nothing,
        "ur" => nothing,
        "dl" => nothing,
        "dr" => nothing
        )
    quad.squares[ud*lr] = QuadTree(empty_dict, point, box[1], box[2], box[3], box[4])
    quad.point = block_point # an impossible point, so we block any processing here
end

l = 0
function insert(quad::QuadTree, point::Point)
    # very first point
    # println("in insert")
    if quad.point == nothing
        quad.point = point
        return true
    end

    ud_p = get_ud(quad, quad.point)
    lr_p = get_lr(quad, quad.point)

    if quad.point.mass != -1
        # println("quad.point")
        # println(quad.point)
        if quad.squares[ud_p*lr_p] == nothing
            # println("setting new tree")
            set_new_quad_tree(quad, quad.point, ud_p, lr_p)
        else
            # println("here")
            insert(quad.squares[ud_p*lr_p], quad.point)
        end
    end

    ud = get_ud(quad, point)
    lr = get_lr(quad, point)

    if quad.squares[ud*lr] == nothing
        set_new_quad_tree(quad, point, ud, lr)
    else
        # println("there")
        insert(quad.squares[ud*lr], point)
    end

    global l -= 1
end

function euclidean_dis(p1, p2)
    return sqrt((p1.x - p2.x)^2 + (p1.y - p2.y)^2)
end

function attractive_force(p1::Point, p2::Point, dis::Float64)
    # normalize distances for x and y for unit vector
    x = (p1.x + p2.x)/dis
    y = (p1.y + p2.y)/dis

    # Newton's law of gravitation
    force = (G * p1.mass * p2.mass)/(dis^2)
    return [force*x, force*y]
end

function compute_forces(points::Array{Point}, quadTree::QuadTree, threshold::Float64)
    forces_points = []
    for p in 1:length(points)
        sum_forces = [0.0, 0.0]
        for i in 1:length(squares)
            # we make sure that the quad tree has been initialized
            if quadTree.squares[squares[i]] == nothing
                continue
            end

            distance = euclidean_dis(points[p], quadTree.squares[squares[i]].point)
            if distance < threshold
                # we split the tree, and recurse into this tree
                 force = compute_forces([points[p]], quadTree.squares[squares[i]], threshold)

                 sum_forces[1] += force[1][1]
                 sum_forces[2] += force[1][2]

            else
                # block point means there is no point there
                if quadTree.point.x != -1
                    force = attractive_force(points[p], quadTree.squares[squares[i]].point, distance) 
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

# ----------------------------------------------------
size = 100

number_of_simulation_iterations = 14
width = size
height = size
theta = size/2

plane_base = Dict{String, Union{QuadTree, Nothing}}(
    "ul" => nothing,
    "ur" => nothing,
    "dl" => nothing,
    "dr" => nothing
)

plane = copy(plane_base)

quad = QuadTree(plane, nothing, width, height, 0, 0)

# Create a new points

p1 = Point(20, 80, 20)
p2 = Point(20, 70, 20)
p3 = Point(80, 80, 20)
p4 = Point(40, 10, 20)

points = [p1, p2, p3, p4]

# println("p1")
# insert(quad, p1)
# println("p2")
# insert(quad, p2)
# insert(quad, p3)
# insert(quad, p4)
# println("--------------------")
# # println(quad.squares["ul"])
# exit()

# println("p3")
# insert(quad, p3)

temp_quad_tree = nothing
temp_points = points
points_of_points = []

for i in eachindex(1:number_of_simulation_iterations)
    global temp_points
    global temp_quad_tree
    # println(temp_points)
    # exit()
    # println("iteration: $i")
    temp_quad_tree = QuadTree(copy(plane_base), nothing, width, height, 0, 0)
    # println("1")
    println(length(temp_points))
    for j in eachindex(temp_points)
        # println("1$j")
        # println(temp_points[j])
        insert(temp_quad_tree, temp_points[j])
    end
    # gif(anim, "tutorial_anim_fps30.gif", fps = 30)
    # now let's calculate all barycenters
    res = barycenter(temp_quad_tree)
    # println("2")
    # compute the forces acting on every single point, and create new points out of them
    forces = compute_forces(temp_points, temp_quad_tree, theta)
    # println("3")
    # WE ARE HERE
    # we apply the forces on our points, so we get a new set of points
    temp_points = simulate_movement(temp_points, forces)
    # println("4")
    push!(points_of_points, (map(get_x, temp_points), map(get_y, temp_points)))
    # println("at end of loop")
end

println("made it")

anim = @animate for i = 1:number_of_simulation_iterations
    scatter(points_of_points[i][1], points_of_points[i][2], legend=false, )
    xlims!(0, 100)  # Set the x-axis limits from 0 to 1
    ylims!(0, 100)
end

gif(anim, "barnes_hut_1.gif", fps = 30)

# for i in 1:eachindex(new_points)
#     insert(new_quad_tree, new_points[i])
# println(forces)
# save as into a gif. Repeat

# https://jheer.github.io/barnes-hut/