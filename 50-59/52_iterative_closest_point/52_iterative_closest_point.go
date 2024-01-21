// % import numpy as np
// % import matplotlib.pyplot as plt

package main

import (
	"fmt"

	"gonum.org/v1/gonum/mat"
)

func findBarycenter(points [][]float64) ([]float64) {
    number_of_points := len(points)
    dim := len(points[0])
    response := make([]float64, dim)

    for i := 0; i < number_of_points; i++ {
        for d := 0; d < dim; d++{
            response[d] += points[i][d]
        } 
    }

    for d := 0; d < dim; d++ {
        response[d] /= float64(number_of_points)
    }
        
    return response
}


func main() {
    fmt.Println("hello there")
    pointSetP := mat.NewDense(6, 2, []float64 {
        -2.4, -1.6,
         0.5, -0.7,
        -3.0,  0.3,
        -1.1,  0.9,
        -3.6,  2.2,
        -0.7,  3.1,
    })

    pointSetQ := mat.NewDense(6, 2, []float64 {
        -0.3,  0.5,
         1.6, -1.8,
         1.3,  1.7,
         2.5,  0.2,
         2.8,  3.0,
         4.7,  0.6,
    })

    pBar := findBarycenter(pointSetP)
    qBar := findBarycenter(pointSetQ)
  
    pHat := findMyHat(pointSetP, pBar)
    qHat := findMyHat(pointSetQ, qBar)

    // covarianceMatrix = getCovarianceMatrix(pHat, qHat)

    // U, Sigma, V = np.linalg.svd(covarianceMatrix) 

    // R = np.dot(U,V.T)

    // optimalT = findOptimalTranslation(pBar, R, qBar)

    // newPoints = np.add(np.dot(R, qSet.T).T,optimalT)

    // // according to specifications, we calculate f
    // fRes = f(pSet, R, qSet, optimalT)

    // // In order to take a took at the actual result, we can plot things in here
    // plotStuff(pointSetP, pointSetQ, R, optimalT, newPoints)

    // // printStuff(R, optimalT, fRes, pSet)
    // return pSet

}