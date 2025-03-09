# ITERATIVE CLOSEST POINT ALGORITHM

import numpy as np
import matplotlib.pyplot as plt 


pointSetP =  np.array([
    [-2.4, -1.6],
    [ 0.5, -0.7],
    [-3.0,  0.3],
    [-1.1,  0.9],
    [-3.6,  2.2],
    [-0.7,  3.1]
    ])

pointSetQ = np.array([
    [-0.3,  0.5],
    [ 1.6, -1.8],
    [ 1.3,  1.7],
    [ 2.5,  0.2],
    [ 2.8,  3.0],
    [ 4.7,  0.6]
    ])

def my_map(pts):
    return [list(map((lambda x: x[0]), pts)), list(map((lambda x: x[1]), pts))]

# we plot our results
def plotStuff(pPoints, qPoints, newPoints):
    px, py = my_map(pPoints)
    qx, qy = my_map(qPoints)

    nx, ny = my_map(newPoints)
    plt.scatter(px, py, color='red', label='1st point cloud')
    plt.scatter(qx, qy, color='blue', label='2nd point cloud')
    plt.scatter(nx, ny, color='purple', label='ideal rigid transformation')

    plt.xlim(-4, 5)
    plt.ylim(-2, 5)
    plt.xlabel("X")
    plt.ylabel("Y")
    plt.title("Iterative Closest Point Demo")
    plt.legend()
    plt.show()


# finds the barycenter of all the points. This can be understood as being the
# midpoint of all of the points given
def findBarycenter(points): 
    # this parameter is the number of dimensions
    dims = len(points[0])
    res = [0]*dims

    for p in range(0, len(points)):
        for d in range(0, dims):
            res[d] += points[p][d]

    # we just divide 
    return np.array([res[d] / len(points) for d in range(0, dims)])


# once we rotate the q set of points, we simply find the translation that maps
# one set of points onto another
def findOptimalTranslation(pBar, R, qBar):
    return pBar - np.dot(R, qBar)

# given a set of points at their mean, it finds the differences between the mean
# of the points for each dimension, and the points themselves.
def findMyHat(pointsSet, pointBar):
    theHat = np.array([[None] * pointsSet.shape[1]] * len(pointsSet))
    for p in range(0,len(pointsSet)):
        for d in range(0,pointsSet.shape[1]):
            theHat[p][d] = pointsSet[p][d] - pointBar[d]
    return np.array(theHat.T, dtype=float)

# creates the covariance matrix from differences between the points and their
# means, by multiplying them together.
def getCovarianceMatrix(pHat, qHat):
    return np.dot(pHat, qHat.T)


# the key trick in the iterative closest point algorithm, is to first, find the
# midpoints of the 'point cloud' that are inputted into the algorithm. These
# are, if all points are treated with equal priority, the barycenter of the
# points. You can imagine this as the point where these points would converge,
# if each point had the same gravitational forces acting on every other point.
# We will eventually translate point point cloud onto another, by applying the
# distance of their barycenters. Before doing so, we must find the ideal
# rotational matrix, which will rotate the points around the origin (0,0)

# to find the rotational matrix, we find the corvariance matrix first. This is
# easily creatable using our points. The covariance describes the variance
# between any two points between the clouds. Important to note however, is that
# the rotational matrix is implicit in the covariance matrix between the two
# point clouds. To extract the rotational matrix from the covariance matrix, we
# need to take the single value decomposition (SVD) of the covariance matrix,
# getting matrices U, S, and V, (multiplying them in this order gets us back our
#  covariance amtrix) U and V which are unitary, meaning that they preserve
# orientation between the points, and S (Sigma), which is a diagonal matrix of
# the square root of eigenvalues. Note, that eignevalues are scalars (numbers)
# which, if they are not zero, stretch any point clouds. As we wish to avoid any
#  stretching because we are only "shifting", and the other two matrices retain
# orientation between all points, we ignore S, and multiply U and V together.
# This results in a matrix that, because we implicitly set the eigenvalues to 1
# (like setting S to be the identity matrix), the emerging must be 1) a rotation
# matrix (preserves orientation), and 2) the ideal rotation matrix (otherwise,
# the SVD would not have come out the way it did). From there, we find the ideal
# translation and we are done. 

def ICP(pSet, qSet):
    # we begin by finding the barycenters of each point clouds (xBar) Next, we
    # find the offset of each point in each cloud, to their barycenter (xHat)
    [pBar, qBar] = [findBarycenter(pSet), findBarycenter(qSet)]
    [pHat, qHat] = [findMyHat(pSet, pBar), findMyHat(qSet, qBar)]

    # we compute the covariance matrix. This involves a simple multiplication of
    # one matrix with another
    covarianceMatrix = getCovarianceMatrix(pHat, qHat)
    
    # single value decomposition. See the SVD algorithm. We use the standard
    # numpy implementation for simplicity
    U, Sigma, V = np.linalg.svd(covarianceMatrix) 

    # multiplying the together, gets us the rotation matrix, as described above. 
    R = np.dot(U, V.T)

    # to find the optimal translation, we first rotate the first point cloud
    # around (0,0), and then find the translation afterwards. Note that we could
    # go the other way, if we decided to find the translation to (0,0) first,
    # then place it at the other barycenter. But that would require two
    # operations in that we would have to center the rotation around that
    # barycenter, two operations, while this method one only requires one. 
    optimalT = findOptimalTranslation(pBar, R, qBar)
    
    # with R and t, we apply these things on our old point cloud, and get new
    # points that are optimally close, but most often, not exact
    newPoints = np.add(np.dot(R, qSet.T).T, optimalT)

    
    # and we plot
    plotStuff(pointSetP, pointSetQ, newPoints)

ICP(pointSetP,pointSetQ)