// EGYPTIAN MULTIPLICATION

#include <stdio.h>

// we compute log2n via a recursive method and remove the remainder
unsigned int log2n(unsigned int num) {
   return (num > 1) ? 1 + log2n(num / 2) : 0;
}

int main()
{
    //to begin, first we initialize our array of additives
    int the_size = log2n(__INT_MAX__);
    int current[the_size];
    for(int i=0;i<the_size;i++) {
        current[i] = 0;
    }

    // we define the two numbers needing multiplying
    // note, that we are assuming small numbers, as this is what was needed in
    // the past. Larger numbers would need to be broken down via recursion to
    // maximize "efficiency"
    unsigned int a = 3;
    unsigned int b = 31;

    // first, let's find the larger of the two numbers, to ease the final
    // summing operation
    unsigned int larger;
    unsigned int smaller;

    if(a > b) {
        larger = a;
        smaller = b;
    } else {
        larger = b;
        smaller = a;
    }

    // now, we run our algorithm
    int max_bit = 0;
    int now = 1;
    int current_large = larger;
    
    for (;;) {
        for (;;) {
            if(now > current_large) {
                current_large = current_large - (now/2);
                break;
            }
            now *= 2;
        }

        current[max_bit] = now/2;
        max_bit = max_bit + 1;

        if(current_large == 0) {
            break;
        }
        now = 1;
    }
    
    int answer = 0;
    for(int j=0;j<max_bit;j++) {
        answer += (current[j]*smaller);
    }

    printf("%u\n", answer);
    printf("%u\n", a*b);

    return 0;
}