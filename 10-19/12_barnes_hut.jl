struct Point
    x::Float64
    y::Float64

    # w::Union(Int8
end



mutable struct QuadTree
    squares::Dict{String, Union{QuadTree, Nothing}}
    point::Union{Point, Nothing}

    width::Int8
    height::Int8

    v_start::Int8
    h_start::Int8

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
        println(quad)
        println(quad.point)
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

insert(q::QuadTree) = insert(q)

# ----------------------------------------------------
width = 100
height = 100

# plane = Dict{String, Union{QuadTree, Nothing}}(
#     "ul" => QuadTree(nothing, nothing, width/2, height/2, 0, 0),
#     "ur" => QuadTree(nothing, nothing, width/2, height/2, width/2, 0),
#     "dl" => QuadTree(nothing, nothing, width/2, height/2, 0, height/2),
#     "dr" => QuadTree(nothing, nothing, width/2, height/2, width/2, height/2)
# )
plane = Dict{String, Union{QuadTree, Nothing}}(
    "ul" => nothing,
    "ur" => nothing,
    "dl" => nothing,
    "dr" => nothing
)
quad = QuadTree(plane, nothing, height, width, 0, 0)

# Create a new
p = Point(33, 55)
p2 = Point(33, 80)
insert(quad, p)
insert(quad, p2)

# https://jheer.github.io/barnes-hut/