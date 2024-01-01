

using Pkg
Pkg.install("LinearAlgebra")
Pkg.install("StatsBase")
using StatsBase, LinearAlgebra
 
function get_random_matrix(size)
    matrix = Matrix{T}(0, size, size)

    for i in 1:size
        for j in 1:size
            matrix[i][j] = rand((0, 1))
        end
    end

    return matrix
end

function power_iteration(M, num_iterations: int = 100, d = 0.85)
    N = size(M, 1)
    v = fill(1, N) / N
    M_hat = (d.*M + (1 - d)/N)
    
    for i in 1:num_iterations
        mul!(v, M_hat, v)
        # v = M_hat @ v
    end

    return v
end

size_network = 40

the_network = get_random_matrix(size_network)
result = power_iteration(the_network)
println(result)