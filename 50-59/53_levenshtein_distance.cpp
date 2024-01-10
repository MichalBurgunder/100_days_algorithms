#include <iostream>
#include <string>

int levenshtein_distance(std::string string_a, std::string string_b) {

    return 0;
}

int main() {
    std::string a_string_simple = "yippie";
    std::string b_string_simple = "yahoo!";

    std::string a_string_complex = "yippie kay-yay!";
    std::string b_string_complex = "remember, remember, the fifth of november";

    std::cout << levenshtein_distance(a_string_simple, b_string_simple) << std::endl;
    std::cout << levenshtein_distance(a_string_complex, b_string_complex) << std::endl;
}