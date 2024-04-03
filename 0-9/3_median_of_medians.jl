# MEDIAN OF MEDIANS ALGORITHM

using Pkg
using StatsBase

#                           array_1
#     [k_1 , k_2,  k_3,  k_4 ... k_(n-3) k_(n-2) k_(n-1) k_n]
#                /                        \ 
#         [k_i, ... k_m]   PIVOT_1   [k_j, ... k_n]
#                |
#                |
#                |
#             array_2
#
# set new array, take out some random PIVOT_2 element from new array
#                           array_2
#           [k_1, k_2, k_3    ...   k_(m-2), k_(m-1), k_(m)]
#                  /                        \ 
#          [k_1 ... k_(m_2)] PIVOT_2 [k_j, ... k_(n_2)]
#                  /                        \ 
#                ...                        ...
#                |
#             array_3
#                           array_3
#                  /                        \ 
#               ...                         ...
#                                            |
#                             ...
# 
#                           Median:
#                              X
# until finally, a pivot emerges, that must forcibly be the median
# 
function median_of_medians(array)
    # the overall idea is make the search space smaller by n/2 at every step,
    # until we've found the median. If we search the array in such a way, we
    # take n + n/2 + n/4 + n/6 + ... = 2n --> O(n) time to do it. 
    temp = array

    still = ceil(size(array)[1]/2)

    # defines how many numbers we have sorted through and KNOW that are not the
    # median
    have_done = [0, 0]

    while true
        # this "final" check ensures that if the array given has only 1 element,
        # this element must be the median
        if size(temp)[1] == 1
            return temp[1]
        end

        # we pick a random pivot. Note, that we MUST take a random number here,
        # because otherwise we would pick a pivot that separas the array so that
        #  the sought out median is in an array we cannot reconstruct.
        pivot = rand((1, size(temp)[1]))

        # we place our temporary elements, from bigger (right) to smaller (left)
        # of the pivot
        left = []
        right = []

        
        # here we sort our given array against the pivot with smaller/bigger
        # elements (O(n) time). We know that the median will be in that subarray
        # that is bigger than half of the original array size, at each
        # iteration. 
        for i in 1:size(temp)[1]
            if temp[i] < temp[pivot]
                push!(left, temp[i])
            else
                push!(right, temp[i])
            end
        end

        # with the organized left/right arrays, we need to compute how many
        # elements we still need on the right & left, before a global median
        # emerges. If both sides have the correct amount of elements (1/2 of
        # the original array), then we know that the pivot itself must be the
        # median, and return this instead. For arrays of even numbers, and a
        # tie-break, we pick out the left number (note that our Julia
        # implementation takes the mean of the two)
        if have_done[1] + size(left)[1] >= still
            temp = left
            have_done[2] = have_done[2] + size(right)[1]
        elseif have_done[2] + size(right)[1] >= still
            temp = right
            have_done[1] = have_done[1] + size(left)[1]
        else
            return pivot 
        end
    end
end

# this algorithm works with any array
the_array = [75, 74, 24, 2, 22, 98, 65, 99, 4, 54, 102, 7, 35, 823, 45,
                                                        9, 87, 12, 1000, 67, 12]

median_result = median_of_medians(the_array)
println(median_result)
println(median(the_array))