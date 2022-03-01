module RegisterTable(clk, reset);
	input					clk, reset;
	input [0:31]			instr_even, instr_odd;		//Instructions from decoder
	input [2:0]				format_even, format_odd;	//Instruction formats, decoded
	output logic [127:0]	rt_even, ra_even, rb_even, rc_even, rt_odd, ra_odd, rb_odd, rc_odd;	//Set all possible register values anyway
	reg [127:0] registers [0:127];						//RegFile
	logic[7:0] 				i;							//8-bit counter for reset loop
	
	always_comb begin
		rc_even = 128'b0;								//Default value of 0
		ra_even = 128'b0;
		rb_even = 128'b0;
		rt_even = 128'b0;
		case (format_even)
			3'b000 : begin								//RR-type instr
				rt_even = registers[instr_even[25:31]];
				ra_even = registers[instr_even[18:24]];
				rb_even = registers[instr_even[11:17]];
			end
			3'b001 : begin								//RRR-type instr
				rc_even = registers[instr_even[25:31]];
				ra_even = registers[instr_even[18:24]];
				rb_even = registers[instr_even[11:17]];
				rt_even = registers[instr_even[4:10]];
			end
			3'b010 : begin								//RI7-type instr
				rt_even = registers[instr_even[25:31]];
				ra_even = registers[instr_even[18:24]];
			end
			3'b011 : begin								//RI10-type instr
				rt_even = registers[instr_even[25:31]];
				ra_even = registers[instr_even[18:24]];
			end
			default : begin								//RI16/RI18-type instr
				rt_even = registers[instr_even[25:31]];
			end
		endcase
	end
	
	always_ff @(posedge clk) begin			//Sychronous reset
		if(reset == 1)begin
			registers[127] = 0;
			for (i=0; i<127; i=i+1) begin
				registers[i] <= 0;
			end
		end
	end
	
endmodule