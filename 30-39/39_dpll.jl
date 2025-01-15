
# DAVIS-PUTNAM-LOGEMAN-LOVELAND ALGORITHM

# TODO NEED TO REWRITE THE ALGORITHM LIKE THIS
# function DPLL(Φ)
#     // unit propagation:
#     while there is a unit clause {l} in Φ do
#         Φ ← unit-propagate(l, Φ);
#     // pure literal elimination:
#     while there is a literal l that occurs pure in Φ do
#         Φ ← pure-literal-assign(l, Φ);
#     // stopping conditions:
#     if Φ is empty then
#         return true;
#     if Φ contains an empty clause then
#         return false;
#     // DPLL procedure:
#     l ← choose-literal(Φ);
#     return DPLL(Φ ∧ {l}) or DPLL(Φ ∧ {¬l});
# "

# although more professional implementations of the algorithm do not rely on
# explicit clauses such as the ones below, for our demonstrative purpose, this
# is sufficient. Each of these functions can be "concatenated" using
# conjunctions to construct the final SAT-program in the conjunctive normal form
# (CNF), the form that the algorithm sets out to solve.
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
    return ~b & (c | ~d)
end



# a summary of all the clauses
clauses = [
    f1,
    f2,
    f3,
    f4,
    f5,
    f6
]

# this is just a support function to enumerate all possible permutations
function convert_to_bools(number)
    results = []
    for i in 1:4
        mask = 1 << (i - 1)
        truthvalue = (number & mask) != 0
        push!(results, truthvalue)
    end
    return results
end

# Our approach is by far the simplest approach to the DPLL algorithm, in that we
# do not use any high-level data structures and simply try and "guess" the
# answer. This is literally the "brute-force" approach done most explicitly.
# Improvements to this code are innumerable: parallelization using multiple
# threads, evaluation of the clauses to determine which atoms necessary must be
# 1, which ones necessarily 0, a  rfactoring involving recursion, backtracking,
# restarts, etc. Existing solvers employ these more sophisticated methods, and
# can solve such formulas in much faster (average) time.
function dpll(clauses)
    # main guess loop
    for i in 1:16
       # decode the guess parameter into its different atoms 
       results = convert_to_bools(i)

       # set the variables to be evaluated in the clauses
       a = results[1]
       b = results[2]
       c = results[3]
       d = results[4]

       satisfiable = true

       # evaluate them
       for j in eachindex(clauses)
        # if one clause isn't satisfied, because the expression is in CNF, the
        # rest of the formula cannot be satisfied. So we exit
            if clauses[j](a,b,c,d) == false
                satisfiable = false
                break   
            end
        end

        # if all the clauses sare satisfiable, then so is the whole formula
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