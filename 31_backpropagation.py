# Every layer of a nerual net contains functions for forward passing and backward passing. The "backward" function, is what is known as backpropagation. This function differs for every different layer of a neural net, hence why there are multiple backward functions in this file. 

# To be more specific, backward passes for every layer are computed in a step by step fashion, by going through the network backwards, computing the derivates of every step along the way. That is, for every layer, the derivative of the activation function in question (e.g. sigmoid, or tanh, in this case) is found, and a small part of it is used to train the neural net. The weights are then adjusted according to this rate, all the way until one arrives at the beginning. 

import numpy as np
import os
import matplotlib as plt

def sigmoid(x):
    return (1 / (1 + np.exp(-(x))))


def sigmoid_vectorized(x):
    return sigmoid(x)


def tanh_vectorized(x):
    return np.tanh(x)


def mse_vectorized(target, prediction):
    return np.vectorize(mse(target, prediction))


def mse(target, prediction):
    return (1 / 2) * (target - prediction)**2


class Tanh:
    def __init__(self):
        self.saved_variables = {}
        self.name = "Tanh Model"

    def forward(self, x):
        result = np.tanh(x)
        self.saved_variables = {"result": result}
        return result

    def backward(self, error):
        tanh_x = self.saved_variables["result"]
        # the derivate of tanh(x)  is 1-(tanh(x))^2
        d_x = error * (1 - np.square(tanh_x))
        self.saved_variables = None
        return None, d_x


class Sigmoid:
    def __init__(self):
        self.name = "Sigmoid Model"

    def forward(self, x):
        result = 1 / (1 + np.exp(-(x)))
        self.saved_variables = {"result": result}
        return result

    def backward(self, error):
        sigmoid_x = self.saved_variables["result"]
        # the derivate of sigmoid(x) is sigmoid_x * (1 - sigmoid_x)
        d_x = error * sigmoid_x * (1 - sigmoid_x)
        self.saved_variables = None
        return None, d_x


class Linear:
    def __init__(self, input_size, output_size):
        self.var = {
            "W":
            np.random.normal(0, np.sqrt(2 / (input_size + output_size)),
                             (input_size, output_size)),
            "b":
            np.zeros((output_size), dtype=np.float32),
        }
        self.name = "Linear Model"

    def forward(self, inputs):
        self.var['x'] = inputs
        outputs = np.matmul(inputs, self.var['W']) + self.var['b']

        self.var['outputs'] = outputs
        return outputs

    def backward(self, error):
        # new errors are computed here, to be multiplied by the learning rate later on
        x = self.var['x']
        outputs = self.var["outputs"]

        dW = np.dot(np.transpose(x), error)
        db = np.dot(np.ones(x.shape[0]), error)

        d_inputs = np.dot(error, np.transpose(self.var['W']))

        self.saved_variables = None
        updates = {"W": dW, "b": db, "x": x, "outputs": outputs}
        return updates, d_inputs


class Sequential:
    def __init__(self, list_of_modules):
        self.modules = list_of_modules
        self.name = "Sequential Model"

    class RefDict(dict):
        def add(self, k, d, key):
            super().__setitem__(k, (d, key))

        def __setitem__(self, k, v):
            assert k in self, "Trying to set a non-existing variable %s" % k
            ref = super().__getitem__(k)
            ref[0][ref[1]] = v

        def __getitem__(self, k):
            ref = super().__getitem__(k)
            return ref[0][ref[1]]

        def items(self):
            for k in self.keys():
                yield k, self[k]

    @property
    def var(self):
        res = Sequential.RefDict()
        for i, m in enumerate(self.modules):
            if not hasattr(m, 'var'):
                continue

            for k in m.var.keys():
                res.add("mod_%d.%s" % (i, k), m.var, k)
        return res

    def update_variable_grads(self, all_grads, module_index, child_grads):
        if child_grads is None:
            return all_grads

        if all_grads is None:
            all_grads = {}

        for name, value in child_grads.items():
            all_grads["mod_%d.%s" % (module_index, name)] = value

        return all_grads

    def forward(self, input):
        result = input
        for module in self.modules:
            result = module.forward(result)

        return result

    def backward(self, error):
        variable_grads = None

        for module_index in reversed(range(len(self.modules))):
            updates, d_inputs = self.modules[module_index].backward(error)

            module_variable_grad = updates
            module_input_grad = d_inputs

            error = module_input_grad
            variable_grads = self.update_variable_grads(
                variable_grads, module_index, module_variable_grad)

        return variable_grads, module_input_grad


class MSE:
    def __init__(self):
        self.name = "MSE"

    def forward(self, prediction, target):
        meanError = (1 / 2) * np.sum(np.square(prediction - target))
        self.saved_variables = {
            "prediction": prediction,
            "target": target,
        }
        return meanError

    def backward(self):
        d_prediction = (self.saved_variables["prediction"] -
                        self.saved_variables["target"]
                        ) / self.saved_variables["prediction"].size

        self.saved_variables = None
        return d_prediction


