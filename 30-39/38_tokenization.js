
function cocke_younger_kasami(I, grammar) {
    // let the input be a string I consisting of n characters: a1 ... an.
    // let the grammar contain r nonterminal symbols R1 ... Rr, with start symbol R1.
    // let P[n,n,r] be an array of booleans. Initialize all elements of P to false.
    // let back[n,n,r] be an array of lists of backpointing triples. Initialize all elements of back to the empty list.

    sl = I.length()
    our_triangle = Array(sl)
        .map(() => Array(sl)
            .map(() => Array(grammar.length())
        )
    )

    back_pointing = Array(sl)
        .map(() => Array(sl)
            .map(() => Array(grammar.length()).map(() => [])
        )
    )

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
    for(let l = 1; l < sl; l++) {
        for(let s = 0; s < sl-i+1; s++) {
            for(let p = 0; p < l-1; p++) {
                for(let g = 0; g < grammar.length(); g++) {
                    if(our_triangle[p][s][g] && our_triangle[l-p][s+p][c]) {
                        out_triangle[l][s][a] = true
                        back_pointing.push((p, b, c))
                    }
                } 
            } 
        }
    }

    if(our_triangle[sl][1][1]) {
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

const sentence = "The cat sat on the mat";

// Use regular expression to split sentence into words and punctuation
const tokens = sentence.match(/\w+|[^\w\s]/g);

console.log(tokens);

function create_rule(the_initial, the_after) {
    return (input) => {
        if (input == the_after) {
            return the_initial
        }
        return false
    }
}

// s -> (np)(vp)
// np -> (dt)(n)
// n -> (adj)(n)



// ('The', 'DT') The
// ('cat', 'NN') cat
// ('sat', 'VBD') sat
// ('on', 'IN') on
// ('the', 'DT') the
// ('mat', 'NN') mat


grammar = [
    ["S", ["NP", "VP"]],
    ["VP", ["V", "NP"]],
    ["VP", ["V", "PP"]],
    ["NP", ["DT", "N"]],
    ["VP", ["DT", "NP"]],
    ["DT", ["The"]]
    ["N", ["cat"]],
    ["V", ["sat"]]
    ["VP", ["sat"]]
    ["IN", ["on"]]
    ["N", ["mat"]]
].map(inputs => create_rule(inputs[0], inputs[1]))

cocke_younger_kasami(tokens, grammar)