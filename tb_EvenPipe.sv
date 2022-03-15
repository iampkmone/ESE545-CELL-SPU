module tb_EvenPipe();
	logic			clk, reset;
	
	//RF/FWD Stage
	logic [0:10]	op;				//Decoded opcode, truncated based on format
	logic [2:0]		format;			//Format of instr, used with op and imm
	logic [1:0]		unit;			//Execution unit of instr (0: FP, 1: FX2, 2: Byte, 3: FX1)
	logic [0:6]		rt_addr;		//Destination register address
	logic [0:127]	ra, rb, rc;		//Values of source registers
	logic [0:17]	imm;			//Immediate value, truncated based on format
	logic			reg_write;		//Will current instr write to RegTable
	
	//WB Stage
	logic [0:127]	rt_wb;			//Output value of Stage 7
	logic [0:6]		rt_addr_wb;		//Destination register for rt_wb
	logic			reg_write_wb;	//Will rt_wb write to RegTable
	
	EvenPipe dut(clk, reset, op, format, unit, rt_addr, ra, rb, rc, imm, reg_write, rt_wb,
		rt_addr_wb, reg_write_wb);
		
	// Initialize the clock to zero.
	initial
		clk = 0;

	// Make the clock oscillate: every 5 time units, it changes its value.
	always begin
		#5 clk = ~clk;
		$display("%d: reset = %h, format = %h, op = %h, rt_addr = %h, ra = %h,
			rb = %h, imm = %h, reg_write = %h, rt_wb = %h, rt_addr_wb = %h,
			reg_write_wb = %h", $time, reset, format, op, rt_addr, ra, rb, imm, reg_write,
			rt_wb, rt_addr_wb, reg_write_wb);
	end
		
	initial begin
		reset = 1;
		format = 3'b000;
		op = 11'b01111000100;						//mpy
		unit = 0;
		rt_addr = 7'b0000011;						//RT = $r3
		ra = 128'h00000025000100010001000100010001;	//Halfwords: 16'h0010
		rb = 128'h00000001000100010001000100010001;	//Halfwords: 16'h0001
		rc = 128'h00010001000100010001000100010001;	//Halfwords: 16'h0001
		imm = 12;
		reg_write = 1;
		
		#6;
		reset = 0;									//@11ns, enable unit, mpy @ Float (int)
		
		@(posedge clk); #1;							//@16ns, fa @ Float
		unit = 0;
		op = 11'b01011000100;
		rt_addr = 7'b0000100;						//RT = $r4
		
		@(posedge clk); #1;							//@21ns, shlh @ FX2
		unit = 1;
		op = 11'b00001011111;	
		rt_addr = 7'b0000101;						//RT = $r5	
	
		@(posedge clk); #1;							//@26ns, cntb @ Byte
		unit = 2;
		op = 11'b01010110100;
		rt_addr = 7'b0000110;						//RT = $r6	
		//format = 5;
		@(posedge clk);								//@31ns, ah @ FX1
		#1; unit = 3;
		op = 11'b00011001000;
		format = 0;
		rt_addr = 7'b0000111;						//RT = $r7	
		@(posedge clk);								//@36ns, NOP
		#1; op = 0;
		@(posedge clk);
		#1; op = 0;
		ra = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE;
		@(posedge clk);
		#1; ra = 128'h00101131337377F7FF000000000000FF;
		@(posedge clk);
		#100; $stop; // Stop simulation
	end
endmodule