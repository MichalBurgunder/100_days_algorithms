
using Pkg
# Pkg.add("Images")
# Pkg.add("Colors")
using Images, Colors, Dates, Images

neighbor_translation = [1 => [-1, 0], 2 => [0, 1], 3 => [1, 0], 4 => [0, -1], ]

the_path = "/Users/michal/Documents/100daysofalgorithms/70-79"
to_images = "/Users/michal/Documents/100daysofalgorithms/70-79/images"

file_name = "maze_solution"

times = []
function convert_to_RGB(maze, color=nothing)
    m, n = size(maze)
    new_maze = fill(RGB(0, 0, 0), m, n)

    for i in 1:m
        for j in 1:n
            new_maze[i, j] = RGB(maze[i, j], maze[i, j], maze[i, j])
        end
    end

    return new_maze
end

## STOPPED HERE
function resize(maze, new_size)
    m, n = size(maze)
    new_maze = Array{RGB}(undef, new_size*m, new_size*n)

    for i in 1:m
        for new_row in 0:new_size-1
            for j in 1:n
                for new_column in 0:new_size-1
                    new_maze[i+new_row, j+new_column] = maze[i, j]
                end
            end
        end 
    end

    return new_maze
end

function save_image(maze, rgb_val)
    the_time = Millisecond(now()).value
    push!(times, the_time)
    save_maze = resize(maze, 5)
    println(save_maze)
    save_maze = map(clamp01, save_maze)
    save("$to_images/$file_name-$the_time.png", save_maze)
end

function is_empty(field)
    return field.r == 0 && field.g == 0 && field.b == 0
end

function is_wall(field)
    return field.r == 1 && field.g == 1 && field.b == 1
end


function where_empty(maze, i, j)
    for next in 1:4
        q_empty = [i, j] .+ neighbor_translation[next]
        if is_empty(maze[q_empty])
            return  q_empty
        end
        return false
    end
end

function fill_dead_end(maze, i, j, val=RGB(1,1,1))
    # in order to get a visualization of how the algorithm fills out our maze,
    # we save an image of the current maze
    save_image(maze, val)

    maze[i, j] = val
    next_empty_field = where_empty(maze, i, j)

    if next_empty_field == false
        # there are no more fields to fill
        # we first save an image of the maze so far
        return fill_dead_end(maze, i, j, val)
    else    
        i, j = next_empty_field
        return fill_dead_end(maze, i, j, val)
    end
    
    # if it's not a dead end, then we are done for this path
end

function get_neighbors(maze, i, j)
    neighbors = [RGB(1,1,1), RGB(1,1,1), RGB(1,1,1), RGB(1,1,1)]
    m, n = size(maze)

    if i >= 2
        neighbors[1] = maze[i-1, j]
    end

    if j >= 2
        neighbors[4] = maze[i, j-1]
    end

    if i <= m-1
        neighbors[3] = maze[i+1, j]
    end

    if j <= n-1
        neighbors[2] = maze[i, j+1]
    end
    return neighbors
end

# checks if this tile is a dead end
function is_dead_end(maze, i, j) 
    neighbors = get_neighbors(maze, i, j)
    wall_fields = count(i -> (is_wall(i)), neighbors)

    if wall_fields >= 3 # for those maze points that are surrounded by 3+ walls
        return true
    end

    # we know that the number of zeros is 1, so we can find it with a simple argmin
    return false
end

# 
function fill_all_dead_ends(maze, coordinates)
    for coordinate in coordinates
        i, j = coordinate
        fill_dead_end(maze, i, j, RGB(1,0,0))
    end
end

function dead_end_filling(maze)
    # we will save our images in a folder. This creates this folder
    if !isdir(to_images)
        mkdir(to_images)
    end
    # we define the parameters of our maze, for easier processing
    m, n = size(maze)

    # here we save all dead ends that we will need to fill
    dead_ends = []

    for i in 1:m
        for j in 1:n
            # we only include those fields that are empty spaces and not walls
            if is_empty(maze[i, j])

                # if its an emoty space, we check its neighbors
                # dead ends will always have 3 walls, 4 walls if it isolated
                dead_end = is_dead_end(maze, i, j)

                # we place them in an intermediary array above. Technically, we
                # could start right away, although doing it this way makes it
                # clear what is happening.
                if dead_end == true
                    push!(dead_ends, [i, j])
                end
            end
        end
    end
    
    # with this, we can parallelize the dead end filling, and so, get a maze
    # that is only left with the solution
    fill_all_dead_ends(maze, dead_ends)

    # though the path is now visually clear, we color it green for even more
    # clarity, and save it
    fill_dead_end(maze, 1, 1, RGB(0,0,1))

    
    return gif_creation()
end

function gif_creation()
    images = []
    sorted_times = sort(times)

    for i in eachindex(sorted_times)
        push!(images, load("$to_images/$file_name-$sorted_times[$i].png"))
        # rm(the_images; recursive=true)
    end

    @time FileIO.save("$the_path/dead_end_filling.gif", images, fps = 5)
end



maze = [
    0 1 1 1 1 1 1 1 1 1 1 1;
    0 1 0 0 0 0 0 0 0 1 0 1;
    0 1 0 1 1 1 0 1 1 1 0 1;
    0 0 0 1 0 1 0 1 0 0 0 1;
    1 1 0 1 0 1 0 1 0 1 0 1;
    0 0 0 1 0 0 0 1 0 1 0 1;
    0 1 1 0 1 1 1 1 0 1 1 1;
    0 0 1 0 0 0 0 0 0 0 0 1;
    0 1 1 0 1 0 1 1 0 1 0 1;
    0 0 0 0 1 0 1 0 0 1 0 0;
    1 1 1 1 0 0 1 1 1 1 1 0;
    1 1 1 1 1 1 1 1 1 1 1 0;
]

maze = convert_to_RGB(maze)

dead_end_filling(maze)