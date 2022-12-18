
function log_it(number) {
    console.log(number)
}

function sleep_sort() {
    array = [2,34,6,4,67,9,8,12,3].map(element => element)

    for(let i=0;i<array.length;i++) {
        setTimeout(log_it, array[i]*100, array[i])
    }
}

sleep_sort()
