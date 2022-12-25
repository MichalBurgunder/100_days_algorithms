a = 3
b = 31

larger = a if a > b else b
smaller = b if a > b else a

curr = []
now = 1
current_large = larger
while(True):
    print(current_large)
    while(True): 
        if now > current_large:
            current_large = current_large - now/2
            break
        now *= 2
        
    curr.append(now/2)
    if current_large == 0:
        break
    now = 1


twos = []
for i in range(0, len(curr)):
    twos.append(curr[i]*smaller)
# print(curr)
print(sum(twos))
print(a*b)
