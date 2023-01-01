rgb_to_lms = [
    0.3904725  0.54990437 0.00890159;
    0.07092586 0.96310739 0.00135809;
    0.02314268 0.12801221 0.93605194;
]

lms2rgb = [
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

# struct color_deficiencies_struct 
#     protanopia::Matrix{float}
#     deuteranopia::Matrix{float}
#     tritanopia::Matrix{float}
# end

using Images, ColorVectorSpace, ColorTypes, Colors

image = load("/Users/michal/Documents/100daysofalgorithms/50-59/friday_meme8_1.jpeg")

new_image_p = Matrix{RGB}(undef,size(image, 1),size(image, 2)) # p
new_image_d = Matrix{RGB}(undef,size(image, 1),size(image, 2)) # d
new_image_t = Matrix{RGB}(undef,size(image, 1),size(image, 2)) # t


function simulate(p, color_deficiency)
    point = [p.r p.g p.b;]
    point = point * transpose(rgb_to_lms)
    simulated = point * transpose(color_deficiency)
    rgb_point = simulated * transpose(lms2rgb)
    fin = map(clamp01nan, rgb_point)
    return RGB(fin[1], fin[2], fin[3])
end


for i in 1:size(image, 1)
    for j in 1:size(image, 2)
        new_image_p[i,j] = simulate(image[i, j], protanopia)
        new_image_d[i,j] = simulate(image[i, j], deuteranopia)
        new_image_t[i,j] = simulate(image[i, j], tritanopia)
    end
end

println("done! Saving...")
save("new_image_p.png", new_image_p)
save("new_image_d.png", new_image_d)
save("new_image_t.png", new_image_t)
println("saved!")