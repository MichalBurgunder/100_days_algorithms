using Pkg
# Pkg.add("Distributions")
# Pkg.add("random")
# Pkg.add("StatsBase")
# Pkg.add("PoissonRandom")
using Plots
using PoissonRandom
using Distributions
using StatsBase

TODO: frewquencies off by 1 (see image)
# we check what the frequency of this data point is in the orignal distribution.
# In truth, this function, in essence, is merely target_distribution[value] with
# some validation to make sure that the values we have reached are valid ones,
# i.e. the probability is greater than 0, and that the value chosen does not
# exceed our original distribution.
function target_probability(value, target_distribution)
    return value < 1 || value >= size(target_distribution)[1] ? 
    0 : target_distribution[value]
end

# we simply plot our results, and save them to disk
function plot_results(og_data, syn_data)
    savefig(histogram(og_data, bins=100), "original_data.png")
    savefig(histogram(syn_data, bins=100), "synthetic_data.png")
end

# here we take the raw data that we have been given and count the number of
# data points per value. This function is not intended for general purpose use,
# as real-world data are sampled from continuous probability distributions.
# Lucky for us, the data we have sourced IN THIS CASE is always in the form of a
# discrete integers, which is why such a counting makes perfect sense. In a more
# continuous setting, we would "bin" the values together, i.e. if a value is
# between 0 =< x < 0.05, it goes in bin1, 0.05 =< x < 0.1 in bin2, etc. 
function get_frequency_counts(data)
    maximum_value = maximum(data)
    length_frequencies = countmap(data)
    frequencies_array = zeros(Float64, maximum_value + 1)

    sum_of_frequencies = size(data)[1]
    for (value, count) in length_frequencies
        frequencies_array[value + 1] = count/sum_of_frequencies
    end

    return frequencies_array
end


function metropolis_hastings_simulation(data, number_samples)
    sigma = 50
    current_sample = rand(data)

    synthetic_data = zeros(Int, number_samples, 1)

    target_distribution = get_frequency_counts(data)

    for i in 1:number_samples
        proposed_sample = Int(round(rand(Normal(current_sample, sigma))))
    
        # we check the probability distributions in the frequency table, and
        # take the one that corresponds to our sample. We do this with the
        # current sample, as well as a suggested next sample to consider.
        current_prob = target_probability(current_sample, target_distribution)
        proposed_prob = target_probability(proposed_sample, target_distribution)
    
        # the current probability/frequency can be zero. We check for this, so
        # as not to divide by zero.
        if current_prob == 0 
            acceptance_probability = 1
        else
            acceptance_probability = min(1, proposed_prob / current_prob)
        end

        if rand() < acceptance_probability
            current_sample = proposed_sample
        end
        

        synthetic_data[i] = Int(current_sample)

    end

    return Array(synthetic_data)
end


