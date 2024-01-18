// EUCLIDEAN ALGORITHM

public class Euclidean {

    static int bigger;
    static int smaller;

    static int bigger_og;

    // here we just take the command line arguments and parse them into our
    // function. If none are given, we set some default ones.
    public static void setNums(String[] args) {
        int n1 = 0;
        int n2 = 0;

        try {
            n1 = Integer.parseInt(args[0]);
            n2 = Integer.parseInt(args[1]);
        } catch (Exception e) {
            System.out.println("Using two default variables");
            n1 = 63;
            n2 = 49;
        }

        if(n1 > n2) {
            bigger_og = n1;
            bigger = n1;
            smaller = n2;
        } else {
            bigger_og = n2;
            bigger = n2;
            smaller = n1;
        }
    }

    public static void euclideanAlgorithm() {
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

        System.out.println("Greatest Common Divisor: " + String.valueOf(smaller));
        System.exit(0);
    }
    public static void main(String[] args) {
        
        // we first set our numbers to to compute the algorithm with. You can
        // set the integers on line __ TODO, or alternatively, pass them as command
        //  line arguments
        setNums(args);

        // and now, we run the algorithm
        euclideanAlgorithm();
    }
}
