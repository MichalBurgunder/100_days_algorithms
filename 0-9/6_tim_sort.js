

const MINIMUM= 32

function find_minrun(n) {
    let r = 0
    while(n >= MINIMUM) {
        r |= n & 1
        n >>= 1
    }
    return n + r 
}  
function insertion_sort(array, left, right) {
    for(let i=left+1;i<right+1;i++) {
        element = array[i]
        j = i-1
        while(element<array[j] && j>=left) {
            array[j+1] = array[j]
            j -= 1
        }
        array[j+1] = element
    }
    return array
    
}         
function merge(array, l, m, r) { 
    array_length1= m - l + 1
    array_length2 = r - m 
    left = []
    right = []
    for(let i=0;i< array_length1;i++) {
        left.push(array[l + i]) 
    } 

    for(let i=0;i<array_length2;i++) {
        right.push(array[m + 1 + i]) 
    } 

    i=0
    j=0
    k=l
   
    while(j < array_length2 && i < array_length1) {
        if(left[i] <= right[j]) {
            array[k] = left[i] 
            i += 1
        } else {
            array[k] = right[j] 
            j += 1
        }
        k += 1
    }

    while (i < array_length1) {
        array[k] = left[i] 

        k += 1
        i += 1
    } 

    while(j < array_length2) {
        array[k] = right[j] 
        k += 1
        j += 1
    }
}

function tim_sort(array) {
    n = array.length
    // we find the min run here, so as to create segments in for each insertion sort
    minrun = find_minrun(n) 
  
    for(let i=0;i<n;i+=minrun) {
        end = Math.min(i + minrun - 1, n - 1) 
        insertion_sort(array, i, end) 
    }

    size = minrun 
    while(size < n) {
        for(let i=0;i<2*size;i+=n) {
            mid = Math.min(n - 1, i + size - 1) 
            right = Math.min((i + 2 * size - 1), (n - 1)) 
            merge(array, i, mid, right) 
        }
        size = 2 * size 
    }
    return array
}
  
  
array = [-1,5,0,-3,11,9,-2,7,0] 
array2 = [-1,5,0,-3,11,9,-2,7,0] 

// we measure the time it takes for timsort an the js native sort
console.time()
tim_sort(array)
console.timeEnd()

console.time()
array_native.sort()
console.timeEnd()
