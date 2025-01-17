# SIMULATED ANNEALING

using Pkg
# Pkg.add("Images")
# Pkg.add("Colors")
using Images, Colors
using Random

Pkg.instantiate()

# the offset of the neighbors of a cell, from which we can randomly sample one
directions = [(1,0), (-1,0), (0,1), (0,-1)]

# here we simply check if the next position is still on the grid
function is_valid_grid_position(state, grid_size)
    if 0 < state[1] && 
        0 < state[2] && 
        state[1] < grid_size[1] &&
         state[2] < grid_size[2]
         return true
    end

    return false
end

# I have opted to select two cells, and compare the energy differences between their neighbors. This is key, while all the other computational decisions are free parameters. I've tried to keep the numbers as true average, so that the energy comparison (against random chance and temperature) follows easily. In other words, I've offloaded complexity to this function. 
function energy_difference(grid, s1, s2)
    # the energies for both states begins at zero
    energy_s1 = 0
    energy_s2 = 0

    # in order to exclude the neighbors from comparison, we record the direction from s1 to s2 and s2 to s1, and check for this direction, before adding to the total energy. 
    original_dir = s1 .- s2
    original_dir_negative = s2 .- s1
    
    grid_size = size(grid)

    # divisors ensure that our floats don't exceed 1.
    divisor_s1 = 4

    # going through all the directions
    for i in range(1, size(directions)[1])
        if is_valid_grid_position(s2 .+ directions[i], grid_size) && directions[i] !== original_dir_negative
            energy_s1 += abs(grid[s1[1], s1[2]] - grid[s2[1]+directions[i][1], s2[2]+directions[i][2]])
        else
            divisor_s1 -= 1 # subtract, if a direction is not valid
        end
    end

    # the same for s2
    divisor_s2 = 4
    for i in range(1, size(directions)[1])
        if is_valid_grid_position(s1 .+ directions[i], grid_size) && directions[i] !== original_dir
            energy_s2 += abs(grid[s2[1], s2[2]] - grid[s1[1]+directions[i][1], s1[2]+directions[i][2]])
        else
            divisor_s1 -= 1
        end
    end
    # we don't divide by 2, because for some reason it comes out nicer
    return energy_s1/divisor_s1 + energy_s2/divisor_s2
end

# we pick a new state on the grid, by taking a random poing on the grid. Although some documentation suggests taking random neighbors, this doesn't make sense if we are simulating the physical process of annealing. With enough iterations, the grid will uniformally be affected without any pockets/areas unaffected by the process. Clearly, physical cooling happens at the places where the temperature differences are maximal, hence why the "outside" would cool first, and work its way inward. We ignore that. This is, after all, a simulation, and not real life. 
function pick_new_state(state, grid_size)
    return [rand(range(1, grid_size[1])), rand(range(1, grid_size[2]))]
end


function simulated_annealing(grid, steps)
    height = size(grid)[1]
    width = size(grid)[2]

    grid_size = (height, width)

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

# we chose some small paramaters for demonstration
height = 50
width = 100
steps = 1500000

# saving a grayscale image with random values
grid = rand(range(0, 255)/255, height, width)
grid_gray = Gray.(grid)
grid_gray = map(clamp01nan, grid_gray)
save("./random_bitmap.bmp", grid_gray)

# we run simulated annealing...
grid_gray_sim = simulated_annealing(grid, steps)

# and save the output for comparison
grid_gray_sim = Gray.(grid_gray_sim)
grid_gray_sim = map(clamp01nan, grid_gray_sim)
save("./annealed_bitmap.bmp", grid_gray_sim)
println("Done!")