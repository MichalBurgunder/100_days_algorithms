import math
import numpy as np
import copy
import os
os.system('clear')

def gamma_i(i):
    return math.atan(2**(-i))

def sigma_i(angle):
    return 1 if angle > 0 else -1

def K_i(i):
    return 1/(math.sqrt(1+2**(-2*i)))

def R(i, s):
    return np.array([
        [1, -s*(2**(-i))],
        [s*(2**(-i)), 1]
        ])


original_angle = 5*math.pi/17 # set
angle = copy.copy(original_angle)


v = np.array([1, 0])

n = 40
for i in range(0,n):
    s = sigma_i(angle)
    v = K_i(i)*R(i,s)@v
    angle = angle - (s * gamma_i(i))
#     print(angle)
print("v")
print(v)
print("via math")
print([math.cos(original_angle), math.sin(original_angle)])