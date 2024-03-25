// GRADIENT DESCENT ALGORITHM

#include <iostream>
#include <vector>
#include <cmath>
#include <numeric>

using namespace std;

// this is the function that we will be trying to find the gradient of. Using pure math (calculus derivatives), we know that the gradient should be 2*a*x, which makes our evaluation of the correctness of our method rather easy.
float the_function(float x, float a) {
    return a * x * x;
}

// a naive implementation of gradient descent will not include a "batch_compute" function (it would just compute one input). We include it here for completion sake: neural networks typically would compute these in batches (multiple inputs at the same time). For neural net libraries (such as torch or tensorflow), CUDA allows parallel computationl if an appropriate GPU is available. This function would typically be written using those libraaries, instread of pure C++.
std::vector<float> batch_compute(const std::vector<float> &input, float a_estimate) {
    std::vector<float> output(input.size());

    for(int i = 0; i<input.size(); i++) {
        output[i] = the_function(input[i], a_estimate); // TODO: this is incorrect
    }
    return output;
}

// we can easily estimate derivatives analytically, by making dx not infinitesimally small, but small nonetheless. This will act as our change in x. Then we just compute the change y, compute and we are done.
std::vector<float> estimate_derivative(const std::vector<float> &xs, float a) {
    // our change of x of choice. 0.001 produces stable enough results, although
    // how large/small this value should be, is up for debate. 
    float dx = 0.001;

    // then we just compute the derivatives for each input. 
    std::vector<float> estimated_derivatives(xs.size());
    for (int i = 0; i < xs.size(); i++) {
        estimated_derivatives[i] = (the_function(xs[i] + dx, a) - the_function(xs[i] - dx, a))/(2 * dx);
    }

    return estimated_derivatives;
}

// here we compute the error to 
float get_errors(std::vector<float> estimates, std::vector<float> actual_outputs) {
    float error = 0;

    for (int i = 0; i < estimates.size(); i++) {
        error += actual_outputs[i] - estimates[i];
    }

    return error / estimates.size();
}

int main() {
    // this is the variable we are trying to estimate
    float a_estimate = 1;

    // we have our inputs, and our "labelled" outputs. Ideally, once the model has finished its training, when the inputs are passed through the model, it gives the outputs.
    std::vector<float> inputs = {5,2,7,9,3,5,8,2,16};
    std::vector<float> outputs = {108.197, 17.3116, 212.067, 350.56, 38.9511, 108.197, 276.986, 17.3116, 1107.94};

    // some variables we will need
    std::vector<float> results(inputs.size());
    std::vector<float> estimated_derivatives(inputs.size());

    float error;

    // these are the hyperparameters of our model, i.e. we (humans) set them, and let the computer figure out the parameters of our function. In our case, there is only 1 paramters to be estimated, which is "a", found in the_function, above. 
    int number_of_iterations = 100;
    float step_size = 0.005;

    // this is the training part. We limit it to a certain amount of iterations (no "early" or "late stopping"). Typically, we would decide based on the error from the ideal output whether to stop computing, or to continue computing, although, again, we limit ourselves to keep it as simple as possible. 
    for (int i = 0; i < number_of_iterations; i++) {
        // compute the function with some inputs
        results = batch_compute(inputs, a_estimate);

        // estimate whether the function is incrasing or decreasing
        estimated_derivatives = estimate_derivative(inputs, a_estimate);

        // compute the error from the ideal results
        error = get_errors(results, outputs);

        // modify the "a" parameter by taking a "step" in the direction of the ideal value
        a_estimate += step_size * error;

        // print for clarity
        cout << the_function(5.0, a_estimate) << endl;
    }


    return 0;
}