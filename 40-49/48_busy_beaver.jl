# BUSY BEAVER

using Pkg
# Pkg.add(["FFMPEG", "Plots", "FileIO"])
# using Plots
using FileIO
using Images
using Colors

# resizes any given matrix. This is only used to make the resulting images a
# little larger, so as to more easy see each pixel
function resize(maze, new_size)
    m, n = size(maze)
    new_maze = Array{Bool}(undef, new_size*m, new_size*n)

    for i in 0:m-1
        for new_row in 1:new_size
            for j in 0:n-1
                for new_column in 1:new_size
                    new_maze[i*new_size+new_row, j*new_size+new_column] =
                                                                  maze[i+1, j+1]
                end
            end
        end 
    end

    return new_maze
end

# save an image of the matrix to disk. 
function save_image(matrix_naive, size_multiplier)
    mat_to_save = resize(matrix_naive, size_multiplier)
    save("$images_directory/bb_demonstration.png", mat_to_save)
end

# hashmap of values found vs. matrix columns
bool_to_pos = Dict(
    0 => 1,
    1 => 2
    )

# hashmap of values found vs. matrix rows
letter_to_pos = Dict(
    "A" => 1,
    "B" => 2,
    "C" => 3,
    "D" => 4,
    "E" => 5,
    "Z" => 1 # halts elsewhere, so the number makes no difference
)

# hasmap to help the head decide in which direction to go
hm_rl = Dict(
    "R" =>  1,
    "L" => -1
)


# takes a transition value (string), and extracts the information needed to run
# the Turing machine.
function extract_info(tf, pos)
    the_string = tf[letter_to_pos[string(pos[1])]][bool_to_pos[pos[2]]]
    return [    
                the_string[1],
                pos[3]+hm_rl[string(the_string[2])],
                the_string[3],
                pos[3]
            ]
end

# to perform a single time step in the busy beaver function. 
function single_timestep(the_row, tf, step_data)
    to_write, new_loc, next_letter, old_loc = extract_info(tf, step_data)

    the_row[old_loc] = Bool(parse(Int, to_write))
    return [next_letter, the_row[new_loc], new_loc]
end


# The goal of the busy beaver "game"/"competition", is to find a busy beaver
# (read: transition function) with n states that 1) halts, and 2) halts after
# the largest number of steps (BB(n)). The current "winner" of the 5-state busy
# beaver is coded below. We also include a trivial 2 state busy beaver, for
# demonstration purposes.

# The automaton is always defined by a given transition table, making the busy
# beaver program (Turing machine) a large class of algorithms. Because we can
# define an arbitrary number of states for a busy beaver function, one can run a
#  busy beaver machine run that has 18 states. Of course, this is for most
# transition tables computationally infeasible, as the number of possible
# configurations increases very fast, such that the busy beaver function with 5
# states is approximately how much we can compute in a "realistic" world (that
# is, compute ALL functions in this class. In other words, try out every
# transition table for 5 states). Note, that the function describing the number
# of different transitions increases faster than polynomial time. So the 

# tf: transition function
# the_size: 2-ple of (height, width)
# size_multiplier: directive for resizing the emerging image
# steps: number of time steps
function busy_beaver(tf, the_size, size_multiplier=5, max_steps=100)
    # we define a matrix, and a row. The row will serve as our busy beaver tape,
    # while the matrix (space-time diagram) will serve as a visualiztion. For
    # the matrix, the downward direction signifies the passing of timesteps. 
    matrix = falses(the_size[1], the_size[2])
    the_row = falses(the_size[2])

    # the initial time step: row 1, 0, and starting in the middle of the
    # (technically infinite) tape, that for practical purposes, is simply very
    # large. 
    new_timestep_data = ["A", 0, Int(the_size[2]/2)]
    
    # we skip the first step, as the first row is by default empty
    for i in 2:max_steps
        new_timestep_data = single_timestep(the_row, tf, new_timestep_data)

        # "Z" signifies the halting step. Thus, if the busy beaver reaches a
        # halting state prior to the max_steps expiring, we save the result
        if string(new_timestep_data[1]) == string("Z")
            return save_image(matrix, size_multiplier)
        end
        
        # setting the row
        matrix[i,:] = the_row
    end

    return save_image(matrix, size_multiplier)
end

# 5-state busy beaver example
# transition_function = [
#     ["1RB", "1LC"],
#     ["1RC", "1RB"],
#     ["1RD", "0LE"],
#     ["1LA", "1LD"],
#     ["1RZ", "0LA"]
# ]

# 2-state busy bueaver example
transition_function = [
    ["1RB", "0LA"],
    ["1LA", "1RZ"],
]


line_length = 50
steps = 50
size_multiplier = 20
# type in your own images_directory
images_directory = "/Users/michal/Downloads/"

busy_beaver(transition_function, (steps, line_length), size_multiplier, steps)
