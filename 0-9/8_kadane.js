function kadanes_algorithm(the_array) {
    let max_now = 0;
    let max_overall = 0;
      
    for (let i = 0; i < the_array.length; i++)
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
  
const to_be_analyzed = [-3, 6, -2, 7, 1, -10, 8, -5, 4]
console.log(kadanes_algorithm(to_be_analyzed))