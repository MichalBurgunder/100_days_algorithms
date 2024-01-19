"""
This is the function Newton's method is supposed to estimate the roots to. Note,
that because this is a quintic, there is no analytical way to find the root,
which means we are foreced to use an iterative method.
"""
function f(x)
    return x^5 - 10*x^4 + 42*x^3 + 193*x^2 + 57*x + 130
end

"""
The derivative of f. This will be used to find the slope at any given point,
along which we travel towards a root
"""
function fprime(x)
    return 5*x^4 - 40*x^3 +126*x^2 + 386*x + 57
end


"""
Newtons Method. We only iterate 10 steps, as this gets us to our result. Note,
that depending on the function it might be slitghtly higher, although not much
higher. Note also, that Newton's method isn't guaranteed to find a root, and
requires manual fine tuning. 
"""
function newtons_method()
    # we start with an arbitrary number
    x_i::Float64 = 3.4

    for i in range(0,10)
        # this is the primary statement in Newton's method
        x_i = x_i -f(x_i)/fprime(x_i)
        println(x_i)
    end
    println("Done!")
    println("final x_1: $x_i")
    print("f(x_i): ")
    println(f(x_i))
end

newtons_method()