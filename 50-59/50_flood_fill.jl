
function get_neighboring_points(matrix, p, c)
    points_to_process = []
    # for each point we check if it is not on a boundary (p[1] != 1), before checking its color. If the color is the one we have selected, then we color it.

    # checking above
    if p[1] != 1 && getindex(matrix, p[1]-1, p[2]) == c
        push!(points_to_process, (p[1]-1, p[2]))
    end

    # checking to the left
    if p[2] != 1 && getindex(matrix, p[1], p[2]-1) == c
        push!(points_to_process, (p[1], p[2]-1))
    end

    # checking bottom
    if p[1] != size(matrix)[1] && getindex(matrix, p[1]+1, p[2]) == c
        push!(points_to_process, (p[1]+1, p[2]))
    end

    # checking to the right
    if p[2] != size(matrix)[2] && getindex(matrix, p[1], p[2]+1) == c
        push!(points_to_process, (p[1], p[2]+1))
    end

    # we return those points that are valid to check next
    return points_to_process
end

function inner_fill(p, matrix, new_color, old_color)    
    # very similar to flood_fill(), except that we now have an old_color.
    matrix[p[1], p[2]] = new_color
    
    # find new neihbors 
    new_points = get_neighboring_points(matrix, p, old_color)

    # fill new neighbors
    for point in new_points
        inner_fill(point, matrix, new_color, old_color)
    end
end

# 
function flood_fill(matrix, point, new_color)
    # first, we need to know which color we are filling in...
    old_color = getindex(matrix, point[1], point[2])
    # ...and we fill in the first pixel
    matrix[point[1], point[2]] = new_color

    # we check each neighbor of the pixel and see if it is the same color as the one that we have chosen to fill in. If so, we save its coordinates, in order to recursively fill it out.
    points = get_neighboring_points(matrix, point, old_color)

    # and now, we restart a more function on the new points. This is a stack-based implementation of flood-fill (instead of a queue), so that the image is filled out in rows/columns, instead of an expanding bubble. But this is just a detail.
    for point in points
        inner_fill(point, matrix, new_color, old_color)
    end

    return an_H
end

function print_matrix(matrix)
    for row in eachrow(matrix)
        println(row)
    end
end

# we give an example of an "image" that can be filed out. Given that a picture saved on a computer consists of only bits as below, we can trivially construct a .png, .jpg etc. image out of it. 
an_H = [
    0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0;
    0 0 1 0 0 1 0 0;
    0 0 1 0 0 1 0 0;
    0 0 1 1 1 1 0 0;
    0 0 1 0 0 1 0 0;
    0 0 1 0 0 1 0 0;
    0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0
]
print_matrix(an_H)
println("------------------------")
flood_fill(an_H, (1,1), 6) # we give a coordinate, and a subsequent new "color". We keep it simple by only using numbers, instead of the RGB class. 
print_matrix(an_H)

