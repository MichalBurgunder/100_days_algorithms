# DYNAMIC TIME WARPING

# TODO: need to make distance the hypotenuse
# this algorithm is very similar to that of the Levenshtein distance algorithm, but its use is slightly different. While the Levenshtein distance works on only discrete values, dynamic time warping can decide how much two continuous curves/arrays with fractional values are unaligned. The method contructs a dynamic programming matrix, and then fills out the matrix, just as before, with the distances. Each step taken is compared to other paths, so that the minimum distance between to curves can be achieved. 
function dynamic_time_warping(curve1, curve2, offset_guess) 
    # set up
    c1s = size(curve1)[1]
    c2s = size(curve2)[1]
    dimensions = size(curve1[1])[1]

    # dynamic programming matrix
    dynamic_time_warping_matrix = fill(Inf, c1s, c2s)

    # with no points, the curves are perfectly aligned
    dynamic_time_warping_matrix[1, 1] = 0

    # we simulate an offset of the curves. Note, that multiplicative offsets can easily be considered as well, by having a multiplier value, instead of an additive one 
    curve2 = [[curve2[i][d]-offset_guess for d in 1:dimensions] for i in 1:c2s]

    for i in 2:c1s
        for j in 2:c2s
            # compute the cost of the path
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

curve1 = [
            [
                sin(multipliers_curve[1]*(i*pi)),
                cos(multipliers_curve[2]*(i*pi))
            ] 
            for i in 1:100
        ]

curve2 = [
            [
                sin(multipliers_curve[1]*(i*pi))+offset,
                cos(multipliers_curve[2]*(i*pi))+offset
            ] 
            for i in 1:100
        ]


# once run, we can easily see that the minimum value (6.0) corresponds to an offset of 0.4, the closest value to 0.43. We would simply use binary search to hone in on the actual value.
for i in 1:10
    offset_guess = i/10
    curve_distance = dynamic_time_warping(curve1, curve2, offset_guess)
    print(offset_guess, " ")
    println(round(curve_distance)) # we round, for simplicity
end