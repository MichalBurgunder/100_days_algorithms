using Pkg
# Pkg.add("Distributions")
# Pkg.add("random")
using Plots
# using random

function target_probability(x)
    return exp(-x.^2) .* (2 + sin(x*5) + sin(x*2));
end

function metropolis_hastings_step(mean, sigma, current_sample)
    proposed_sample = rand(Normal(mean, sigma))

    current_prob = targetdist(proposed_sample)
    proposed_prob = targetdist(mean)

    if current_prob == 0  # Handle edge cases where current prob is 0
        acceptance_ratio = 1
    else
        acceptance_ratio = min(1, proposed_prob / current_prob)
    end

    return rand() <= acceptance_probability ? proposed_sample : current_sample
end

function metropolis_hastings_simulation(number_samples)
    burn_in = 100
    sigma = 50
    x = -1

    X = zeros(number_samples, 1)
    # acc = [0, 0]

    for i in 1:burn_in
        x_and_a = metropolis_hastings_step(x, sigma)
        acc = acc + x_and_a
    end

    for i in 1:number_samples
        x_and_a = metropolis_hastings_step(x, sigma)
        acc = acc + x_and_a
        X[i] = x_and_a[1]
    end

    histogram(X, bins=30, xlabel="Value", ylabel="Frequency", title="Histogram of some Data")
end


metropolis_hastings_simulation(1000)