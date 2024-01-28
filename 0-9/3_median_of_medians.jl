
using Pkg
using StatsBase

function median_of_medians(array)
    temp = array

    still = ceil(size(array)[1]/2)

    # defines how many numbers we have sorted through and KNOW that are not the median
    have_done = [0, 0]

    while true
        # we pick a random pivot. Note, that we MUST take a random number here, because otherwise we could pick a pivot that keeps separating the array in such a way, that the sought out median will always be in an array that we cannot reconstruct.
        pivot = rand((1, size(temp)[1]))

        # we place our temporary elements, from bigger (right) to smaller (left) of the pivot
        left = []
        right = []

        # this final check ensures that if the array given has only 1 element, this element must be the median
        if size(temp)[1] == 1
            return temp[1]
        end
        
        # here we sort our given array, with the pivot with smaller/bigger elements. If this is the first time we pass into this code, we know that the median must be in the bigger array, which we recursively will go into
        for i in 1:size(temp)[1]
            if temp[i] < temp[pivot]
                push!(left, temp[i])
            else
                push!(right, temp[i])
            end
        end

        # with the organized left/right arrays, we need to compute how many elements we still need on the right & left, before a median emerges. If both sides have the correct amount of elements, then we know that the pivot itself must be the median, and return this instead.
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