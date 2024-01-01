import java.util.concurrent.atomic.AtomicIntegerArray;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class chat {
    // Number of threads
    private int n;

    // Array to store the ticket numbers of each thread
    private AtomicIntegerArray ticket;

    // Array to store the choosing status of each thread
    private AtomicIntegerArray choosing;

    public chat(int numThreads) {
        n = numThreads;
        ticket = new AtomicIntegerArray(n);
        choosing = new AtomicIntegerArray(n);

        // Initialize the ticket numbers and choosing status of each thread
        for (int i = 0; i < n; i++) {
            ticket.set(i, 0);
            choosing.set(i, 0);
        }
    }

    // Function to acquire the lock
    public void lock(int threadId) {
        // Mark the thread as choosing
        choosing.set(threadId, 1);

        // Find the maximum ticket number of all threads
        int maxTicket = 0;
        for (int i = 0; i < n; i++) {
            maxTicket = Math.max(maxTicket, ticket.get(i));
        }

        // Assign the next available ticket number to the thread
        ticket.set(threadId, maxTicket + 1);

        // Mark the thread as not choosing
        choosing.set(threadId, 0);

        // Wait until all other threads with smaller or equal ticket numbers have finished choosing
        for (int j = 0; j < n; j++) {
            if (j != threadId) {
                // Wait until thread j is not choosing
                while (choosing.get(j) != 0) {
                    System.out.println("Thread " + j + " yielding at 1");
                    Thread.yield();
                }

                // Wait until either thread j has a larger ticket number, or it has a smaller ticket number but has finished choosing
                while (ticket.get(j) != 0 && (ticket.get(j) < ticket.get(threadId) || (ticket.get(j) == ticket.get(threadId) && j < threadId))) {   System.out.println("Thread " + j + " locking here");
                    Thread.yield();
                }
            }
            // System.out.println("Thread " + j + " is accessing the shared resource");
        }
    }

    // Function to release the lock
    public void unlock(int threadId) {
        // Clear the ticket number of the thread
        System.out.println("Thread " + threadId + " is unlocking");
        ticket.set(threadId, 0);
    }

    public static void main(String[] args) throws InterruptedException {
        // Create a BakeryAlgorithm object with 4 threads
        chat bakery = new chat(4);

        // Create a thread pool with 4 threads
        ExecutorService executor = Executors.newFixedThreadPool(4);

        // Submit a task to the thread pool that acquires and releases the lock using the BakeryAlgorithm object
        for (int i = 0; i < 4; i++) {
            final int threadId = i;
            executor.submit(() -> {
                bakery.lock(threadId);
                try {
                    // Access shared resource here
                    System.out.println("Thread " + threadId + " is accessing the shared resource");
                } finally {
                    bakery.unlock(threadId);
                }
            });
        }

        // Shut down the thread pool
        executor.shutdown();
        executor.awaitTermination(1, TimeUnit.MINUTES);
    }

}