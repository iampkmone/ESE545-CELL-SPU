module tb_Pipes();
	logic			clk, reset;
	logic [0:31]	instr_even, instr_odd;					//Instr from decoder
	logic [7:0]		pc;										//Program counter from IF stage
	
	//Signals for handling branches
	logic [7:0]		pc_wb;									//New program counter for branch
	logic			branch_taken;							//Was branch taken?
	
	Pipes dut(clk, reset, instr_even, instr_odd, pc, pc_wb, branch_taken);
		
	// Initialize the clock to zero.
	initial
		clk = 0;

	// Make the clock oscillate: every 5 time units, it changes its value.
	always begin
		#5 clk = ~clk;
		/*$display("%d: reset = %h, format = %h, op = %h, rt_addr = %h, ra = %h,
			rb = %h, imm = %h, reg_write = %h, rt_wb = %h, rt_addr_wb = %h,
			reg_write_wb = %h", $time, reset, format, op, rt_addr, ra, rb, imm, reg_write,
			rt_wb, rt_addr_wb, reg_write_wb);*/
		pc = pc + 1;
	end
		
	initial begin
		reset = 1;
		pc = 0;
		instr_even = 0;
		instr_odd = 0;
		
		
		#6;
		reset = 0;											//@11ns, enable unit
		
		@(posedge clk); //#1;									//@16ns
		instr_even = 32'b01011000100000001000000010000011;	//fa $3, $1, $2
		instr_odd = 32'b00111011011000010100001000000110;	//shlqbi $6, $4, $5
		
		@(posedge clk); //#1;
		instr_even = 0; instr_odd = 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		
		@(posedge clk); //#1;									//@21ns
		instr_even = 32'b00001011111000001100000110000111;	//shlh $7, $3, $3
		instr_odd = 32'b0;									//nop (ls)
		
		@(posedge clk); //#1; 
		instr_even = 0; instr_odd = 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		
		@(posedge clk); //#1;									//@26ns
		instr_even = 32'b00011001000000001100001110001000;	//fa $8, $7, $3
		instr_odd = 32'b0;									//nop (ls)
		
		@(posedge clk); //#1; #1; 
		instr_even = 0; instr_odd = 0;	//@31ns
		
		@(posedge clk); #1;									//@36ns
		
		@(posedge clk); #1;									//@41ns
		
		@(posedge clk); #1;									//@46ns
		
		@(posedge clk); #1;									//@51ns
		#200; $stop;
	end
endmodule