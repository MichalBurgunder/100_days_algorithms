
import time
def karatsuba(x, y):
    # with single digits, we can simply multiply
    if x < 10 or y < 10:
        return x * y
    
    # we get the lengths, to see what our base should be
    n = max(len(str(x)), len(str(y)))
    m = n // 2 # get an integer
    B = 10
    
    # we get the left and right digits
    x_1, x_0 = divmod(x, 10**m)
    y_1, y_0 = divmod(y, 10**m)

    # now we recurse for every multiplication into Karasubas until only single digits are left
    z2 = karatsuba(x_1, y_1)
    z0 = karatsuba(x_0, y_0)
    
    z1 = karatsuba(x_1+y_0, x_0+y_1)-z2-z0

    # 
    return z2 * B**(2*m) + z1 * B**m + z0

def naive_multiplication(x, y):
    result = 0
    x_str = str(x)
    y_str = str(y)
    # we go backwards, from most significant digit to least
    for i in range(len(x_str)-1, -1, -1):
        xi = int(x_str[i]) * 10**(len(x_str)-i-1)

        # same here
        for j in range(len(y_str)-1, -1, -1):
            yj = int(y_str[j]) * 10**(len(y_str)-j-1)
            
            result += xi * yj

    # Return the result
    return result

a = 122
b = 122
start_naive = time.time()
print(naive_multiplication(a, b))
end_naive = time.time()
# exit()
start_karatsuba = time.time()
print(karatsuba(a, b))
end_karatsuba = time.time()

start_implicit = time.time()
print(a*b)
end_implicit = time.time()


print(f"Naive: {end_naive-start_naive}\nKaratsuba: {end_karatsuba-start_karatsuba}\nImplicit: {end_implicit-start_implicit}")
