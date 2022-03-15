module tb_RegisterTable();

    logic					clk, reset;
	logic[0:31]			instr_even, instr_odd;			//Instructions to read from decoder
	logic[2:0]				format_even, format_odd;		//Instruction formats to read, decoded
	logic[0:127]	ra_even, rb_even, rc_even, ra_odd, rb_odd, rt_st_odd;	//Set all possible register values regardless of format

	logic[0:6]				rt_addr_even, rt_addr_odd;		//Destination registers to write to
	logic[0:127]			rt_even, rt_odd;				//Values to write to destination registers
	logic					reg_write_even, reg_write_odd;	//1 if instr will write to rt, else 0



	RegisterTable dut (.clk(clk), .reset(reset), .instr_even(instr_even),
	.instr_odd(instr_odd), .ra_even(ra_even), .rb_even(rb_even),
	.rc_even(rc_even), .ra_odd(ra_odd), .rb_odd(rb_odd),.rt_st_odd(rt_st_odd),.rt_addr_even(rt_addr_even),
	.rt_addr_odd(rt_addr_odd), .rt_even(rt_even), .rt_odd(rt_odd),
	.reg_write_even(reg_write_even), .reg_write_odd(reg_write_odd));




    initial
        clk = 0;


    always begin
		#5 clk = ~clk;
        $display("%0t: reset = %h, instr_even = %b instr_odd = %b  ra_even = %h rb_even = %h rc_even = %h ra_odd = %h rb_odd = %h rt_addr_even = %h rt_addr_odd = %h rt_even = %h rt_odd = %h reg_write_even = %h reg_write_odd = %h rt_st_odd = %d ",$time, reset , instr_even, instr_odd,
		ra_even, rb_even, rc_even, ra_odd, rb_odd,rt_addr_even, rt_addr_odd, rt_even, rt_odd,
        reg_write_even, reg_write_odd,rt_st_odd);
    end



    initial begin
		reset = 1;
		reg_write_even=0;
		instr_even=32'h00000000;
		reset = 0;									//@5ns, enable unit
		@(posedge clk );
		#1;
		format_even=2'b01;
		instr_even=32'b00001011111000001100001000000101; 		//shlh rb=3 ra =4 rt=5
		rt_addr_even=7'b0000101;
		instr_odd=32'b00000000010000000000000000000; 		//lnop
		reg_write_odd = 0;
		rt_addr_odd = 7'b00000000;

		#30;
		@(posedge clk );
		#1;
		rt_even=128'h000A000000000000000000000000000;


		// At address 5 we write the value rt_even

		#20; // writing back the value at at end of 8th cycle
		@(posedge clk );
		#1;
		reg_write_even = 1;



		// Write to reg 5 at end of 8th cycle and read of reg 5 from start of 8th cycle
		instr_even=32'b00001011111000010100001000001001; 		//shlh rb=5 ra =4 rt=9
		rt_addr_even=7'b0001001;


		instr_odd =32'b00111011011000001000001010000111; 		//shlqbi rb=2 ra =5 rt=7
		rt_addr_odd=7'b0000111;

		#5;
		@(posedge clk);
		#1;
		reg_write_even = 0;

		#20;// Simulating delay of 4 cycle [ at the end of 4th cycle we have the result for even pipe]
		@(posedge clk );
		#1;
		rt_even=128'h000C000000000000000000000000000;

		#10; // Simulating delay of 6 cycle
		@(posedge clk );
		#1;
		rt_odd =128'h000B000000000000000000000000000;

		#5; // writing back the value at at end of 8th cycle
		@(posedge clk );
		#1;
		reg_write_even = 1;
		reg_write_odd = 1;


		#5; // writing back the value to reg 7 by odd pipe and reg 9 by even pipe at end of 8th cycle
		@(posedge clk );
		#1;
		reg_write_even = 0;
		reg_write_odd = 0;
		// Even instruction reading value from reg 7 from odd pipe write operation
		instr_even=32'b00001011111000011100010010001010; 		//shlh rb=7 ra =9 rt=10
		rt_addr_even=7'b0001010;


		instr_odd =32'b00111011011000011000011010001111; 		//shlqbi rb=6 ra =11 rt=15
		rt_addr_odd=7'b0001111;

		#20;
		@(posedge clk );
		#1;
		rt_even=128'h000D000000000000000000000000000;

		#10; // Simulating delay of
		@(posedge clk );
		#1;
		rt_odd =128'h000E000000000000000000000000000;

		#5; // writing back the value at at end of 8th cycle
		@(posedge clk );
		#1;
		reg_write_even = 1;
		reg_write_odd = 1;

		#5;
		@(posedge clk);
		#1;
		reg_write_even = 0;
		reg_write_odd = 0;

		#50;
		@(posedge clk)
		#1;

		$stop; // Stop simulation

    end
endmodule