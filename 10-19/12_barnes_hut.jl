struct Point
    x::Float64
    y::Float64
end

struct QuadTree
    nw::Union{Point, Nothing}
    ne::Union{Point, Nothing}
    sw::Union{Point, Nothing}
    se::Union{Point, Nothing}
end

test(p::QuadTree) = println("test")

p = QuadTree(nothing, nothing, nothing, nothing)

# Create a new
test(p)
