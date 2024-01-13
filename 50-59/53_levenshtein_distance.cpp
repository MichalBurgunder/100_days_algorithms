#include <iostream>
#include <string>

using namespace std;

int get_min_element(int the_array[]) {
    int the_int = INFINITY;

    for(int i = 0; i < 3; i++) {
        if(the_array[i] < INFINITY) {
            the_int = the_array[i];
        }
    }
    std::cout << the_int << std::endl;
    return the_int;
}
// the two following functions make our string to be analyzed smaller, i.e. allow for divide and conquer, so that we can dynamically solve sub problems before tackling the larger one of the Levenshtein distance between the two original strings
string head(string some_string) {
    // we return only the first letter of the string. This will allow us to analyze the string character by character
    return some_string.substr(0, 1);
}
string tail(string some_string) {
    // here instead, we return the whole substring from the SECOND character, until the last character. This will break up our string into substrings, which we can anaylze. 
    return some_string.substr(1, some_string.length());
}

int levenshtein_distance(std::string string_a, std::string string_b) {
    // we begin by checking the lengths of stirng. If one of them is 0, it's easy: it's just the length of the other string (we add a new character for every change)
    if (string_a.length() == 0) {
        return string_b.length();
    }
    // the same goes for the other string
    else if ( string_b.length() == 0 ) {
        return string_a.length();
    // if, however, the first part of the string is the same, we need to analyze the levenshtein difference of its tail. Differently put, if the first 
    } else if (head(string_a) == head(string_b)) { 
        return levenshtein_distance(tail(string_a), tail(string_b));
    }
    else {
        int integer_array[] = {
            levenshtein_distance(tail(string_a), string_b),
            levenshtein_distance(string_a, tail(string_b)),
            levenshtein_distance(tail(string_a), tail(string_b))
        };

        return get_min_element(integer_array) + 1;
    }
}

int main() {
    std::string a_string_simple = "yahoo!";
    std::string b_string_simple = "yippie";

    
    std::string a_string_complex = "yippie kay-yay!";
    std::string b_string_complex = "darn hippies";

    std::cout << levenshtein_distance(a_string_simple, b_string_simple) << std::endl;
    std::cout << levenshtein_distance(a_string_complex, b_string_complex) << std::endl;

    // TODO: implement dynamic programming version
}