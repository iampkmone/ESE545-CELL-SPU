module SinglePrecision(clk, reset, op, format, rt_addr, ra, rb, rc, imm, reg_write, rt_wb, rt_addr_wb, reg_write_wb, rt_int, rt_addr_int, reg_write_int);
	input			clk, reset;
	
	//RF/FWD Stage
	input [0:10]	op;				//Decoded opcode, truncated based on format
	input [2:0]		format;			//Format of instr, used with op and imm
	input [0:6]		rt_addr;		//Destination register address
	input [0:127]	ra, rb, rc;		//Values of source registers
	input [0:17]	imm;			//Immediate value, truncated based on format
	input			reg_write;		//Will current instr write to RegTable
	
	//WB Stage
	output logic [0:127]	rt_wb;			//Output value of Stage 6
	output logic [0:6]		rt_addr_wb;		//Destination register for rt_wb
	output logic			reg_write_wb;	//Will rt_wb write to RegTable
	
	output logic [0:127]	rt_int;			//Output value of Stage 7
	output logic [0:6]		rt_addr_int;	//Destination register for rt_wb
	output logic			reg_write_int;	//Will rt_wb write to RegTable
	
	//Internal Signals
	logic [6:0][0:127]	rt_delay;			//Staging register for calculated values
	logic [6:0][0:6]	rt_addr_delay;		//Destination register for rt_wb
	logic [6:0]			reg_write_delay;	//Will rt_wb write to RegTable
	logic [6:0]			int_delay;			//1 if int op, 0 if else
	
	logic [6:0]			i;					//7-bit counter for loops
	
	// TODO : Implement all instr
	
	always_ff @(posedge clk) begin
		if (reset == 1) begin
			rt_wb = 0;
			rt_addr_wb = 0;
			reg_write_wb = 0;
			rt_int = 0;
			rt_addr_int = 0;
			reg_write_int = 0;
			rt_delay[6] = 0;
			rt_addr_delay[6] = 0;
			reg_write_delay[6] = 0;
			int_delay[6] = 0;
			for (i=0; i<6; i=i+1) begin
				rt_delay[i] = 0;
				rt_addr_delay[i] = 0;
				reg_write_delay[i] = 0;
				int_delay[i] = 0;
			end
		end
		else begin
			if (int_delay[6] == 1) begin			//FP7 writeback (only for int ops)
				rt_int = rt_delay[6];
				rt_addr_int = rt_addr_delay[6];
				reg_write_int = reg_write_delay[6];
			end
			else begin
				rt_int = 0;
				rt_addr_int = 0;
				reg_write_int = 0;
			end
			
			if (int_delay[5] == 0) begin			//FP6 writeback
				rt_wb = rt_delay[5];
				rt_addr_wb = rt_addr_delay[5];
				reg_write_wb = reg_write_delay[5];
			end
			else begin
				rt_wb = 0;
				rt_addr_wb = 0;
				reg_write_wb = 0;
			end
			rt_delay[6] <= rt_delay[5];
			rt_addr_delay[6] <= rt_addr_delay[5];
			reg_write_delay[6] <= reg_write_delay[5];
			int_delay[6] <= int_delay[5];
			for (i=0; i<5; i=i+1) begin
				rt_delay[i+1] <= rt_delay[i];
				rt_addr_delay[i+1] <= rt_addr_delay[i];
				reg_write_delay[i+1] <= reg_write_delay[i];
				int_delay[i+1] <= int_delay[i];
			end
			
			if (format == 0 && op[0:9] == 0000000000) begin		//nop : No Operation (Execute)
				rt_delay[0] = 0;
				rt_addr_delay[0] = 0;
				reg_write_delay[0] = 0;
				int_delay[0] = 0;
			end
			else begin
				rt_addr_delay[0] = rt_addr;
				reg_write_delay[0] = reg_write;
				if (format == 0) begin
					case (op)
						11'b01111000100 : begin					//mpy : Multiply
							int_delay[0] = 1;
							for (i=0; i<4; i=i+1)
								rt_delay[0][(i*32) +: 32] = ra[(i*32)+16 +: 16] * rb[(i*32)+16 +: 16];
						end
						11'b01011000100 : begin					//fa : Floating Add
							int_delay[0] = 0;
							for (i=0; i<4; i=i+1) begin
								if (($bitstoshortreal(ra[(i*32) +: 32]) + $bitstoshortreal(rb[(i*32) +: 32])) >= $bitstoshortreal(32'h7F7FFFFF))
									rt_delay[0][(i*32) +: 32] = 32'h7F7FFFFF;
								else if (($bitstoshortreal(ra[(i*32) +: 32]) + $bitstoshortreal(rb[(i*32) +: 32])) <= $bitstoshortreal(32'h8F7FFFFF))
									rt_delay[0][(i*32) +: 32] = 32'hFF7FFFFF;
								else if (($bitstoshortreal(ra[(i*32) +: 32]) + $bitstoshortreal(rb[(i*32) +: 32])) <= $bitstoshortreal(32'h00000001)
									&& ($bitstoshortreal(ra[(i*32) +: 32]) + $bitstoshortreal(rb[(i*32) +: 32])) >= 0)
									rt_delay[0][(i*32) +: 32] = 32'h00000001;
								else if (($bitstoshortreal(ra[(i*32) +: 32]) + $bitstoshortreal(rb[(i*32) +: 32])) >= $bitstoshortreal(32'h80000001)
									&& ($bitstoshortreal(ra[(i*32) +: 32]) + $bitstoshortreal(rb[(i*32) +: 32])) <= 0)
									rt_delay[0][(i*32) +: 32] = 32'h80000001;
								else
								rt_delay[0][(i*32) +: 32] = $shortrealtobits($bitstoshortreal(ra[(i*32) +: 32]) + $bitstoshortreal(rb[(i*32) +: 32]));
							end
						end
						default begin
							int_delay[0] = 0;
							rt_delay[0] = 0;
							rt_addr_delay[0] = 0;
							reg_write_delay[0] = 0;
						end
					endcase
				end
				//else if (format == 1) begin
				//end
				//else if (format == 2) begin
				//end
				//else if (format == 3) begin
				//end
				//else if (format == 4) begin
				//end
				//else if (format == 5) begin
				//end
				//else if (format == 6) begin
				//end
			end
		end
	end
endmodule