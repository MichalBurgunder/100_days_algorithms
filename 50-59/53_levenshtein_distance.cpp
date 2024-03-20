// LEVENSHTEIN DISTANCE ALGORITHM

#include <iostream>
#include <cmath>

using namespace std;

// we get the minimum entry of a particular array
int get_min_element(int the_array[]) {
    int the_int = INFINITY;

    for(int i = 0; i < 3; i++) {
        if(the_array[i] < the_int) {
            the_int = the_array[i];
        }
    }

    return the_int;
}

int levenshtein_distance(int i,
                            int j,
                                std::vector<std::vector<int> > *arr) {

    // because the character is different, we need to take the minimum distance
    // for the substrings, and add 1, as the cost to change this character. This
    //  automatically considers all possible changes to the previous substrings,
    //  and only outputs their Levenshteins distances:
    int integer_array[] = {
        (*arr)[i-1][j]+1,
        (*arr)[i][j-1]+1,
        (*arr)[i-1][j-1]+1
    };

    // and because we want the smallest number, we get the minmum of this array
    return get_min_element(integer_array);
}

int main() {
    // we first define our strings. You can choose either the simple string, of
    // the more complex one, which is commented out (or create your own, for
    // that matter)
    std::string string_a = "hallo!";
    std::string string_b = "hello!";

    // std::string a_string = "Never have I ever seen a blue orange.";
    // std::string b_string = "A blue orange is a thing I have never seen";

    // we take the length, for easier reading...
    int len_a = string_a.length();
    int len_b = string_b.length();

    // ...and define our dynamic array. This is where we will store our
    // intermediary results, i.e. the Levenshtein distances for substrings. We
    // set every value to -INFINITY, so that if there is a mistake in our
    // program, we will be notified right away it 
    std::vector<std::vector<int> > dynamic_array(len_a,
                                        std::vector<int>(len_b, -1));

    // we check if the first character of the string is same, thus initializing
    // our rectangle of subresults.
    dynamic_array[0][0] = string_a[0] == string_b[0] ? 0 : 1;

    // we begin filling in those values in the array that obvious: when string_b
    // is "" and all substrings of a. This distance will always be the length of
    // the substring of a, as one would have to add a new character to b for
    // every character in a. In other words, the distance is always the length
    // of the one substring. 
    for (int i = 1; i < len_a; i++) {
        dynamic_array[i][0] = i + dynamic_array[0][0];
    }

    // we perform the same operation, but now when string a is empty, while we
    // cycle through the substrings of b
    for (int j = 1; j < len_b; j++) {
        dynamic_array[0][j] = j + dynamic_array[0][0];
    }
    

    // now we fill out the more difficult values, starting with the simplest
    // next version: when at least one string as two characters. Every step is
    // filled out in the same manner: we check the "top", "left" and "diagonal
    // top-left" values. That is, we check the Levenshtein distances of those
    // substrings that are above, to the left, and diagonally to the top-left
    // from our current position":
    //
    //     h   a   ...
    //   ---------
    // h | 0 | 1 | ...
    //   ----\----
    // e | 1 | x | ...
    // .   .   .
    // .   .   .
    // .   .   .

    // because we fill out the table row by row, we "chase" the x corner across 
    // he matrix, because we are capable of filling it our.

    for (int i = 1; i < len_a; i++) {
        for (int j = 1; j < len_b; j++) {

            // in the case where the current character is the same, the
            // Levenshtein distance does not change. Thus, we only take the
            // value from the previous string comparison 
            if (string_a[i] == string_b[j]) {
                dynamic_array[i][j] = dynamic_array[i - 1][j - 1];
            } else {
                // otherwise, we need to actually fill it out
                dynamic_array[i][j] = levenshtein_distance(i,
                                                            j, 
                                                            &dynamic_array);
            }
        }
    }
    // we pick the final element in the table, as this corresponds to the set
    // difference between the two non-proper, i.e. full strings, instead of
    // their substrings.
    int result = dynamic_array[len_a-1][len_b-1];
    std::cout << result << std::endl;
}