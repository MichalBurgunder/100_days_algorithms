
using Pkg
using StatsBase

function median_of_medians(array)
    temp = array

    still = ceil(size(array)[1]/2)
    have_done = [0, 0]

    while true
        pivot = rand((1, size(temp)[1]))

        left = []
        right = []

        if size(temp)[1] == 1
            return temp[1]
        end
        
        for i in 1:size(temp)[1]
            if temp[i] < temp[pivot]
                push!(left, temp[i])
            else
                push!(right, temp[i])
            end
        end

        if have_done[1] + size(left)[1] >= still
            temp = left
            have_done[2] = have_done[2] + size(right)[1]
        elseif have_done[2] + size(right)[1] >= still
            temp = right
            have_done[1] = have_done[1] + size(left)[1]
        else
            return pivot 
        end

        if size(temp)[1] == 0
            return pivot
        end
    end
end

the_array = [75, 74, 24, 2, 22, 98, 65, 99, 4, 54, 102, 7, 35, 823, 45, 9, 87, 12, 1000, 67, 12]

median_result = median_of_medians(the_array)
println(median_result)
println(median(the_array))