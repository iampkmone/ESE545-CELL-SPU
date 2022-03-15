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
		reset = 0;									//@11ns, enable unit, mpy @ Float (int)
		
		@(posedge clk); #1;							//@16ns, even = fa, odd = dhlqbi
		instr_even = 32'b01011000100000001000000010000011;
		instr_odd = 32'b00111011011000010100001000000110;
		//unit = 0;
		//op = 11'b01011000100;
		//rt_addr = 7'b0000100;						//RT = $r4
		
		@(posedge clk); #1;							//@21ns, shlh @ FX2
		//unit = 1;
		//op = 11'b00001011111;	
		//rt_addr = 7'b0000101;						//RT = $r5	
	
		@(posedge clk); #1;							//@26ns, cntb @ Byte
		//unit = 2;
		//op = 11'b01010110100;
		//rt_addr = 7'b0000110;						//RT = $r6	
		//format = 5;
		@(posedge clk);								//@31ns, ah @ FX1
		#1; //unit = 3;
		//op = 11'b00011001000;
		//format = 0;
		//rt_addr = 7'b0000111;						//RT = $r7	
		@(posedge clk);								//@36ns, NOP
		#1; //op = 0;
		@(posedge clk);
		#1; //op = 0;
		//ra = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE;
		@(posedge clk);
		#1; //ra = 128'h00101131337377F7FF000000000000FF;
		@(posedge clk);
		#100; $stop; // Stop simulation
	end
endmodule