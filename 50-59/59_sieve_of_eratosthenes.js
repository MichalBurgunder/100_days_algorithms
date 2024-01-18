// SIEVE OF ERATOSTHENES

function sieve_eratosthenes(x) {
    // we first create an the_array with all of our numbers, which we would like
    // tick off one by one.
    const the_array = Array.from({length: x}, (_, i) => i + 1);

    // next we pick the ceiling of the square root of the largest number. Any
    // number squared that is larger than the upper limit, need not concern us. 
    sqrt_x = Math.ceil(Math.sqrt(x))

    // and now, we simply check for the numbers up to this square root. Remember,
    // that if n is larger than the the square root, then those numbers affected
    // by the larger numbers have already been dealth with, with a correspoding
    // smaller number.
    for(let i = 2; i < sqrt_x; i++) {
        // we know that i * x will equal the upper bound, so we don't need to
        // check any higher numbers.
        bound = Math.ceil(x/i)

        // and we begin ticking off the numbers.
        // +1 to get even the last number
        for(let j = 2; j < bound+1; j++) {
            // set to zero to mean that this number is NOT a prime
            the_array[i*j-1] = 0
        }
    }

    // now we simply filter out the zeros and we are done
    return the_array.filter(i => i != 0)
}

x = 100
res = sieve_eratosthenes(x)
console.log(res)