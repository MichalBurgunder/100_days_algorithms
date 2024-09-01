# LUHN ALGORITHM

function luhn_algorithm(string_number)
    sum = 0
    number_of_digits = length(string_number)
    parity = number_of_digits % 2
 
    # in order to check the number given, we will need to do a linear scan through all of the numbers
    for i in range(1, number_of_digits)

        # we pick the digit from the string
        digit = parse(Int, string_number[i])

        # now we check whether the entry is odd or even, to multiply by two, or not
        if i % 2 == parity
            digit = digit * 2

            # here we simply reduce the number to a single digit, nothing more.
            if digit > 9
                digit = digit - 9
            end
        end
        # once our digit has been modified, we simply add it to the sum
        sum = sum + digit
    end
    # and finally, we do modulo 10, to validate the number
    return (sum % 10) == 0
end


number_string = "110494"
the_check = luhn_algorithm(number_string)
println(the_check)