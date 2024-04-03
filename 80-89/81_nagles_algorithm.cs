// if there is new data to send then
//     if the window size ≥ MSS and available data is ≥ MSS then
//         send complete MSS segment now
//     else
//         if there is unconfirmed data still in the pipe then
//             enqueue data in the buffer until an acknowledge is received
//         else
//             send data immediately
//         end if
//     end if
// end if

class Computer
class Router {
    
    public Router(int packetBoilerPlate) {
        boilerplateLength = packetBoilerPlate
    }
    int boilerplateLength
    int[] messageSeparatorsFromSource = [0]
    int[] messageSeparatorsToDestination = [0]
    int[] connectorToRouter = new int[10000];
    int[]  connectorToDestination = new int[10000];

    void placeMessageInQueue(byte[] message) {
        int adder = 0
        for(int i=messageSeparatorsFromSource[-1]; i<message.length; i++) {
            connectorToDestination[messageSeparatorsToDestination[-1]+adder] = messageSeparatorsFromSource[-1] + i
            adder++
        }
    }
    void passInformationToDestination(source, destination) {
        for(int i=messageSeparatorsFromSource[-2]; i<messageSeparatorsFromSource[-1]; i++) {
            connectorToDestination[messageSeparatorsToDestination[-1]+adder] = messageSeparatorsFromSource[i]
        }
    }

    byte[] getAllDestinationData() {
        for(int i=0; i<messageSeparatorsToDestination.length-1;i++)
    }

    void reset() {
        this.messageSeparatorsFromSource = {0}
        this.messageSeparatorsToDestination = {0}
        this.connectorToRouter = {}
        this.connectorToRouter = {}
    }
}


//  // Creating a buffer of 100 bytes

// // Setting values in the buffer
// binaryBuffer[0] = 0b00000001; // Set the first byte to binary 00000001

class Message {

    byte[] connectorToMain = new byte[10000];
    byte[] connectorToDestination = new byte[10000];

    byte[] standardBoilerPlateTop = {0b00101101, 0b11010100} // ... TODO
    static Message createMessage(int[] message) {
        return standardBoilerPlateTop.Concat(message).ToArray();
    }

    static void sendMessage(byte[] message, Router router) {
        Array.Copy(message, 0, connectorToDestination, lastMessageByte, smallerArray.Length);
        router.messageSeparators.push(Buffer.ByteLength(b) + router.messageSeparators[messageSeparators.length()]);
    }
}

// Hello World! program
namespace HelloWorld {

    class Hello {
  
        static void Main(string[] args)
        {
            // System.Console.WriteLine("Hello World!");
            
            int passes = 100
            mml = 100 // message length
            tbts = 1000 // total bytes to send
            int lengthOfMessage
            Router router = new Router()


            // without nagle (naive packet sending)
            byte[mml] draft;
            for(int i = 0; i < passes; i++) {
                lengthOfMessage = Math.floor(mml*Random.random())

                
                for(int i = 0; i < lengthOfMessage; i++) {
                    draft[i] = Random.random({0,1})
                }
                byte[mml] message = Message.createMessage(draft)
                router.placeMessageInQueue(message)
                draft = {}
            }

            byte[mml] message = Message.createMessage(draft)
            router.placeMessageInQueue()
            router.passInformationToDestination()
            
            int fullDataSizeNaive = router.getPassedDataLength()

            // DONE. some cleaning
            router.clean()
            lengthCurrentMessage = 0
            // with Nagle (smart packet sending)
            byte[mml] draft;

            for(int i = 0; i < passes; i++) {
                int lengthOfMessage = Math.floor(mml*Random.random())

                byte[] draft;
                for(int i = 0; i < lengthOfMessage; i++) {
                    draft[i] = Random.random({0,1})

                    if (draft.length() == mml) {
                        byte[] message = Message.createMessage(draft)
                        router.placeMessageInQueue(message)
                        draft = {}
                    }
                }
                
            }
            byte[mml] message = Message.createMessage(draft)
            router.placeMessageInQueue(message)
            router.passInformationToDestination()
            int fullDataSizeNagle = router.getPassedDataLength()
            
            System.println(f"Full datasize naive: " {fullDataSizeNaive})
            System.println(f"Full datasize Nagle: " {fullDataSizeNagle})
        }
    }
}
