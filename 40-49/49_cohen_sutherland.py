# Note: taken from here, and modifed slightly: https://github.com/zanuarts/cohen-sutherland-py
from tkinter import *

# Defining region codes 
INSIDE = 0  # 0000 
LEFT = 1    # 0001 
RIGHT = 2   # 0010 
BOTTOM = 4  # 0100 
TOP = 8     # 1000 

tl_corner = [100, 100]
size = [500, 400]


x_max = tl_corner[0] + size[0]
y_max = tl_corner[1] + size[1]
x_min = tl_corner[0]
y_min = tl_corner[1]

# here the rectangle

def computeCode(x, y): 
    code = INSIDE 
    if x < x_min:      # to the left of rectangle 
        code |= LEFT 
    elif x > x_max:    # to the right of rectangle 
        code |= RIGHT 
    if y < y_min:      # below the rectangle 
        code |= BOTTOM 
    elif y > y_max:    # above the rectangle 
        code |= TOP 
    
    print(code)
    return code

def hitung():
    x1 = float(entry_x1.get())
    y1 = float(entry_y1.get())
    x2 = float(entry_x2.get())
    y2 = float(entry_y2.get())

    my_canvas.create_line(x1, y1, x2, y2, fill = 'blue')
    my_canvas.grid(row = 6, column = 0)

    code1 = computeCode(x1, y1)
    code2 = computeCode(x2, y2)
    accept = False

    while True: 
  
        # If both endpoints lie within rectangle 
        if code1 == 0 and code2 == 0: 
            accept = True
            break
  
        # If both endpoints are outside rectangle 
        elif (code1 & code2) != 0: 
            break
  
        # Some segment lies within the rectangle 
        else: 
  
            # Line Needs clipping 
            # At least one of the points is outside,  
            # select it 
            x = 1.0
            y = 1.0
            if code1 != 0: 
                code_out = code1 
            else: 
                code_out = code2 
  
            # Find intersection point 
            # using formulas y = y1 + slope * (x - x1),  
            # x = x1 + (1 / slope) * (y - y1) 
            if code_out & TOP: 
                
                # point is above the clip rectangle 
                x = x1 + ((x2 - x1) / (y2 - y1)) * (y_max - y1) 
                y = y_max 
  
            elif code_out & BOTTOM: 
                  
                # point is below the clip rectangle 
                x = x1 + ((x2 - x1) / (y2 - y1)) * (y_min - y1) 
                y = y_min 
  
            elif code_out & RIGHT: 
                  
                # point is to the right of the clip rectangle 
                y = y1 + ((y2 - y1) / (x2 - x1)) * (x_max - x1) 
                x = x_max 
  
            elif code_out & LEFT: 
                  
                # point is to the left of the clip rectangle 
                y = y1 + ((y2 - y1) / (x2 - x1)) * (x_min - x1)  
                x = x_min 
  
            # Now intersection point x, y is found 
            # We replace point outside clipping rectangle 
            # by intersection point 
            if code_out == code1: 
                x1 = x 
                y1 = y 
                code1 = computeCode(x1, y1) 
  
            else: 
                x2 = x 
                y2 = y 
                code2 = computeCode(x2, y2) 
  
    if accept: 
        print ("Line accepted from %.2f, %.2f to %.2f, %.2f" % (x1, y1, x2, y2)) 
        my_canvas.create_line(x1, y1, x2, y2, fill = 'red',  width = 1)
        my_canvas.grid(row = 6, column = 0)
  
    else: 
        print("Line rejected") 

#   ui
my_window = Tk()
my_window.title("Cohen Sutherland Algorithm tinkerbox")

#   input
Label (my_window, text = "x value of point 1: ", fg = "black", font = "none 12").grid(row = 1, column = 0, sticky = W)
entry_x1 = Entry(my_window, width = 20, bg= "white")
entry_x1.grid (row = 1, column = 0)
Label (my_window, text = "y value of point 1 : ", fg = "black", font = "none 12").grid(row = 2, column = 0, sticky = W)
entry_y1 = Entry(my_window, width = 20, bg= "white")
entry_y1.grid (row = 2, column = 0)
Label (my_window, text = "x value of point 2: ", fg = "black", font = "none 12").grid(row = 3, column = 0, sticky = W)
entry_x2 = Entry(my_window, width = 20, bg= "white")
entry_x2.grid (row = 3, column = 0)
Label (my_window, text = "y value of point 2: ", fg = "black", font = "none 12").grid(row = 4, column = 0, sticky = W)
entry_y2 = Entry(my_window, width = 20, bg= "white")
entry_y2.grid (row = 4, column = 0)

#   button
Button(my_window, text = "SUBMIT", width = 6, command = hitung) .grid(row = 5, column = 0)


# here the canvas
my_canvas = Canvas(my_window, width = 2*tl_corner[0]+size[0], height = 2*tl_corner[1]+size[1])
my_canvas.grid(row = 6, column = 0)



my_canvas.create_line(tl_corner[0],tl_corner[1],size[0]+tl_corner[0],tl_corner[1], fill = 'black')
my_canvas.create_line(tl_corner[0],tl_corner[1],tl_corner[0],tl_corner[1]+size[1], fill = 'black')
my_canvas.create_line(tl_corner[0],tl_corner[1]+size[1],tl_corner[0]+size[0],tl_corner[1]+size[1], fill = 'black')
my_canvas.create_line(tl_corner[0]+size[0],tl_corner[1]+size[1],tl_corner[0]+size[0],tl_corner[1], fill = 'black')

my_window.mainloop()