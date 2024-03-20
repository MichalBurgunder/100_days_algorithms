// FISHER-YATES ALGORITHM

import java.util.Random;
import java.util.Arrays;

public class Fisher_Yates {
    public static void main(String[] args) {
        // we begin with an ordered array of numbers. The goal will be to shuffle it as good as we possibly can, in as short amount of time, as we possibly can
        int[] ordered_array = {2, 4, 7, 9, 12, 12, 22, 24, 35, 45, 54, 65, 67, 74, 75, 87, 98, 99, 102, 823, 1000};
        
        int temp = 0;

        // in order to shuffle, we will need to evoke every element at least once, hence the loop. Here, 
        for(int i = ordered_array.length-1; 0<i-1; i--) {
            Random rand = new Random();
            int new_position = rand.nextInt(i);

            temp = ordered_array[new_position];
            ordered_array[new_position] = ordered_array[i];
            ordered_array[i] = temp;
        }
        
        System.out.println(Arrays.toString(ordered_array));
    }
}