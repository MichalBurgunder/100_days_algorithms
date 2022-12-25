#include <stdio.h>

// we compute log2n via a recursive method and remove the remainder
unsigned int log2n(unsigned int num) {
   return (num > 1) ? 1 + log2n(num / 2) : 0;
}

int main()
{
    // we initialize our array of additives
    int the_size = log2n(__INT_MAX__);
    int current[the_size];
    for(int i=0;i<the_size;i++) {
        current[i] = 0;
    }

    // define the two numbers needing multiplying
    // note, that we are assuming small numbers, as this is likely what was needed in the past
    // larger numbers would need to be broken down via recursion to maximize "efficiency"
    unsigned int a = 3;
    unsigned int b = 31;

    // let's find the larger of the two numbers, to ease the final summing
    unsigned int larger;
    unsigned int smaller;
    if(a > b) {
        larger = a;
        smaller = b;
    } else {
        larger = b;
        smaller = a;
    }

    // now we run our algorithm
    int max_bit = 0;
    int now = 1;
    int current_large = larger;
    while(1) {
    printf("%u\n", current_large);
        while(1) {
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