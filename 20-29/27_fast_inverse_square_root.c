// FAST INVERSE SQUARE ROOT

#include <stdio.h>
#include <math.h>

// fast inverse square root, as specified by Wikipedia:
// 						https://en.wikipedia.org/wiki/Fast_inverse_square_root
// below is the actual implementation of the algorithm found in production,
// comments including
float Q_rsqrt( float number ) {
	long i;
	float x2, y;
	const float threehalfs = 1.5F;

	x2 = number * 0.5F;
	y  = number;
	i  = * ( long * ) &y;                       // evil floating point bit level hacking
	i  = 0x5f3759df - ( i >> 1 );               // what the fuck? 
	y  = * ( float * ) &i;
	y  = y * ( threehalfs - ( x2 * y * y ) );   // 1st iteration
//	y  = y * ( threehalfs - ( x2 * y * y ) );   // 2nd iteration, this can be removed

	return 1/y;
}

int main() {
	// we take some random number, for which we want to estimate a square root
    const float x = 10000;
    printf("%f\n", sqrt(x));
    float res = Q_rsqrt(x);
    printf("%f\n", res);
}