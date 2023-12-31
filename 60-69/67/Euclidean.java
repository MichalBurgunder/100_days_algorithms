
public class Euclidean {


    public static void main(String[] args) {
        int n1 = 0;
        int n2 = 0;
        
        try {
            n1 = Integer.parseInt(args[0]);
            n2 = Integer.parseInt(args[1]);
        } catch (Exception e) {
            System.out.println("Must input two integers. Exiting.");
            System.exit(1);
        }

        int bigger_og = 0;
        int bigger = 0;
        int smaller = 0;

        if(n1 > n2) {
            bigger_og = n1;
            bigger = n1;
            smaller = n2;
        } else {
            bigger_og = n2;
            bigger = n2;
            smaller = n1;
        }

        int counter = 1;
        int difference = 0;

        while(true) {
            if (bigger == counter * smaller) {
                break;
            }

            if(bigger - (counter * smaller) > 0) {
                counter += 1;
            } else {
                difference = bigger_og - ((counter-1) * smaller);
                counter = 1;
                bigger_og = smaller;
                bigger = smaller;
                smaller = difference;
            }
        }

        System.out.println("Greatest Commone Divisor: " + String.valueOf(smaller));
        System.exit(0);
    }
}
