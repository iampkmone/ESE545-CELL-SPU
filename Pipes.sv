module Pipes(clk, reset, instr_even, instr_odd);
	input			clk, reset;
	input [0:31]	instr_even, instr_odd;		//Instr from decoder
	
	//Nets from decode logic (Note: Will be placed in decode/hazard unit in final submission)
	logic [2:0]		format_even, format_odd;	//Format of instr
	logic [0:10]	op_even, op_odd;			//Opcode of instr (used with format)
	logic [1:0]		unit_even, unit_odd			//Destination unit of instr; Order of: FP, FX2, Byte, FX1 (Even); Perm, LS, Br (Odd)
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
															//Even decoding, RRR-type
		if (instr_even[0:3] == 4'b1100) begin				//mpya
			format_even = 1;
			op_even = 4'b1100;
			unit_even = 0;
		end
		else if (instr_even[0:3] == 4'b1110) begin			//fma
			format_even = 1;
			op_even = 4'b1110;
			unit_even = 0;
		end
		else if (instr_even[0:3] == 4'b1111) begin			//fms
			format_even = 1;
			op_even = 4'b1111;
			unit_even = 0;
		end													//RI18-type
		else if (instr_even[0:6] == 7'b0100001) begin		//ila
			format_even = 6;
			op_even = 7'b0100001;
			unit_even = 3;
		end													//RI8-type
		else if (instr_even[0:9] == 10'b0111011000) begin	//cflts
			format_even = 3;
			op_even = 10'b0111011000;
			unit_even = 0;
		end
		else if (instr_even[0:9] == 10'b0111011001) begin	//cfltu
			format_even = 3;
			op_even = 10'b0111011001;
			unit_even = 0;
		end													//RI16-type
		else if (instr_even[0:8] == 9'b010000011) begin		//ilh
			format_even = 5;
			op_even = 9'b010000011;
			unit_even = 3;
		end
		else if (instr_even[0:8] == 9'b010000010) begin		//ilhu
			format_even = 5;
			op_even = 9'b010000010;
			unit_even = 3;
		end
		else if (instr_even[0:8] == 9'b011000001) begin		//iohl
			format_even = 5;
			op_even = 9'b011000001;
			unit_even = 3;
		end
		else begin
			format_even = 4;				//RI10-type
			case(instr_even[0:7])
				8'b01110100 : begin			//mpyi
					op_even = 8'b01110100;
					unit_even = 0;
				end
				8'b01110101 : begin			//mpyui
					op_even = 8'b01110101;
					unit_even = 0;
				end
				8'b00011101 : begin			//ahi
					op_even = 8'b00011101;
					unit_even = 3;
				end
				8'b00011100 : begin			//ai
					op_even = 8'b00011100;
					unit_even = 3;
				end
				8'b00001101 : begin			//sfhi
					op_even = 8'b00001101;
					unit_even = 3;
				end
				8'b00001100 : begin			//sfi
					op_even = 8'b00001100;
					unit_even = 3;
				end
				8'b00010110 : begin			//andbi
					op_even = 8'b00010110;
					unit_even = 3;
				end
				8'b00010101 : begin			//andhi
					op_even = 8'b00010101;
					unit_even = 3;
				end
				8'b00010100 : begin			//andi
					op_even = 8'b00010100;
					unit_even = 3;
				end
				8'b00000110 : begin			//orbi
					op_even = 8'b00000110;
					unit_even = 3;
				end
				8'b00000101 : begin			//orhi
					op_even = 8'b00000101;
					unit_even = 3;
				end
				8'b00000100 : begin			//ori
					op_even = 8'b00000100;
					unit_even = 3;
				end
				8'b01000110 : begin			//xorbi
					op_even = 8'b01000110;
					unit_even = 3;
				end
				8'b01000101 : begin			//xorhi
					op_even = 8'b01000101;
					unit_even = 3;
				end
				8'b01000100 : begin			//xori
					op_even = 8'b01000100;
					unit_even = 3;
				end
				8'b01111110 : begin			//ceqbi
					op_even = 8'b01111110;
					unit_even = 3;
				end
				8'b01111101 : begin			//ceqhi
					op_even = 8'b01111101;
					unit_even = 3;
				end
				8'b01111100 : begin			//ceqi
					op_even = 8'b01111100;
					unit_even = 3;
				end
				8'b01001110 : begin			//cgtbi
					op_even = 8'b01001110;
					unit_even = 3;
				end
				8'b01001101 : begin			//cgthi
					op_even = 8'b01001101;
					unit_even = 3;
				end
				8'b01001100 : begin			//cgti
					op_even = 8'b01001100;
					unit_even = 3;
				end
				8'b01011110 : begin			//clgtbi
					op_even = 8'b01011110;
					unit_even = 3;
				end
				8'b01011101 : begin			//clgthi
					op_even = 8'b01011101;
					unit_even = 3;
				end
				8'b01011100 : begin			//clgti
					op_even = 8'b01011100;
					unit_even = 3;
				end
				default : format_even = 7;
			endcase
			if (format_even == 7) begin
				format_even = 0;					//RR-type
				case(instr_even[0:10])
					11'b01111000100 : begin			//mpy
						op_even = 11'b01111000100;
						unit_even = 0;
					end
					11'b01111001100 : begin			//mpyu
						op_even = 11'b01111001100;
						unit_even = 0;
					end
					11'b01111000101 : begin			//mpyh
						op_even = 11'b01111000101;
						unit_even = 0;
					end
					11'b01011000100 : begin			//fa
						op_even = 11'b01011000100;
						unit_even = 0;
					end
					11'b01011000101 : begin			//fs
						op_even = 11'b01011000101;
						unit_even = 0;
					end
					11'b01011000110 : begin			//fm
						op_even = 11'b01011000110;
						unit_even = 0;
					end
					11'b01111000010 : begin			//fceq
						op_even = 11'b01111000010;
						unit_even = 0;
					end
					11'b01011000010 : begin			//fcgt
						op_even = 11'b01011000010;
						unit_even = 0;
					end
					11'b00001011111 : begin			//shlh
						op_even = 11'b00001011111;
						unit_even = 1;
					end
					11'b00001011011 : begin			//shl
						op_even = 11'b00001011011;
						unit_even = 1;
					end
					11'b00001011100 : begin			//roth
						op_even = 11'b00001011100;
						unit_even = 1;
					end
					11'b00001011000 : begin			//rot
						op_even = 11'b00001011000;
						unit_even = 1;
					end
					11'b00001011101 : begin			//rothm
						op_even = 11'b00001011101;
						unit_even = 1;
					end
					11'b00001011001 : begin			//rotm
						op_even = 11'b00001011001;
						unit_even = 1;
					end
					11'b00001011110 : begin			//rotmah
						op_even = 11'b00001011110;
						unit_even = 1;
					end
					11'b00001011010 : begin			//rotma
						op_even = 11'b00001011010;
						unit_even = 1;
					end
					11'b01010110100 : begin			//cntb
						op_even = 11'b01010110100;
						unit_even = 2;
					end
					11'b00011010011 : begin			//avgb
						op_even = 11'b00011010011;
						unit_even = 2;
					end
					11'b00001010011 : begin			//absdb
						op_even = 11'b00001010011;
						unit_even = 2;
					end
					11'b01001010011 : begin			//sumb
						op_even = 11'b01001010011;
						unit_even = 2;
					end
					11'b00011001000 : begin			//ah
						op_even = 11'b00011001000;
						unit_even = 3;
					end
					11'b00011000000 : begin			//a
						op_even = 11'b00011000000;
						unit_even = 3;
					end
					11'b00001001000 : begin			//sfh
						op_even = 11'b00001001000;
						unit_even = 3;
					end
					11'b00001000000 : begin			//sf
						op_even = 11'b00001000000;
						unit_even = 3;
					end
					11'b00011000001 : begin			//and
						op_even = 11'b00011000001;
						unit_even = 3;
					end
					11'b00001000001 : begin			//or
						op_even = 11'b00001000001;
						unit_even = 3;
					end
					11'b01001000001 : begin			//xor
						op_even = 11'b01001000001;
						unit_even = 3;
					end
					11'b00011001001 : begin			//nand
						op_even = 11'b00011001001;
						unit_even = 3;
					end
					11'b01111010000 : begin			//ceqb
						op_even = 11'b01111010000;
						unit_even = 3;
					end
					11'b01111001000 : begin			//ceqh
						op_even = 11'b01111001000;
						unit_even = 3;
					end
					11'b01111000000 : begin			//ceq
						op_even = 11'b01111000000;
						unit_even = 3;
					end
					11'b01001010000 : begin			//cgtb
						op_even = 11'b01001010000;
						unit_even = 3;
					end
					11'b01001001000 : begin			//cgth
						op_even = 11'b01001001000;
						unit_even = 3;
					end
					11'b01001000000 : begin			//cgt
						op_even = 11'b01001000000;
						unit_even = 3;
					end
					11'b01011010000 : begin			//clgtb
						op_even = 11'b01011010000;
						unit_even = 3;
					end
					11'b01011001000 : begin			//clgth
						op_even = 11'b01011001000;
						unit_even = 3;
					end
					11'b01011000000 : begin			//clgt
						op_even = 11'b01011000000;
						unit_even = 3;
					end
					11'b01000000001 : begin			//nop
						op_even = 11'b01000000001;
						unit_even = 0;
					end
					default : format_even = 7;
				endcase
				if (format_even == 7) begin
					format_even = 2;					//RI7-type
					case(instr_even[0:10])
						11'b00001111011 : begin			//shli
							op_even = 11'b00001111011;
							unit_even = 1;
						end
						11'b00001111100 : begin			//rothi
							op_even = 11'b00001111100;
							unit_even = 1;
						end
						11'b00001111000 : begin			//roti
							op_even = 11'b00001111000;
							unit_even = 1;
						end
						11'b00001111110 : begin			//rotmahi
							op_even = 11'b00001111110;
							unit_even = 1;
						end
						11'b00001111010 : begin			//rotmai
							op_even = 11'b00001111010;
							unit_even = 1;
						end
					endcase
				end
			end
		end
		
															//odd decoding, RI10-type
		if (instr_odd[0:7] == 8'b00110100) begin			//lqd
			format_odd = 4;
			op_odd = 4'b00110100;
			unit_odd = 1;
		end
		else if (instr_odd[0:7] == 8'b00110100) begin		//stqd
			format_odd = 4;
			op_odd = 4'b00110100;
			unit_odd = 1;
		end
		else begin
			format_odd = 5;					//RI16-type
			case(instr_odd[0:8])
				9'b001100001 : begin		//lqa
					op_odd = 9'b001100001;
					unit_odd = 1;
				end
				9'b001000001 : begin		//stqa
					op_odd = 9'b001000001;
					unit_odd = 1;
				end
				9'b001100100 : begin		//br
					op_odd = 9'b001100100;
					unit_odd = 2;
				end
				9'b001100000 : begin		//bra
					op_odd = 9'b001100000;
					unit_odd = 2;
				end
				9'b001100110 : begin		//brsl
					op_odd = 9'b001100110;
					unit_odd = 2;
				end
				9'b001000010 : begin		//brnz
					op_odd = 9'b001000010;
					unit_odd = 2;
				end
				9'b001000000 : begin		//brz
					op_odd = 9'b001000000;
					unit_odd = 2;
				end
				default : format_odd = 7;
			endcase
			if (format_odd == 7) begin
				format_odd = 0;					//RR-type
				case(instr_odd[0:10])
					11'b00111011011 : begin		//shlqbi
						op_odd = 11'b00111011011;
						unit_odd = 0;
					end
					11'b00111011111 : begin		//shlqby
						op_odd = 11'b00111011111;
						unit_odd = 0;
					end
					11'b00111011000 : begin		//rotqbi
						op_odd = 11'b00111011000;
						unit_odd = 0;
					end
					11'b00111011100 : begin		//rotqby
						op_odd = 11'b00111011100;
						unit_odd = 0;
					end
					11'b00110110010 : begin		//gbb
						op_odd = 11'b00110110010;
						unit_odd = 0;
					end
					11'b00110110001 : begin		//gbh
						op_odd = 11'b00110110001;
						unit_odd = 0;
					end
					11'b00110110000 : begin		//gb
						op_odd = 11'b00110110000;
						unit_odd = 0;
					end
					11'b00111000100 : begin		//lqx
						op_odd = 11'b00111000100;
						unit_odd = 1;
					end
					11'b00101000100 : begin		//stqx
						op_odd = 11'b00101000100;
						unit_odd = 1;
					end
					11'b00110101000 : begin		//bi
						op_odd = 11'b00110101000;
						unit_odd = 2;
					end
					11'b00000000001 : begin		//lnop
						op_odd = 11'b00000000001;
						unit_odd = 0;
					end
					default : format_odd = 7;
				endcase
				if (format_odd == 7) begin
					format_odd = 2;					//RI7-type
					case(instr_odd[0:10])
						11'b00111111011 : begin		//shlqbii
							op_odd = 11'b00111111011;
							unit_odd = 0;
						end
						11'b00111111111 : begin		//shlqbyi
							op_odd = 11'b00111111111;
							unit_odd = 0;
						end
						11'b00111111000 : begin		//rotqbii
							op_odd = 11'b00111111000;
							unit_odd = 0;
						end
						11'b00111111100 : begin		//rotqbyi
							op_odd = 11'b00111111100;
							unit_odd = 0;
						end
					endcase
				end
			end
		end
	end
	
endmodule