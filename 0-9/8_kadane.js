// KADANE'S ALGORITHM

function kadanes_algorithm(the_array) {
    // we initialize a variables that is a rolling sum with every iteration...
    // ...and one variable to act as our rolling maximum sum
    let max_now = 0;
    let max_overall = 0;
      
    // we go through our array using a loop (only one call per element!)
    for (let i = 0; i < the_array.length; i++) {
        // we add our rolling sum with the next number...
        max_now = max_now + the_array[i];
        // ...and decide whether this rolling sum is a new maximum subarray sum
        if (max_overall < max_now) {
            max_overall = max_now;
        }
    
        // the key insight is here: if the sum of the subarray is smaller than 0,
        // then the trivial subarray [] is always larger (sum([])=0). So we reset
        // our rolling sum to 0 in that case, and restart our summing from 0. 
        if (max_now < 0) {
            max_now = 0;
        }
    }

    // finally return our overall maximum, and we are done.
    return max_overall
}
  
const to_be_analyzed = [-3, 6, -2, 7, 1, -10, 8, -5, 4]
console.log(kadanes_algorithm(to_be_analyzed))