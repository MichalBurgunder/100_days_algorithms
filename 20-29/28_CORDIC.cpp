#include <iostream>
#include <vector>
#include <cmath>

using namespace std;

// custom function to multiply a matrix by a vector
vector<float> mat_mult(vector<vector<float>> A, vector<float> B)
{
    // initialize the result matrix with zeros
    vector<float> C = {0, 0};


    C[0] += A[0][0] * B[0];
    C[0] += A[0][1] * B[1];

    C[1] += A[1][0] * B[0];
    C[1] += A[1][1] * B[1];

    return C;
}

// returns our appropriate sigma value, based on the angle
int sigma_i(float angle) {
    return angle > 0 ? 1 : -1;
}

// we return our K value based on i
float K_i(int i) {
    return 1/(sqrt(1+pow(2, -2*i)));
}

vector<vector<float> > R_i(int i, int s) {
    vector<vector<float> > A(2, vector<float>(2));
    A[0][0] = 1;
    A[0][1] = -s*pow(2, -i);
    A[1][0] = s*pow(2, -i);
    A[1][1] = 1;
    return move(A);
}

float gamma_i(int i) {
     return atan(pow(2, -i));
}

int main()
{
    vector<float> v = {1, 0};

    int n = 20;
    float angle = 5*M_PI/17;

    for (int i = 0; i < n; i++)
    {
        int s = sigma_i(angle);
        float k = K_i(i);
        vector<vector<float> > r = R_i(i, s);
        r[0][0] *= k;
        r[0][1] *= k;
        r[1][0] *= k;
        r[1][1] *= k;
        v = mat_mult(r, v);
        angle = angle - (s * gamma_i(i));
    }
    cout << "\ncmath computed values for cosine and sine: " << endl;
    cout << "cosine: " << cos(angle) << endl;
    cout << "sine: " << sin(angle) << endl;

    cout << "\nCORDIC computed values for cosine and sine:" << endl;
    cout << "cosine: " << v[0] << endl;
    cout << "sine: " << v[1] << endl;

    return 0;
}