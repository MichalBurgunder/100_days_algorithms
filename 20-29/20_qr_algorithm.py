# QR ALGORITHM

import numpy as np
import copy
import math

# when you have two vectors, then the projection of one vector onto another, is
# the component of the matrix which makes of the component of the other. This is
# particularly useful for finding the orthogonal component of a vector. 
def proj(un, an):
    return ((un.T@an)/(un.T@un))*un

# each square matrix can, by missing proof, be decomposed into an orthogonal
# matrix (Q^T=Q^-1) and an upper/lower triangular matrix. It isn't clear that
# this can be done, although using Gaussian elimination, we can at least prove
# to ourselves that we can get the triangular matrix. The remaining value is
# indeed orthogonal (each of its columns is linearly independent), as otherwise
# they would have been eliminated. 
def qr_decomposition(matrix):
    # we take the first column of the inputted matrix as the starting point,
    # before beginning the Gram-Schmid process on the other vectors
    U = [matrix[:,0]]
    for i in range(1, len(matrix)):
        un = copy.deepcopy(matrix[:,i])
        # now we take the projection of one column on the previous one, forming
        # subsequent linearly independent vectors, which we concatenate into the
        #  matrix U. 
        for j in range(i, 0, -1):
            un -= proj(np.array(U[j-1]), np.array(matrix[:,i]))
        U.append(un)
    U = np.array(U).T

    # now we normalize each column by diving the value of each entry iby the
    # norm of each column.
    Q = []
    for i in range(0,len(U)):
        Q.append(U[:,i]/math.sqrt(sum([U[j][i]**2 for j in range(0,3)])))
        
    Q = np.array(Q, dtype=float).T

    # because we assume that A=QR, and Q^T=Q^-1, when we multiply both sides by
    # Q^-1 (really, Q^T), we get R
    R = Q.T@matrix

    return Q, R


# the QR decomposition is done by the Gram-Schmidt process, hence we iterate.
def qr_algorithm(A, max_iter=400):
    # here we copy the matrix, so that we can manipulate these two matricies
    # as the algorithm progresses
    q = A.copy()
    r = A.copy()
    
    for i in range(0, max_iter):
        # first, we perform a QR decomposition
        q, r = qr_decomposition(r)

        # as A_(k+1) = Q_k.TA_kQ_k, by redefining the r matrix with one of
        # "reduced excessive eigenvector magnitudes", every iteration slowly
        # converges on the eigenvalues of the initial matrix.
        r = np.dot(r, q)

    return np.diagonal(r)

matrix = np.array([[2,-22,-49], [-8273,2,612], [4,-5,-2]], dtype=float)

res = qr_algorithm(matrix)

print(res)
print(np.linalg.eigvals(matrix))
