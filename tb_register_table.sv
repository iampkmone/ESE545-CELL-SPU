module tb_RegisterTable();

    logic					clk, reset;
	logic[0:31]			instr_even, instr_odd;			//Instructions to read from decoder
	logic[2:0]				format_even, format_odd;		//Instruction formats to read, decoded
	logic[0:127]	ra_even, rb_even, rc_even, ra_odd, rb_odd;	//Set all possible register values regardless of format

	logic[0:6]				rt_addr_even, rt_addr_odd;		//Destination registers to write to
	logic[0:127]			rt_even, rt_odd;				//Values to write to destination registers
	logic					reg_write_even, reg_write_odd;	//1 if instr will write to rt, else 0



	RegisterTable dut (.clk(clk), .reset(reset), .instr_even(instr_even),
	.instr_odd(instr_odd), .format_even(format_even),
	.format_odd(format_odd), .ra_even(ra_even), .rb_even(rb_even),
	.rc_even(rc_even), .ra_odd(ra_odd), .rb_odd(rb_odd),.rt_addr_even(rt_addr_even),
	.rt_addr_odd(rt_addr_odd), .rt_even(rt_even), .rt_odd(rt_odd),
	.reg_write_even(reg_write_even), .reg_write_odd(reg_write_odd));




    initial
        clk = 0;


    always begin
		#5 clk = ~clk;
        $display("%0t: reset = %h, instr_even = %h instr_odd = %h format_even = %h
	    format_odd = %h ra_even = %h rb_even = %h rc_even = %h
        ra_odd = %d rb_odd = %h rt_addr_even = %h rt_addr_odd = %h rt_even = %h rt_odd = %h
        reg_write_even = %h reg_write_odd = %h",$time, reset , instr_even, instr_odd, format_even,
        format_odd, ra_even, rb_even, rc_even, ra_odd, rb_odd,rt_addr_even, rt_addr_odd, rt_even, rt_odd,
        reg_write_even, reg_write_odd);
    end



    initial begin
		reset = 1;
		reg_write_even=0;
		instr_even=32'h00000000;

        #6;
		reset = 0;									//@11ns, enable unit
		@(posedge clk ); #1;
		format_even=2'b01;
		@(posedge clk);#1;
		reg_write_even = 1;
		instr_even=32'b00001011111000001100001000000101; 		//shlh rb=3 ra =4 rt=5
		rt_addr_even=7'b000101;
		rt_even=128'h000A000000000000000000000000000;
		#100;
		$stop; // Stop simulation
    end
endmodule