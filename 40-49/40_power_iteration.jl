# POWER ITERATION ALGORITHM

using Pkg
# Pkg.add("LinearAlgebra")
# Pkg.add("StatsBase")
using StatsBase, LinearAlgebra


function power_iteration(M, num_iterations= 50)
    N = size(M, 1)
    v = Float64.(rand((Bool), 1, N))

    v_result = similar(v)

    for i in 1:num_iterations
        
        mul!(v_result, v, M)

        v_normed = v_result / norm(v_result)
        v = v_normed
    end

    return v
end

# 
the_network = Matrix(
    [
        0 0 0 0 1;
        0 0 1 1 1;
        1 0 0 1 1;
        1 0 0 0 1;
        0 0 1 0 0
    ]
)

result = power_iteration(the_network)

for i in 1:size_network
    println(result[i])
end