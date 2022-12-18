import numpy as np
import copy

def proj(un, an):
    return ((un.T@an)/(un.T@un))*un

def qr_decomposition(matrix):
    U = [matrix[:,0]]
    for i in range(1, len(matrix)):
        un = copy.deepcopy(matrix[:,i])
        for j in range(i, 0, -1):
            un -= proj(np.array(U[j-1]), np.array(matrix[:,i]))
        U.append(un)
    U = np.array(U).T

    Q = []
    for i in range(0,len(U)):
        Q.append(U[:,i]/np.linalg.norm(U[:,i])*(-1))
        
    Q = np.array(Q, dtype=float).T
    R = Q.T@matrix

    return Q, R


def qr_algorithm(A, max_iter=400):
    q = A.copy()# this is just the identity matrix
    r = A.copy() # ..
    
    for i in range(0, max_iter):
        q, r = qr_decomposition(r)
        r = np.dot(r, q)

    return np.diagonal(r)

matrix = np.array([[2,-22,-49], [-8273,2,612], [4,-5,-2]], dtype=float)

res = qr_algorithm(matrix)

print(res)
print(np.linalg.eigvals(matrix))
