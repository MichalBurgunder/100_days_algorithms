# DEAD END FILLING ALGORITHM

using Pkg
# Pkg.add("Images")
# Pkg.add("Colors")
# Pkg.add("FFMPEG")
using Images, Colors, FFMPEG

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

function resize(maze, new_size)
    m, n = size(maze)
    new_maze = Array{RGB}(undef, new_size*m, new_size*n)

    for i in 0:m-1
        for new_row in 1:new_size
            for j in 0:n-1
                for new_column in 1:new_size
                    new_maze[i*new_size+new_row, j*new_size+new_column] = maze[i+1, j+1]
                end
            end
        end 
    end

    return new_maze
end

i = 0
function save_image(maze)
    global i
    save_maze = resize(maze, 10)
    save_maze = map(clamp01, save_maze)
    name = lpad(i, 4, "0")
    i += 1

    save("$to_images/$name.png", save_maze)
end

function is_empty(field)
    # given that every field in our maze is some color, we check if these color
    # values are all 0, which corresponds to white
    return field.r == 0 && field.g == 0 && field.b == 0
end


function is_valid_neighbor(pos, maze)
    try
        val = maze[pos[1], pos[2]]
        return true
    catch
        return false 
    end
end

# we check where the next empty field is. This is used in the fill_dead_end
# function. If there isn't one, it returns false
function where_next_empty(maze, i, j)
    new_neighbors = map(neighbor -> neighbor .+ [i, j], neighbor_translation)

    for next in 1:4
            # is not outside of maze
        if is_valid_neighbor(new_neighbors[next], maze) && 
            # the field is empty
            is_empty(maze[new_neighbors[next][1], new_neighbors[next][2]]) && 
            # the next field only has one other place to go
            is_dead_end(maze, new_neighbors[next][1], new_neighbors[next][2]) 

            return new_neighbors[next]
        end
    end
    return false
end

function fill_dead_end(maze, i, j, val=RGB(1,1,1))
    # first we mark the field the color we have specified, and save the image.
    # We will construct our gif from it afterwards
    maze[i, j] = val
    save_image(maze)

    next_empty_field = where_next_empty(maze, i, j)

    # we check if there are no more fields to fill
    # otherwise, we fill in the next dead end recursively
    if next_empty_field == false
        return 0
    else    
        i, j = next_empty_field
        return fill_dead_end(maze, i, j, val)
    end
end

function get_valid_neighbors(maze, i, j)
    neighbors = []
    # we translate our incoming coordinates using the neighborhood translations
    # to get the neighbors: [[-1, 0],  [0, 1], [1, 0], [0, -1]]
    # these we check for validity and emptyless, for further processing
    # downstream
    for n in eachindex(neighbor_translation)
        new_field = [i, j] .+ neighbor_translation[n]
        if is_valid_neighbor(new_field, maze) &&
                                    is_empty(maze[new_field[1], new_field[2]])
            push!(neighbors, new_field)
        end
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

# this is the upper function of filling dead ends. fill_dead_end() is where
# the magic happens
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
    fill_dead_end(maze, 1, 1, RGB(0,1,0))

    
    return gif_creation()
end

# this is just the gif creation process. Don't worry about it.
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

    images_directory = "/Users/michal/Documents/100daysofalgorithms/70-79/images"
    framerate = 100
    gifname = "/Users/michal/Documents/100daysofalgorithms/70-79/dead_end_filling.gif"
    FFMPEG.ffmpeg_exe(`-framerate $(framerate) -f image2 -i $(images_directory)/%04d.png -y $(gifname)`)

    # we remove the images, as we now have our gif
    rm(images_directory, recursive=true)
end



# In essence, we can replace this bitmap with any maze we want. In our case,
# the 1s are walls, and 0s are empty spaces (passage ways). The bitmap given is
# small, although this is just a toy example to illustrate the algorithm. We can
# replace the bitmap with with other larger bitmap, if we wished to.
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