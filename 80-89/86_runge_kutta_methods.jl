# RUNGE-KUTTA METHOD

using Pkg
# Pkg.add("Plots")
using Plots

# this is the function we are going to try and approximate. Note, that we are
# NOT using in the runge-kutta method. We only use it to illustrate the true
# curve
function actual_function(x)
    return (1/32)*x^5+(1/60)*x^4-(21/50)*x^3+0.8*x
end

# to estimate the function, as per the parameters of the method, we need the
# derivative of the function. You can verify that this indeed is the derivative
# of the above function by using calculus, of a derivative calculator.
function derivative_function(x)
    return (5/32)*x^4+(4/60)*x^3-(63/50)*x^2+0.8
end


# the Runge-Kutta method. Although we can approximate the function with any
# degree of specificity, we are resorting to the standard RK4 implementation,
# one using 2 intermediary variables. 
function runge_kutta()
    # the only necessary parameters in order to run the method is the initial
    # point, and the gradient at each selected point. If we have one point,
    # then we can more easily visualize how closely our estimated function
    # follows the actual function. Without this initial point, our predicted
    # function would be a constant away from the actual answer at all times.
    final_ts = [-3.0] # x starting point, and all subsequent points
    actual_function_yn = [2.696] # actual values 2.696 is the value of the
                                                            # function at x=-3
    predicted_yn = [2.696] # these are our predicted values
    
    # because this is a numerical approxmiation, we need to choose a small
    # interval with which we will space out our estimated points. 
    x_increment = 0.01 
    
    # we pick the interval we wish to approximate. I picked -3 to 3, because it
    # has two local minimal, two local maxima. Thus, our method needs to
    # modulate its predictions as it iterates, so we get to see the method in
    # full action

    # we begin one increment further ahead, given that the first point has
    # already been filled out for us
    x_beginning = -3+x_increment 
    x_ending = 3
    
    for t in x_beginning:x_increment:x_ending
        push!(final_ts, t) # recording our x

        # the key concept of RK4, is that we are estimating where the next point based on the derivative of 4 points. These are the first point, the point that Euler's method would have predicted, the point that Euler's method would have given, if we had point 2, and the final point, which is the derivative at the full increment. Note, that we give each derivative a different weight in terms of "how much of it" should be used to compute the final, predicted point (non-derivative)
        k1 = derivative_function(t)
        k2 = derivative_function(t+x_increment/2) + x_increment*(k1/2)
        k3 = derivative_function(t+x_increment/2) + x_increment*(k2/2)
        k4 = derivative_function(t+x_increment)   + x_increment*k3

        # we estimate the next position from the last position
        i = size(predicted_yn)[1]

        # the Runge-Kutta estimation
        y_n_plus_1 = predicted_yn[i] + (x_increment/6)*(k1+(2*k2)+(2*k3)+k4)

        # we record the estimated value, and the true value
        push!(predicted_yn, y_n_plus_1)
        push!(actual_function_yn, actual_function(t))
    end


    # we display the graph
    display(plot(final_ts, [actual_function_yn, predicted_yn]))
    sleep(100)
    return
end


runge_kutta()