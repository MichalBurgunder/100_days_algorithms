# DYNAMIC TIME WARPING

function dynamic_time_warping(curve1, curve2, offset_guess) 
    c1s = size(curve1)[1]
    c2s = size(curve2)[1]
    dimensions = size(curve1[1])[1]

    dynamic_time_warping_matrix = fill(Inf, c1s, c2s)

    dynamic_time_warping_matrix[1, 1] = 0

    curve2 = [[curve2[i][d]-offset_guess for d in 1:dimensions] for i in 1:c2s]

    for i in 2:c1s
        for j in 2:c2s
            cost = abs(sum([curve1[i][d] - curve2[j][d] for d in 1:dimensions]))

            dynamic_time_warping_matrix[i, j] = cost + minimum([
                dynamic_time_warping_matrix[i-1, j  ],
                dynamic_time_warping_matrix[i  , j-1],
                dynamic_time_warping_matrix[i-1, j-1]
            ])
        end
    end

    return dynamic_time_warping_matrix[c1s, c2s]
end

multipliers_curve = [5.5, 6.2]
offset = 0.4

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


for i in 1:10
    offset_guess = i/10
    curve_distance = dynamic_time_warping(curve1, curve2, offset_guess)
    println(round(curve_distance))
end