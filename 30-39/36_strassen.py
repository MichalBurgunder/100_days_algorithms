# STRASSEN'S ALGORITHM

import numpy as np
import time

# simple matrix multiplication, where we multiply each column in one matrix, by
# each row in the other matrix. This results in Θ(n^2) computations
def naive_matrix_multiplication(A, B):
    n, m, p = A.shape[0], A.shape[1], B.shape[1]
    
    result = np.zeros((n, p))

    for i in range(n):
        for j in range(p):
            for k in range(m):
                result[i][j] = result[i][j] + A[i][k]*B[k][j]

    return result

# here we split the matrix into 4 different submatricies, split down & across
# the middle, vetically and horizontally 
def split_matrix(matrix):
    n = len(matrix)
    return [
            matrix[:int(n/2), :int(n/2)], # top-left
                matrix[:int(n/2), int(n/2):], # top-right
                    matrix[int(n/2):, :int(n/2)], # bottom-left 
                        matrix[int(n/2):, int(n/2):] # bottom-right
            ]

# we verify that the method actually works
def verify_are_same(M1, M2):
    for i in range(0, len(M1)):
        for j in range(0, len(M1[i])):
            # as float values can somes differ by the LSB due to rounding, we
            # resolve the issue by accepting a slight deviation in the final
            # result. Note, that as the size of the original matrices increase,
            # so does the error
            if abs(np.round(M1[i,j], 8)) - abs((np.round(M2[i,j], 8))) != 0:
                return False
    return True

def strassen_algorithm(Matrix1, Matrix2):
    # for tiny matricies (2x2 or smaller) it is faster to just just mulitply
    if len(Matrix1) <= 2:
        return naive_matrix_multiplication(Matrix1, Matrix2)

    # to get the promised speedup, we first split the matricies into
    # submatrices, to then perform computation these smaller ones. 
    A, B, C, D = split_matrix(Matrix1)
    E, F, G, H = split_matrix(Matrix2)

    # note that here, each letter corresponds to a submatrix, that has been
    # created by splitting the original matricies in 4 equally sized parts:
    #
    # Matrix1 =
    #     [ A  B ]
    #     [ C  D ]
    #   =
    #     [  
    #       [      a_0,0, a_0,1, ... a_0,n-2 | b_0,0, b_0,1, ... b_0,n-2      ],
    #       [      a_1,0, a_1,1, ... a_1,n-2 | b_1,0, b_1,1, ... b_1,n-2      ],
    #                                       ...
    #                                       ...
    #       [  a_n/2,0 a_n-2,1 ... a_n-2,n-2 | b_n-2,0, b_n-2,1, ... b_1,n-2  ],
    #         ----------------------------------------------------------------
    #       [      c_0,0, c_0,1, ... c_0,n-2 | d_0,0, d_0,1, ... d_0,n-2      ],
    #       [      c_1,0, c_1,1, ... c_1,n-2 | d_1,0, d_1,1, ... d_1,n-2      ],
    #                                       ...
    #                                       ...
    #       [  a_n/2,0 a_n-2,1 ... a_n-2,n-2 | b_n-2,0, b_n-2,1, ... b_1,n-2 ] ,
    #     ]
    #
    
    #  we compute the summations of the different submatricies, the summation of
    #  which has been proven to provide the same result as multiplying matricies
    #  together. This provides a speedup in computation, as multiplication of
    #  matricies (and numbers in general) is always more cumbersome than
    #  addition.
    M1 = strassen_algorithm(A+D, E+H)
    M2 = strassen_algorithm(D, G-E)
    M3 = strassen_algorithm(A+B, H)
    M4 = strassen_algorithm(B-D, G+H)
    M5 = strassen_algorithm(A, F-H)
    M6 = strassen_algorithm(C+D, E)
    M7 = strassen_algorithm(A-C, E+F)

    result = np.vstack(
            (
                np.hstack((M1 + M2 - M3 + M4,      M5 + M3     )),
                np.hstack((     M6 + M2     , M5 + M1 - M6 - M7))
            )
        )
    return result


# choose your square matrix size. Given this rather simple implementation of
# strassen algorithm, it can only accept powers of 2 (2,4,8,16, etc). The bigger
# the number, the more significant the speedup wil be, compared to naive matrix
# multiplication
matrix_size = 128

Matrix1 = np.random.rand(matrix_size,matrix_size)
Matrix2 = np.random.rand(matrix_size,matrix_size)

before1 = time.time()
result_naive = naive_matrix_multiplication(Matrix1, Matrix2)
after1 = time.time()

before2 = time.time()
result_strassen = strassen_algorithm(Matrix1, Matrix2)
after2 = time.time()

the_same = verify_are_same(result_naive, result_strassen)

print("Matrices are the same: " + str(the_same))
print("naive_multiplication: " + str(after1 - before1))
print("strassen: " + str(after2 - before2))
