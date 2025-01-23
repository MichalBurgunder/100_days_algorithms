# DYNAMIC TIME WARPING

# this algorithm is very similar to that of the Levenshtein distance algorithm,
# with the exception that the Levenshtein distance computes the exact, linear
# offset. Dynamic timewarping however decides how much two continuous curves/
# arrays with non-integer values are unaligned. The method contructs a dynamic
# programming matrix, and then fills out the matrix, just as before, with the
# distances. Each step taken is compared to other paths, so that the minimum
# distance between to curves can be achieved, instead of the absolute minimum
# number of changes needing to be done, to align two strings.
function dynamic_time_warping(curve1, curve2, offset_guess) 
    # set up
    c1s = size(curve1)[1]
    c2s = size(curve2)[1]
    dimensions = size(curve1[1])[1]

    # dynamic programming matrix
    dynamic_time_warping_matrix = fill(Inf, c1s, c2s)

    # with no points, the curves are perfectly aligned
    dynamic_time_warping_matrix[1, 1] = 0

    # we simulate an offset of the curves. Note, that multiplicative offsets
    # can easily be considered as well, by having a multiplier value, instead
    # of an additive one. But we leave this out, for simplicity sake.
    curve2 = [[curve2[i][d]-offset_guess for d in 1:dimensions] for i in 1:c2s]

    for i in 2:c1s
        for j in 2:c2s
            # compute the cost of the path by finding the hypotenuse
            cost = abs(sum([curve1[i][d] - curve2[j][d] for d in 1:dimensions]))

            # take the mininum distance path 
            dynamic_time_warping_matrix[i, j] = cost + minimum([
                dynamic_time_warping_matrix[i-1, j  ],
                dynamic_time_warping_matrix[i  , j-1],
                dynamic_time_warping_matrix[i-1, j-1]
            ])
        end
    end

    # et voilà
    return dynamic_time_warping_matrix[c1s, c2s]
end


multipliers_curve = [5.5, 6.2]
offset = 0.43

# we choose two curves in three dimensional space, x, y and time t. Each curve
# has a constant radius, that just goes round and round, over time, but at
# different offsets. it's clear here that the curves have the same rotational
# speed in both dimensions, but the algorith/ also works if you change it up a
# little (i.e. for cruve two swap the multipliers, or insert your own
# mulitpliers). 
curve1 = [
            [
                sin(multipliers_curve[1]*(i*pi)),
                cos(multipliers_curve[2]*(i*pi))
            ] 
            for i in 1:100
        ]

curve2 = [
            [ # feel free to use differet multipliers
                sin(multipliers_curve[1]*(i*pi))+offset,# sin(7.7*(i*pi))+offset
                cos(multipliers_curve[2]*(i*pi))+offset # cos(3.6*(i*pi))+offset
            ] 
            for i in 1:100
        ]


# once run, we can easily see that the minimum value (6.0) corresponds to an
# offset of 0.4, the closest value to 0.43. We would simply use binary search
# to hone in on the actual value, if need be, even recursive to get a better
# final answer
for i in 1:10
    offset_guess = i/10
    curve_distance = dynamic_time_warping(curve1, curve2, offset_guess)
    print(offset_guess, " ")
    println(round(curve_distance)) # we round, for simplicity
end