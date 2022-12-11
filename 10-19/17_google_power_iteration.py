
from os import system, path
from sys import platform
import numpy as np
from copy import deepcopy

def clear_terminal():
    '''clears terminal, for easier overview'''
    if platform == "darwin":
        system('clear')
    else:
        system('cls')
clear_terminal()


def get_tuples_from_file(file_name):
    '''opens a file and extracts all fo the tuples from it'''
    assert path.exists(file_name)
    
    with open(file_name) as f:
        lines = f.readlines()
        the_list = list(map((lambda x: tuple(x[:-1].split(' '))), lines ))[1:]
        for i in range(len(the_list)):
            the_list[i] = (int(the_list[i][0])-1, int(the_list[i][1])-1)
        return the_list, int(lines[0].split(' ')[0])

def normalize(A):
    '''normalizes a matrix'''
    new_A = A
    N_js = [None]*len(A)
    for i in range(len(A)):
        N_js[i] = list(A[:,i]).count(1)
        
    for i in range(len(A)):
        if N_js[i] != 0:
            for j in range(len(A)):
                new_A[i][j] = A[i][j]/N_js[j]

    return np.array(new_A)
    
    
def get_link_matrix(tuples, n):
    '''creates the link matrix froma  list of tuples'''
    A = list(np.zeros((n,n)))
    for t in tuples:
        A[t[0]][t[1]] = 1
    return normalize(np.array(A))


def get_E_matrix(n, mu):
    '''gets the e matrix'''
    return np.full(n, mu/n)


def get_final_ranking(result):
    '''gets the final ranking given a list of numbers'''
    final_ranking = result.argsort()[::-1]
    return final_ranking
    
    
def full_assignment():
    '''executes the required code for the complete assignment'''
    mu = 0.15
    
    file_name = 'links.txt'
    
    links_tuples, n = get_tuples_from_file(file_name)
    
    A = get_link_matrix(links_tuples, n)
    
    e = get_E_matrix(n, mu)

    x = np.array([1/n] * n)
    
    prev_x = np.array([1] * n)
    
    i = -1
    
    not_converged = True
    
    to_print = True
    
    max_diff = 0
    
    prev_max_diff = 0
    
    while not_converged:
        max_diff = 0
        i += 1
        prev_x = deepcopy(x)
        x = (1-mu)*A@x + e
        for x1, x2 in zip(prev_x, x):
            max_diff = max(max_diff, abs(x1 - x2))
        
        if max_diff < 1e-8 and to_print:
            print("number of iterations needed to reach the threshold: " + str(i))
            print("resulting array:")
            print(x)
            ranking = get_final_ranking(x)+1
            print("Threshold ranking:")
            print(ranking)
            to_print = False
        
        if prev_max_diff == max_diff:
            not_converged = False
            
        prev_max_diff = max_diff
    
    print()

    print("Algorithm converged!")
    print("number of iterations needed: " + str(i))
    print("resulting array:") 
    print(x)

    
    final_ranking = get_final_ranking(x)+1

    print("final ranking:")
    print(final_ranking)

    print()
    print()
    print("After adding the backlink:")
    
    links_tuples_1 = deepcopy(links_tuples)
    # transforming tuple to list to be able to insert the back link
    links_tuples_1 = list(links_tuples_1)
    links_tuples_1.append((13,13))
    links_tuples_1 = tuple(links_tuples_1)
    
    #getting the new backlink matrix
    A_1 = get_link_matrix(links_tuples_1, n)
    
    x_1 = np.array([1/n] * n)
    
    prev_x_1 = np.array([1] * n)
    i = -1
    not_converged = True
    to_print = True
    max_diff = 0
    prev_max_diff = 0
    while not_converged:
        max_diff = 0
        i += 1
        prev_x_1 = deepcopy(x_1)
        #x = (1-mu)*A@x + (mu/n)*e
        x_1 = (1-mu)*A_1@x_1 + e
        for x1, x2 in zip(prev_x_1, x_1):
            max_diff = max(max_diff, abs(x1 - x2))
        
        if max_diff < 1e-8 and to_print:
            print("number of iterations needed to reach the threshold: " + str(i))
            print("resulting array:")
            print(x_1)
            ranking = get_final_ranking(x_1)+1
            #final_ranking_1 = get_final_ranking(x_1)
            print("Threshold ranking:")
            print(ranking)
            to_print = False
        
        if prev_max_diff == max_diff:
            not_converged = False
            
        prev_max_diff = max_diff
    
    

    print("Algorithm converged!")
    print("number of iterations needed: " + str(i))
    print("resulting array:") 
    print(x_1)

    
    final_ranking = get_final_ranking(x_1)+1

    print("final ranking:")
    print(final_ranking)
full_assignment()