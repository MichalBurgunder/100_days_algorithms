
function log_it(number) {
    console.log(number)
}
function sleep_sort() {
    array = [2,6,4,9,8,12,34,67,3].map(element => element * 100)

    for(let i=0;i<array.length;i++) {
        setTimeout(log_it, array[i], array[i])
    }
}

sleep_sort()
