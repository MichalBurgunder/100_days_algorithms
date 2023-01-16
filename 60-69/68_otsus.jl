
using Images
using Statistics

function compute_otsu_criteria(matrix, thr, final_image=false)
    m, n = size(matrix)
    thresholded_im = zeros(m, n)

    # julia goes from 1-256, so we simply shift down by 1
    threshold = thr - 1 

    # we check how which pixels are above the given threshold
    thresholded_im[matrix .>= threshold] .= 1

    # if the final_image parameter is set, we can return the image
    if final_image
        return thresholded_im
    end

    # now we check the frequency of pixels above and below the stated threshold
    number_pixels = m * n
    number_pixels_non_zero = count(i->(i > 0), thresholded_im)

    # these values then form the weight variables of our equation
    weight_non_zero = number_pixels_non_zero / number_pixels
    weight_zero = 1 - weight_grays_p_white

    # if the image consists of only a single value (with a given threshold),
    # then there cannot be a threashold, i.e. any one threshold is as good
    # as any other. Therefore, we ignore this particular case
    if weight_non_zero == 0 || weight_zero == 0
        return thresholded_im
    end

    # This produce an array of values that are above a certain threshold. We
    # do not pay heed to the variance across an images edge, because we will
    # simply need to compare our final value with the final values of other
    # thresholds, where the same bias is present. 
    val_pixels1 = matrix[thresholded_im .== 1]
    val_pixels0 = matrix[thresholded_im .== 0]


    # we multiply the variances with how much weight (i.e. how many pixels
    # belong to this class) they hold. The result summarizes the total "visual
    # worthlessness" of thresholding an image with a particular threshold.
    # This is why we try and maximie this value, so that the final image
    # differentiats as much "important" information as possible 
    return weight_non_zero * var(val_pixels_non_zero) + weight_zero * var(val_pixels_zero)
end



using Images, ColorVectorSpace, ColorTypes, Colors

file_name = ""
my_image = load("/Users/michal/Documents/$file_name")

criteria = []
for thr in range(1:256)
    criterion = compute_otsu_criteria(my_image, thr)
    push!(criteria, criterion)
end

minimal_value = argmin(criteria)

final_image = compute_otsu_criteria(my_image, criteria[minimal_value])

save("$file_name", final_image)