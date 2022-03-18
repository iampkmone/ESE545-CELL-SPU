module tb_SimpleFixed1();
	logic			clk, reset;

	//RF/FWD Stage
	logic [0:10]	op;				//Decoded opcode, truncated based on format
	logic [2:0]		format;			//Format of instr, used with op and imm
	logic [0:6]		rt_addr;		//Destination register address
	logic [0:127]	ra, rb;			//Values of source registers
	logic [0:17]	imm;			//Immediate value, truncated based on format
	logic			reg_write;		//Will current instr write to RegTable

	//WB Stage
	logic [0:127]	rt_wb;			//Output value of Stage 3
	logic [0:6]		rt_addr_wb;		//Destination register for rt_wb
	logic			reg_write_wb;	//Will rt_wb write to RegTable

	SimpleFixed1 dut(clk, reset, op, format, rt_addr, ra, rb, imm, reg_write, rt_wb,
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
		op = 11'b01010110100;						//shlh
		rt_addr = 7'b0000011;						//RT = $r3
		ra = 128'h00010001000100010001000100010001;	//Halfwords: 16'h0010
		rb = 128'h00010001000100010001000100010001;	//Halfwords: 16'h0001
		imm = 0;
		reg_write = 1;

		#6;
		reset = 0;									//@11ns, enable unit

		@(posedge clk); #1;
		op = 0;										//@16ns, instr = nop

		@(posedge clk);
		#1; op = 11'b00011001000;
		ra = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE;
		@(posedge clk);
		//#1; op = 0;
		@(posedge clk);
		#1; op = 11'b00001011111;
		@(posedge clk);
		//#1; op = 0;
		@(posedge clk);
		#1; op = 11'b00011001000;
		ra = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE;
		@(posedge clk);
		#1; ra = 128'h00101131337377F7FF000000000000FF;
		@(posedge clk);
		#1; op = 11'b00011000000;
			ra = 128'h7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF;
		@(posedge clk);
		#1; op = 11'b00011000000;
		ra = 128'h80000000800000008000000080000000;	rb = 128'h10001000100010001000100010001000;
		@(posedge clk);
		#1; op = 11'b00011000000;
		ra = 128'h90000000900000009000000090000000;	rb = 128'h10001000100010001000100010001000;



		@(posedge clk);
		#1; op=11'b00011000001;
		ra = 128'h7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF;
		rb = 128'h10001000100010001000100010001000;
		@(posedge clk);
		#1; op = 11'b00001000001;
			ra = 128'h7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF;
			rb = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
		@(posedge clk);
		#1; op = 11'b01001000001;
		@(posedge clk);
		#1; op = 11'b00011001001;
		@(posedge clk);
		#1; op = 11'b01111010000;
		@(posedge clk);
		#1; op = 11'b01111010000;
			ra = 128'h7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF;
			rb = 128'h7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF;
		@(posedge clk);
		// ceqb rt, ra, rb Compare Equal Byte
		#1; op = 11'b01111001000;
		@(posedge clk);
		// ceqh rt, ra, rb Compare Equal Halfword
		#1; op = 11'b01111001000;
			ra = 128'h7F007F007F007FFF7FFF7FFF7FFF7F00;
			rb = 128'h7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF;
		@(posedge clk);
		// ceqb rt, ra, rb Compare Equal Byte
		#1; op = 11'b01111000000;
		@(posedge clk);
		// ceq rt, ra, rb Compare Equal Word
		#1; op = 11'b01111000000;
			ra = 128'h7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF;
			rb = 128'h7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF;

		@(posedge clk);
		// cgtb rt, ra, rb Compare Greater Than Byte
		#1; op = 11'b01001010000;
		@(posedge clk);
		// cgtb rt, ra, rb Compare Greater Than Byte
		#1; op = 11'b01001010000;
			ra = 128'h7FFFFFFF7FFF7FFF7FFF7FFF7FFFFFFF;
			rb = 128'h76FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF;
		@(posedge clk);
		// cgth rt, ra, rb Compare Greater Than Halfword
		#1; op = 11'b01001001000;
			ra = 128'h7FFFFFFF7FFF7FFF7FFF7FFF7FFFFFFF;
			rb = 128'h77FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF;
		@(posedge clk);
		// cgt rt, ra, rb Compare Greater Than Word
		#1; op = 11'b01001000000;
			ra = 128'h7FFFFFFF7FFF7FFF7FFF7FFF7FFFFFFF;
			rb = 128'h7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF;
		@(posedge clk);
		// clgtb rt, ra, rb Compare Logical Greater Than Byte
		#1; op = 11'b01011010000;
			ra = 128'hFFFFFFFF7FFF7FFF7FFF7FFF7FFFFFFF;
			rb = 128'h7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF;
		@(posedge clk);
		// clgth rt, ra, rb Compare Logical Greater Than Halfword
		#1; op = 11'b01011001000;
			ra = 128'hFFFFFFFF7FFF7FFF7FFF7FFF7FFFFFFF;
			rb = 128'h7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF;
		@(posedge clk);
		// clgt rt, ra, rb Compare Logical Greater Than Word
		#1; op = 11'b01011000000;
			ra = 128'hFFFFFFFF7FFF7FFF7FFF7FFF7FFFFFFF;
			rb = 128'h7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF;
		@(posedge clk);
		 // andbi rt, ra, imm10 And Byte Immediate
		#1; op = 8'b00010110;
			format = 4;
			ra = 128'hFFFFFFFF7FFF7FFF7FFF7FFF7FFFFFFF;
			imm = 10'b0000000111;
		@(posedge clk);
		#1; op=0;
		@(posedge clk);
		#100; $stop; // Stop simulation
	end
endmodule