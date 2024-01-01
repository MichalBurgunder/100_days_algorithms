import java.util.Random;
import java.util.Arrays;

public class Fisher_Yates {
    public static void main(String[] args) {
        int[] ordered_array = {1,3,6,9,12,15,18,34,38,45,40,90,101,102,111,298,548,880,1000};
        
        int temp = 0;

        System.out.println(ordered_array.length);

        for(int i = ordered_array.length-1; 0<i-1; i--) {
            Random rand = new Random();
            int new_position = rand.nextInt(i);

            temp = ordered_array[new_position];
            ordered_array[new_position] = ordered_array[i];
            ordered_array[i] = temp;

            System.out.println(Arrays.toString(ordered_array));
        }
        
        System.out.println(Arrays.toString(ordered_array));
    }
}