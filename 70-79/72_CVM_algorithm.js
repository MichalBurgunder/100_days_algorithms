// CVM ALGORITHM

var fs = require('fs')
path = require('path')

directory_name = "/Users/michal/Documents/100daysofalgorithms/70-79/"

function get_text() {
    const filePath = path.join(directory_name, 'sample_text.txt');

    let final_text = fs.readFileSync(`${directory_name}/sample_text.txt`, 'utf8');
    
    final_text = final_text
        .replace(/[^\w\s]|_/g, "") // Remove punctuation
        .replace(/\s+/g, " ")      // Replace multiple spaces with single space
        .trim()                    // Remove leading/trailing spaces
        .split(" ")              // Split by space
        .map(s => s.toLowerCase())

    return final_text
}





function cvmAlgorithm(text) {
    let c = 0;
    s = 100;
    B = []

    for(let i=0; i < text.length(); i++) {
        if 
    }
}

text = get_text()
console.log(text)