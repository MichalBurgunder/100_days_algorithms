// FISHER-YATES ALGORITHM

import java.util.Random;
import java.util.Arrays;

public class Fisher_Yates {
    
    public static void main(String[] args) {
        // We note that in order to shuffle with best practices, we need at
        // least one extra variable that we use to swap out numbers, and a
        // random number generator. 

        // we begin with an ordered array of numbers. I've sorted it, so that
        // we can easily see how shuffled the emerging array will be. 
        int[] ordered_array = {2, 4, 7, 9, 12, 12, 22, 24, 35, 45, 
                                54, 65, 67, 74, 75, 87, 98, 99, 102, 823, 1000};
        
        // our temporary variable, used for swapping
        int temp = 0;

        // here we create our random number generator (such as the linear
        // congruential generator)
        Random rand = new Random();
        
        // in order to shuffle, we will need to evoke every element at least
        // once, hence the single loop. We begin at the end of the array
        for(int i = ordered_array.length-1; 0<i-1; i--) {
            // we query a random number 
            int new_position = rand.nextInt(i);

            // with the random number, we swap that array position with the i'th 
            // position of our loop. This we do with every position, so that
            // every element ends up in a random place in the array. 
            temp = ordered_array[new_position];
            ordered_array[new_position] = ordered_array[i];
            ordered_array[i] = temp;
        }
        
        System.out.println(Arrays.toString(ordered_array));
    }
}