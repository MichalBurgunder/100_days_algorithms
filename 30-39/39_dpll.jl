


function f1(a, b, c, d)
    return (a | b) | (c | d)
end


function f2(a, b, c, d)
    return a | b | c | d
end

function f3(a, b, c, d)
    return ~a | d
end

function f4(a, b, c, d)
    return ~b | (c | d)
end

function f5(a, b, c, d)
    return a | d
end

function f6(a, b, c, d)
    return ~b | (c | d)
end


clauses = [
    f1,
    f2,
    f3,
    f4,
    f5,
    f6
]


function convert_to_bools(number)
    results = []
    for i in 1:4
        mask = 1 << (i - 1)
        truthvalue = (number & mask) != 0
        push!(results, truthvalue)
    end
    return results
end



function dpll(clauses)
    for i in 1:16
       results = convert_to_bools(i)
       a = results[1]
       b = results[2]
       c = results[3]
       d = results[4]

       satisfiable = true
       for j in 1:length(clauses)
            if clauses[j](a,b,c,d) == false
                satisfiable = false
                break   
            end
        end

        if satisfiable
            return [true, [a,b,c,d]]
        end
    end
    return false, []
end



result = dpll(clauses)
res = result[1]
variables = result[2]
println(res)
println(variables)