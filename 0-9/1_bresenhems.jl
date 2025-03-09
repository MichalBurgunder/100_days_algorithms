# BRESENHEMS LINE ALGORITHM

using Images

function bresenhems_line_algorithm(start_point, end_point) 
    # we disattach the x and from the points inrder to do calculations on them separately
    sx, sy = start_point
    ex, ey = end_point

    # for starters, we would like to standardize our line drawing, so that we are drawing the line from left to right. This will make the line drawing standardized as well. Clearly is doesn't really matter in what direction we choose to go, i.e. we could go from bottom to top, left to right. If we choose a direction however, and modify the starting points appropriately, we can imagine the process easier, and then simply modify the coordinates appropriately, before coloring them. 

    # first, we are going to make sure that our line is going more right than it is going up or down. To do, we need the "rise" and "run" or our line
    dx = ex - sx
    dy = ey - sy

    # we remember this variable in order to determine whether to make the swap when we add each point. This operation just reflects the axes, such that each x is now a y, each y is now an x, i.e. we are going from. We can also imagine "swapping" the x and y axes with each other
    steep = abs(dy) > abs(dx)

    if steep
        sx, sy = sy, sx
        ey, ex = ex, ey
    end

    # now we check whether the line is going from top to botton, and if not, we simply swap the start and end points. Recall that images, by convention, have their (0,0) point in the top left corner, and the positive, e.g (50,50), bottom-right. Note also, that this does not change what line will be drawn, but in what order. This can make a tiny difference depending on the application, although this is just a minor detail
    swap = false
    if sx > ex
        sx, ex = ex, sx
        sy, ey = ey, sy
        swap = true
    end

    # we recalculate the dy and dx of the new corrdinate system
    dx = ex - sx
    dy = ey - sy

    # we also calculate an error. Note, that if the points were separated at an exact 45 degree angle.
    error = Int(round(dx / 2.0))
    ystep = sy < ey ? 1 : -1

    # we set our beginning y point, and initialize an array where we will deposit all of the points that we wish to draw. The first point will always be included 
    y = sy
    pixels = []

    # finally comes the key point of the algorithm. As every line we could possibly have is moving faster to the right than vertically up or down, we know that there will always be a single point to connect a left part of the line with the right one, which is either 1) directly to the right, or 2) to the right and one up/down. If this weren't the case (e.g. if you go up twice), then we would see a steep line, which, given our previous processing, excludes this possibility. In other words, for every x, we check which of the two possiiblities we must choose. This is done using the "error" variable
    for x in range(sx, ex + 1)
        push!(pixels, steep ? (y, x) : (x, y))

        # given the ratios of x and y, we know if its one right, or one right + vertical. We subtract the dy for every step until we are below 0, i.e. until we have gone to the right by the same proportion of x as exists on y.
        error -= abs(dy)

        # whether we do a strict smaller than operator, is a minor detail, that makes a difference, albeit a very small one. 
        if error < 0
            y += ystep
            error += dx
        end
    end

    # if the coordinates were swapped, we reverse the array 
    if swap
        reverse(pixels)
    end

    return pixels
end

function resize(matrix, multiplier)
    m, n = size(matrix)
    new_matrix = Array{Bool}(undef, multiplier*m, multiplier*n)

    for i in 0:m-1
        for new_row in 1:multiplier
            for j in 0:n-1
                for new_column in 1:multiplier
                    new_matrix[i*multiplier+new_row, j*multiplier+new_column] =
                                                                matrix[i+1, j+1]
                end
            end
        end 
    end
    return new_matrix
end

function insert_points(matrix, points)
    for i in range(1, size(points)[1])
        matrix[points[i][1],points[i][2]] = 0
    end
end

function save_image(matrix_naive, size_multiplier)
    path_to_image = "/Users/michal/Documents/100daysofalgorithms/0-9/bresenhams_demo.png"
    mat_to_save = resize(matrix_naive, size_multiplier)
    save(path_to_image, mat_to_save)
end

matrix = ones(Int, (100,100))

points = bresenhems_line_algorithm((2,87), (97,12))

insert_points(matrix, points)
save_image(matrix, 5)
