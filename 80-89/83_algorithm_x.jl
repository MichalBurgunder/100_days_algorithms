# ALGORITHM X



function where_row_is_minimum_number(number_of_nodes, excluded_rows, sums_of_ones, minimum_number)
    return [filter(element -> i in excluded_rows) || sums_of_ones[i] != minimum_number for i in 1:number_of_nodes]
end

function exclude_rows(adjacency_matrix, number_of_nodes, sums_of_ones)
    rows_to_exclude = []

    for i in 1:number_of_nodes
        if sums_of_ones[row_to_choose,i] == 1
            for j in 1:number_of_nodes
                if i != j && adjacency_matrix[i,j] == 1
                    push!(rows_to_exclude, j)
                end
            end
        end
    end
    return rows_to_exclude
end

function concatenate_arrays(a, b)
    return collect(set(vcat(a, b)))
end

function algorithm_x(adjecency_matrix, excluded_rows=[]) 
    sums_of_ones = []
    for i in 1:size(adjecency_matrix)[1]
        sums_of_ones[i] = sum(adjecency_matrix[i])
    end

    minimum_number = min(sums_of_ones)
    number_of_nodes = size(adjecency_matrix)[1]
    rows = where_row_is_minimum_number(number_of_nodes, excluded_rows, sums_of_ones, minimum_number)


    while(true)
        if size(rows)[1] == 0
            return excluded_rows
        end
        row_to_choose = rnd(rows)
        filter!(element -> element != row_to_choose, rows)
        
        rows_to_exclude = exclude_rows(adjacency_matrix, number_of_nodes, sums_of_ones)

        all_excluded_rows = concatenate_arrays(excluded_rows, rows_to_exclude)

        if size(all_excluded_rows)[1] == number_of_nodes
            return all_excluded_rows
        end

        result = algorithm_x(adjecency_matrix, all_excluded_rows)
        if size(result)[1] == size(adjecency_matrix)[1]
            return result
        end
    end
end

# converts an edge list to an adjacency matrix. Of course, we could have chosen to simply written the adjacency matrix and be done. However, with an edge list, we can very clearly see what nodes are connected to what other nodes as opposed to the matrix structre. This way we can also more easily modify our graph, in a coherent way. 
function convert_to_adjacency_matrix(nodes, edge_list)
    matrix = zeros(size(nodes)[1])
    for i in 1:size(nodes)[1]
        for j in 1:edge_list[i]
            matrix[i,j] = 1
        end
    end
    return matrix
end

# the graph for which we are trying to find an exact cover. While this is very much a toy problem (solution is {2, 6, 10}) it is fully understandable as a problem and solution.

#  1 -- 2 -- 3
#       | 
#       4 -- 5 -- 6 -- 7
#                 | 
#      10 -- 9 -- 8 

nodes = [1:1:10;]
sets = [
    [2],     # 1
    [1,3,4], # 2
    [2],     # 3
    [2,5],   # 4
    [4,6],   # 5
    [5,7,8], # 6
    [6],     # 7
    [6,9],   # 8
    [8,10],  # 9
    [9]     # 10
]

adjacency_matrix = convert_to_adjacency_matrix(nodes, sets)
result = algorithm_x(adjacency_matrix)