

const sentence = "Hello, how are you doing today?";

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

s -> (np)(vp)
np -> (dt)(n)
n -> (adj)(n)



('The', 'DT') The
('cat', 'NN') cat
('sat', 'VBD') sat
('on', 'IN') on
('the', 'DT') the
('mat', 'NN') mat


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

function cocke_younger_kasami(language, grammar) {
    // for (let i = language.length; i > 0; i--) {

    // }

    // let the input be a string I consisting of n characters: a1 ... an.
    // let the grammar contain r nonterminal symbols R1 ... Rr, with start symbol R1.
    // let P[n,n,r] be an array of booleans. Initialize all elements of P to false.
    // let back[n,n,r] be an array of lists of backpointing triples. Initialize all elements of back to the empty list.

    // for each s = 1 to n
    //     for each unit production Rv → as
    //         set P[1,s,v] = true

    // for each l = 2 to n -- Length of span
    //     for each s = 1 to n-l+1 -- Start of span
    //         for each p = 1 to l-1 -- Partition of span
    //             for each production Ra    → Rb Rc
    //                 if P[p,s,b] and P[l-p,s+p,c] then
    //                     set P[l,s,a] = true, 
    //                     append <p,b,c> to back[l,s,a]

    // if P[n,1,1] is true then
    //     I is member of language
    //     return back -- by retracing the steps through back, one can easily construct all possible parse trees of the string.
    // else

}
// ('The', 'DT') The
// ('cat', 'NN') cat
// ('sat', 'VBD') sits
// ('on', 'IN') on
// ('the', 'DT') the
// ('mat', 'NN') mat
