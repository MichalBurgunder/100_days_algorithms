# LUHN ALGORITHM

# While this implementation gives us a prototype on which to build other
# identification number checkers, it is not the only one. For example, there is
# no reason why the checksum should add to the final digit, instead of some
# specific digit. We also do not need to multiply by two: we can multipl by 3,
# 4, 9384, etc., as long as we reduce the result of the multiplication/function
# to a standard number of digits, in a deterministic way. So lines 25-32 can be
# replaced by a function of any complexity that fulfills these requirements.
# This is why identification numbers on ID, bank numbers, etc. cannot be
# "hacked" all too easily: only the issuing authority can determine whether the
# number given is valid of not.  
function luhn_algorithm(string_number)
    sum = 0
    number_of_digits = length(string_number)-1
    parity = number_of_digits % 2

    # in order to check the number given, we will need to do a linear scan
    # through all of the numbers
    for i in range(1, number_of_digits)

        # we pick the digit from the string
        digit = parse(Int, string_number[i])

        # now we check whether the entry is odd or even, to decide whether we
        # multiply by two, ornot
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
    return sum % 10 ==  parse(Int, string_number[end])
end


number_string = "1104948"
the_check = luhn_algorithm(number_string)
println(the_check)