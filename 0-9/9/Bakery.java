import java.util.concurrent.atomic.AtomicIntegerArray;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;


class MyThread extends Thread {
    // Bakery bake;
    int pid;
    static Bakery bake;

    public MyThread(Bakery bakery, int i) {
        bake = bakery;
        pid = i;
    }
    public void run() {
        bake.lock(pid);
        // try {
        //     // Access shared resource here
        System.out.println("Thread " + pid + " is accessing the shared resource");
        // } finally {
        bake.unlock(pid);
    }
    public static void main(String[] args) {
        bake.main2(args);
    }
}

public class Bakery {

    AtomicIntegerArray ticket;
    AtomicIntegerArray entering;

    int num_threads;
    public Bakery(int threads_length) {
        num_threads = threads_length;
        // ticket for threads in line, n - number of threads
        // Java initializes each element of 'ticket' to 0
        ticket = new AtomicIntegerArray(num_threads);

        // 1 when thread entering in line
        // Java initializes each element of 'entering' to 0
        entering = new AtomicIntegerArray(num_threads);
    }

    public void lock(int pid) { // thread ID
        entering.set(pid, 1);
        int max = 0;
        for (int i = 0; i < num_threads; i++) {
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
                    System.out.println("Thread " + i + " locking at 1");
                    Thread.yield();
                } // wait while other thread picks a ticket
                while (ticket.get(i) != 0 && (ticket.get(i) < ticket.get(pid) ||
                        (ticket.get(i) == ticket.get(pid) && i < pid))) {
                    System.out.println("Thread " + i + " locking there");
                    Thread.yield();
                }
            }
            // try {
                // Access shared resource here
                // System.out.println("Thread " + i + " is accessing the shared resource");
            // // } finally {
            //     this.unlock(i);
            // // }
           


        }

    }
    public void unlock(int pid) {
        System.out.println("Thread " + pid + " is unlocking");
        ticket.set(pid, 0);
    }

    public static void main2(String[] args) {
        
        int number_threads = 5;

        Bakery bake = new Bakery(number_threads);

        
        // Create a thread pool with 4 threads
        // ExecutorService executor = Executors.newFixedThreadPool(number_threads);
        // Submit a task to the thread pool that acquires and releases the lock using the BakeryAlgorithm object
        for (int i = 0; i < number_threads; i++) {
            MyThread thread = new MyThread(bake, i);
            // final int threadId = i;/*  */

            thread.start();
            // executor.submit(() -> {
            //     bake.lock(0);
            //     // try {
            //     //     // Access shared resource here
            //         System.out.println("Thread " + threadId + " is accessing the shared resource");
            //     // } finally {
            //     bake.unlock(threadId);
            //     // }
            // });
        }

        // Shut down the thread pool
        // executor.shutdown();
        // executor.awaitTermination(1, TimeUnit.MINUTES);
    }

}
