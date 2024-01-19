#include <iostream>
#include <cmath>

using namespace std;

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

    int cost = (*arr)[i-1][j-1] == (*arr)[i][j] ? 0 : 1;

    int integer_array[] = {
        (*arr)[i-1][j]+1,
        (*arr)[i][j-1]+1,
        (*arr)[i-1][j-1]+cost
    };
    int res = get_min_element(integer_array);

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

    // if the first character of the string is same,
    dynamic_array[0][0] = string_a[0] == string_b[0] ? 0 : 1;

    // first, we fill in those values that obvious: when string b is "" and all
    // substrings of a. This distance will always be the length of the substring
    // of a, as one would have to add a new character to b for every character
    // in a. In other words, the distance is always the length of the substring. 
    for (int i = 1; i < len_a; i++) {
        dynamic_array[i][0] = i + dynamic_array[0][0];
    }

    // we perform the same operation, but now when string a is empty,
    // while we cycle through the substrings of b
    for (int j = 1; j < len_b; j++) {
        dynamic_array[0][j] = j + dynamic_array[0][0];
    }
    


    for (int i = 1; i < len_a; i++) {
        for (int j = 1; j < len_b; j++) {

            if (string_a[i - 1] == string_b[j - 1]) {
                dynamic_array[i][j] = dynamic_array[i - 1][j - 1];
            } else {
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