
using Pkg
# Pkg.add("Images")
# Pkg.add("QuartzImageIO")
using Images, Colors, Dates, Images, FileIO, QuartzImageIO, Images, FFMPEG

neighbor_translation = [1 => [-1, 0], 2 => [0, 1], 3 => [1, 0], 4 => [0, -1], ]
neighbor_translation = [[-1, 0],  [0, 1], [1, 0], [0, -1]]

the_path = "/Users/michal/Documents/100daysofalgorithms/70-79"
to_images = "/Users/michal/Documents/100daysofalgorithms/70-79/images"

file_name = "0000"

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

    for i in 0:m-1
        for new_row in 1:new_size
            for j in 0:n-1
                for new_column in 1:new_size
                    new_maze[i*new_size+new_row , j*new_size+new_column] = maze[i+1, j+1]
                end
            end
        end 
    end

    return new_maze
end

i = 0
function save_image(maze, rgb_val)
    global i
    save_maze = resize(maze, 10)
    save_maze = map(clamp01, save_maze)
    name = lpad(i, 4, "0")
    i += 1

    save("$to_images/$name.png", save_maze)
end

function is_empty(field)
    return field.r == 0 && field.g == 0 && field.b == 0
end

# function is_not_wall(field)
#     return field.r == 0 && field.g == 0 && field.b = 0
# end

function is_valid_neighbor(pos, maze)
    try
        val = maze[pos[1], pos[2]]
        return true
    catch
        return false 
    end
end

# function add_ton
function where_next_empty(maze, i, j)
    new_neighbors = map(neighbor -> neighbor .+ [i, j], neighbor_translation)

    for next in 1:4
        if is_valid_neighbor(new_neighbors[next], maze) &&
            is_empty(maze[new_neighbors[next][1], new_neighbors[next][2]])  && 
            is_dead_end(maze, new_neighbors[next][1], new_neighbors[next][2])

            return new_neighbors[next]
        end
    end
    return false
end

function fill_dead_end(maze, i, j, val=RGB(1,1,1))
    maze[i, j] = val
    save_image(maze, val)

    next_empty_field = where_next_empty(maze, i, j)

    if next_empty_field == false
        # there are no more fields to fill
        # we first save an image of the maze so far
        return 0
        # return save_image(maze, val)
    else    
        # in order to get a visualization of how the algorithm fills out our maze,
        # we save an image of the current maze
        # save_image(maze, val)

        i, j = next_empty_field
        return fill_dead_end(maze, i, j, val)
    end
    
    # if it's not a dead end, then we are done for this path
end

function get_valid_neighbors(maze, i, j)
    neighbors = []

    if is_valid_neighbor([i-1, j], maze) && is_empty(maze[i-1, j])
        push!(neighbors, [i-1, j])
    end

    if is_valid_neighbor([i, j-1], maze) && is_empty(maze[i, j-1])
        push!(neighbors, [i, j-1]) 
    end

    if is_valid_neighbor([i+1, j], maze) && is_empty(maze[i+1, j])
        push!(neighbors, [i+1, j]) 
    end

    if is_valid_neighbor([i, j+1], maze) && is_empty(maze[i, j+1])
        push!(neighbors, [i, j+1]) 
    end
    return neighbors
end

# checks if this tile is a dead end
function is_dead_end(maze, i, j) 
    m, n = size(maze)
    if (i == 1 && j == 1) || (i == m && j == n)
        return false
    end
    neighbors = get_valid_neighbors(maze, i, j)

    if length(neighbors) <= 1
        return true
    end

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

                # if its an empty space, we check its neighbors
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
        ending = sorted_times[i]
        image = load("$to_images/$file_name-$ending.png")
        rgb_matrix = convert(Matrix{RGB}, image)
        final_image = map(clamp01nan, rgb_matrix)
        push!(images, final_image)
    end

    imagesdirectory = "/Users/michal/Documents/100daysofalgorithms/70-79/images"
    framerate = 100
    gifname = "/Users/michal/Documents/100daysofalgorithms/70-79/dead_end_filling.gif"
    FFMPEG.ffmpeg_exe(`-framerate $(framerate) -f image2 -i $(imagesdirectory)/%04d.png -y $(gifname)`)

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