original_data = [5, 7, 3, 2, 10, 16, 8, 8, 8, 8, 8, 19, 24, 14, 13, 13, 6, 6, 10, 22, 17, 21, 34, 23, 10, 17, 5, 1, 10, 9, 13, 5, 13, 22, 4, 3, 20, 9, 4, 12, 25, 5, 13, 8, 16, 18, 12, 21, 32, 16, 7, 8, 1, 6, 7, 7, 5, 7, 8, 14, 30, 2, 10, 30, 14, 30, 28, 9, 6, 31, 12, 8, 13, 12, 51, 4, 22, 23, 2, 20, 13, 4, 8, 22, 3, 1, 6, 30, 10, 15, 20, 34, 15, 7, 15, 10, 36, 23, 31, 1, 7, 8, 10, 15, 23, 13, 10, 2, 2, 65, 1, 6, 19, 23, 17, 14, 31, 1, 1, 21, 9, 5, 3, 18, 56, 9, 8, 5, 1, 3, 27, 3, 3, 2, 5, 2, 2, 5, 1, 22, 20, 28, 27, 15, 13, 6, 13, 22, 12, 13, 14, 3, 15, 13, 20, 26, 14, 14, 17, 8, 19, 16, 9, 34, 20, 6, 27, 16, 9, 3, 11, 18, 5, 46, 20, 11, 22, 3, 1, 34, 7, 18, 14, 36, 7, 8, 68, 14, 15, 5, 13, 6, 37, 3, 5, 12, 3, 1, 2, 4, 2, 6, 6, 3, 2, 9, 5, 6, 7, 9, 4, 11, 6, 4, 3, 10, 11, 1, 2, 5, 6, 7, 3, 6, 21, 6, 7, 7, 3, 3, 2, 11, 1, 2, 2, 13, 7, 2, 15, 2, 4, 2, 23, 11, 3, 1, 2, 3, 4, 5, 2, 4, 3, 2, 5, 6, 1, 3, 7, 6, 2, 7, 3, 3, 1, 7, 7, 8, 11, 12, 8, 3, 9, 5, 12, 10, 1, 14, 25, 14, 27, 12, 1, 5, 9, 17, 4, 12, 2, 19, 13, 8, 24, 8, 16, 6, 5, 10, 4, 9, 13, 1, 11, 9, 24, 16, 8, 32, 2, 2, 4, 2, 1, 18, 1, 8, 8, 5, 2, 10, 10, 15, 10, 4, 10, 13, 7, 9, 17, 12, 10, 9, 13, 10, 5, 8, 1, 1, 15, 10, 3, 5, 15, 12, 13, 4, 20, 3, 9, 1, 1, 5, 6, 15, 15, 2, 12, 10, 6, 2, 5, 1, 11, 21, 1, 2, 12, 25, 10, 4, 13, 9, 3, 20, 11, 8, 1, 3, 9, 2, 7, 3, 1, 4, 6, 6, 2, 6, 5, 9, 10, 1, 1, 2, 2, 18, 7, 1, 5, 8, 17, 2, 9, 21, 4, 6, 37, 7, 12, 2, 3, 9, 15, 3, 8, 11, 17, 7, 4, 17, 2, 4, 12, 13, 7, 14, 3, 9, 11, 15, 25, 16, 5, 4, 12, 5, 7, 36, 2, 4, 9, 16, 5, 6, 10, 11, 5, 10, 3, 8, 16, 2, 4, 3, 2, 14, 1, 4, 9, 5, 37, 3, 5, 13, 17, 1, 2, 33, 4, 11, 4, 9, 5, 4, 9, 5, 18, 32, 6, 20, 2, 1, 3, 3, 2, 4, 14, 3, 3, 8, 20, 15, 22, 2, 5, 6, 1, 8, 2, 7, 20, 11, 23, 14, 14, 6, 7, 17, 31, 14, 26, 16, 31, 8, 23, 13, 32, 24, 11, 20, 10, 11, 11, 17, 14, 16, 6, 24, 6, 3, 2, 2, 17, 6, 4, 10, 26, 13, 4, 4, 34, 11, 36, 19, 17, 5, 1, 2, 2, 1, 14, 28, 11, 28, 5, 9, 19, 5, 20, 16, 33, 13, 13, 11, 5, 13, 17, 13, 7, 7, 6, 4, 1, 1, 3, 1, 11, 11, 9, 23, 15, 13, 5, 10, 6, 9, 6, 9, 5, 36, 9, 9, 8, 5, 17, 12, 8, 6, 24, 14, 10, 8, 7, 12, 5, 8, 5, 8, 14, 12, 2, 7, 5, 5, 18, 4, 21, 13, 6, 36, 28, 11, 9, 30, 13, 2, 1, 5, 10, 5, 8, 11, 1, 7, 2, 13, 1, 27, 3, 11, 6, 21, 1, 3, 20, 2, 8, 1, 3, 14, 7, 3, 6, 2, 13, 27, 1, 2, 12, 3, 9, 27, 5, 6, 9, 8, 22, 12, 10, 9, 6, 18, 10, 6, 10, 4, 5, 4, 5, 9, 5, 23, 6, 10, 7, 10, 5, 3, 14, 12, 4, 3, 9, 1, 1, 4, 2, 7, 9, 10, 13, 3, 11, 2, 23, 24, 6, 1, 10, 2, 11, 8, 5, 10, 9, 7, 4, 8, 21, 6, 14, 9, 18, 18, 2, 2, 6, 2, 12, 1, 15, 1, 11, 9, 28, 4, 8, 20, 14, 28, 4, 8, 27, 11, 13, 4, 12, 3, 1, 8, 5, 28, 50, 4, 2, 12, 2, 11, 10, 20, 37, 3, 3, 35, 25, 9, 5, 14, 1, 1, 9, 14, 9, 8, 4, 2, 6, 12, 6, 7, 10, 10, 18, 20, 8, 2, 8, 6, 20, 28, 13, 13, 8, 9, 15, 13, 12, 12, 4, 20, 11, 7, 6, 12, 8, 12, 10, 2, 1, 8, 5, 12, 10, 2, 9, 1, 1, 4, 14, 9, 9, 6, 19, 2, 14, 3, 18, 11, 9, 5, 17, 9, 10, 1, 5, 4, 1, 11, 18, 16, 5, 15, 3, 4, 16, 1, 15, 5, 16, 37, 2, 12, 20, 9, 23, 34, 43, 19, 16, 9, 1, 20, 4, 34, 20, 2, 15, 27, 7, 4, 8, 13, 9, 2, 7, 13, 8, 6, 6, 6, 6, 5, 13, 11, 6, 3, 16, 14, 23, 27, 7, 13, 6, 6, 3, 1, 5, 14, 22, 15, 9, 11, 6, 7, 11, 12, 11, 8, 1, 9, 10, 13, 10, 1, 2, 17, 2, 2, 0, 3, 5, 5, 27, 9, 17, 15, 24, 8, 6, 10, 6, 16, 12, 5, 27, 4, 3, 6, 1, 1, 5, 11, 6, 9, 2, 1, 2, 9, 19, 10, 15, 14, 12, 18, 23, 11, 5, 6, 5, 9, 20, 8, 12, 2, 15, 10, 9, 2, 9, 4, 7, 3, 5, 22, 10, 5, 5, 4, 7, 37, 6, 8, 6, 7, 1, 4, 4, 14, 9, 1, 1, 2, 14, 14, 24, 15, 19, 19, 32, 9, 5, 15, 20, 14, 5, 8, 18, 10, 32, 29, 11, 29, 10, 17, 8, 6, 12, 3, 12, 10, 7, 34, 3, 13, 10, 3, 16, 33, 1, 5, 5, 4, 27, 17, 11, 14, 10, 8, 13, 11, 12, 11, 5, 15, 4, 12, 4, 2, 12, 7, 1, 21, 29, 23, 3, 10, 13, 9, 14, 8, 1, 21, 5, 8, 16, 15, 9, 19, 35, 1, 2, 5, 9, 3, 33, 6, 4, 1, 1, 18, 3, 4, 7, 17, 15, 8, 25, 11, 3, 8, 10, 8, 22, 19, 16, 1, 1, 6, 9, 10, 5, 33, 10, 11, 9, 8, 15, 11, 18, 7, 4, 4, 3, 2, 7, 21, 7, 1, 11, 7, 2, 6, 7, 1, 8, 11, 2, 2, 12, 3, 4, 8, 1, 14, 16, 3, 3, 13, 17, 2, 7, 8, 13, 17, 8, 1, 3, 2, 2, 7, 1, 1, 2, 6, 30, 1, 3, 10, 2, 2, 8, 11, 25, 7, 11, 17, 17, 6, 6, 12, 2, 3, 4, 8, 3, 5, 7, 6, 2, 2, 36, 8, 15, 16, 6, 15, 6, 6, 12, 12, 5, 13, 9, 1, 2, 2, 2, 15, 18, 1, 6, 2, 26, 12, 6, 2, 1, 6, 3, 7, 3, 16, 21, 15, 14, 13, 8, 4, 19, 11, 16, 12, 8, 3, 7, 8, 10, 5, 20, 12, 13, 27, 16, 32, 6, 18, 19, 11, 11, 10, 4, 5, 12, 10, 8, 2, 18, 1, 13, 11, 8, 1, 2, 10, 19, 2, 8, 1, 3, 3, 3, 6, 1, 7, 12, 1, 2, 12, 2, 3, 4, 9, 19, 8, 1, 7, 5, 2, 10, 8, 13, 9, 8, 16, 9, 12, 4, 14, 9, 8, 9, 9, 10, 11, 3, 4, 7, 18, 17, 15, 13, 12, 1, 14, 1, 4, 4, 30, 7, 16, 24, 7, 2, 3, 2, 10, 12, 1, 18, 5, 6, 37, 1, 9, 12, 1, 4, 3, 2, 26, 26, 16, 6, 2, 1, 16, 5, 35, 9, 10, 23, 9, 9, 13, 12, 2, 1, 5, 13, 13, 10, 16, 17, 7, 7, 29, 1, 14, 11, 12, 42, 3, 6, 7, 23, 5, 9, 8, 21, 9, 6, 15, 5, 25, 11, 9, 30, 2, 3, 14, 24, 8, 10, 3, 18, 9, 34, 1, 3, 8, 33, 6, 23, 7, 46, 11, 4, 5, 5, 5, 9, 8, 2, 9, 3, 5, 36, 4, 1, 22, 3, 25, 7, 10, 7, 4, 3, 5, 16, 14, 15, 9, 4, 10, 6, 16, 14, 3, 25, 3, 2, 2, 1, 2, 1, 6, 5, 9, 6, 18, 22, 1, 7, 16, 11, 22, 5, 9, 17, 2, 21, 11, 23, 17, 19, 21, 22, 13, 5, 18, 13, 13, 7, 39, 39, 8, 7, 3, 40, 9, 35, 21, 20, 10, 14, 6, 7, 4, 14, 4, 18, 20, 16, 11, 12, 13, 11, 22, 12, 5, 14, 14, 19, 6, 2, 5, 18, 8, 2, 13, 22, 13, 9, 44, 31, 8, 15, 1, 5, 21, 10, 19, 18, 2, 38, 5, 1, 5, 13, 13, 12, 10, 6, 22, 5, 7, 28, 20, 14, 25, 19, 32, 2, 3, 9, 7, 2, 3, 23, 10, 9, 9, 7, 11, 18, 5, 11, 10, 2, 12, 10, 12, 21, 10, 19, 16, 14, 5, 10, 4, 1, 9, 7, 12, 27, 13, 9, 11, 1, 5, 14, 4, 11, 40, 9, 33, 5, 4, 6, 11, 17, 6, 10, 8, 16, 14, 30, 5, 13, 18, 16, 8, 28, 8, 8, 13, 10, 11, 10, 11, 13, 5, 6, 1, 2, 2, 19, 4, 10, 11, 8, 4, 5, 4, 28, 6, 3, 2, 2, 12, 13, 11, 3, 14, 31, 5, 3, 14, 2, 9, 7, 21, 14, 20, 7, 11, 9, 18, 8, 21, 12, 22, 17, 30, 10, 24, 4, 19, 11, 15, 6, 32, 8, 12, 4, 14, 9, 17, 9, 9, 2, 4, 10, 29, 3, 34, 32, 2, 12, 25, 19, 22, 14, 17, 19, 7, 4, 31, 9, 8, 16, 37, 15, 8, 6, 6, 30, 17, 24, 48, 8, 15, 22, 28]



synthetic_data = metropolis_hastings_simulation(original_data, 100000)

plot_results(original_data, synthetic_data)
