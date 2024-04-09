# RUNGE-KUTTA METHOD
using Pkg
# Pkg.add("Plots")
using Plots

function actual_function(x)
    return (1/32)*x^5+(1/60)*x^4-(21/50)*x^3+0.8*x
end

# derivative
# \frac{5}{32}x^{4}+\frac{4}{60}x^{3}-\frac{63}{50}x^{2}+0.8

function derivative_function(x)
    return (5/32)*x^4+(4/60)*x^3-(63/50)*x^2+0.8
end

function runge_kutta()
    x_n = [-3, -2, -1, 0, 1, 2, 3]
    predicted_yn = [0.316]
    actual_function_yn = [0.316]

    x_ending = 3 
    x_increment = 0.01
    x_beginning = -3+x_increment

    y_beginning = 0.316 # only need this for vertical shift

    final_ts = [-3.0]
    for t in x_beginning:x_increment:x_ending
        push!(final_ts, t)
        # println(t)

        i = size(predicted_yn)[1]
        k1 = derivative_function(t)
        k2 = derivative_function(t+x_increment/2) + predicted_yn[i]+x_increment*(k1/2)
        k3 = derivative_function(t+x_increment/2) + predicted_yn[i]+x_increment*(k2/2)
        k4 = derivative_function(t+x_increment) +   predicted_yn[i]+x_increment*k3


        y_n_plus_1 = predicted_yn[i] + x_increment/6*(k1+2*k2+2*k3+k4)

        push!(predicted_yn, y_n_plus_1)
        push!(actual_function_yn, actual_function(t))
    end

    # println(predicted_yn)
    display(plot(final_ts, [actual_function_yn, predicted_yn]))
    # plot(final_ts, predicted_yn)
    # display(plot(final_ts, [predicted_yn, actual_function_yn]))
    wait()
end


runge_kutta()