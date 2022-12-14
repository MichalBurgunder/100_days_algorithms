
function get_neighboring_points(matrix, p, c)
    points_to_process = []

    if p[1] != 1 && getindex(matrix, p[1]-1, p[2]) == c
        push!(points_to_process, (p[1]-1, p[2]))
    end
    # print("here")
    if p[2] != 1 && getindex(matrix, p[1], p[2]-1) == c
        push!(points_to_process, (p[1], p[2]-1))
    end

    # print()
    # size(matrix)[0]
    if p[1] != size(matrix)[1] && getindex(matrix, p[1]+1, p[2]) == c
        push!(points_to_process, (p[1]+1, p[2]))
    end
    # print("3", "\n")
    if p[2] != size(matrix)[2] && getindex(matrix, p[1], p[2]+1) == c
        push!(points_to_process, (p[1], p[2]+1))
    end
    # print(points_to_process)
    # exit()
    return points_to_process
end

function inner_fill(dones, p, matrix, new_color, old_color)
    # println("in inner fill")
    if getindex(dones, p[1], p[2]) == 1
        # println("returning")
        return
    end

    dones[p[1], p[2]] = 1
    
    matrix[p[1], p[2]] = new_color
    
    new_points = get_neighboring_points(matrix, p, old_color)
    # print(new_points)
    # exit()
    for point in new_points
        println("going in")
        println(point)
        inner_fill(dones, point, matrix, new_color, old_color)
        println("coming out in")
    end
end

# 
function flood_fill(matrix, point, new_color)
    
    old_color = getindex(matrix, point[1], point[2])
    matrix[point[1], point[2]] = new_color
    dones = zeros(Int8, size(matrix)[1],size(matrix)[2])


    points = get_neighboring_points(matrix, point, old_color)

    for point in points
        inner_fill(dones, point, matrix, new_color, old_color)
    end

    return an_H
end

an_H = [
    0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0;0 0 1 0 0 1 0 0;0 0 1 0 0 1 0 0;0 0 1 1 1 1 0 0;0 0 1 0 0 1 0 0;0 0 1 0 0 1 0 0;0 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0
]
# print(an_H)
flood_fill(an_H, (1,1), 6)

for row in eachrow(an_H)
    println(row)
end