def train_one_step(model, loss, learning_rate, inputs, targets):
    output = model.forward(inputs)
    error = loss.forward(output, targets)
    # backpropagation for this neural net starts here !!!
    d_error = loss.backward()
    var_grads, input_grads = model.backward(d_error)
    for i in range(0, len(model.modules), 2):
        model.modules[i].var['W'] = model.modules[i].var['W'] - learning_rate * \
            var_grads['mod_'+str(i)+'.W']
        model.modules[i].var['b'] = model.modules[i].var['b'] - learning_rate * \
            var_grads['mod_'+str(i)+'.b']

    return error


def create_network():
    L_IL_inputs = 2
    L_HL1_inputs = 50
    L_H2_inputs = 30
    L_O_inputs = 1

    network = Sequential([
        Linear(L_IL_inputs, L_HL1_inputs),
        Tanh(),
        Linear(L_HL1_inputs, L_H2_inputs),
        Tanh(),
        Linear(L_H2_inputs, L_O_inputs),
        Sigmoid(),
    ])

    return network


def gradient_check():
    X, T = twospirals(n_points=10)
    NN = create_network()

    loss = MSE()
    loss.forward(NN.forward(X), T)

    variable_gradients, _ = NN.backward(loss.backward())

    all_succeeded = True

    for key, value in NN.var.items():
        variable = NN.var[key].reshape(-1)
        variable_gradient = variable_gradients[key].reshape(-1)
        success = True

        if NN.var[key].shape != variable_gradients[key].shape:
            print("[FAIL]: %s: Shape differs: %s %s" %
                  (key, NN.var[key].shape, variable_gradients[key].shape))
            success = False
            break

        for index in range(variable.shape[0]):
            var_backup = variable[index]
            analytic_grad = 1
            numeric_grad = 1

            variable[index] = var_backup
            if abs(numeric_grad - analytic_grad) > 0.00001:
                print(
                    "[FAIL]: %s: Grad differs: numerical: %f, analytical %f" %
                    (key, numeric_grad, analytic_grad))
                success = False
                break

        all_succeeded = all_succeeded and success

    return all_succeeded

if __name__ == "__main__":
    import matplotlib
    import matplotlib.pyplot as plt

    np.random.seed(0xDEADBEEF)

    plt.ion()

    def twospirals(n_points=120, noise=1.6, twist=420):
        """
         Returns a two spirals dataset.
        """
        np.random.seed(0)
        n = np.sqrt(np.random.rand(n_points, 1)) * twist * (2 * np.pi) / 360
        d1x = -np.cos(n) * n + np.random.rand(n_points, 1) * noise
        d1y = np.sin(n) * n + np.random.rand(n_points, 1) * noise
        X, T = (np.vstack((np.hstack((d1x, d1y)), np.hstack(
            (-d1x, -d1y)))), np.hstack(
                (np.zeros(n_points), np.ones(n_points))))
        T = np.reshape(T, (T.shape[0], 1))
        return X, T

    fig, ax = plt.subplots()

    def plot_data(X, T):
        ax.scatter(X[:, 0], X[:, 1], s=40, c=T.squeeze(), cmap=plt.cm.Spectral)

    def plot_boundary(model, X, targets, threshold=0.0):
        ax.clear()
        x_min, x_max = X[:, 0].min() - .5, X[:, 0].max() + .5
        y_min, y_max = X[:, 1].min() - .5, X[:, 1].max() + .5
        xx, yy = np.meshgrid(np.linspace(x_min, x_max, 200),
                             np.linspace(y_min, y_max, 200))
        X_grid = np.c_[xx.ravel(), yy.ravel()]
        y = model.forward(X_grid)
        ax.contourf(xx, yy, y.reshape(*xx.shape) < threshold, alpha=0.5)
        plot_data(X, targets)
        ax.set_ylim([y_min, y_max])
        ax.set_xlim([x_min, x_max])
        plt.show()
        plt.draw()
        plt.pause(0.001)

    def main():
        os.system('clear')
        print("Checking the network")
        if not gradient_check():
            print("Failed. Not training, because your gradients are not good.")
            return
        print("Done. Training...")

        X, T = twospirals(n_points=200, noise=1.6, twist=600)
        NN = create_network()
        loss = MSE()

        learning_rate = 0.1

        for i in range(20000):
            curr_error = train_one_step(NN, loss, learning_rate, X, T)
            if i % 200 == 0:
                print("step: ", i, " cost: ", curr_error)
                plot_boundary(NN, X, T, 0.5)

        plot_boundary(NN, X, T, 0.5)
        print("Done. Close window to quit.")
        plt.ioff()
        plt.show()

    main()
