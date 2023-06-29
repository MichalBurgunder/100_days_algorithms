


function f1(a, b, c, d)
    return (a & b) | (c | ~d)
end


function f2(a, b, c, d)
    return ~a | b | ~c | d
end

function f3(a, b, c, d)
    return ~a | ~d
end

function f4(a, b, c, d)
    return ~b | (c & ~d)
end

clauses = [
    f1,
    f2,
    f3,
    f4,
    f5,
    f6,
    f67
]

function dpll(clauses, variables)
    while true

    end
end
