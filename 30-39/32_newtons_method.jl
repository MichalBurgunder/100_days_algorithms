# NEWTON'S METHOD

# the function Newton's method is supposed to estimate the roots to. Because
# this is a quintic function, there is no analytical way to find the root,
# which means we are forced to use an iterative method, like this one
function f(x)
    return x^5 - 10*x^4 + 42*x^3 + 193*x^2 + 57*x + 130
end

# the derivative of f. This will be used to find the slope at any given point,
# along which we travel towards a root
function fprime(x)
    return 5*x^4 - 40*x^3 +126*x^2 + 386*x + 57
end


# we only iterate 10 steps, as this, already, gets us to our result. Note that
# depending on the function it might be slitghtly higher, although not by much.
# Note also, that Newton's method isn't guaranteed to find a root, i.e. can fall
# into a case where "the root" because larger and larger, never converging.
# Thus, it requires manual fine tuning. 
function newtons_method()
    # we start with an arbitrary number. 
    x_i::Float64 = 3.4

    # for this example, we do 10 iterations. However, we can also iterate for
    # longer, if we see that it's not converging to our liking. 
    for i in range(0,10)
        # we iterate using Newton's method (below line). We reset x_i to be
        # the new starting point after every calculation, so we perform the same
        # procedure with a new point
        x_i = x_i -f(x_i)/fprime(x_i)
        println(x_i)
    end
    println("Done!")
    println("final x_1: $x_i")
    print("Plugging into the function:: ")
    println(f(x_i))
    
end

newtons_method()