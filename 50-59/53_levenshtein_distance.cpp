#include <iostream>
// #include <string>

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

int levenshtein_distance(const std::string &string_a, const std::string &string_b, std::vector<std::vector<int> > *arr) {
    if((*arr)[string_a.length()][string_b.length()] != -1) {
        return (*arr)[string_a.length()][string_b.length()];
    }

    int integer_array[] = {
        (*arr)[string_a.length()-1][string_b.length()]+1,
        (*arr)[string_a.length()][string_b.length()-1]+1,
        (*arr)[string_a.length()-1][string_b.length()-1]
    };

    return get_min_element(integer_array);
}

int main() {
    std::string a_string_simple = "yahoo!";
    std::string b_string_simple = "yippie";


    std::string a_string_complex = "";
    std::string b_string_complex = "bca";

    int len_a = a_string_complex.length();
    int len_b = b_string_complex.length();

    std::vector<std::vector<int> > dynamic_array(len_a+1, std::vector<int>(len_b+1, -1));


    for (int i = 0; i < len_a; i++) {
        dynamic_array[i][0] = i;
    }

    for (int j = 0; j < len_b; j++) {
        dynamic_array[0][j] = j;
    }

    if (a_string_complex[0] == b_string_complex[0]) {
        dynamic_array[0][0] = 0;
    }


    for (int i = 1; i <= len_a; i++) {
        for (int j = 1; j <= len_b; j++) {
            dynamic_array[i][j] = levenshtein_distance(a_string_complex.substr(0, i), b_string_complex.substr(0, j), &dynamic_array);
        }
    }

    int result = levenshtein_distance(a_string_complex, b_string_complex, &dynamic_array);
    std::cout << result << std::endl;
}