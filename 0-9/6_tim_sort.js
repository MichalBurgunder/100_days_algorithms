// TIM SORT ALGORITHM

const MINRUN = 2

function find_minrun(n) {
    let r = 0
    while(n >= MINRUN) {
        r |= n & 1
        n >>= 1 
    }
    return n + r 
}  

// here we are simply doing an insertion sort: go through the array, element by element, switching those positions that need switching, until the full array is sorted)
function insertion_sort(array, left=0, right=array.length) {
    let temp = null
    
    for(let i = left; i < right; i++) {
        for(let j = i+1; j <= right; j++) {
            if(array[i] > array[j]) {
                temp = array[i]
                array[i] = array[j]
                array[j] = temp
            }
        }
    }
    return array
}


// this is the merge from merge sort. We basically take an array, split it in two, and then combine the two subarrays by aligning its elements like a "zipper"
function merge(array, l, r, e) {
    // we first take the segment of the array we wish to align and split it into two
    left = array.slice(l, r+1)
    right = array.slice(r+1, e+1)

    // now we zip them up. We initialize the variables so that we are able to iterate through the array
    let i = 0 // going through our "left" subarray
    let j = 0 // going through our "right" subarray
    let setPosition = l // determines which element to update in the original array

    // and now we zip:
    while (i < left.length && j < right.length) {
        // left or right does in next?
        if (left[i] < right[j]) {
            array[setPosition] = left[i] // left
            i++
            setPosition++
        } else {
            array[setPosition] = right[j] // right
            j++
            setPosition++
        }
    }

    // as the arrays may not be the same length, we apply the rest of the left-over elements of each arrays onto the original array (the four lines below do this for the left array. The following four lines do it for the right array). Note, we could wrap these two code segments into a loop, so that it iterates for all variables involved. However, I decided to keep it this way, for clarity sake. 
    while (i < left.length) {
        array[setPosition] = left[i]
        i++, setPosition++
    }
    
    while (j < right.length) {
        array[setPosition] = right[j]
        j++, setPosition++
    }
}

// timsort combines different sorting algorithms into a single one, such that we
// use the quantitatively-proved best aspects of each algorithm, and combine
// them into a single algorithm. The strategy is as follows: 1) We split the array recursively
// into smaller arrays up to a particular threshold. This threshold is defined by experimentation, usually 32 for randomly sorted arrays on modern CPUs. 2) We apply
// insertion sort on each subarray. This way, we will have adjecent sorted sequences of threshold length, but no globally sorted sequence yet 3) We combine two of these subarrays together by
// using the "zipper" method of merge sort, up until there is a single array left, which forecilby must be sorted. 
function tim_sort(array) {
    const n = array.length
    
    // here we find the size of the array that we want, so as to segment each
    // array needed for our insertion sorts
    let minrun = find_minrun(n) 

    // we first sort the minimum length subarrays using insertion sort
    for(let i=0;i<n;i+=minrun) {
        end = Math.min(i + minrun - 1, n - 1) 
        insertion_sort(array, i, end) 
    }
    
    // then we simply merge each two sorted arrays, so that at the end, we get a fully sorted array. Note that here, we sort arrays two by two, making their size bigger by a factor 2 every time we pass through this outer loop.
    for (let size = minrun; size < n+1; size *= 2) {
        for (let left = 0; left < n; left += 2 * size) {
            const mid = left + size - 1;
            const right = Math.min(left + 2 * size - 1, n - 1);

            merge(array, left, mid, right);

        }
    }

    return array
}
  
  
array = [-1, 5, 0, -3 ,11, 9, -2, 7, 0]
// array = [7, 3, 8, 5]
// array = [1, 8, 99, 100, 6, 9, 40]

// we measure the time it takes for timsort an the js native sort
console.time()
console.log(tim_sort(array))
console.timeEnd()

// our implementation of timsort in JavaScript is nowhere near the efficient implementation in its compiler. The reason for this, is that we are performing significant memory allocations, along with the fact that we are using pre-given functions, which also take time to compile and run. Node however is implemented with C++ (for some parts), where efficiency is at a near theoretical maximum. We have not tried to be this precise in our sorting algorithm, hence why it significantly underpeforms.  
console.time()
console.log(array.sort())
console.timeEnd()