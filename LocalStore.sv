module LocalStore(clk, reset, op, format, rt_addr, ra, rb, rt_st, imm, reg_write, rt_wb, rt_addr_wb, reg_write_wb, branch_taken,
stall_odd_raw, ra_odd_addr, rb_odd_addr,  rc_odd_addr,stall_even_raw, ra_even_addr, rb_even_addr, rc_even_addr,
is_ra_odd_valid,is_rb_odd_valid,is_rc_odd_valid, is_ra_even_valid,is_rb_even_valid,is_rc_even_valid);
	input			clk, reset;

	//RF/FWD Stage
	input [0:10]	op;				//Decoded opcode, truncated based on format
	input [2:0]		format;			//Format of instr, used with op and imm
	input [0:6]		rt_addr;		//Destination register address
	input [0:127]	ra, rb, rt_st;	//Values of source registers
	input [0:17]	imm;			//Immediate value, truncated based on format
	input			reg_write;		//Will current instr write to RegTable
	input			branch_taken;	//Was branch taken?

	//WB Stage
	output logic [0:127]	rt_wb;			//Output value of Stage 3
	output logic [0:6]		rt_addr_wb;		//Destination register for rt_wb
	output logic			reg_write_wb;	//Will rt_wb write to RegTable

	//Internal Signals
	logic [5:0][0:127]	rt_delay;			//Staging register for calculated values
	logic [5:0][0:6]	rt_addr_delay;		//Destination register for rt_wb
	logic [5:0]			reg_write_delay;	//Will rt_wb write to RegTable

	logic [0:127] mem [0:2047];				//32KB local memory

	input logic [0:7] ra_odd_addr,rb_odd_addr,rc_odd_addr;
	input logic [0:7] ra_even_addr,rb_even_addr,rc_even_addr;
	output logic stall_odd_raw,stall_even_raw;
	input logic is_ra_odd_valid,is_rb_odd_valid,is_rc_odd_valid, is_ra_even_valid,is_rb_even_valid,is_rc_even_valid;


	always_comb begin
		rt_wb = rt_delay[5];
		rt_addr_wb = rt_addr_delay[5];
		reg_write_wb = reg_write_delay[5];

		if(reset) begin
			stall_even_raw = 0;
			stall_odd_raw = 0;

		end
		else begin
			if(reg_write == 1 &&
					(
						(rt_addr == ra_odd_addr && is_ra_odd_valid == 1) ||
						(rt_addr == rb_odd_addr && is_rb_odd_valid==1 ) ||
						(rt_addr == rc_odd_addr && is_rc_odd_valid==1 )
					)
				) begin
					stall_odd_raw = 1;
					$display("%s %d RAW hazard found addr %d ",`__FILE__,`__LINE__,rt_addr);
					$display("addr rt_addr_delay %d ",rt_addr);
			end

			else if(reg_write_delay[0] == 1 &&
					(
						(rt_addr_delay[0] == ra_odd_addr && is_ra_odd_valid == 1) ||
						(rt_addr_delay[0] == rb_odd_addr && is_rb_odd_valid==1 ) ||
						(rt_addr_delay[0] == rc_odd_addr && is_rc_odd_valid==1 )
					)
				) begin
					stall_odd_raw = 1;
					$display("%s %d RAW hazard found addr %d ",`__FILE__,`__LINE__,rt_addr_delay[0]);
					$display("i=  %d addr rt_addr_delay %d ",0,rt_addr_delay[0]);
			end
			else if(reg_write_delay[1] == 1 &&
					(
						(rt_addr_delay[1] == ra_odd_addr && is_ra_odd_valid == 1) ||
						(rt_addr_delay[1] == rb_odd_addr && is_rb_odd_valid==1 ) ||
						(rt_addr_delay[1] == rc_odd_addr && is_rc_odd_valid==1 )
					)
				) begin
					stall_odd_raw = 1;
					$display("%s %d RAW hazard found addr %d ",`__FILE__,`__LINE__,rt_addr_delay[1]);
					$display("i=  %d addr rt_addr_delay %d ",1,rt_addr_delay[1]);
			end
			else if(reg_write_delay[2] == 1 &&
					(
						(rt_addr_delay[2] == ra_odd_addr && is_ra_odd_valid == 1) ||
						(rt_addr_delay[2] == rb_odd_addr && is_rb_odd_valid==1 ) ||
						(rt_addr_delay[2] == rc_odd_addr && is_rc_odd_valid==1 )
					)
				) begin
					stall_odd_raw = 1;
					$display("%s %d RAW hazard found addr %d ",`__FILE__,`__LINE__,rt_addr_delay[2]);
					$display("i=  %d addr rt_addr_delay %d ",2,rt_addr_delay[2]);
			end
			else if(reg_write_delay[3] == 1 &&
					(
						(rt_addr_delay[3] == ra_odd_addr && is_ra_odd_valid == 1) ||
						(rt_addr_delay[3] == rb_odd_addr && is_rb_odd_valid==1 ) ||
						(rt_addr_delay[3] == rc_odd_addr && is_rc_odd_valid==1 )
					)
				) begin
					stall_odd_raw = 1;
					$display("%s %d RAW hazard found addr %d ",`__FILE__,`__LINE__,rt_addr_delay[3]);
					$display("i=  %d addr rt_addr_delay %d ",2,rt_addr_delay[3]);
			end
			else if(reg_write_delay[4] == 1 &&
					(
						(rt_addr_delay[4] == ra_odd_addr && is_ra_odd_valid == 1) ||
						(rt_addr_delay[4] == rb_odd_addr && is_rb_odd_valid==1 ) ||
						(rt_addr_delay[4] == rc_odd_addr && is_rc_odd_valid==1 )
					)
				) begin
					stall_odd_raw = 1;
					$display("%s %d RAW hazard found addr %d ",`__FILE__,`__LINE__,rt_addr_delay[4]);
					$display("i=  %d addr rt_addr_delay %d ",2,rt_addr_delay[4]);
			end

			else begin
				stall_odd_raw=0;
			end

			if(reg_write == 1 &&
					(
						(rt_addr == ra_even_addr && is_ra_even_valid ==1  ) ||
						(rt_addr == rb_even_addr && is_rb_even_valid ==1) ||
						(rt_addr == rc_even_addr && is_rc_even_valid==1)
					)
				) begin
					stall_even_raw = 1;
					$display("%s %d RAW hazard found addr %d ",`__FILE__,`__LINE__,rt_addr);
					$display("addr rt_addr_delay %d ",rt_addr);
			end
			else if(reg_write_delay[0] == 1 &&
					(
						(rt_addr_delay[0] == ra_even_addr && is_ra_even_valid ==1  ) ||
						(rt_addr_delay[0] == rb_even_addr && is_rb_even_valid ==1) ||
						(rt_addr_delay[0] == rc_even_addr && is_rc_even_valid==1)
					)
				) begin
					stall_even_raw = 1;
					$display("%s %d RAW hazard found addr %d ",`__FILE__,`__LINE__,rt_addr_delay[0]);
					$display("i=  %d addr rt_addr_delay %d ",0,rt_addr_delay[0]);
			end

			else if(reg_write_delay[1] == 1 &&
					(
						(rt_addr_delay[1] == ra_even_addr && is_ra_even_valid ==1  ) ||
						(rt_addr_delay[1] == rb_even_addr && is_rb_even_valid ==1) ||
						(rt_addr_delay[1] == rc_even_addr && is_rc_even_valid==1)
					)
				) begin
					stall_even_raw = 1;
					$display("%s %d RAW hazard found addr %d ",`__FILE__,`__LINE__,rt_addr_delay[1]);
					$display("i=  %d addr rt_addr_delay %d ",1,rt_addr_delay[1]);
			end

			else if(reg_write_delay[2] == 1 &&
					(
						(rt_addr_delay[2] == ra_even_addr && is_ra_even_valid ==1  ) ||
						(rt_addr_delay[2] == rb_even_addr && is_rb_even_valid ==1) ||
						(rt_addr_delay[2] == rc_even_addr && is_rc_even_valid==1)
					)
				) begin
					stall_even_raw = 1;
					$display("%s %d RAW hazard found addr %d ",`__FILE__,`__LINE__,rt_addr_delay[2]);
					$display("i=  %d addr rt_addr_delay %d ",2,rt_addr_delay[2]);
			end
				else if(reg_write_delay[3] == 1 &&
					(
						(rt_addr_delay[3] == ra_even_addr && is_ra_even_valid ==1  ) ||
						(rt_addr_delay[3] == rb_even_addr && is_rb_even_valid ==1) ||
						(rt_addr_delay[3] == rc_even_addr && is_rc_even_valid==1)
					)
				) begin
					stall_even_raw = 1;
					$display("%s %d RAW hazard found addr %d ",`__FILE__,`__LINE__,rt_addr_delay[3]);
					$display("i=  %d addr rt_addr_delay %d ",2,rt_addr_delay[3]);
			end
			else if(reg_write_delay[4] == 1 &&
				(
					(rt_addr_delay[4] == ra_even_addr && is_ra_even_valid ==1  ) ||
					(rt_addr_delay[4] == rb_even_addr && is_rb_even_valid ==1) ||
					(rt_addr_delay[4] == rc_even_addr && is_rc_even_valid==1)
				)
			) begin
					stall_even_raw = 1;
					$display("%s %d RAW hazard found addr %d ",`__FILE__,`__LINE__,rt_addr_delay[4]);
					$display("i=  %d addr rt_addr_delay %d ",2,rt_addr_delay[4]);
			end

			else begin
				stall_even_raw = 0;
			end

		end
	end

	always_ff @(posedge clk) begin
		if (reset == 1) begin
			rt_delay[5] <= 0;
			rt_addr_delay[5] <= 0;
			reg_write_delay[5] <= 0;
			for (int i=0; i<5; i=i+1) begin
				rt_delay[i] <= 0;
				rt_addr_delay[i] <= 0;
				reg_write_delay[i] <= 0;
			end
			for (logic [0:11] i=0; i<2048; i=i+1) begin
				//mem[i] <= 0;
				mem[i] <= {i*4, (i*4 + 1), (i*4 + 2), (i*4 + 3)};
			end
		end
		else begin
			rt_delay[5] <= rt_delay[4];
			rt_addr_delay[5] <= rt_addr_delay[4];
			reg_write_delay[5] <= reg_write_delay[4];

			for (int i=0; i<4; i=i+1) begin
				rt_delay[i+1] <= rt_delay[i];
				rt_addr_delay[i+1] <= rt_addr_delay[i];
				reg_write_delay[i+1] <= reg_write_delay[i];
			end

			if (format == 0 && op == 0) begin					//nop : No Operation (Load)
				rt_delay[0] <= 0;
				rt_addr_delay[0] <= 0;
				reg_write_delay[0] <= 0;
			end
			else begin
				rt_addr_delay[0] <= rt_addr;
				reg_write_delay[0] <= reg_write;
				if (branch_taken) begin						// If branch taken last cyc, cancel last instr
					rt_delay[0] <= 0;
					rt_addr_delay[0] <= 0;
					reg_write_delay[0] <= 0;
				end
				else if (format == 0) begin
					case (op)
						11'b00111000100 : begin					//lqx : Load Quadword (x-form)
							rt_delay[0] <= mem[$signed(ra[0:31]) + $signed(rb[0:31])];
						end
						11'b00101000100 : begin					//stqx : Store Quadword (x-form)
							mem[$signed(ra[0:31]) + $signed(rb[0:31])] <= rt_st;
							reg_write_delay[0] <= 0;
						end
						default begin
							rt_delay[0] <= 0;
							rt_addr_delay[0] <= 0;
							reg_write_delay[0] <= 0;
						end
					endcase
				end
				else if (format == 4) begin
					case (op[3:10])
						8'b00110100 : begin					//lqd : Load Quadword (d-form)
							rt_delay[0] <= mem[$signed((ra[0:31]) + $signed(imm[8:17]))];
						end
						8'b00100100 : begin					//stqd : Store Quadword (d-form)
							mem[$signed(ra[0:31] + $signed(imm[8:17]))] <= rt_st;
							reg_write_delay[0] <= 0;
						end
						default begin
							rt_delay[0] <= 0;
							rt_addr_delay[0] <= 0;
							reg_write_delay[0] <= 0;
						end
					endcase
				end
				else if (format == 5) begin
					case (op[2:10])
						9'b001100001 : begin				//lqa : Load Quadword (a-form)
							rt_delay[0] <= mem[$signed(imm[2:17])];
						end
						9'b001000001 : begin				//stqa : Store Quadword (a-form)
							mem[$signed(imm[2:17])] <= rt_st;
							reg_write_delay[0] <= 0;
						end
						default begin
							rt_delay[0] <= 0;
							rt_addr_delay[0] <= 0;
							reg_write_delay[0] <= 0;
						end
					endcase
				end
				else begin
					rt_delay[0] <= 0;
					rt_addr_delay[0] <= 0;
					reg_write_delay[0] <= 0;
				end
			end
		end
	end

endmodule