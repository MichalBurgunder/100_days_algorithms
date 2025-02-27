# ITERATIVE CLOSEST POINT ALGORITHM

import numpy as np
import matplotlib.pyplot as plt 

pointSetP =  np.array([[-2.4,-1.6], [0.5,-0.7],[-3.0,0.3],[-1.1,0.9],[-3.6,2.2],[-0.7,3.1],])
pointSetQ = np.array([[-0.3,0.5],[1.6,-1.8],[1.3,1.7],[2.5,0.2],[2.8,3.0],[4.7,0.6]])

def my_map(pts):
    return [list(map((lambda x: x[0]), pts)), list(map((lambda x: x[1]), pts))]
# we plot our results
def plotStuff(pPoints, qPoints, R, t, newPoints):
    px, py = my_map(pPoints)
    qx, qy = my_map(qPoints)

    nx, ny = my_map(newPoints)
    plt.scatter(px, py, color='red', label='1st point cloud')
    plt.scatter(qx, qy, color='blue', label='2nd point cloud')
    plt.scatter(nx, ny, color='purple', label='ideal rigid transformation')

    # plt.xlim(0, 5)
    plt.ylim(-2, 5)
    plt.xlabel("X")
    plt.ylabel("Y")
    plt.title("Iterative Closest Point Demo")
    plt.legend()
    plt.show()


# we f
def findBarycenter(points): 
    # this parameter is the number of dimensions
    dims = len(points[0])
    res = [0]*dims

    for p in range(0, len(points)):
        for d in range(0, dims):
            res[d] += points[p][d]

    # we just divide 
    return np.array([res[d] / len(points[0]) for d in range(0, dims)])

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


# the key trick in the iterative closest point algorithm, is to first, find the midpoints of the 'point cloud' that have been given. These are, if all points are treated with equal priority, the barycenter of the points. You can image this as the point where these points would converge, if each point had the same gravitational forces acting on every other point. It essentially acts as the midpoint. Once found for both point clouds, we can apply a simple transloation, such that we only need to find the ideal rotational matrix. 

# this matrix is implicit in the covariance matrix between the two point clouds, a matrix describing the variance between any two points between the clouds. To extract the rotational matrix, we need to take the SVD of the covariance matrix, getting matrices U, S, and V, S and V which are unitary (they preserve orientation) and S, which is a diagonal matrix of the square root of eigenvalues. Note, that eignevalues are scalars (numbers) which, if they are not zero, stretch any point clouds. As we wish to avoid this, we ignore this matrix, and multiply U and V together. This results in a matrix that, because we set the eigenvalues to 1 (like an identity matrix), the emerging matrix must preserve orientation, making it 1) a rotation matrix, and 2) the ideal rotation matrix.
def ICP(pSet, qSet):
    # we begin by finding the barycenters of each point clouds (xBar)
    # next, we find the offset of each point in each cloud, to the given barycenter (xHat)
    [pBar, qBar] = [findBarycenter(pSet), findBarycenter(qSet)]
    [pHat, qHat] = [findMyHat(pSet, pBar), findMyHat(qSet, qBar)]

    # we compute the covariance matrix. This involves a simple multiplication of one matrix with another
    covarianceMatrix = getCovarianceMatrix(pHat, qHat)

    # TODO: must mention the file containing single value decomposition
    # single value decomposition. See the SVD algorithm in ___. We use the standard numpy implementation for simplicity
    U, Sigma, V = np.linalg.svd(covarianceMatrix) 

    # multiplying the together, gets us the rotation matrix, as described above. 
    R = np.dot(U, V.T)

    # to find the optimal transloation, we first rotate the first point cloud around (0,0), and then find the translation afterwards. Note that we could go the other way, if we decided to find the translation to (0,0) first, then place it at the other barycenter. But that would require two operations, and this one only requires one. 
    optimalT = findOptimalTranslation(pBar, R, qBar)

    # with R and t, we apply these things on our old point cloud, and get new points that are optimally close, but most often, not exact
    newPoints = np.add(np.dot(R, qSet.T).T,optimalT)

    # and we plot
    plotStuff(pointSetP, pointSetQ, R, optimalT, newPoints)

ICP(pointSetP,pointSetQ)