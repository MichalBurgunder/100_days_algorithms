struct Point
    x::Float64
    y::Float64
    mass::Int64
end

mutable struct QuadTree
    squares::Dict{String, Union{QuadTree, Nothing}}
    point::Union{Point, Nothing}

    width::Int64
    height::Int64

    v_start::Int64
    h_start::Int64


end

squares = ["ul", "ur", "dl", "dr"]

function barycenter(quad::QuadTree)
    # println(quad.point)
    if quad.point == nothing
        return
    end
    top = [0, 0]
    bot = 0
    for i in 1:length(squares)
        # println(quad.squares[squares[i]])
        if quad.squares[squares[i]] != nothing
            barycenter(quad.squares[squares[i]])

            if quad.squares[squares[i]].point != nothing
                position = [quad.squares[squares[i]].point.x, quad.squares[squares[i]].point.y]
                println("in here")
                println("------")
                println(quad.squares[squares[i]].point.x)
                println(quad.squares[squares[i]].point.y)
                println(quad.squares[squares[i]].point.mass)
                println("------")
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
    # println("---")
    # println(top)
    # println(bot)
    # println(position, bot)
    # println("---")
    quad.point = Point(position[1], position[2], bot)
    return quad.point
end


function get_lr(quad::QuadTree, point::Point)
    if point.x < quad.width/2
        return "l"
    else
        return "r"
    end
end

function get_ud(quad::QuadTree, point::Point)
    if point.y < quad.height/2
        return "d"
    else
        return "u"
    end
end

function insert(quad::QuadTree, point::Point)
    if quad.point == nothing
        quad.point = point
        return
    else

        # v_start, h_start = get_start_numbers(quad)
        v_start, h_start = quad.v_start, quad.h_start

        # create vector for dictionaries
        vec = Vector{Dict}()

        for i in 0:4
            push!(vec, Dict{String, Union{QuadTree, Nothing}}(
                "ul" => nothing,
                "ur" => nothing,
                "dl" => nothing,
                "dr" => nothing
                )
            )
        end

        plane = Dict{String, Union{QuadTree, Nothing}}(
            "ul" => QuadTree(vec[1], nothing, width/2, height/2, quad.v_start, quad.h_start),
            "ur" => QuadTree(vec[2], nothing, width/2, height/2, quad.v_start, quad.h_start+quad.width/2),
            "dl" => QuadTree(vec[3], nothing, width/2, height/2, quad.v_start+quad.height/2, quad.h_start, ),
            "dr" => QuadTree(vec[4], nothing, width/2, height/2, quad.v_start+quad.height/2, quad.h_start+quad.width/2, )
        )

        new_quad = QuadTree(plane, nothing, width/2, height/2, quad.h_start, quad.v_start)

        # quad 
        ud_q = get_ud(quad, quad.point)
        lr_q = get_lr(quad, quad.point)
        
        quad.squares[ud_q*lr_q] = new_quad
        quad.squares[ud_q*lr_q].point = quad.point

        ud = get_ud(quad.squares[ud_q*lr_q], point)
        lr = get_lr(quad.squares[ud_q*lr_q], point)

        insert(new_quad.squares[ud*lr], point)
    end
end

# function compute_barycenters(quad::QuadTree)
    
#     for i in length(squares)
#         if 
#     end
# end
insert(q::QuadTree) = insert(q)
# barycenter(q::QuadTree) = barycenter(q)

# ----------------------------------------------------
width = 100
height = 100

plane = Dict{String, Union{QuadTree, Nothing}}(
    "ul" => nothing,
    "ur" => nothing,
    "dl" => nothing,
    "dr" => nothing
)
quad = QuadTree(plane, nothing, height, width, 0, 0)

# Create a new points
p = Point(20, 20, 20)
p2 = Point(20, 80, 20)
insert(quad, p)
insert(quad, p2)

# now let's calculate all barycenters
barycenter(quad)

println(quad.point.x)
println(quad.point.y)
println(quad.point.mass)
# compute the forces acting on every single point, and create new points out of them

# save as into a gif. Repeat

# https://jheer.github.io/barnes-hut/