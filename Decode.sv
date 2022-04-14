module Decode(clk, reset, instr, pc, stall_pc,stall);
    input logic			clk, reset;
    // input logic[0:63]    instr;                                  // From Instruction File (Fetch Stage)
    input logic[0:31] instr[0:1];


	logic [0:31]	instr_even, instr_odd,instr_odd_issue,instr_even_issue;					//Instr from decoder
	
	//Signals for handling branches
	logic[7:0]	pc_wb;									//New program counter for branch
	output logic [7:0] stall_pc;
	output logic stall;
	logic		branch_taken;							//Was branch taken?

    input logic[7:0] pc;                           // PC for the current state

    //Nets from decode logic (Note: Will be placed in decode/hazard unit in final submission)
	logic [2:0]		format_even, format_odd;				//Format of instr
	logic [0:10]	op_even, op_odd;						//Opcode of instr (used with format)
	logic [1:0]		unit_even, unit_odd;					//Destination unit of instr; Order of: FP, FX2, Byte, FX1 (Even); Perm, LS, Br (Odd)
	logic [0:6]		rt_addr_even, rt_addr_odd;				//Destination register addresses
	// logic [0:127]	ra_even, rb_even, rc_even, ra_odd, rb_odd, rt_st_odd;	//Register values from RegTable
	logic [0:17]	imm_even, imm_odd;						//Full possible immediate value (used with format)
	logic			reg_write_even, reg_write_odd;			//1 if instr will write to rt, else 0

typedef struct { 
	logic [0:31]	instr_even, instr_odd;	
	logic [0:10]	op_even, op_odd;
	logic			reg_write_even, reg_write_odd;
	logic [0:17]	imm_even, imm_odd;	
	logic [0:6]		rt_addr_even, rt_addr_odd;	
	logic [1:0]		unit_even, unit_odd;	
	logic [2:0]		format_even, format_odd;
} op_codes;

