module fifo (write, read, clk, rst, in_data, out_data, full_flag, empty_flag, overflow_flag, underflow_flag);	//module definition

	input write, read, clk, rst;		//clk - clock, rst - reset
	input in_data;

	output reg out_data;
	
	//since default value of reg is 'z', initialization of all flags to 0 is necessary
	output reg full_flag = 0; 
	output reg empty_flag = 0;
	output reg overflow_flag = 0; 
	output reg underflow_flag = 0;

	reg[3:0] wr_ptr = 0; 			//wr_ptr - write pointer
	reg[3:0] rd_ptr = 0;			//rd_ptr - read pointer
	reg[15:0] data_storage;
	//data_storage is the fifo memory	
	//data_storage[p] indicates the pth stage in the 16-stage fifo

	//always block for positions of read and write pointers	
	always @ (posedge clk or posedge rst)	
	begin
		//read pointer
		if (rst) rd_ptr <= 0 ;						//reset causes pointer to go to initial 0th stage

		else if (read == 1 && empty_flag != 1) rd_ptr <= rd_ptr + 1;	//if fifo is not empty and read signal is high, output 											//is read and pointer is incremented to the next stage
		else rd_ptr <= rd_ptr;

		//write pointer
		if (rst) wr_ptr <= 0 ;						//reset causes pointer to go to initial 0th stage

		else if (write == 1 && full_flag != 1) wr_ptr <= wr_ptr + 1;	//if fifo is not full and write signal is high, input is 											//written and pointer is incremented to the next stage
		else wr_ptr <= wr_ptr;

		if (rd_ptr == 4'b1111) rd_ptr <= 0;				//the pointer should circle back to 0th stage after 15th stage
		if (wr_ptr == 4'b1111) wr_ptr <= 0;

	end

	//always block for status of empty and full flags
	always @ (*)
	begin
		full_flag <= (wr_ptr == rd_ptr - 1)?1:0;			//if write pointer traverses the fifo to reach below the read 											//pointer, the fifo is full
		empty_flag <= (wr_ptr == rd_ptr)?1:0;				//if read pointer catches up to the write pointer, the fifo is 											//empty
	end

	//always block for status of overflow and underflow flags
	always @ (posedge clk or posedge rst)	
	begin
		//if reset signal is high or if read operation is enabled, overflow
		//condition would not occur. Overflow flag is set to 0
		if (rst) overflow_flag <= 0;
		else if (read == 1 && empty_flag != 1) overflow_flag <= 0;

		//if fifo is full and still write signal is high, overflow
		//condition occurs. Overflow flag is set to 1
		else if (full_flag && write) overflow_flag <= 1;

		else overflow_flag <= overflow_flag;

		//if reset signal is high or if write operation is enabled, underflow
		//condition would not occur. Underflow flag is set to 0
		if (rst) underflow_flag <= 0;
		else if (write == 1 && full_flag != 1) underflow_flag <= 0;

		//if fifo is empty and still read signal is given, underflow
		//occurs. Underflow flag is set to 1
		else if (empty_flag && read) underflow_flag <= 1;

		else underflow_flag <= underflow_flag;
	end

	//always block for read and write operations on the fifo
	always @ (posedge clk)
	begin
	//if fifo is not full and write signal is high, input data is written into the fifo memory at
	//the location given by the write pointer (wr_ptr)
		if(write == 1 && full_flag != 1)
			data_storage[wr_ptr] <= in_data;

	//if fifo is not empty and read signal is high, data stored in the fifo at the location given
	//by the read pointer (rd_ptr) is read
		if(read == 1 && empty_flag != 1)
			out_data <= data_storage [rd_ptr];
	end

endmodule



