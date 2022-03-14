module RegisterTable(clk, reset, instr_even, instr_odd, format_even, format_odd, ra_even, rb_even, rc_even, ra_odd, rb_odd,
		rt_addr_even, rt_addr_odd, rt_even, rt_odd, reg_write_even, reg_write_odd);
	input logic					clk, reset;
	input logic[0:31]			instr_even, instr_odd;			//Instructions to read from decoder
	input logic[2:0]				format_even, format_odd;		//Instruction formats to read, decoded
	output logic[0:127]	ra_even, rb_even, rc_even, ra_odd, rb_odd;	//Set all possible register values regardless of format

	input logic[0:6]				rt_addr_even, rt_addr_odd;		//Destination registers to write to
	input logic[0:127]			rt_even, rt_odd;				//Values to write to destination registers
	input logic					reg_write_even, reg_write_odd;	//1 if instr will write to rt, else 0

	logic [0:127] registers [0:127];						//RegFile
	logic [7:0] 			i;								//8-bit counter for reset loop

	always_comb begin
		//All source register addresses are in the same location in all instr, so read no matter what
		rc_even = registers[instr_even[25:31]];
		ra_even = registers[instr_even[18:24]];
		rb_even = registers[instr_even[11:17]];

		ra_odd = registers[instr_odd[18:24]];
		rb_odd = registers[instr_odd[11:17]];

		// $display("rt_even = %h ",rt_even);
		//Forwarding in case of WAR hazard
		if (reg_write_even == 1) begin
			if (instr_even[25:31] == rt_addr_even)
				rc_even = rt_even;
			else if (instr_even[18:24] == rt_addr_even)
				ra_even = rt_even;
			else if (instr_even[11:17] == rt_addr_even)
				rb_even = rt_even;
			else if (instr_odd[18:24] == rt_addr_even)
				ra_odd = rt_even;
			else if (instr_odd[11:17] == rt_addr_even)
				rb_odd = rt_even;
		end

		if (reg_write_odd == 1) begin
			if (instr_even[25:31] == rt_addr_odd)
				rc_even = rt_odd;
			else if (instr_even[18:24] == rt_addr_odd)
				ra_even = rt_odd;
			else if (instr_even[11:17] == rt_addr_odd)
				rb_even = rt_odd;
			else if (instr_odd[18:24] == rt_addr_odd)
				ra_odd = rt_odd;
			else if (instr_odd[11:17] == rt_addr_odd)
				rb_odd = rt_odd;
		end
	end

	always_ff @(posedge clk) begin
		if(reset == 1)begin
			registers[127] = 0;
			for (i=0; i<127; i=i+1) begin
				registers[i] <= 0;
			end
		end
		else begin
			if (reg_write_even == 1)
				registers[rt_addr_even] <= rt_even;
			if (reg_write_odd == 1)
				registers[rt_addr_odd] <= rt_odd;
		end
		// $display("val: rc_even = %h rt_even = %h addr : rc_even = %h ra_even = %h rb_even = %h ",rc_even,rt_even,instr_even[25:31],ra_even,rb_even);
	end

endmodule