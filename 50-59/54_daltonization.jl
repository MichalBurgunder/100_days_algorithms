# DALTONIZATION ALGORITHM

using Pkg
Pkg.add("Images")
Pkg.add("ColorVectorSpace")
Pkg.add("ColorTypes")
Pkg.add("Colors")
using Images
using ColorVectorSpace
using ColorTypes
using Colors

# while the RGB format works best when working with images on computers, the LMS
# more closely corresponds to human reality, in that this color space respects
# human oculuar biology. This is because the cells that respond to different
# colors do so, with different probability distributions (both mean and std.
# being different). In RGB-color space however, this subtilty is not reflected. 

# transformation of rbg space to lms space (taken from the research paper)
rgb_to_lms = [
    0.3904725  0.54990437 0.00890159;
    0.07092586 0.96310739 0.00135809;
    0.02314268 0.12801221 0.93605194;
]
# transformation of lms space to rgb space (taken from the research paper)
lms2rgb = [
    2.85831110 -1.62870796 -0.02481870;
    -0.21043478  1.15841493  0.00320463;
    -0.04188950 -0.11815433  1.06888657;
]

# these are the different corrections depending on one's specific
# colorblindness, both in type and intensity. The values cannot ever be exactly
# correct, as everyone's colorblindness differs slightly, which is why these can
# be different, depending on who specifically it is targeting. 
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

# TODO: whats this
err2mod = [
    0 0 0; 
    0.7 1 0;
    0.7 0 1;
]

# take an RGB point and transform it to vector form for computations
function vectorize(p)
    return [p.r p.g p.b;]
end

# take a vector point and transform it to RGB for saving
function rgbize(p)
    return RGB(p[1], p[2], p[3])
end

# in order to know what to correct for, we need to first simulate what a dichromat sees
function simulate(p, color_deficiency)
    point = vectorize(p)
    point = point * transpose(rgb_to_lms)
    simulated = point * transpose(color_deficiency)
    rgb_point = simulated * transpose(lms2rgb)
    
    return RGB(rgb_point[1], rgb_point[2], rgb_point[3])
end

# performs color correction on images so that dichromats can see betters
function daltonize(image)
    new_image_p = Matrix{RGB}(undef, size(my_image, 1), size(my_image, 2)) # final protanopia image
    new_image_d = Matrix{RGB}(undef, size(my_image, 1), size(my_image, 2)) # final deuteranopia image
    new_image_t = Matrix{RGB}(undef, size(my_image, 1), size(my_image, 2)) # final tritanopia image

    # we first simulate what dichromats can see
    for i in 1:size(image, 1)
        for j in 1:size(image, 2)
            new_image_p[i,j] = simulate(image[i, j], protanopia)
            new_image_d[i,j] = simulate(image[i, j], deuteranopia)
            new_image_t[i,j] = simulate(image[i, j], tritanopia)
        end
    end

    new_image_p = map(clamp01nan, new_image_p)
    new_image_d = map(clamp01nan, new_image_d)
    new_image_t = map(clamp01nan, new_image_t)

    # these images allow us to see what "dichromats", i.e. people who only see two colors see
    # uncomment to save these images

    # save("protanopia_simulation.png", new_image_p)
    # save("deuteranopia_simulation.png", new_image_d)
    # save("tritanopia_simulation.png", new_image_t)

    # now we correct the color spaces
    for i in 1:size(image, 1)
        for j in 1:size(image, 2)
            point = vectorize(image[i, j])
            # we compute the values that dichromats cannot see in our image...
            # ...rotate the color space to somewhere that they can see...
            cant_see_p = (point - vectorize(new_image_p[i,j])) * err2mod
            cant_see_d = (point - vectorize(new_image_d[i,j])) * err2mod
            cant_see_t = (point - vectorize(new_image_t[i,j])) * err2mod

            # ...and add this correction to our original image
            new_image_p[i,j] = rgbize(point + cant_see_p)
            new_image_d[i,j] = rgbize(point + cant_see_d)
            new_image_t[i,j] = rgbize(point + cant_see_t)
        end
    end
    new_image_p = map(clamp01nan, new_image_p)
    new_image_d = map(clamp01nan, new_image_d)
    new_image_t = map(clamp01nan, new_image_t)

    print("Done! Saving... ")
    save("corrected_protanopia.png", new_image_p)
    save("corrected_deuteranopia.png", new_image_d)
    save("corrected_tritanopia.png", new_image_t)
    println("saved!")
end
# -----------------------------------------------------------------

my_image = load("/Users/michal/Documents/my_image.jpeg")

daltonize(my_image)