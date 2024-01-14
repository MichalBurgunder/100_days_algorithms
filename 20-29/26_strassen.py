# code taken from https://gist.github.com/syphh/1cb6b9bb57a400873fa9d05cd1ee7cc3
import numpy as np
import time

def naive_multiplication(A, B):
    n, m, p = A.shape[0], A.shape[1], B.shape[1]
    C = np.array([[0]*p for i in range(n)])

    for i in range(n):
        for j in range(p):
            for k in range(m):
                C[i][j] = C[i][j] + A[i][k]*B[k][j]
    return C

def split_matrix(matrix):
    n = len(matrix)
    return matrix[:n/2, :n/2], matrix[:n/2, n/2:], matrix[n/2:, :n//2], matrix[n/2:, n/2:]

def strassen(A, B):
    if len(A) <= 2:
        return naive_multiplication(A, B)
    
    # note that here, each letter corresponds to a a matrix entry:

    # M =
    #     [ a   b ]
    #     [ c   d ]
    
    # similarly, 
    # N = 
    #     [ e   f ]
    #     [ g   h ]
    
    a, b, c, d = split_matrix(A)
    e, f, g, h = split_matrix(B)
    
    M1 = strassen(a+d, e+h)
    M2 = strassen(d, g-e)
    M3 = strassen(a+b, h)
    M4 = strassen(b-d, g+h)
    M5 = strassen(a, f-h)
    M6 = strassen(c+d, e)
    M7 = strassen(a-c, e+f)
    C_11 = M1 + M2 - M3 + M4
    C_12 = M5 + M3
    C_21 = M6 + M2
    C_22 = M5 + M1 - M6 - M7
    C = np.vstack((np.hstack((C_11, C_12)), np.hstack((C_21, C_22))))
    return C


# choose your square matrix size
matrix_size = 64

A = np.random.rand(matrix_size,matrix_size)
B = np.random.rand(matrix_size,matrix_size)

before1 = time.time()
C = naive_multiplication(A, B)
after1 = time.time()

before2 = time.time()
C = strassen(A, B)
after2 = time.time()


print("naive_multiplication: " + str(after1 - before1))
print("strassen: " + str(after2 - before2))