

const MINIMUM = 2

function find_minrun(n) {
    let r = 0
    while(n >= MINIMUM) {
        r |= n & 1
        n >>= 1 
    }
    return n + r 
}  
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


function merge(array, l, r, e) { 
    i = l
    j = r

    left = array.slice(l, r)
    right = array.slice(r+1, e)
    
    new_array = [...array]
    
    while(true) {
        if (i >= r && j >= array.length) {
            break
        }

        if ((array[i] < array[j] && i != r) || j > 2*l-r) {
            new_array[i+j-r] = array[i]
            i++
        } else {
            new_array[i+j-r] = array[j]
            j++
        }

    }

    return new_array
    // for(let i=0;i< array_length1;i++) {
    //     left.push(array[l + i]) 
    // } 

    // for(let i=0;i<array_length2;i++) {
    //     right.push(array[m + 1 + i]) 
    // } 

    // i=0
    // j=0
    // k=l
   
    // while(j < array_length2 && i < array_length1) {
    //     if(left[i] <= right[j]) {
    //         array[k] = left[i] 
    //         i += 1
    //     } else {
    //         array[k] = right[j] 
    //         j += 1
    //     }
    //     k += 1
    // }

    // while (i < array_length1) {
    //     array[k] = left[i] 
    //     k += 1
    //     i += 1
    // } 

    // while(j < array_length2) {
    //     array[k] = right[j] 
    //     k += 1
    //     j += 1
    // }
}

// timsort combines different sorting algorithms into a single one, such that we
// use the quantitatively proved best aspects of each algorithm, and combine
// them into one. The strategy is as follows: 1) we split the array recursively
// into smaller arrays up to a particular threshold, before we 2) apply
// insertion sort on each array. These we then combine back into a single array
// using the "zipper" method of merge sort.
function tim_sort(array) {
    const n = array.length
    
    // here we find the size of the array that we want, so as to segment each
    // array needed for our insertion sorts
    let minrun = find_minrun(n) 

    for(let i=0;i<n;i+=minrun) {
        end = Math.min(i + minrun - 1, n - 1) 
        // console.log(i)
        // console.log(end)
        insertion_sort(array, i, end) 
    }
    
    // console.log(minrun)
    let new_array = array 
    console.log(new_array)
    size = minrun
    while(size < n+1) {
        for(let i = 0; i < n; i++) {
            let left = Math.min(i*size, n - 1) 
            let right = Math.min(((i+1)*size), (n - 1)) 
            // print()
            console.log("----")
            console.log(left, right)
            // console.log(right)
            // console.log("----")
            console.log(new_array)
            console.log("STARTING")
            new_array = merge(new_array, left, right) 
            console.log(new_array)
            console.log("----")
            process.exit()
            // console.log("skdrjgisudrg")
            // print(2*size)
        }
        console.log(new_array)
        process.exit()
        process.exit()
        size = 2 * size 
    }
    return new_array
}
  
  
array = [-1,5,0,-3,11,9,-2,7,0]
array2 = [-1,5,0,-3,11,9,-2,7,0]

// we measure the time it takes for timsort an the js native sort
console.time()
// console.log(tim_sort(array))
// console.log(insertion_sort(array2))
console.log(merge([1,8,99,2,7,40,8], 0, 4))
//  res = merge([1,2,8,3,5,7], 0, 3)
//  console.log(res)
// console.log(merge(res, 0, 3))
console.timeEnd()

// res = 
// res = 
// array2.sort((a, b) => {
//     if (a > b) {
//       return 1;
//     } else return -1;
//   });
// console.log(array2)
// console.timeEnd()



// console.log(insertion_sort(array, 0, array.length-1))