module Pipes(clk, reset, instr_even, instr_odd);
	input			clk, reset;
	input [0:31]	instr_even, instr_odd;		//Instr from decoder
	
	//Nets from decode logic (Note: Will be placed in decode/hazard unit in final submission)
	logic [2:0]		format_even, format_odd;	//Format of instr
	logic [0:10]	op_even, op_odd;			//Opcode of instr (used with format)
	logic [127:0]	rt_even, ra_even, rb_even, rc_even, rt_odd, ra_odd, rb_odd, rc_odd;	//Register values from RegTable
	logic [0:6]		imm7_even, imm7_odd;		//Decoded 7-bit immediate value
	logic [0:9]		imm10_even, imm10_odd;		//Decoded 10-bit immediate value
	logic [0:15]	imm16_even, imm16_odd;		//Decoded 16-bit immediate value
	logic [0:17]	imm18_even, imm18_odd;		//Decoded 18-bit immediate value
	
	RegisterTable rf(.clk(clk), .reset(reset), .instr_even(instr_even), .instr_odd(instr_odd), .format_even(format_even), .format_odd(format_odd),
		.rt_even(rt_even), .ra_even(ra_even), .rb_even(rb_even), .rc_even(rc_even), .rt_odd(rt_odd), .ra_odd(ra_odd), .rb_odd(rb_odd), .rc_odd(rc_odd));
	
	EvenPipe ev(.clk(clk), .reset(reset), .instr(instr_even), .op(op_even), .rt(rt_even), .ra(ra_even), .rb(rb_even), .rc(rc_even), .imm7(imm7_even),
		.imm10(imm10_even), .imm16(imm16_even), .imm18(imm18_even));
	
	OddPipe od(.clk(clk), .reset(reset), .instr(instr_odd), .op(op_odd), .rt(rt_odd), .ra(ra_odd), .rb(rb_odd), .rc(rc_odd), .imm7(imm7_odd),
		.imm10(imm10_odd), .imm16(imm16_odd), .imm18(imm18_odd));
		
	//Decode logic (Note: Will be placed in decode/hazard unit in final submission)
	always_comb begin
		
	end
	
endmodule