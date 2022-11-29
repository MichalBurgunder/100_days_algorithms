rom os import system
from sys import platform
import numpy as np
from math import pi

def clear_terminal():
    '''clears terminal, for easier overview'''
    if platform == "darwin":
        system('clear')
    else:
        system('cls')
clear_terminal()

def the_function(x):
    '''the function we need to find the fast fourier transform for'''
    return 10/(1+(10*x-5)**2)

def get_V_omega_normal(p):
    '''NOTE: this is the (normal) fourier transform'''
    omegas = np.zeros((p,p), dtype=complex)
    for k in range(p):
        for n in range(p):
            omegas[k][n] = np.exp(-2*pi*1j*k*n/p)
    return omegas

def verify_correct(p,F,m):
    '''prints out the value our code has achieved, and the value that numpy gives for the same data'''
    ps = [the_function(k/p) for k in range(p)]
    previously_implemented = np.fft.fft(ps)
    F_sum = sum(F)
    np_sum = sum(previously_implemented)
    
    # rearrange the indicies back
    new_indicies = get_new_indices(m)
    rearranged = rearrange_array(F, new_indicies)

    # print the last 5 terms of the numpy implemented fft, and our version of the fft
    print("Numpy implementation:")
    print(np.array(previously_implemented)[-6:-1])
    print("Our implementation:")
    print(np.array(rearranged[-6:-1])) 
    print("\nYour summed value: " + str(F_sum))
    print("Their summed value: " + str(np_sum) + "\n")
    print("Verfied: " + str(round(F_sum, 8) == round(np_sum, 8)))

def omega(k, n):
    '''the value of omega in the handouts'''
    return np.exp(-2*pi*1j*k/n)
    
def get_fancy_fft_array(f_ks):
    '''computes the fast fourier transform, given some initial points'''
    length = len(f_ks)
    if length < 2:
        return [f_ks[0] * np.exp(-2*pi*1j)]
    else:
        left = get_fancy_fft_array(f_ks[::2]) # even
        right = get_fancy_fft_array(f_ks[1::2]) # odd
        
        final = [0] * (length*2)
    
        for j in range(int(length/2)):
            final[j] = left[j] + omega(j, length)*right[j]
            final[int(j+length/2)] =  left[j] - omega(j,length)*right[j]
    return final

def get_new_indices(m):
    '''fetches the new indicies for the fourier terms'''
    length = 2**m
    new_indices = [None] * length
    for n in range(length):
        new_indices[n] = int(format(n, 'b').zfill(m)[::-1],2)
    return new_indices

def rearrange_array(fs, inds):
    '''rearranges the fourier terms with respect to some new indicies'''
    final = [None] * len(inds)
    for n in range(len(inds)):
        final[n] = fs[inds[n]]
    return final

def get_F_slow(p):
    '''computes the (normal) fourier transform'''
    f_ks = [the_function(k/p) for k in range(p)]
    V_omega = get_V_omega_normal(p)
    return np.array(V_omega)@f_ks

def get_F_fast(m):
    '''computes the fast fourier transform and organizes the terms'''
    f_ks = [the_function(k/(2**m)) for k in range(2**m)]
    fancy_array = get_fancy_fft_array(f_ks) # returns a bit of a bogus array
    new_indicies = get_new_indices(m)
    return rearrange_array(fancy_array, new_indicies)

def full_assignment():
    '''solves the assignment, as speicfied by the assignment sheet'''
    m = 8
    p = 2**m # points to graph
    F = None # final fs
    fast_mode = True
    
    if fast_mode == True:
        F = get_F_fast(m)
    else:
        F = get_F_slow(2**m)
        
    verify_correct(p, F, m)
    
    return 0


full_assignment()