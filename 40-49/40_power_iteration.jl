# POWER ITERATION ALGORITHM

using Pkg
# Pkg.add("LinearAlgebra")
# Pkg.add("StatsBase")
using StatsBase, LinearAlgebra

# although a significant portion of Google's PageRank algorithm, it has
# nonetheless been made public, as that Google's search engine has advances
# far beyond it.
function power_iteration(M, num_iterations= 50)
    N = size(M, 1)

    # we take a random vector of size N. It doesn't much matter what vector we
    # define: because we multiply it by a matrix, and then divide it element-
    # wise by the norm, the product of all the norms effectively act as
    # mulitplier (i.e. an eigenvalue), leaving behind the eigenvector, which
    # characterizes the network in question. 
    v = Float64.(rand((Bool), 1, N))

    v_result = similar(v)

    for i in 1:num_iterations
        # we multiply M by v, and place the result in v_result
        mul!(v_result, v, M)

        # and now we just divide by the norm, and reset v
        v = v_result / norm(v_result)
    end

    return v
end

# a simple network, where the rows signify links going out of the [row_number]th
# node, and going into the [column_number]th node. What's important to note
# here, is that the node_5 has few outgoing connections but many incoming ones.
# This node would then rank high in a ranking of best webpages. On the other
# hand, node_2 only has single link going to it, which means that it is a rather
# unpopular website. So this webpage has a low ranking among the other websites.
the_network = Matrix(
    [
        0 0 0 0 1;
        0 0 1 1 1;
        1 0 0 1 1;
        1 1 0 0 1;
        0 0 1 0 0
    ]
)

result = power_iteration(the_network)

# to display the ranking, we label our nodes, sort the, and print the final
# results.
all_nodes = []
for i in 1:5
    push!(all_nodes, (i, result[i]))
end

sorted_nodes = sort(all_nodes, by=x -> x[2], rev=true)
for i in 1:5
    println(sorted_nodes[i])
end
