
function cocke_younger_kasami(sentence, grammar) {
    // let the input be a string I consisting of n characters: a1 ... an.
    // let the grammar contain r nonterminal symbols R1 ... Rr, with start symbol R1.
    // let P[n,n,r] be an array of booleans. Initialize all elements of P to false.
    // let back[n,n,r] be an array of lists of backpointing triples. Initialize all elements of back to the empty list.

    sl = sentence.length
    our_triangle = Array.from({length: sl})
        .map(() => Array.from({length: sl})
            .map(() => Array.from({length: grammar.length})
        )
    )

    // let doubleArray = Array.from({ length: rows }, () => Array(cols).fill('dummy'));

    back_pointing = Array(sl)
        .map(() => Array(sl)
            .map(() => Array(grammar.length()).map(() => [])
        )
    )

    console.log(Array(5))
    // console.log(our_triangle)
    // console.log(our_triangle[0])
    // console.log(our_triangle[2])
    // console.log(back_pointing)
    // console.log(back_pointing[0])
    // console.log(back_pointing[2])
    // for each s = 1 to n
    //     for each unit production Rv → as
    //         set P[1,s,v] = true
    for(let i = 0; i < sl; i++) {
        for(let g = 0; g < sl; g++) {
            our_triangle[1][i][g] = true;
        }
    }
    
    // for each l = 2 to n -- Length of span
    //     for each s = 1 to n-l+1 -- Start of span
    //         for each p = 1 to l-1 -- Partition of span
    //             for each production Ra    → Rb Rc
    //                 if P[p,s,b] and P[l-p,s+p,c] then
    //                     set P[l,s,a] = true, 
    //                     append <p,b,c> to back[l,s,a]
    // for(let l = 1; l < sl; l++) { // going through the string, charcter by character
        // for(let s = 0; s < sl-l+1; s++) { // going vertical
            // for(let p = 0; p < l-1; p++) {// going horizontal 
                for(let g = 0; g < grammar.length; g++) { // going through the grammar
                    our_triangle[l-p][s+p][g] = grammar[g](sentence[0])
                    // if(our_triangle[p][s][g] && our_triangle[l-p][s+p][g]) {
                    //     our_triangle[l][s][a] = true
                    //     back_pointing[p][b][g].push((p, b, g))
                    // }
                } 
            // } 
        // }
    // }

    if(our_triangle[0][0][0]) {
        // is a syntactically valid sentence
        return back_pointing // TODO: give back the POS tags
    }

    return "Invalid sentence"
    // if P[n,1,1] is true then
    //     I is member of language
    //     return back -- by retracing the steps through back, one can easily construct all possible parse trees of the string.
    // else
    //     return "not a member of language"

}

let sentence = "The cat sat on the mat";

// Use regular expression to split sentence into words and punctuation
// const tokens = sentence.match(/\w+|[^\w\s]/g);

// console.log(tokens);



// s -> (np)(vp)
// np -> (dt)(n)
// n -> (adj)(n)



// ('The', 'DT') The
// ('cat', 'NN') cat
// ('sat', 'VBD') sat
// ('on', 'IN') on
// ('the', 'DT') the
// ('mat', 'NN') mat


// let grammar = [
//     ["S", ["NP", "VP"]],
//     ["VP", ["V", "NP"]],
//     ["VP", ["V", "PP"]],
//     ["NP", ["DT", "N"]],
//     ["VP", ["DT", "NP"]],
//     ["DT", ["The"]],
//     ["N", ["cat"]],
//     ["V", ["sat"]],
//     ["VP", ["sat"]],
//     ["IN", ["on"]],
//     ["N", ["mat"]]
// ].map(inputs => create_rule(inputs[0], inputs[1]))


function get_initial(sentence, grammar) {
    const initial = []
    for(let i=0;i<sentence.length;i++) {
        initial.push(grammar.map(g => {
            if(sentence[i] == g[1]) {
                return g[0]
            }
        }))
    }
    return initial
// [
//     [ undefined, undefined, undefined, 'CHAR', undefined ],
//     [ undefined, undefined, undefined, undefined, 'CHAR' ],
//     [ undefined, 'TERMINAL', undefined, undefined, undefined ]
// ]
}




function get_grammar_correct(grammar, prior, k) {
    const corrects = []
    
    for(let m =0; m<initial.length-1;m++) {
        const g_correct = []
        for(let g=0;g<grammar.length;g++) {
            // TODO
            for(let l=0;l<grammar.length;l++) {
                // console.log(g, l)
                if (prior[m][g] == grammar[k][1][0] && prior[m+1][l] == grammar[k][1][1]) {
                    g_correct.push(grammar[k][0])
                } else {
                    g_correct.push(undefined)
                }
            }


        }
    }
    console.log(corrects)
    return corrects
}
// function get_grammar_correct(grammar, prior, k) {
//     correct = []
//     for(let m=0;m<grammar.length;m++) {
//         k = is_correct()
//         if (k !== false) {
//             correct.push(k)
//         }
//     }
//     return correct
// }


grammar = [
    ["S", ["WORD", "TERMINAL"]],
    ["TERMINAL", "!"],
    ["WORD", ["CHAR", "CHAR"]],
    ["CHAR", ["h"]],
    ["CHAR", ["i"]],
]//.map(inputs => create_rule(inputs[1], inputs[0]))

// const initial = []

sentence = "hi!"

const initial = get_initial(sentence, grammar)
// console.log(initial)
const first = []
for(let j=0;j<initial.length-1;j++) {
    console.log(j)
    the_one = []

    for(let k=0;k<grammar.length;k++) {
        result = get_grammar_correct(grammar, initial, k)
        console.log(result)
        the_one.push(result)
    }
    console.log(the_one)
    first.push(the_one)
    // process.exit()
}

console.log(first)
    process.exit()
// console.log(the_one)