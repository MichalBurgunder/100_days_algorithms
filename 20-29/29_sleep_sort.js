// SLEEP SORT ALGORITHM

// we could also place them into an array if we wished to, although this is
// just a formalization. Given that out we are working in a sync environment, we
// would have to do some more processing (settimeout to the largest element
// which then prints the array), but this is optional.
function log_it(number) {
    console.log(number)
}

// we sort an array of integers by passing them into a sleep function, which
// will print the number after the number amount of seconds. Because the
// smallest numbers will "sleep" the shortest, i.e. the shortest ones will be
// printed, they will be printed in order, smallest ones first. The longer ones 
// will be printed out later, hence giving us an ordered column of our integers.
function sleep_sort(array) {
    // recall that we need to loop through the array to, at the very least,
    // check every value
    for(let i=0;i<array.length;i++) {
        // we set the timeout to sleep for the given amount of time
        setTimeout(log_it, array[i]*100, array[i])
    }
}

// our unsorted array
array = [3,17,6,2,14,9,8,12,4]
sleep_sort(array)