# OTSU'S ALGORITHM

function get_grayscale(image)
    # if it's already in Grayscale, then we can skip the transformation part
    if isa(image[1, 1], Gray)
        return image
    end

    m, n = size(image)
    grayscale = Matrix{Gray}(undef, size(image, 1), size(image, 2))

    for i in 1:m
        for j in 1:n
            value = (image[i, j].r + image[i, j].g + image[i, j].b)/3
            grayscale[i, j] = Gray(value)
        end
    end
    # simple verification that all values adhere to valid numbers
    return map(clamp01nan, grayscale)
end

function compute_otsu_criteria(image, threshold, final_image=false)
    # we create the thresholded image
    m, n = size(image)
    thresholded_im = zeros(m, n)

    thresholded_im[256*image .>= threshold] .= 1

    # if the final_image parameter is set, we can return the image
    if final_image
        return thresholded_im
    end

    # now we check the frequency of pixels above and below the stated threshold
    number_pixels = m * n
    number_pixels_non_zero = count(i->(i > 0), thresholded_im)

    # these values then form the weight variables of our equation
    weight_non_zero = number_pixels_non_zero / number_pixels
    weight_zero = 1 - weight_non_zero

    # if the image consists of only a single value (with a given threshold),
    # then there cannot be a threashold, i.e. any one threshold is as good
    # as any other. Therefore, we ignore this particular case
    if weight_non_zero == 0 || weight_zero == 0
        return Inf
    end

    # This produce an array of values that are above a certain threshold. We
    # do not pay heed to the variance across an images edge, because we will
    # simply need to compare our final value with the final values of other
    # thresholds, where the same bias is present. 
    val_pixels_non_zero = image[thresholded_im .== 1]
    val_pixels_zero = image[thresholded_im .== 0]

    # we multiply the variances with how much weight (i.e. how many pixels
    # belong to this class) they hold. The result summarizes the total "visual
    # worthlessness" of thresholding an image with a particular threshold.
    # This is why we try and maximie this value, so that the final image
    # differentiats as much "important" information as possible 
    return weight_non_zero * var(val_pixels_non_zero) + weight_zero * var(val_pixels_zero)
end



using Images, ColorVectorSpace, ColorTypes, Colors
using Statistics
using BenchmarkTools

# --------------------------------------------------
#                      START HERE
# --------------------------------------------------
function main()
    file_path = "/Users/michal/Documents/100daysofalgorithms"
    file_name = "sudoku.png"
    my_image = load("$file_path/$file_name")
    
    # we first convert the image into a grayscale image, if necessary
    matrix = get_grayscale(my_image)
    
    # now we compute all criteria, and take the minimum of those
    criteria = []
    for thr in 1:256
        criterion = compute_otsu_criteria(matrix, thr)
        push!(criteria, criterion)
    end
    
    minimal_value = argmin(criteria)
    final_image = compute_otsu_criteria(matrix, minimal_value, true)
    
    # save the image
    print("Saving... ")
    save("$file_path/otsued_$file_name", final_image)
    println("Done!")
end


@time main()