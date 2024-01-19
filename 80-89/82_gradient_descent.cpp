#include <iostream>
#include <vector>
#include <cmath>
#include <numeric>

using namespace std;

float the_function(float x, float a) {
    return a * x * x;
}

std::vector<float> batch_compute(const std::vector<float> &input, float a_estimate) {
    std::vector<float> output(input.size());

    for(int i = 0; i<input.size();i++) {
        output[i] = the_function(input[i], a_estimate);
    }
    return output;
}


std::vector<float> estimate_derivative(const std::vector<float> &xs, float a) {
    float diff = 0.001;
    std::vector<float> estimated_derivatives(xs.size());
    for (int i = 0; i < xs.size(); i++) {
        estimated_derivatives[i] = (the_function(xs[i] + diff, a) - the_function(xs[i] - diff, a))/(2 * diff);
    }

    return estimated_derivatives;
}


float get_errors(std::vector<float> estimates, std::vector<float> actual_outputs) {
    float error = 0;

    for (int i = 0; i < estimates.size(); i++) {
        error += actual_outputs[i] - estimates[i];
    }

    return error / estimates.size();
}

int main() {
    float a_estimate = 1;

    std::vector<float> inputs = {5,2,7,9,3,5,8,2,16};
    std::vector<float> outputs = {108.197, 17.3116, 212.067, 350.56, 38.9511, 108.197, 276.986, 17.3116, 1107.94};

    std::vector<float> results(inputs.size());
    std::vector<float> estimated_derivatives(inputs.size());
    float error;

    int number_of_iterations = 100;
    float step_size = 0.005;

    for (int i = 0; i < number_of_iterations; i++) {
        results = batch_compute(inputs, a_estimate);

        estimated_derivatives = estimate_derivative(inputs, a_estimate);
        error = get_errors(results, outputs);

        a_estimate += step_size * error;

        cout << the_function(5.0, a_estimate) << endl;
    }


    return 0;
}