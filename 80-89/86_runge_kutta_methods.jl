# RUNGE-KUTTA METHOD

using Pkg
# Pkg.add("Plots")
using Plots

# this is the function we are going to try and approximate. We are including it here in order to show what our Runge-Kutta method is supposed to approximate. 
function actual_function(x)
    return (1/32)*x^5+(1/60)*x^4-(21/50)*x^3+0.8*x
end

# to estimate the function, as per the parameters of the method, we have the derivative of the function, which we are going to use to try and approximate the function. You can trivially verify that this indeed is the derivative of the above function. 
function derivative_function(x)
    return (5/32)*x^4+(4/60)*x^3-(63/50)*x^2+0.8
end


# the Runge-Kutta method. Although we can approximate the function with any degree of specificity, we are resorting to the standard RK4 implementation, one using 4 intermediary variables. 
function runge_kutta()
    # the only necessary parameters in order to run the method, are the initial conditions. Of course, we don't need these per se: the prediction would then just be a constant away from the actual answer. With intial conditions however, we can illustrate the effectiveness of the method more easily, as the ideal function points, and those we predict using the method become nearly identical.
    final_ts = [-3.0] # x starting point
    actual_function_yn = [2.696]  # 2.696 is the true value of the function at x=-3
    predicted_yn = [2.696]
    
    # becuase this is a numerical approxmiation, we need to choose a small interval with which we will space out our estimated points. 
    x_increment = 0.01 
    
    # we pick the interval we wish to approximate. We could pick any interval, although I picked this particular one because it is dynamic (two local minimal, two local maxima). This way, we get to see the approximation change, as the true value from the function change.
    # we begin one increment further ahead, given that the first point has already been filled out for us
    x_beginning = -3+x_increment 
    x_ending = 3  # 
    
    for t in x_beginning:x_increment:x_ending
        push!(final_ts, t) # recording our x


        k1 = derivative_function(t)
        k2 = derivative_function(t+x_increment/2) + x_increment*(k1/2)
        k3 = derivative_function(t+x_increment/2) + x_increment*(k2/2)
        k4 = derivative_function(t+x_increment)   + x_increment*k3

        # we pick the last element position in order to estimate the next position from there
        i = size(predicted_yn)[1]

        # the Runge-Kutta estimation
        y_n_plus_1 = predicted_yn[i] + (x_increment/6)*(k1+(2*k2)+(2*k3)+k4)

        # recording of the estimated value, along with the true value from the actual function
        push!(predicted_yn, y_n_plus_1)
        push!(actual_function_yn, actual_function(t))
    end

    # we display the graph
    display(plot(final_ts, [actual_function_yn, predicted_yn]))
    wait()
end


runge_kutta()