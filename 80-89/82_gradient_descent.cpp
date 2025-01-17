// GRADIENT DESCENT ALGORITHM

#include <iostream>
#include <vector>
#include <cmath>
#include <numeric>

using namespace std;

// this is the function that we will be trying to estimate. Specifically, we
// will try to find the value "a". Using pure math (calculus derivatives), we
// know that the gradient should be 2*a*x, which makes our evaluation of the
// gradient of our method rather perfect. If we wouldn't know the function, we
// would eestimate the gradient numerically. 
float the_function(float x, float a) {
    return a * x * x;
}

// the below function is included in any proper implementation of gradient
// descent, though we include our naive implementation for completion sake: it
// simply computes multiple inputs at the same time. When using gradient descent
// for neural networks, they would typically compute the inputs/errors in such
// batches. However, neural net libraries (such as torch or tensorflow),
// implement this via CUDA, which allows parallel processing (read: computing)
// if an appropriate GPU is available. This function would typically be written
// using those libraries, instread of pure C++, as we have it here.
std::vector<float> batch_compute(const std::vector<float> &input,
                                                             float a_estimate) {
    std::vector<float> output(input.size());

    for(int i = 0; i < input.size(); i++) {
        output[i] = the_function(input[i], a_estimate);
    }
    return output;
}

// we can easily estimate derivatives analytically, by making dx not
// infinitesimally small, but small nonetheless. This will act as our change in
// x. Then we just compute the change y by computing the y values for each x
// value and taking the difference, divide one by the other and we are done.
std::vector<float> estimate_derivative(const std::vector<float> &xs, float a) {
    // our change of x of choice. 0.001 produces stable enough results, although
    // how large/small this value should be, is up for debate. 
    float dx = 0.001;

    // then we just compute the derivatives for each input. 
    std::vector<float> estimated_derivatives(xs.size());
    for (int i = 0; i < xs.size(); i++) {
        estimated_derivatives[i] = (the_function(xs[i] + dx, a) -
                                          the_function(xs[i] - dx, a))/(2 * dx);
    }

    return estimated_derivatives;
}

// here we compute the error to to see if our procedure is improving the result
float get_errors(std::vector<float> estimates,
                                            std::vector<float> actual_outputs) {
    float error = 0;

    for (int i = 0; i < estimates.size(); i++) {
        error += actual_outputs[i] - estimates[i];
    }

    return error / estimates.size();
}

int main() {
    // this is the variable we are trying to estimate
    float a_estimate = 1;

    // we have our inputs, and our "labelled" outputs. Ideally, once the model
    // has finished its training, when the inputs are passed through the model,
    // it gives the outputs.
    std::vector<float> inputs = {5,2,7,9,3,5,8,2,16};

    std::vector<float> outputs = {
        108.1970, 17.3116, 212.067,
        350.5600, 38.9511, 108.197,
        276.9860, 17.3116, 1107.94
        };

    // some variables we will need
    std::vector<float> results(inputs.size());
    std::vector<float> estimated_derivatives(inputs.size());

    float error;

    // these are the hyperparameters of our model, i.e. we (humans) set them,
    // and let the computer figure out the parameters of our function. In our
    // case, there is only 1 parameter to be estimated, namely  "a", found in
    // the_function, above. 
    int number_of_iterations = 100;
    float step_size = 0.005;

    // this is the training part. We limit it to a certain amount of iterations
    // (no early or late "stopping"). Typically, we would decide based on the
    // size of the error from the output whether to stop computing, or to
    // continue computing. Although, again, we limit ourselves to keep this
    // demonstration as simple as possible. 
    for (int i = 0; i < number_of_iterations; i++) {
        // compute the function with some inputs
        results = batch_compute(inputs, a_estimate);

        // estimate whether the function is incrasing or decreasing
        estimated_derivatives = estimate_derivative(inputs, a_estimate);

        // compute the error from the ideal results
        error = get_errors(results, outputs);

        // modify the "a" parameter by taking a "step" in the direction of the
        // correct value
        a_estimate += step_size * error;

        // print for clarity
        cout << the_function(5.0, a_estimate) << endl;
    }


    return 0;
}