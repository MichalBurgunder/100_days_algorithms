import java.util.Random;
import java.util.Arrays;

public class Fisher_Yates {
    public static void main(String[] args) {
        int[] ordered_array = {2, 4, 7, 9, 12, 12, 22, 24, 35, 45, 54, 65, 67, 74, 75, 87, 98, 99, 102, 823, 1000};
        
        int temp = 0;

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