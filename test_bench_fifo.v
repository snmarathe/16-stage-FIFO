`timescale 1ns/1ps			//`timescale <time unit>/<time precision>
`include "fifo16.v"

module testbench();
	reg write, read, clk, rst;					//DUT inputs are declared as reg
	reg in_data;

	wire out_data;
	wire full_flag, empty_flag, overflow_flag, underflow_flag;	//DUT outputs are declared as wire

	always #2 clk = ~clk;		//toggle every 2 time units

	//instantiation of fifo module
	fifo tb (write, read, clk, rst, in_data, out_data, full_flag, empty_flag, overflow_flag, underflow_flag);

	initial
	begin
		$monitor ("clk = %b, write = %b, read = %b, rst = %b, in_data = %b, ff = %b, ef = %b, of = %b, uf = %b, out_data = %b", clk, write, read, rst, in_data, full_flag, empty_flag, overflow_flag, underflow_flag, out_data);
		
		clk = 0; write = 0; read = 0; rst = 0; 
		#4 in_data = 1; write = 1;
		#4 in_data = 0;
		#4 in_data = 1; write = 0;
		#4 read = 1;		
		#4 $finish;
	end

endmodule
