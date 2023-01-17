
using Images, Colors

neighbor_translation = [1 => [-1, 0], 2 => [0, 1], 3 => [1, 0], 4 => [0, -1], ]

image_name_modifier = 0
file_path = "/Users/michal/Documents/100daysofalgorithms/images_79"
file_name = "maze_solution_$image_name_modifier.png"

function save_image(maze)
    image_name_modifier += 1
    save("$file_path/$file_name", maze)
end

function fill_dead_end(maze, point, next=[0, 0], val=1)
    maze[point[1], point[2]] = val
    next_point = point .+ neighbor_translation[next]
    val = fetch_next_tile(maze[next_point[1], next_point[2]])
    if val != 0
        # dead end, so we fill
        # we first save an image of the maze so far
        save_image(maze)
        return fill_dead_end(maze, [i, j], val)
    end
    
    # if it's not a dead end, then we are done for this path
end

function fetch_next_tile(maze, point) 
    neighbors = [maze[i-1, j], maze[i, j+1],  maze[i+1, j],  maze[i, j-1]]
    empty_fields = count(i-> (i == 0), neighbors)
    if empty_fields != 1
        return 0
    end

    # we know that the number of zeros is 1, so we can find it with a simple argmin
    return argmin(neighbors)
end

function dead_end_filling(maze, endpoints)
    m, n = size(maze)

    for i in 1:m:
        for j in 1:n:
            # including all those fields that are empty spaces
            if maze[i, j] == 0
                # we fetch his neighbors
                val = fetch_next_tile(maze[point[1], point[2]])
                if val != 0
                    # dead end. We fill
                    fill_dead_end(maze, [i, j], val)
                end
            end
        end
    end
    
    # Now we simply fill in the remaining path
    return fill_dead_end(maze, endpoints[1], val=RGB(1,0,0))
end
