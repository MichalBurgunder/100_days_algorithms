// LINEAR CONGRUENTIAL GENERATOR

#include <stdio.h>

// Here is the ACUTAL linear congruential generator. A practical one relies on
// saving x for further random numbers, which here, we temporarily save in the
// generate_random_numbers() function. 
long get_random_number(unsigned long x, unsigned long a, unsigned long c,
                                                            unsigned long m) {
    return (a * x + c) % m;
}

// to avoid having to redefine variables, I just plugged them into this function
// for cleaner management. 
void reset_nums(
    unsigned long *x, unsigned long *a, unsigned long *c, unsigned long *m, 
            long new_x, long new_a, long new_c, long new_m) {
    *x = new_x;
    *a = new_a;
    *c = new_c;
    *m = new_m;
}

// This function is mostly just a wrapper for easier demonstration, with the
// exception that it saves the x number for future use/for generating additional
// random numbers.
void generate_random_numbers(unsigned long x, unsigned long a, unsigned long c,
                                            unsigned long m, int normalize) {
    // we here save our current random number, that we plug into the linear
    // congruetial generator. The output from that function updates this
    // rolling x
    long rolling_number = x;

    // for demonstration purposes, we only generate the first 20 random numbers
    for(int i = 0; i < 20; i++) {
        // we take all of our constants & x, and plug them in
        rolling_number = get_random_number(rolling_number, a, c, m);

        // some code for neat printing
        if(normalize == 1) {
            float normalized = (float)rolling_number / m;
            printf("%.2f ", normalized);
        } else {
            printf("%ld ", rolling_number);
        }
    }
    printf("\n");
}


int main() {
    unsigned long x = 0;
    unsigned long a = 4;
    unsigned long c = 0;
    unsigned long m = 2;

    // With very simple paramters the results can be very predictable. In this
    // case, when c = 0, and a is a multiple of m, the result always evaluates
    // to 0
    generate_random_numbers(x, a, c, m, 0);

    // With larger numbers, and ones that are relatively prime to one another
    // (a and m), we can get a better results. However, on inspection, they are
    // in fact a small recurring set of numbers within the modular function.
    // Thus, knowing one number will allow us to easily predict the next number
    // to be generated.
    reset_nums(&x, &a, &c, &m, 2, 5, 2, 7);
    generate_random_numbers(x, a, c, m, 0);

    // Increasing the size of the modulator will increase the size of the loop.
    // Furthermore, by changing 'a' to a larger numbers, it more difficult to
    // guess the 'seed' (starting conditions) of the random number generator
    // function. With the large numbers below, it will take many queries to the
    // random number generator before sequences repeat. Many, yes, but not
    // unrealistically many.
    reset_nums(&x, &a, &c, &m, 103, 778, 935, 1081);
    generate_random_numbers(x, a, c, m, 0);

    // Finally, if we increase all numbers to very large sizes, the loop becomes
    // so large that it takes a significant amount of time before the function
    // loops again. Ideally, the loop would be so large that it would take more
    // than a few minutes, days, or weeks before the loop repeats, when
    // resources are full dedicated to generating these random numbers. If we
    // additionally normalize these numbers on [0, 1], we can get easily
    // intrepretable numbers.
    reset_nums(&x, &a, &c, &m, 4129383429, 9826292137, 232134123423, 922349401);
    generate_random_numbers(x, a, c, m, 1);
    return 0;
}