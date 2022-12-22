
#include <iostream>
#include <map>
#include <string>
#include <vector>

// #include <stdint.h>

// #define STB_IMAGE_IMPLEMENTATION
// #include "stb_image.h"

using namespace std;

int main() {
    // transforms the matrix from RGB color palette to LMS color palette

    std::vector<std::vector<float>> rgb_to_lms = {
       {0.3904725 , 0.54990437, 0.00890159},
       {0.07092586, 0.96310739, 0.00135809},
       {0.02314268, 0.12801221, 0.93605194}
    };
    std::vector<std::vector<float>> lms2rgb = {
       {2.85831110, -1.62870796, -0.02481870},
       {-0.21043478,  1.15841493,  0.00320463},
       {-0.04188950, -0.11815433,  1.06888657}
    };

    std::vector<std::vector<float>> protanopia = {
        {0, 0.90822864, 0.008192},
        {0, 1, 0},
        {0, 0, 1}
    };
    std::vector<std::vector<float>> deuteranopia = {
        {1, 0, 0}, 
        {1.10104433, 0, -0.00901975}, 
        {0, 0, 1}
    };
    std::vector<std::vector<float>> tritanopia = {
        {1, 0, 0}, 
        {0, 1, 0}, 
        {-0.15773032, 1.19465634, 0}
    };

    map<string, std::vector<std::vector<float>>> color_deficiencies;

    color_deficiencies["protanopia"] = protanopia;
    color_deficiencies["deuteranopia"] = deuteranopia;
    color_deficiencies["tritanopia"] = tritanopia;

    
    // import image
    // img = ...

    // 
   
    // transform colorspace into LMS
    // new_point = point @ rgb_to_lms.T
    // ...
    // multiply each point in image for correction
    // new_point = point @ color_deficiencies[case].T
    // ...
    // transform colorspace back into RBG
    // new_point = point @ lms2rgb.T

    // save image
    // ...


    return 0;
}