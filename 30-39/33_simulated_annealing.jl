# SIMULATED ANNEALING

using Pkg
# Pkg.add("Images")
# Pkg.add("Colors")
using Images, Colors
using Random

Pkg.instantiate()

directions = [(1,0), (-1,0), (0,1), (0,-1)]


function is_valid_grid_position(state, grid_size)
    if 0 < state[1] && 
        0 < state[2] && 
        state[1] < grid_size[1] &&
         state[2] < grid_size[2]
         return true
    end

    return false
end

function energy_difference(grid, s1, s2)
    energy_s1 = 0
    energy_s2 = 0

    grid_size = size(grid)
    original_dir = s1 .- s2
    original_dir_negative = s2 .- s1

    divisor_s1 = 4
    for i in range(1, size(directions)[1])
        if is_valid_grid_position(s2 .+ directions[i], grid_size) && directions[i] !== original_dir_negative
            energy_s1 += abs(grid[s1[1], s1[2]] - grid[s2[1]+directions[i][1], s2[2]+directions[i][2]])
        else
            divisor_s1 -= 1
        end
    end

    divisor_s2 = 4
    for i in range(1, size(directions)[1])
        if is_valid_grid_position(s1 .+ directions[i], grid_size) && directions[i] !== original_dir
            energy_s2 += abs(grid[s2[1], s2[2]] - grid[s1[1]+directions[i][1], s1[2]+directions[i][2]])
        else
            divisor_s1 -= 1
        end
    end

    # println(abs(energy_s1/divisor_s1 + energy_s2/divisor_s2))

    return energy_s1/divisor_s1 + energy_s2/divisor_s2
end


function pick_new_state(state, grid_size)
    return [rand(range(1, grid_size[1])), rand(range(1, grid_size[2]))]

    while(true)
        new_state = state .+ rand(directions)

        if is_valid_grid_position(new_state, grid_size) 
            return new_state, direction
        end
    end
end


function simulated_annealing(grid, steps)
    height = size(grid)[1]
    width = size(grid)[2]

    grid_size = (height, width)

    rand_state_height = rand((1, height))
    rand_state_width = rand((1, width))

    state = [Int(height/2), Int(width/2)]

    for i in range(0, steps)
        T = (i+1)/steps
        
        new_state = pick_new_state(state, grid_size)

        # if true, we swap the two positions
        if energy_difference(grid, state, new_state) > rand(Float64) + T
            temp = grid[state[1], state[2]]
            grid[state[1], state[2]] = grid[new_state[1], new_state[2]]
            grid[new_state[1], new_state[2]] = temp

        end
    end

    return grid
end


function convert_to_Gray(maze)
    m, n = size(maze)
    new_maze = fill(Gray(0), m, n)

    for i in 1:m
        for j in 1:n
            new_maze[i, j] = Gray(maze[i, j])
        end
    end

    return new_maze
end


height = 50
width = 50
steps = 1000000

grid = rand(range(0, 255)/255, height, width)
grid_gray = convert_to_Gray(grid)
grid_gray = map(clamp01nan, grid_gray)

save("./i1.bmp", grid_gray)

grid_gray_sim = simulated_annealing(grid, steps)

grid_gray_sim = convert_to_Gray(grid_gray_sim)
grid_gray_sim = map(clamp01nan, grid_gray_sim)
save("./i2.bmp", grid_gray_sim)

println("Done!")