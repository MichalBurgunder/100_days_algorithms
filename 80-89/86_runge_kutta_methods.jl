# RUNGE-KUTTA METHOD

# function
# (1/32)*x^5+(1/60)x^4-(21/50)x^3+0.8

# derivative
# \frac{5}{32}x^{4}+\frac{4}{60}x^{3}-\frac{63}{50}x^{2}+0.8

function derivative_function(t)
    return (5/32)*t^4+(4/60)*t^3-(63/50)*t^2+0.8
end

function runge_kutta()
    y_n = [0.316]
    h = 0.1

    for k in range(0, 50, 1)
        t = k/10-2
        k1 = derivative_function(t)


        k1 = derivative_function()
        k2 = derivative_function(t+h/2) + y_n[k]+h*(k1/2)
        k3 = derivative_function(t+h/2) + y_n[k]+h*(k2/2)
        k4 = derivative_function(t+h) +   y_n[k]+h*k3


        y_n_plus_1 = y_n[k] + h/6*(k1+k2+k3+k4)

        push!(y_n_plus_1)
    end
end

