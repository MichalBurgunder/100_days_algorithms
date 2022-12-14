import numpy as np

def proj(un, an):
    return ((un.T@an)/(un.T@un))*un

def qr_decomposition(matrix):
    U = [matrix[:,0]]
    for i in range(1, len(matrix)):
        un = matrix[:,i]
        for j in range(i, 0, -1):
            un -= proj(np.array(U[j-1], dtype=float), np.array(matrix[:,i],dtype=float))
        U.append(un)
    U = np.array(U, dtype=float).T

    Q = []
    for i in range(0,len(U)):
        Q.append(U[:,i]/np.linalg.norm(U[:,i]))
        
    Q = np.array(Q, dtype=float).T
    R = Q.T@matrix
    # print(matrix)
    # print(Q)
    # print(R)
    # exit()
    return Q, R

def qr_algorithm(A, max_iter=10):
    
    # Initialize values
    q = np.eye(A.shape[0]) # this is just the identity matrix
    r = q.copy() # ..
    
    a = A
    for i in range(0, max_iter):
        print(a)
        q, r = qr_decomposition(a)
        # print(q)
        # print(r)
        # print(q@r)
        # exit()
        # q, r = np.linalg.qr(a)
        a = np.dot(r, q)
        # a = q.T@a@q

    return np.diagonal(a)

matrix = np.array([[12,-51,4], [6,167,-68], [-4,24,-41]], dtype=float)

res = qr_algorithm(matrix)

print(res)
print(np.linalg.eigvals(matrix))

            
        
        
        
        
# print(qr_algorithm(matrix))
# print(qr_decomposition(matrix))