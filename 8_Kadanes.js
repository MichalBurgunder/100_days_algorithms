function kadanes_algorithm(the_array)
{
    let max_overall = 0;
    let max_now = 0;
      
    for (var i = 0; i < the_array.length; i++)
    {
        max_now = max_now + the_array[i];
        if (max_overall < max_now) {
            max_overall = max_now;
        }
    
        if (max_now < 0) {
            max_now = 0;
        }
    }
    return max_overall
}
  
const to_be_analyzed = [4, 2, -1, 4, -8, -1, 2, 5, -7 , 4, -3, -2, -4, 5, 3, 6, -7, 8]
console.log(kadanes_algorithm(to_be_analyzed))