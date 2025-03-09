# DIRECT LINEAR TRANSFORM

# needs to be modified. 

import numpy as np

# a few points
pink_ball = (1171, 783)
blue_ball = (1171, 512)
brown_ball = (1171, 251)
blue_ball = (1340, 251)

middle_left = (568, 251)
white_line_left = (625, 263)
black_ball = (1171, 988)


up_left_corner = (680, 102)
up_right_corner = (1668, 102)
bottom_right_corner = (1929, 1143)
bottom_left_corner = (421, 1143)

flat_up_left_corner = (421, 102) # simply changed x
flat_up_right_corner = (1929, 102) # simply changed x
flat_bottom_right_corner = (1929, 1143)
flat_bottom_left_corner = (421, 1143)


# the distances

# vars: define the points in the original image, and in the modified (flat) image
def get_A(po, pn): # points original, points new
  draft_A = []
  # print(len(po))
  for n in range(len(po)):
    x = po[n][0]
    y = po[n][1]
    # n --> new
    xn = pn[n][0]
    yn = pn[n][1]

    # we can assume w and w' to be 1
    draft_A.append([
                    0, 0, 0,
                    -x, -y, -1,
                    x*yn, y*yn, yn # we place the last number so that we can reshape later
                  ])
    draft_A.append([
                    x, y, 1,
                    0, 0, 0,
                    -x*xn, -y*xn, -x # we place the last number so that we can reshape later
                  ])

  return np.array(draft_A)

def single_value_decompose(A):
  U, S, V = np.linalg.svd(A)
  # V = V.T
  return U, S, V

# lets define the "flat" points
original_points = [up_left_corner, up_right_corner, bottom_right_corner, flat_bottom_left_corner] # we leave out bottom left corner
flat_points = [flat_up_left_corner, flat_up_right_corner, flat_bottom_right_corner, flat_bottom_left_corner] # we leave out bottom left corner

# this is the matrix that is given in the textbook
A = get_A(original_points, flat_points)
# print("np.linalg.matrix_rank(A)")
# print(np.linalg.matrix_rank(A))

# step ii (using library function so that we don't have to program the whole thing)
U, S, V = single_value_decompose(A)

# h is the last column
h = V[-1]

# we reshape so that
h = h.reshape((3,3))/h[-1]
print("h")
print(h)


# taken from https://stackoverflow.com/questions/49852455/how-to-find-the-null-space-of-a-matrix-in-python-using-numpy
def get_nullspace(A, atol=1e-13, rtol=0):
    A = np.atleast_2d(A)
    u, s, vh = np.linalg.svd(A)
    tol = max(atol, rtol * s[0])
    nnz = (s >= tol).sum()
    ns = vh[nnz:].conj().T
    return ns

nullspace = get_nullspace(A)
ns_reshaped = nullspace.reshape((3,3))
print("ns_reshaped")
print(ns_reshaped/ns_reshaped[2][2])
# final_rs = get_nullspace(ns_reshaped)
# print(ns_reshaped/ns_reshaped[2][2])
# identity_matrix = np.array([[1,0,0], [0,1,0], [0,0,1]])
# print(np.array(U@np.diag(S)@V, dtype=int))
# print(U)
# print(H)
# print(np.diag(S))
# print()
# print(V)
# print()

# print()
# print(V[-1])
# print(V[-1,-1])
# print(res)