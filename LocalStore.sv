module LocalStore(clk, reset, op, format, rt_addr, ra, rb, imm, reg_write, rt_wb, rt_addr_wb, reg_write_wb);
	input			clk, reset
	
	//RF/FWD Stage
	input [0:10]	op;				//Decoded opcode, truncated based on format
	input [2:0]		format;			//Format of instr, used with op and imm
	input [0:6]		rt_addr;		//Destination register address
	input [0:127]	ra, rb;			//Values of source registers
	input [0:17]	imm;			//Immediate value, truncated based on format
	input			reg_write;		//Will current instr write to RegTable
	
	//WB Stage
	output [0:127]	rt_wb;			//Output value of Stage 3
	output [0:6]	rt_addr_wb;		//Destination register for rt_wb
	output			reg_write_wb;	//Will rt_wb write to RegTable
	
	//Internal Signals
	logic [5:0][0:127]	rt_delay;			//Staging register for calculated values
	logic [5:0][0:6]	rt_addr_delay;		//Destination register for rt_wb
	logic [5:0]			reg_write_delay;	//Will rt_wb write to RegTable
	
	logic [6:0]			i					//7-bit counter for loops
	
	logic [0:15] memory [0:7]				//32KB local memory
	
	// TODO : Implement all instr, memory
	
	always_comb begin		
		rt_wb = rt_delay[6];
		rt_addr_wb = rt_addr_delay[6];
		reg_write_wb = reg_write_delay[6];
		
		if (format == 0 && op == 0) begin					//nop : No Operation (Load)
			rt_delay[0] = 0;
			rt_addr_delay[0] = 0;
			reg_write_delay[0] = 0;
		end
		else begin
			rt_addr_delay[0] = rt_addr;
			reg_write_delay[0] = reg_write;
			if (format == 0) begin
				case (op)
					11'b00111000100 : begin					//lqx : Load Quadword (x-form)
															// TODO : Implement after creating memory
							rt_delay[0] = mem[$signed((ra[0:31]) + $signed(rb[0:31])) & 32'hFFFFFFF0 +: 16];
						
						end
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
	
	always_ff @(posedge clk) begin
		if (reset == 1) begin
			rt_delay[5] <= 0;
			rt_addr_delay[5] <= 0;
			reg_write_delay[5] <= 0;
			for (i=0; i<5; i=i+1) begin
				rt_delay[i] <= 0;
				rt_addr_delay[i] <= 0;
				reg_write_delay[i] <= 0;
			end
		end
		else begin
			rt_delay[6] <= rt_delay[5];
			rt_addr_delay[6] <= rt_addr_delay[5];
			reg_write_delay[6] <= reg_write_delay[5];
			for (i=0; i<5; i=i+1) begin
				rt_delay[i+1] <= rt_delay[i];
				rt_addr_delay[i+1] <= rt_addr_delay[i];
				reg_write_delay[i+1] <= reg_write_delay[i];
			end
		end
	end
	
endmodule