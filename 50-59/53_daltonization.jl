rgb_to_lms = [
    0.3904725  0.54990437 0.00890159;
    0.07092586 0.96310739 0.00135809;
    0.02314268 0.12801221 0.93605194;
]

rgb_to_lms = [
    2.85831110 -1.62870796 -0.02481870;
    -0.21043478  1.15841493  0.00320463;
    -0.04188950 -0.11815433  1.06888657;
]

protanopia = [
    0 0.90822864 0.008192;
    0 1 0;
    0 0 1;
]

deuteranopia = [
    1 0 0;
    1.10104433 0 -0.00901975;
    0 0 1;
]

tritanopia = [
    1 0 0;
    0 1 0;
    -0.15773032 1.19465634 0;
]

struct color_deficiencies_struct 
    protanopia::Matrix{float}
    deuteranopia::Matrix{float}
    tritanopia::Matrix{float}
end

using Images, ColorVectorSpace, ColorTypes, Colors

image = load("/Users/michal/Documents/100daysofalgorithms/50-59/friday_meme8_2.jpeg")
# x_type = typeof(image)
# println(x_type)
new_image = Matrix{RGB}(undef,size(image, 1),size(image, 2))
# new_image = zeros(, 3)

println("start...")
for i in 1:size(image, 1)
    for j in 1:size(image, 2)
        point = transpose([image[i, j].r*256 image[i, j].g*256 image[i, j].b*256;])
        res = transpose(protanopia * point)
        new_image[i, j] = RGB(res[1]/256, res[2]/256, res[3]/256)
    end
end
println("done!")
save("new_image.png", new_image)
# image
# color_deficiencies = color_deficiencies_struct(protanopia, deuteranopia, tritanopia)