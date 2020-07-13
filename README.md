# 16-stage-fifo
Verilog code for 16-stage FIFO memory

* FIFO (first in, first out) memory often serves as an intermediate storage in the exchange of data between two systems. 

* The first generation FIFOs were called 'fall-through FIFOs' because their architecture caused all the data words to shift, i.e fall through all the memory locations. This resulted in a delay or fall-through time. To overcome this, a new architecture is now used, which does not require data to travel through all the memory locations. This *static memory architecture* is implemented using a **circular memory** and two (read and write) **pointers**.

* Status signals for the FIFO - full, empty, overflow, underflow - are also generated using the locations of the read and write pointers. 

* The write pointer travels ahead in the FIFO memory, writing the input data in the memory. The read pointer continuously follows the write pointer as it reads out the data from the FIFO memory. 

* If the read pointer catches up with the write pointer, there is nothing left to be read - the FIFO is **empty**.
If the write pointer goes ahead in the circular memory and reaches just below the read pointer - the FIFO is **full**.

* **Overflow** occurs if the FIFO is full and data is still being written, while **underflow** occurs if the FIFO is empty and data is still being read from it.

The code in this repository results in a 16-stage FIFO and displays its four status flags.
