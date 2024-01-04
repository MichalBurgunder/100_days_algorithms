
using Pkg
using StatsBase

function median_of_medians(array)
    temp = array

    while size(temp)[1] > 1
        pivot = rand((1, size(temp)[1]))

        smaller = []
        greater = []
        for i in 1:size(temp)[1]
            if temp[i] < temp[pivot]
                push!(smaller, temp[i])
            else
                push!(greater, temp[i])
            end
        end

        if size(smaller)[1] <= size(greater)[1]
            temp = greater
        else
            temp = smaller
        end

    end

    return temp[1]
end

the_array = [75, 74, 24, 2, 22, 98, 65, 99, 4, 54, 102, 7, 35, 823, 45, 9, 87, 12, 1000, 67, 12]

median = midpoint(the_array)
println(median)