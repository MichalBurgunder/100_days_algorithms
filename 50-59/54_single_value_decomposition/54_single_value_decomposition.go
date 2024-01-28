package main

import (
	"fmt"
	"math"

	"gonum.org/v1/gonum/mat"
)


func main() {
    the_matrix := mat.NewDense(3, 3, []float64 {
         9, 24,   5,
         1, -5, -16,
        -3, 11,  17,
    })
    // Input: Matrix A (m x n)

    // Step 1: Compute A^TA and AA^T
    // Covariance_AA_T = A * A^T
    // Covariance_A_T_A = A^T * A
    covariance_matrix_1 := mat.NewDense(3, 3, nil)
    covariance_matrix_2 := mat.NewDense(3, 3, nil)


    covariance_matrix_1 = mat.Mul(the_matrix, mat.T(the_matrix))
    covariance_matrix_2 = mat.Mul(the_matrix, mat.T(the_matrix))

    // Step 2: Eigenvalue Decomposition
    // Eigenvalues_AA_T, Eigenvectors_AA_T = eig(Covariance_AA_T)
    // Eigenvalues_A_T_A, Eigenvectors_A_T_A = eig(Covariance_A_T_A)

    var eig1 mat.Eigen
    var eig2 mat.Eigen
	eig1.Factorize(covariance_matrix_1, false)
	eig2.Factorize(covariance_matrix_2, false)
    eigenvalues1 := eig1.Values(nil)
    // eigenvalues2 := eig2.Values(nil)
	eigenvectors1 := mat.NewDense(3, 3, nil)
	eigenvectors2 := mat.NewDense(3, 3, nil)
    

    // Sigma = sqrt(Eigenvalues_AA_T)  // Singular values
    Sigma := mat.NewDense(3, 3, nil)
    for i := 0; i < the_matrix.length; i++ {
        Sigma[i][i] = math.Sqrt(eigenvalues1[i])
    }
    // Step 3: Calculate U
    // U = Eigenvectors_A_T_A
    U :=  mat.NewDense(3, 3, nil)
    U = eigenvectors1

    // Step 4: Assemble U, Sigma, and V^T
    V := mat.NewDense(3, 3, nil)
    V = eigenvectors2


    // Now we print
    fmt.Println(U, Sigma, V)

    fmt.Println("The decomposition:")
    fmt.Println()
    fmt.Println("When multiplied")
    fmt.Println(U)
    fmt.Print("The original matrix:")
    fmt.Println(mat.Mul(Sigma, V))

}

