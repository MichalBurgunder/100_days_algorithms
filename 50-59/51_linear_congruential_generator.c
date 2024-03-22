

#include <stdio.h>

void reset_nums(
    unsigned long *x, unsigned long *a, unsigned long *c, unsigned long *m, 
            long new_x, long new_a, long new_c, long new_m) {
    *x = new_x;
    *a = new_a;
    *c = new_c;
    *m = new_m;

}

long get_random_number(unsigned long x, unsigned long a, unsigned long c, unsigned long m) {
    return (a * x + c) % m;
}

void generate_random_numbers(unsigned long x, unsigned long a, unsigned long c, unsigned long m, int normalize) {
    long rolling_number = x;

    for(int i=0;i<20;i++) {
        rolling_number = get_random_number(rolling_number, a, c, m);
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

    // With very simple paramters the results can be very predictable to the human eye
    generate_random_numbers(x, a, c, m, 0);

//  With a little more 'complex' numbers, we can get seemingly more random results. However, on closer inspection, they are in fact a recurring set of numbers. \n");
    reset_nums(&x, &a, &c, &m, 2, 5, 2, 7);
    generate_random_numbers(x, a, c, m, 0);

// Increasing the size of the modulator will increase the size of the loop. Furthermore, by changing up the paramters to larger numbers, it more difficult to guess the 'seed' of the random number generator function
    reset_nums(&x, &a, &c, &m, 103, 778, 935, 1081);
    generate_random_numbers(x, a, c, m, 0);

// Finally, if we increase the number to very large numbers, then normalize on [0, 1], we get a seemingly completely random number generator, even though these number are in fact, pseudorandom.\n");
    reset_nums(&x, &a, &c, &m, 41293834263, 9832629238, 23421341234123, 923849234902);
    generate_random_numbers(x, a, c, m, 1);
    return 0;
}