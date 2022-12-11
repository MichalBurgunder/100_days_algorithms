import java.util.concurrent.atomic.AtomicIntegerArray

public class Bakery {

    AtomicIntegerArray ticket;
    AtomicIntegerArray entering;

    static Thread[] threads;
    public Bakery(Thread[] threads) {
        // ticket for threads in line, n - number of threads
        // Java initializes each element of 'ticket' to 0
        ticket = new AtomicIntegerArray(threads.length);

        // 1 when thread entering in line
        // Java initializes each element of 'entering' to 0
        entering = new AtomicIntegerArray(threads.length);
    }
    public void lock(int pid) { // thread ID
        entering.set(pid, 1);
        int max = 0;
        for (int i = 0; i < threads.length; i++) {
            int current = ticket.get(i);
            if (current > max) {
                max = current;
            }
        }
        ticket.set(pid, 1 + max);
        entering.set(pid, 0);
        for (int i = 0; i < ticket.length(); ++i) {
            if (i != pid) {
                while (entering.get(i) == 1) {
                    Thread.yield();
                } // wait while other thread picks a ticket
                while (ticket.get(i) != 0 && (ticket.get(i) < ticket.get(pid) ||
                        (ticket.get(i) == ticket.get(pid) && i < pid))) {
                    Thread.yield();
                }
            }

            // The critical section goes here...


        }

    }
    public void unlock(int pid) {
        ticket.set(pid, 0);
    }

    public static void main(String[] args) {

        Runnable func = new Runnable() {
            public void run() {
                // what comes in here?
            }
        };

        int number_threads = 5;
        for(int i=0;i<number_threads;i++) {
            threads[i] = new Thread(func);
            }
        }

    }
}