op_codes op;

    Pipes pipe(.clk(clk), .reset(reset), .pc(pc),
		.instr_even(instr_even), .instr_odd(instr_odd),
		.pc_wb(pc_wb), .branch_taken(branch_taken),
        .op_even(op_even), .op_odd(op_odd),
        .unit_even(unit_even), .unit_odd(unit_odd),
        .rt_addr_even(rt_addr_even), .rt_addr_odd(rt_addr_odd),
        .format_even(format_even), .format_odd(format_odd),
        .imm_even(imm_even), .imm_odd(imm_odd),
        .reg_write_even(reg_write_even), .reg_write_odd(reg_write_odd)
        );



	always_ff @( posedge clk ) begin : decode_op
		instr_even <= op.instr_even;
		instr_odd <= op.instr_odd;
		op_even <= op.op_even;
		op_odd <= op.op_odd;
		reg_write_even <= op.reg_write_even;
		reg_write_odd <= op.reg_write_odd;
		imm_even <= op.imm_even;
		imm_odd <= op.imm_odd;
		rt_addr_even <= op.rt_addr_even;
		rt_addr_odd <= op.rt_addr_odd;
		unit_even <= op.unit_even;
		unit_odd <= op.unit_odd;
		format_even <= op.format_even;
		format_odd <= op.format_odd;
		$display("================================================================");
		$display($time," Decode: OP struct values ");
		$display($time," Decode: instr_even %b instr_odd %b ",op.instr_even, op.instr_odd);
		$display($time," Decode: op_even %b op_odd %b ",op.op_even, op.op_odd);
		$display($time," Decode: reg_write_even %b reg_write_odd %b ",op.reg_write_even, op.reg_write_odd);
		$display($time," Decode: imm_even %b imm_odd %b ",op.imm_even, op.imm_odd);
		$display($time," Decode: rt_addr_even %b rt_addr_odd %b ",op.rt_addr_even, op.rt_addr_odd);
		$display($time," Decode: unit_even %d unit_odd %d ",op.unit_even, op.unit_odd);
		$display($time," Decode: format_even %d format_odd %d ",op.format_even, op.format_odd);
		$display("================================================================");


	end
	//Decode logic (Note: Will be placed in decode/hazard unit in final submission)
    // always_ff @(posedge clk ) begin
	always_comb begin
		$display($time," Decode: pc %d pc_wb %d stall %d  ins1 %b ins2 %b  ",pc ,pc_wb, stall, instr[0], instr[1]);
		if(reset == 1 ) begin
			// pc_wb = 0;
			// op.instr_even = 32'h0000;
			// op.instr_odd =32'h0000;
			instr_odd_issue = 32'h0000;
			instr_even_issue = 32'h0000;
			stall = 0;
			stall_pc = 0;
			op = check(instr_even_issue, instr_odd_issue);
		end

		else begin
			$display($time," instr[0] %b instr[1] %b stall %d ",instr[0],instr[1], stall );
			if(instr[0]!=32'h0000 && instr[1]!=32'h0000 && stall ==0) begin
				// instr_even = instr[0];
				// instr_odd = instr[1];s
				op = check(instr[0],instr[1]);
				// both instruction is valid
				$display($time," Decode: op_even %b op_odd %b ",op.op_even, op.op_odd);
				// $display($time," Decode: op_even %b op_odd %b ",check(instr[0],instr[1]).op_even, check(instr[0],instr[1]).op_odd);
				if(op.op_even==0 && op.op_odd!=0) begin
					// both instruction are odd pipe,
					// first instruction should be execute
					// op.instr_odd = instr[0];
					// op.instr_even = instr[1];
					// check(instr_even,instr_odd);s
				
					// instr_even = 32'h0000;
					// instr_odd = instr[1];
					$display($time," Decode: Both are odd pipe");
					op = check(32'h0000,instr[0]);
					instr_even_issue = 32'h0000;
					instr_odd_issue = instr[1];


					$display($time," Decode: no-op odd instruction needs update pc %d ", pc);
					
					stall_pc = pc;  // in this case we should increement pc with only one
					stall = 1;
					
				end
				else if(op.op_even!=0 && op.op_odd==0) begin
					// Both instruction are even pipe
					stall = 1;
					stall_pc = pc; // in this case we should increement pc with only one
					// instr_even = instr[1];
					// instr_odd = 32'h0000;
					op = check(instr[0],32'h0000);
					instr_even_issue = instr[1];
					instr_odd_issue = 32'h0000;

					stall_pc = pc;
					$display($time," Decode: Both instruction are even pipe %d ",pc);
				end
				else if(op.op_even==0 && op.op_odd==0) begin
					op = check(32'h0000,instr[0]);
					instr_even_issue = instr[1];
					instr_odd_issue = 32'h0000;
					stall_pc = pc ;
					stall = 1;
					$display($time, "Decode: Instruction are not aligned to even and odd pipe");

					$display($time,"Decode: op_even %b op_odd %b ", op.op_even, op.op_odd);
				end		
				else begin
					stall_pc = 0;
					stall = 0;
					$display($time," Decode : all good  PC %d op_even %b op_odd %b ",pc, op.op_even, op.op_odd);
				end
			end
			else begin 				
				if( stall==1) begin
					op = check(instr_even_issue, instr_odd_issue);
					$display($time," Decode : all good with stall  PC %d op_even %b op_odd %b ",pc, op.op_even, op.op_odd);
					// pc_wb = stall_pc;
				end
				else begin
					// end of code
					op = check(instr[0],instr[1]);
					$display($time," Decode: End of code");
				end
				stall =0;
			end		

		end
		$display($time," Decode: pc %d  pc_wb %d stall %d stall_pc %d ",pc, pc_wb, stall, stall_pc );
				
    end


	function op_codes check (input logic[0:31] even,input logic[0:31] odd);

		if(reset==1) begin
			check.op_even=0;
			check.op_odd=0;
		end
		$display($time," even %b %b odd %b %bs",even, even[0:10], odd, odd[0:10]);
															//Even decoding
		check.reg_write_even = 1;
		check.rt_addr_even = even[25:31];
		check.instr_even = even;
		check.instr_odd = odd;
		if (even == 0) begin							//alternate nop
			check.format_even = 0;
			check.op_even = 0;
			check.unit_even = 0;
			check.rt_addr_even = 0;
			check.imm_even = 0;
		end													//RRR-type
		else if	(even[0:3] == 4'b1100) begin			//mpya
			check.format_even = 1;
			check.op_even = 4'b1100;
			check.unit_even = 0;
			check.rt_addr_even = even[4:10];
		end
		else if (even[0:3] == 4'b1110) begin			//fma
			check.format_even = 1;
			check.op_even = 4'b1110;
			check.unit_even = 0;
			check.rt_addr_even = even[4:10];
		end
		else if (even[0:3] == 4'b1111) begin			//fms
			check.format_even = 1;
			check.op_even = 4'b1111;
			check.unit_even = 0;
			check.rt_addr_even = even[4:10];
		end													//RI18-type
		else if (even[0:6] == 7'b0100001) begin		//ila
			check.format_even = 6;
			check.op_even = 7'b0100001;
			check.unit_even = 3;
			check.imm_even = $signed(even[7:24]);
		end													//RI8-type
		else if (even[0:9] == 10'b0111011000) begin	//cflts
			check.format_even = 3;
			check.op_even = 10'b0111011000;
			check.unit_even = 0;
			check.imm_even = $signed(even[10:17]);
		end
		else if (even[0:9] == 10'b0111011001) begin	//cfltu
			check.format_even = 3;
			check.op_even = 10'b0111011001;
			check.unit_even = 0;
			check.imm_even = $signed(even[10:17]);
		end													//RI16-type
		else if (even[0:8] == 9'b010000011) begin		//ilh
			check.format_even = 5;
			check.op_even = 9'b010000011;
			check.unit_even = 3;
			check.imm_even = $signed(even[9:24]);
		end
		else if (even[0:8] == 9'b010000010) begin		//ilhu
			check.format_even = 5;
			check.op_even = 9'b010000010;
			check.unit_even = 3;
			check.imm_even = $signed(even[9:24]);
		end
		else if (even[0:8] == 9'b011000001) begin		//iohl
			check.format_even = 5;
			check.op_even = 9'b011000001;
			check.unit_even = 3;
			check.imm_even = $signed(even[9:24]);
		end
		else begin
			check.format_even = 4;				//RI10-type
			check.imm_even = $signed(even[8:17]);
			case(even[0:7])
				8'b01110100 : begin			//mpyi
					check.op_even = 8'b01110100;
					check.unit_even = 0;
				end
				8'b01110101 : begin			//mpyui
					check.op_even = 8'b01110101;
					check.unit_even = 0;
				end
				8'b00011101 : begin			//ahi
					check.op_even = 8'b00011101;
					check.unit_even = 3;
				end
				8'b00011100 : begin			//ai
					check.op_even = 8'b00011100;
					check.unit_even = 3;
				end
				8'b00001101 : begin			//sfhi
					check.op_even = 8'b00001101;
					check.unit_even = 3;
				end
				8'b00001100 : begin			//sfi
					check.op_even = 8'b00001100;
					check.unit_even = 3;
				end
				8'b00010110 : begin			//andbi
					check.op_even = 8'b00010110;
					check.unit_even = 3;
				end
				8'b00010101 : begin			//andhi
					check.op_even = 8'b00010101;
					check.unit_even = 3;
				end
				8'b00010100 : begin			//andi
					check.op_even = 8'b00010100;
					check.unit_even = 3;
				end
				8'b00000110 : begin			//orbi
					check.op_even = 8'b00000110;
					check.unit_even = 3;
				end
				8'b00000101 : begin			//orhi
					check.op_even = 8'b00000101;
					check.unit_even = 3;
				end
				8'b00000100 : begin			//ori
					check.op_even = 8'b00000100;
					check.unit_even = 3;
				end
				8'b01000110 : begin			//xorbi
					check.op_even = 8'b01000110;
					check.unit_even = 3;
				end
				8'b01000101 : begin			//xorhi
					check.op_even = 8'b01000101;
					check.unit_even = 3;
				end
				8'b01000100 : begin			//xori
					check.op_even = 8'b01000100;
					check.unit_even = 3;
				end
				8'b01111110 : begin			//ceqbi
					check.op_even = 8'b01111110;
					check.unit_even = 3;
				end
				8'b01111101 : begin			//ceqhi
					check.op_even = 8'b01111101;
					check.unit_even = 3;
				end
				8'b01111100 : begin			//ceqi
					check.op_even = 8'b01111100;
					check.unit_even = 3;
				end
				8'b01001110 : begin			//cgtbi
					check.op_even = 8'b01001110;
					check.unit_even = 3;
				end
				8'b01001101 : begin			//cgthi
					check.op_even = 8'b01001101;
					check.unit_even = 3;
				end
				8'b01001100 : begin			//cgti
					check.op_even = 8'b01001100;
					check.unit_even = 3;
				end
				8'b01011110 : begin			//clgtbi
					check.op_even = 8'b01011110;
					check.unit_even = 3;
				end
				8'b01011101 : begin			//clgthi
					check.op_even = 8'b01011101;
					check.unit_even = 3;
				end
				8'b01011100 : begin			//clgti
					check.op_even = 8'b01011100;
					check.unit_even = 3;
				end
				default : check.format_even = 7;
			endcase
			if (check.format_even == 7) begin
				check.format_even = 0;					//RR-type
				case(even[0:10])
					11'b01111000100 : begin			//mpy
						check.op_even = 11'b01111000100;
						check.unit_even = 0;
					end
					11'b01111001100 : begin			//mpyu
						check.op_even = 11'b01111001100;
						check.unit_even = 0;
					end
					11'b01111000101 : begin			//mpyh
						check.op_even = 11'b01111000101;
						check.unit_even = 0;
					end
					11'b01011000100 : begin			//fa
						check.op_even = 11'b01011000100;
						check.unit_even = 0;
					end
					11'b01011000101 : begin			//fs
						check.op_even = 11'b01011000101;
						check.unit_even = 0;
					end
					11'b01011000110 : begin			//fm
						check.op_even = 11'b01011000110;
						check.unit_even = 0;
					end
					11'b01111000010 : begin			//fceq
						check.op_even = 11'b01111000010;
						check.unit_even = 0;
					end
					11'b01011000010 : begin			//fcgt
						check.op_even = 11'b01011000010;
						check.unit_even = 0;
					end
					11'b00001011111 : begin			//shlh
						check.op_even = 11'b00001011111;
						check.unit_even = 1;
					end
					11'b00001011011 : begin			//shl
						check.op_even = 11'b00001011011;
						check.unit_even = 1;
					end
					11'b00001011100 : begin			//roth
						check.op_even = 11'b00001011100;
						check.unit_even = 1;
					end
					11'b00001011000 : begin			//rot
						check.op_even = 11'b00001011000;
						check.unit_even = 1;
					end
					11'b00001011101 : begin			//rothm
						check.op_even = 11'b00001011101;
						check.unit_even = 1;
					end
					11'b00001011001 : begin			//rotm
						check.op_even = 11'b00001011001;
						check.unit_even = 1;
					end
					11'b00001011110 : begin			//rotmah
						check.op_even = 11'b00001011110;
						check.unit_even = 1;
					end
					11'b00001011010 : begin			//rotma
						check.op_even = 11'b00001011010;
						check.unit_even = 1;
					end
					11'b01010110100 : begin			//cntb
						check.op_even = 11'b01010110100;
						check.unit_even = 2;
					end
					11'b00011010011 : begin			//avgb
						check.op_even = 11'b00011010011;
						check.unit_even = 2;
					end
					11'b00001010011 : begin			//absdb
						check.op_even = 11'b00001010011;
						check.unit_even = 2;
					end
					11'b01001010011 : begin			//sumb
						$display("found  sumb");
						check.op_even = 11'b01001010011;
						check.unit_even = 2;
					end
					11'b00011001000 : begin			//ah
						check.op_even = 11'b00011001000;
						check.unit_even = 3;
					end
					11'b00011000000 : begin			//a
						check.op_even = 11'b00011000000;
						check.unit_even = 3;
					end
					11'b00001001000 : begin			//sfh
						check.op_even = 11'b00001001000;
						check.unit_even = 3;
					end
					11'b00001000000 : begin			//sf
						check.op_even = 11'b00001000000;
						check.unit_even = 3;
					end
					11'b00011000001 : begin			//and
						check.op_even = 11'b00011000001;
						check.unit_even = 3;
					end
					11'b00001000001 : begin			//or
						check.op_even = 11'b00001000001;
						check.unit_even = 3;
					end
					11'b01001000001 : begin			//xor
						check.op_even = 11'b01001000001;
						check.unit_even = 3;
					end
					11'b00011001001 : begin			//nand
						check.op_even = 11'b00011001001;
						check.unit_even = 3;
					end
					11'b01111010000 : begin			//ceqb
						check.op_even = 11'b01111010000;
						check.unit_even = 3;
					end
					11'b01111001000 : begin			//ceqh
						check.op_even = 11'b01111001000;
						check.unit_even = 3;
					end
					11'b01111000000 : begin			//ceq
						check.op_even = 11'b01111000000;
						check.unit_even = 3;
					end
					11'b01001010000 : begin			//cgtb
						check.op_even = 11'b01001010000;
						check.unit_even = 3;
					end
					11'b01001001000 : begin			//cgth
						check.op_even = 11'b01001001000;
						check.unit_even = 3;
					end
					11'b01001000000 : begin			//cgt
						check.op_even = 11'b01001000000;
						check.unit_even = 3;
					end
					11'b01011010000 : begin			//clgtb
						check.op_even = 11'b01011010000;
						check.unit_even = 3;
					end
					11'b01011001000 : begin			//clgth
						check.op_even = 11'b01011001000;
						check.unit_even = 3;
					end
					11'b01011000000 : begin			//clgt
						check.op_even = 11'b01011000000;
						check.unit_even = 3;
					end
					11'b01000000001 : begin			//nop
						check.op_even = 11'b01000000001;
						check.unit_even = 0;
						check.reg_write_even = 0;
					end
					default : check.format_even = 7;
				endcase
				if (check.format_even == 7) begin
					check.format_even = 2;					//RI7-type
					check.imm_even = $signed(even[11:17]);
					case(even[0:10])
						11'b00001111011 : begin			//shli
							check.op_even = 11'b00001111011;
							check.unit_even = 1;
						end
						11'b00001111100 : begin			//rothi
							check.op_even = 11'b00001111100;
							check.unit_even = 1;
						end
						11'b00001111000 : begin			//roti
							check.op_even = 11'b00001111000;
							check.unit_even = 1;
						end
						11'b00001111110 : begin			//rotmahi
							check.op_even = 11'b00001111110;
							check.unit_even = 1;
						end
						11'b00001111010 : begin			//rotmai
							check.op_even = 11'b00001111010;
							check.unit_even = 1;
						end
						default begin
							check.format_even = 0;
							check.op_even = 0;
							check.unit_even = 0;
							check.rt_addr_even = 0;
							check.imm_even = 0;
						end
					endcase
				end
			end
		end

															//odd decoding
		check.rt_addr_odd = odd[25:31];
		check.reg_write_odd = 1;
		if (odd == 0) begin							//alternate lnop
			check.format_odd = 0;
			check.op_odd = 0;
			check.unit_odd = 0;
			check.rt_addr_odd = 0;
			check.imm_odd = 0;
		end													//RI10-type
		else if (odd[0:7] == 8'b00110100) begin		//lqd
			check.format_odd = 4;
			check.op_odd = 8'b00110100;
			check.unit_odd = 1;
			check.imm_odd = $signed(odd[8:17]);
		end
		else if (odd[0:7] == 8'b00110100) begin		//stqd
			check.format_odd = 4;
			check.op_odd = 8'b00110100;
			check.unit_odd = 1;
			check.imm_odd = $signed(odd[8:17]);
			check.reg_write_odd = 0;
		end
		else begin
			check.format_odd = 5;					//RI16-type
			check.imm_odd = $signed(odd[9:24]);
			case(odd[0:8])
				9'b001100001 : begin		//lqa
					check.op_odd = 9'b001100001;
					check.unit_odd = 1;
				end
				9'b001000001 : begin		//stqa
					check.op_odd = 9'b001000001;
					check.unit_odd = 1;
					check.reg_write_odd = 0;
				end
				9'b001100100 : begin		//br
					check.op_odd = 9'b001100100;
					check.unit_odd = 2;
					check.reg_write_odd = 0;
				end
				9'b001100000 : begin		//bra
					check.op_odd = 9'b001100000;
					check.unit_odd = 2;
					check.reg_write_odd = 0;
				end
				9'b001100110 : begin		//brsl
					check.op_odd = 9'b001100110;
					check.unit_odd = 2;
				end
				9'b001000010 : begin		//brnz
					check.op_odd = 9'b001000010;
					check.unit_odd = 2;
					check.reg_write_odd = 0;
				end
				9'b001000000 : begin		//brz
					check.op_odd = 9'b001000000;
					check.unit_odd = 2;
					check.reg_write_odd = 0;
				end
				default : check.format_odd = 7;
			endcase
			if (check.format_odd == 7) begin
				check.format_odd = 0;					//RR-type
				$display("check: odd[0:10] %b ",odd[0:10]);
				case(odd[0:10])
					11'b00111011011 : begin		//shlqbi
						$display("shlqbi ");
						check.op_odd = 11'b00111011011;
						check.unit_odd = 0;
					end
					11'b00111011111 : begin		//shlqby
						check.op_odd = 11'b00111011111;
						check.unit_odd = 0;
					end
					11'b00111011000 : begin		//rotqbi
						check.op_odd = 11'b00111011000;
						check.unit_odd = 0;
					end
					11'b00111011100 : begin		//rotqby
						check.op_odd = 11'b00111011100;
						check.unit_odd = 0;
					end
					11'b00110110010 : begin		//gbb
						check.op_odd = 11'b00110110010;
						check.unit_odd = 0;
					end
					11'b00110110001 : begin		//gbh
						check.op_odd = 11'b00110110001;
						check.unit_odd = 0;
					end
					11'b00110110000 : begin		//gb
						check.op_odd = 11'b00110110000;
						check.unit_odd = 0;
					end
					11'b00111000100 : begin		//lqx
						check.op_odd = 11'b00111000100;
						check.unit_odd = 1;
					end
					11'b00101000100 : begin		//stqx
						check.op_odd = 11'b00101000100;
						check.unit_odd = 1;
						check.reg_write_odd = 0;
					end
					11'b00110101000 : begin		//bi
						check.op_odd = 11'b00110101000;
						check.unit_odd = 2;
						check.reg_write_odd = 0;
					end
					11'b00000000001 : begin		//lnop
						check.op_odd = 11'b00000000001;
						check.unit_odd = 0;
						check.reg_write_odd = 0;
					end
					default : check.format_odd = 7;
				endcase
				if (check.format_odd == 7) begin
					check.format_odd = 2;					//RI7-type
					check.imm_odd = $signed(odd[11:17]);
					case(odd[0:10])
						11'b00111111011 : begin		//shlqbii
							check.op_odd = 11'b00111111011;
							check.unit_odd = 0;
						end
						11'b00111111111 : begin		//shlqbyi
							check.op_odd = 11'b00111111111;
							check.unit_odd = 0;
						end
						11'b00111111000 : begin		//rotqbii
							check.op_odd = 11'b00111111000;
							check.unit_odd = 0;
						end
						11'b00111111100 : begin		//rotqbyi
							check.op_odd = 11'b00111111100;
							check.unit_odd = 0;
						end
						default begin
							check.format_odd = 0;
							check.op_odd = 0;
							check.unit_odd = 0;
							check.rt_addr_odd = 0;
							check.imm_odd = 0;
						end
					endcase
				end
			end
		end
	
	
		$display("check : op_even %h op_odd %h ", check.op_even, check.op_odd);
		
	endfunction


    /*
	always_comb begin
															//Even decoding
		reg_write_even = 1;
		rt_addr_even = instr[25:31];
		if (instr[0:31] == 32'h0000) begin							//alternate nop
			format_even = 0;
			check.op_even = 0;
			unit_even = 0;
			rt_addr_even = 0;
			imm_even = 0;
		end													//RRR-type
		else if	(instr[0:3] == 4'b1100) begin			//mpya
			format_even = 1;
			check.op_even = 4'b1100;
			unit_even = 0;
			rt_addr_even = instr[4:10];
		end
		else if (instr[0:3] == 4'b1110) begin			//fma
			format_even = 1;
			check.op_even = 4'b1110;
			unit_even = 0;
			rt_addr_even = instr[4:10];
		end
		else if (instr[0:3] == 4'b1111) begin			//fms
			format_even = 1;
			check.op_even = 4'b1111;
			unit_even = 0;
			rt_addr_even = instr[4:10];
		end													//RI18-type
		else if (instr[0:6] == 7'b0100001) begin		//ila
			format_even = 6;
			check.op_even = 7'b0100001;
			unit_even = 3;
			imm_even = $signed(instr[7:24]);
		end													//RI8-type
		else if (instr[0:9] == 10'b0111011000) begin	//cflts
			format_even = 3;
			check.op_even = 10'b0111011000;
			unit_even = 0;
			imm_even = $signed(instr[10:17]);
		end
		else if (instr[0:9] == 10'b0111011001) begin	//cfltu
			format_even = 3;
			check.op_even = 10'b0111011001;
			unit_even = 0;
			imm_even = $signed(instr[10:17]);
		end													//RI16-type
		else if (instr[0:8] == 9'b010000011) begin		//ilh
			format_even = 5;
			check.op_even = 9'b010000011;
			unit_even = 3;
			imm_even = $signed(instr[9:24]);
		end
		else if (instr[0:8] == 9'b010000010) begin		//ilhu
			format_even = 5;
			check.op_even = 9'b010000010;
			unit_even = 3;
			imm_even = $signed(instr[9:24]);
		end
		else if (instr[0:8] == 9'b011000001) begin		//iohl
			format_even = 5;
			check.op_even = 9'b011000001;
			unit_even = 3;
			imm_even = $signed(instr[9:24]);
		end
		else begin
			format_even = 4;				//RI10-type
			imm_even = $signed(instr[8:17]);
			case(instr[0:7])
				8'b01110100 : begin			//mpyi
					check.op_even = 8'b01110100;
					unit_even = 0;
				end
				8'b01110101 : begin			//mpyui
					check.op_even = 8'b01110101;
					unit_even = 0;
				end
				8'b00011101 : begin			//ahi
					check.op_even = 8'b00011101;
					unit_even = 3;
				end
				8'b00011100 : begin			//ai
					check.op_even = 8'b00011100;
					unit_even = 3;
				end
				8'b00001101 : begin			//sfhi
					check.op_even = 8'b00001101;
					unit_even = 3;
				end
				8'b00001100 : begin			//sfi
					check.op_even = 8'b00001100;
					unit_even = 3;
				end
				8'b00010110 : begin			//andbi
					check.op_even = 8'b00010110;
					unit_even = 3;
				end
				8'b00010101 : begin			//andhi
					check.op_even = 8'b00010101;
					unit_even = 3;
				end
				8'b00010100 : begin			//andi
					check.op_even = 8'b00010100;
					unit_even = 3;
				end
				8'b00000110 : begin			//orbi
					check.op_even = 8'b00000110;
					unit_even = 3;
				end
				8'b00000101 : begin			//orhi
					check.op_even = 8'b00000101;
					unit_even = 3;
				end
				8'b00000100 : begin			//ori
					check.op_even = 8'b00000100;
					unit_even = 3;
				end
				8'b01000110 : begin			//xorbi
					check.op_even = 8'b01000110;
					unit_even = 3;
				end
				8'b01000101 : begin			//xorhi
					check.op_even = 8'b01000101;
					unit_even = 3;
				end
				8'b01000100 : begin			//xori
					check.op_even = 8'b01000100;
					unit_even = 3;
				end
				8'b01111110 : begin			//ceqbi
					check.op_even = 8'b01111110;
					unit_even = 3;
				end
				8'b01111101 : begin			//ceqhi
					check.op_even = 8'b01111101;
					unit_even = 3;
				end
				8'b01111100 : begin			//ceqi
					check.op_even = 8'b01111100;
					unit_even = 3;
				end
				8'b01001110 : begin			//cgtbi
					check.op_even = 8'b01001110;
					unit_even = 3;
				end
				8'b01001101 : begin			//cgthi
					check.op_even = 8'b01001101;
					unit_even = 3;
				end
				8'b01001100 : begin			//cgti
					check.op_even = 8'b01001100;
					unit_even = 3;
				end
				8'b01011110 : begin			//clgtbi
					check.op_even = 8'b01011110;
					unit_even = 3;
				end
				8'b01011101 : begin			//clgthi
					check.op_even = 8'b01011101;
					unit_even = 3;
				end
				8'b01011100 : begin			//clgti
					check.op_even = 8'b01011100;
					unit_even = 3;
				end
				default : format_even = 7;
			endcase
			if (format_even == 7) begin
				format_even = 0;					//RR-type
				case(instr[0:10])
					11'b01111000100 : begin			//mpy
						check.op_even = 11'b01111000100;
						unit_even = 0;
					end
					11'b01111001100 : begin			//mpyu
						check.op_even = 11'b01111001100;
						unit_even = 0;
					end
					11'b01111000101 : begin			//mpyh
						check.op_even = 11'b01111000101;
						unit_even = 0;
					end
					11'b01011000100 : begin			//fa
						check.op_even = 11'b01011000100;
						unit_even = 0;
					end
					11'b01011000101 : begin			//fs
						check.op_even = 11'b01011000101;
						unit_even = 0;
					end
					11'b01011000110 : begin			//fm
						check.op_even = 11'b01011000110;
						unit_even = 0;
					end
					11'b01111000010 : begin			//fceq
						check.op_even = 11'b01111000010;
						unit_even = 0;
					end
					11'b01011000010 : begin			//fcgt
						check.op_even = 11'b01011000010;
						unit_even = 0;
					end
					11'b00001011111 : begin			//shlh
						check.op_even = 11'b00001011111;
						unit_even = 1;
					end
					11'b00001011011 : begin			//shl
						check.op_even = 11'b00001011011;
						unit_even = 1;
					end
					11'b00001011100 : begin			//roth
						check.op_even = 11'b00001011100;
						unit_even = 1;
					end
					11'b00001011000 : begin			//rot
						check.op_even = 11'b00001011000;
						unit_even = 1;
					end
					11'b00001011101 : begin			//rothm
						check.op_even = 11'b00001011101;
						unit_even = 1;
					end
					11'b00001011001 : begin			//rotm
						check.op_even = 11'b00001011001;
						unit_even = 1;
					end
					11'b00001011110 : begin			//rotmah
						check.op_even = 11'b00001011110;
						unit_even = 1;
					end
					11'b00001011010 : begin			//rotma
						check.op_even = 11'b00001011010;
						unit_even = 1;
					end
					11'b01010110100 : begin			//cntb
						check.op_even = 11'b01010110100;
						unit_even = 2;
					end
					11'b00011010011 : begin			//avgb
						check.op_even = 11'b00011010011;
						unit_even = 2;
					end
					11'b00001010011 : begin			//absdb
						check.op_even = 11'b00001010011;
						unit_even = 2;
					end
					11'b01001010011 : begin			//sumb
						check.op_even = 11'b01001010011;
						unit_even = 2;
					end
					11'b00011001000 : begin			//ah
						check.op_even = 11'b00011001000;
						unit_even = 3;
					end
					11'b00011000000 : begin			//a
						check.op_even = 11'b00011000000;
						unit_even = 3;
					end
					11'b00001001000 : begin			//sfh
						check.op_even = 11'b00001001000;
						unit_even = 3;
					end
					11'b00001000000 : begin			//sf
						check.op_even = 11'b00001000000;
						unit_even = 3;
					end
					11'b00011000001 : begin			//and
						check.op_even = 11'b00011000001;
						unit_even = 3;
					end
					11'b00001000001 : begin			//or
						check.op_even = 11'b00001000001;
						unit_even = 3;
					end
					11'b01001000001 : begin			//xor
						check.op_even = 11'b01001000001;
						unit_even = 3;
					end
					11'b00011001001 : begin			//nand
						check.op_even = 11'b00011001001;
						unit_even = 3;
					end
					11'b01111010000 : begin			//ceqb
						check.op_even = 11'b01111010000;
						unit_even = 3;
					end
					11'b01111001000 : begin			//ceqh
						check.op_even = 11'b01111001000;
						unit_even = 3;
					end
					11'b01111000000 : begin			//ceq
						check.op_even = 11'b01111000000;
						unit_even = 3;
					end
					11'b01001010000 : begin			//cgtb
						check.op_even = 11'b01001010000;
						unit_even = 3;
					end
					11'b01001001000 : begin			//cgth
						check.op_even = 11'b01001001000;
						unit_even = 3;
					end
					11'b01001000000 : begin			//cgt
						check.op_even = 11'b01001000000;
						unit_even = 3;
					end
					11'b01011010000 : begin			//clgtb
						check.op_even = 11'b01011010000;
						unit_even = 3;
					end
					11'b01011001000 : begin			//clgth
						check.op_even = 11'b01011001000;
						unit_even = 3;
					end
					11'b01011000000 : begin			//clgt
						check.op_even = 11'b01011000000;
						unit_even = 3;
					end
					11'b01000000001 : begin			//nop
						check.op_even = 11'b01000000001;
						unit_even = 0;
						reg_write_even = 0;
					end
					default : format_even = 7;
				endcase
				if (format_even == 7) begin
					format_even = 2;					//RI7-type
					imm_even = $signed(instr[11:17]);
					case(instr[0:10])
						11'b00001111011 : begin			//shli
							check.op_even = 11'b00001111011;
							unit_even = 1;
						end
						11'b00001111100 : begin			//rothi
							check.op_even = 11'b00001111100;
							unit_even = 1;
						end
						11'b00001111000 : begin			//roti
							check.op_even = 11'b00001111000;
							unit_even = 1;
						end
						11'b00001111110 : begin			//rotmahi
							check.op_even = 11'b00001111110;
							unit_even = 1;
						end
						11'b00001111010 : begin			//rotmai
							check.op_even = 11'b00001111010;
							unit_even = 1;
						end
						default begin
							format_even = 0;
							check.op_even = 0;
							unit_even = 0;
							rt_addr_even = 0;
							imm_even = 0;
						end
					endcase
				end
			end
		end

															//odd decoding
		rt_addr_odd = instr[57:63];
		reg_write_odd = 1;
		if (instr[32:63] == 32'h0000) begin							//alternate lnop
			format_odd = 0;
			check.op_odd = 0;
			unit_odd = 0;
			rt_addr_odd = 0;
			imm_odd = 0;
		end													//RI10-type
		else if (instr[32:39] == 8'b00110100) begin		//lqd
			format_odd = 4;
			check.op_odd = 8'b00110100;
			unit_odd = 1;
			imm_odd = $signed(instr[40:49]);
		end
		else if (instr[32:39] == 8'b00110100) begin		//stqd
			format_odd = 4;
			check.op_odd = 8'b00110100;
			unit_odd = 1;
			imm_odd = $signed(instr[40:49]);
			reg_write_odd = 0;
		end
		else begin
			format_odd = 5;					//RI16-type
			imm_odd = $signed(instr[41:56]);
			case(instr[32:40])
				9'b001100001 : begin		//lqa
					check.op_odd = 9'b001100001;
					unit_odd = 1;
				end
				9'b001000001 : begin		//stqa
					check.op_odd = 9'b001000001;
					unit_odd = 1;
					reg_write_odd = 0;
				end
				9'b001100100 : begin		//br
					check.op_odd = 9'b001100100;
					unit_odd = 2;
					reg_write_odd = 0;
				end
				9'b001100000 : begin		//bra
					check.op_odd = 9'b001100000;
					unit_odd = 2;
					reg_write_odd = 0;
				end
				9'b001100110 : begin		//brsl
					check.op_odd = 9'b001100110;
					unit_odd = 2;
				end
				9'b001000010 : begin		//brnz
					check.op_odd = 9'b001000010;
					unit_odd = 2;
					reg_write_odd = 0;
				end
				9'b001000000 : begin		//brz
					check.op_odd = 9'b001000000;
					unit_odd = 2;
					reg_write_odd = 0;
				end
				default : format_odd = 7;
			endcase
			if (format_odd == 7) begin
				format_odd = 0;					//RR-type
				case(instr[32:42])
					11'b00111011011 : begin		//shlqbi
						check.op_odd = 11'b00111011011;
						unit_odd = 0;
					end
					11'b00111011111 : begin		//shlqby
						check.op_odd = 11'b00111011111;
						unit_odd = 0;
					end
					11'b00111011000 : begin		//rotqbi
						check.op_odd = 11'b00111011000;
						unit_odd = 0;
					end
					11'b00111011100 : begin		//rotqby
						check.op_odd = 11'b00111011100;
						unit_odd = 0;
					end
					11'b00110110010 : begin		//gbb
						check.op_odd = 11'b00110110010;
						unit_odd = 0;
					end
					11'b00110110001 : begin		//gbh
						check.op_odd = 11'b00110110001;
						unit_odd = 0;
					end
					11'b00110110000 : begin		//gb
						check.op_odd = 11'b00110110000;
						unit_odd = 0;
					end
					11'b00111000100 : begin		//lqx
						check.op_odd = 11'b00111000100;
						unit_odd = 1;
					end
					11'b00101000100 : begin		//stqx
						check.op_odd = 11'b00101000100;
						unit_odd = 1;
						reg_write_odd = 0;
					end
					11'b00110101000 : begin		//bi
						check.op_odd = 11'b00110101000;
						unit_odd = 2;
						reg_write_odd = 0;
					end
					11'b00000000001 : begin		//lnop
						check.op_odd = 11'b00000000001;
						unit_odd = 0;
						reg_write_odd = 0;
					end
					default : format_odd = 7;
				endcase
				if (format_odd == 7) begin
					format_odd = 2;					//RI7-type
					imm_odd = $signed(instr[43:49]);
					case(instr[32:42])
						11'b00111111011 : begin		//shlqbii
							check.op_odd = 11'b00111111011;
							unit_odd = 0;
						end
						11'b00111111111 : begin		//shlqbyi
							check.op_odd = 11'b00111111111;
							unit_odd = 0;
						end
						11'b00111111000 : begin		//rotqbii
							check.op_odd = 11'b00111111000;
							unit_odd = 0;
						end
						11'b00111111100 : begin		//rotqbyi
							check.op_odd = 11'b00111111100;
							unit_odd = 0;
						end
						default begin
							format_odd = 0;
							check.op_odd = 0;
							unit_odd = 0;
							rt_addr_odd = 0;
							imm_odd = 0;
						end
					endcase
				end
			end
		end

	end
    */

endmodule