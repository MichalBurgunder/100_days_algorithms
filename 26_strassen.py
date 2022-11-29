# code taken from https://gist.github.com/syphh/1cb6b9bb57a400873fa9d05cd1ee7cc3
import numpy as np
import time

# choose your square matrix size
matrix_size = 64

def naive_multiplication(A, B):
    n, m, p = A.shape[0], A.shape[1], B.shape[1]
    C = np.array([[0]*p for i in range(n)])

    for i in range(n):
        for j in range(p):
            for k in range(m):
                C[i][j] = C[i][j] + A[i][k]*B[k][j]
    return C

def split(matrix):
    n = len(matrix)
    return matrix[:n//2, :n//2], matrix[:n//2, n//2:], matrix[n//2:, :n//2], matrix[n//2:, n//2:]

def strassen(A, B):
    if len(A) <= 2:
        return naive_multiplication(A, B)
    a, b, c, d = split(A)
    e, f, g, h = split(B)
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



A = np.random.rand(matrix_size,matrix_size)
B = np.random.rand(matrix_size,matrix_size)

before2 = time.time()
for i in range(1):
    C = naive_multiplication(A, B)
    print(i)
after2 = time.time()

before1 = time.time()
for i in range(1):
    C = strassen(A, B)
    print(C)
after1 = time.time()


print("naive_multiplication: " + str(after2 - before2))
print("strassen: " + str(after1 - before1))