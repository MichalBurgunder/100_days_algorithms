import numpy as np
import matplotlib.pyplot as plt 

pointSetP =  np.array([[-2.4,-1.6], [0.5,-0.7],[-3.0,0.3],[-1.1,0.9],[-3.6,2.2],[-0.7,3.1],])
pointSetQ = np.array([[-0.3,0.5],[1.6,-1.8],[1.3,1.7],[2.5,0.2],[2.8,3.0],[4.7,0.6]])

'''Plots some data points (used for testing)'''
def plotStuff(pPoints, qPoints, R, t, newPoints):
    nx = list(map((lambda x: x[0]), newPoints))
    ny = list(map((lambda x: x[1]), newPoints ))

    px = list(map((lambda x: x[0]), pPoints))
    py = list(map((lambda x: x[1]), pPoints ))

    qx = list(map((lambda x: x[0]), qPoints))
    qy = list(map((lambda x: x[1]), qPoints ))

    plt.scatter(px, py, color=['red'])
    plt.scatter(qx, qy, color=['blue'])
    plt.scatter(nx, ny, color=['purple'])

    plt.xlabel("X")
    plt.ylabel("Y")
    plt.title("Scatter Plot")
    plt.show()


'''
Finds the means of the point values, for every dimension
'''
def findBarycenter(points): 
    m = len(points)
    dim = len(points[0])
    res = [0]*dim

    for p in range(0,m):
        for d in range(0,dim):
            res[d] += points[p][d]

    for d in range(0,dim):
        res[d] /= m
    return np.array(res)

'''Find the optimal translation used for ICP'''
def findOptimalTranslation(pBar, R, qBar):
    return pBar - np.dot(R, qBar)

'''Given a set of points at their mean, it finds the differences between the mean and the points'''
def findMyHat(pointsSet, pointBar):
    theHat = np.array([[None] * pointsSet.shape[1]] * len(pointsSet))
    for p in range(0,len(pointsSet)):
        for d in range(0,pointsSet.shape[1]):
            theHat[p][d] = pointsSet[p][d] - pointBar[d]
    return np.array(theHat.T, dtype=float)

'''Gets the covariance matrix of two matrices'''
def getCovarianceMatrix(pHat, qHat):
    return np.dot(pHat, qHat.T)

'''Returns the difference in coordinates of the pSet and the new points'''
def f(p, R, q, t):
    return np.subtract(np.subtract(p,np.dot(R, q.T).T),t)

'''Prints the result as specified by the assignment sheet'''
def printStuff(R, t, fRes, p):
    print("R")
    print(R)
    print("\noptimalT")
    print(t)
    print("\nfRes")
    print(fRes)
    print("\npSet")
    print(p)

'''The Iterative closest point (ICP) algorithm on two point sets'''
def ICP(pSet, qSet):
    [pBar, qBar] = [findBarycenter(pSet), findBarycenter(qSet)]
    [pHat, qHat] = [findMyHat(pSet, pBar), findMyHat(qSet, qBar)]

    covarianceMatrix = getCovarianceMatrix(pHat, qHat)

    U, Sigma, V = np.linalg.svd(covarianceMatrix) 

    R = np.dot(U,V.T)

    optimalT = findOptimalTranslation(pBar, R, qBar)

    newPoints = np.add(np.dot(R, qSet.T).T,optimalT)

    # according to specifications, we calculate f
    fRes = f(pSet, R, qSet, optimalT)

    # In order to take a took at the actual result, we can plot things in here
    plotStuff(pointSetP, pointSetQ, R, optimalT, newPoints)

    # printStuff(R, optimalT, fRes, pSet)
    return pSet

ICP(pointSetP,pointSetQ)

'''
This function will print out the following:

R
[[ 0.36070496 -0.93267997]
 [ 0.93267997  0.36070496]]

optimalT
[-1.82127111 -1.51112141]

fRes
[[-0.00417742  0.01057293]
 [ 0.06531922 -0.03189761]
 [-0.06208939 -0.01456098]
 [ 0.0060447   0.00728049]
 [ 0.00933713  0.01750261]
 [-0.01443423  0.01110257]]

pSet
[[-2.4 -1.6]
 [ 0.5 -0.7]
 [-3.   0.3]
 [-1.1  0.9]
 [-3.6  2.2]
 [-0.7  3.1]]
'''