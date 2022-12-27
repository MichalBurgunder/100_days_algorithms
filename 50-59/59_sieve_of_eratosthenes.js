

function sieve_eratosthenes(x) {
    // we create an array with all of our numbers, which we tick off one by one. 
    const arr = Array.from({length: x}, (_, i) => i + 1);

    // we pick the ceiling for 1. rounding, and 2., to make sure we check every possible number.
    sqrt_x = Math.ceil(Math.sqrt(x))
    for(let i = 2; i < sqrt_x; i++) {
        // selecting the bound we must compute to
        bound = Math.ceil(x/i)

        // +1 to get even the last number
        for(let j = 2; j < bound+1; j++) {
            // set to zero to mean that this number is NOT a prime
            arr[i*j-1] = 0
        }
    }

    // now we simply filter out the zeros and we are done
    return arr.filter(i => i != 0)
}
x = 100000
res = sieve_eratosthenes(x)
console.log(res)