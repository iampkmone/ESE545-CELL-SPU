module Permute(clk, reset, op, format, rt_addr, ra, rb, imm, reg_write, rt_wb, rt_addr_wb, reg_write_wb, branch_taken);
	input			clk, reset;

	//RF/FWD Stage
	input [0:10]	op;				//Decoded opcode, truncated based on format
	input [2:0]		format;			//Format of instr, used with op and imm
	input [0:6]		rt_addr;		//Destination register address
	input [0:127]	ra, rb;			//Values of source registers
	input [0:17]	imm;			//Immediate value, truncated based on format
	input			reg_write;		//Will current instr write to RegTable
	input			branch_taken;	//Was branch taken?

	//WB Stage
	output logic [0:127]	rt_wb;			//Output value of Stage 3
	output logic [0:6]		rt_addr_wb;		//Destination register for rt_wb
	output logic			reg_write_wb;	//Will rt_wb write to RegTable

	//Internal Signals
	logic [3:0][0:127]	rt_delay;			//Staging register for calculated values
	logic [3:0][0:6]	rt_addr_delay;		//Destination register for rt_wb
	logic [3:0]			reg_write_delay;	//Will rt_wb write to RegTable

	logic [6:0]			i;					//7-bit counter for loops

	// Temp variables
	logic [0:127] tmp;

	// TODO : Implement all instr

	always_comb begin
		rt_wb = rt_delay[3];
		rt_addr_wb = rt_addr_delay[3];
		reg_write_wb = reg_write_delay[3];
	end

	always_ff @(posedge clk) begin
		if (reset == 1) begin
			rt_delay[3] <= 0;
			rt_addr_delay[3] <= 0;
			reg_write_delay[3] <= 0;
			for (i=0; i<3; i=i+1) begin
				rt_delay[i] <= 0;
				rt_addr_delay[i] <= 0;
				reg_write_delay[i] <= 0;
			end
			tmp <= 0;

		end
		else begin
			rt_delay[3] <= rt_delay[2];
			rt_addr_delay[3] <= rt_addr_delay[2];
			reg_write_delay[3] <= reg_write_delay[2];

			rt_delay[2] <= rt_delay[1];
			rt_addr_delay[2] <= rt_addr_delay[1];
			reg_write_delay[2] <= reg_write_delay[1];

			rt_delay[1] <= rt_delay[0];
			rt_addr_delay[1] <= rt_addr_delay[0];
			reg_write_delay[1] <= reg_write_delay[0];

			if (format == 0 && op == 0) begin					//nop : No Operation (Load)
				rt_delay[0] <= 0;
				rt_addr_delay[0] <= 0;
				reg_write_delay[0] <= 0;
			end
			else begin
				rt_addr_delay[0] <= rt_addr;
				reg_write_delay[0] <= reg_write;
				if (branch_taken) begin
					rt_delay[0] <= 0;
					rt_addr_delay[0] <= 0;
					reg_write_delay[0] <= 0;
				end
				else if (format == 0) begin
					case (op)
						11'b00111011011 : begin					//shlqbi : Shift Left Quadword by Bits
							rt_delay[0] <= ra << rb[29:31];
						end
                        11'b00111011111 : begin                 //shlqby rt, ra, rb : Shift Left Quadword by Bytes
                            rt_delay[0] = ra << rb[27:31];
                        end
                        11'b00111011000 : begin                 //rotqbi rt, ra, rb : Rotate Quadword by Bits
							tmp = rb[29:31];
							// $display("ra %b ",ra);
							// $display("rotqbi");
							for(int b=0;b<128;b++) begin
								if(b+tmp < 128 ) begin
									rt_delay[0][b] = ra[b+tmp];
								end
								else begin
									rt_delay[0][b]=ra[b+tmp-128];
								end
							end
                        end
						11'b00111011100 : begin                 //rotqby rt,ra,rb Rotate Quadword by Bytes
							tmp = rb[28:31];
							// $display("tmp =      %d",tmp);
							// $display("ra =       %b",ra);
							// $display("ra[10] =       %b",ra[10]);
							// $display("rt_delay = %b",rt_delay[0]);

							for(int b=0;b<=15;b++) begin
								// _s = (b+tmp)*8;
								// _d = b*8;
								if(b+tmp < 16 ) begin
									for(int i = b*8;i<(b*8+8);i++) begin
										rt_delay[0][i] = ra[i+tmp*8];
										// $display("rt_delay = %h  ra = %h  i = %d b = %d i+tmp*8 = %d",rt_delay[0][i], ra[i+tmp*8], i, b,i+tmp*8);
									end

								end
								else begin
									for(int i = b*8;i<(b*8+8);i++) begin
										rt_delay[0][i] = ra[i+tmp*8-16*8];
										// $display("rt_delay = %h  ra = %h  i = %d b = %d i+tmp*8-16*8 = %d",rt_delay[0][i], ra[i+tmp*8-16*8], i, b,i+tmp*8-16*8);
									end

								end
								// $display(" ");
							end
							// $display("ra =       %b",ra);
							// $display("rt_delay = %b",rt_delay[0]);
                        end
						11'b00110110010 : begin                 //gbb rt,ra Gather Bits from Bytes
							tmp = 0;
							// $display("tmp =      %d",tmp);
							// $display("ra =       %b",ra);
							// $display("rt_delay = %b",rt_delay[0]);
							for(int j=7,k=0;j<128;j=j+8,k++) begin
								tmp[k+16] = ra[j];
								// $display("ra[j] =  %b j =  %d k = %d ",ra[j],j,k);
							end
							// $display("tmp =      %b",tmp[0:31]);

							for(int i = 32;i<128;i++) begin
								rt_delay[0][i]=0;
							end
							rt_delay[0][0:31] = 16'h0000 | tmp[0:31];
							// $display("ra =       %b",ra);
							// $display("rt_delay = %b",rt_delay[0]);
                        end
						11'b00110110001 : begin                 //gbb rt,ra Gather Bits from halfwords
							tmp = 0;
							// int _d = 0;
							// int _s = 0;
							// $display("tmp =      %d",tmp);
							// $display("ra =       %b",ra);
							// $display("rt_delay = %b",rt_delay[0]);

							for(int j=15,k=0;j<128;j=j+16,k++) begin
								tmp[k+24] = ra[j];
								// $display("ra[j] =  %b j =  %d k = %d ",ra[j],j,k);
							end
							// $display("tmp =      %b",tmp[0:31]);

							for(int i = 0;i<128;i++) begin
								rt_delay[0][i]=0;
							end
							rt_delay[0][24:31] = 8'h00 | tmp[24:31];
							// $display("ra =       %b",ra);
							// $display("rt_delay = %b",rt_delay[0]);
                        end
						11'b00110110000 : begin                 //gbb rt,ra Gather Bits from halfwords
							tmp = 0;
							// $display("tmp =      %d",tmp);
							// $display("ra =       %b",ra);
							// $display("rt_delay = %b",rt_delay[0]);

							for(int j=31,k=0;j<128;j=j+32,k++) begin
								tmp[k+28] = ra[j];
								// $display("ra[j] =  %b j =  %d k = %d ",ra[j],j,k);
							end
							// $display("tmp =      %b",tmp[0:31]);

							for(int i = 0;i<128;i++) begin
								rt_delay[0][i]=0;
							end
							rt_delay[0][28:31] = 4'h0 | tmp[28:31];
							// $display("ra =       %b",ra);
							// $display("rt_delay = %b",rt_delay[0]);
                        end
						default begin
							rt_delay[0] <= 0;
							rt_addr_delay[0] <= 0;
							reg_write_delay[0] <= 0;
						end
					endcase
				end
				//else if (format == 1) begin
				//end
				else if (format == 2) begin
					case (op)
						11'b00111111011 : begin					//shlqbi : Shift Left Quadword by Bits
							tmp[0:6]  = imm & 7'b0000111;
							// $display("tmp =  %b %d imm = %b %d ",tmp,tmp,imm,imm);
							for(int b=0;b<128;b++) begin
								if(b+tmp[0:6] < 128 ) begin
									// $display("b+tmp %d ",b+tmp[0:6]);
									rt_delay[0][b] = ra[b+tmp[0:6]];
								end
								else begin
									rt_delay[0][b] = 0;
								end
							end
							// $display("rt_delay =  %h ",rt_delay[0]);
						end
						11'b00111111111 : begin                 //shlqbyi rt,ra,value Shift Left Quadword by Bytes Immediate
							tmp[0:6]  = imm & 7'b0001111;
							// $display("tmp =      %d",tmp);
							// $display("ra =       %b",ra);
							// $display("rt_delay = %b",rt_delay[0]);
							for(int b=0;b<=15;b++) begin
								if(b+tmp[0:6] < 16 ) begin
									for(int i = b*8;i<(b*8+8);i++) begin
										rt_delay[0][i] = ra[i+tmp[0:6]*8];
										// $display("rt_delay = %h  ra = %h  i = %d b = %d i+tmp*8 = %d",rt_delay[0][i], ra[i+tmp[0:6]*8], i, b,i+tmp[0:6]*8);
									end
								end
								else begin
									for(int i = b*8;i<(b*8+8);i++) begin
										rt_delay[0][i] = 0;
									end
								end
								$display(" ");
							end
							// $display("ra =       %b",ra);
							// $display("rt_delay = %b",rt_delay[0]);
                        end
						11'b00111111000 : begin                 //rotqbii rt,ra,value Rotate Quadword by Bits Immediate
							tmp[0:6]  = imm & 7'b0000111;       // bits 4:6 of imm or bits 15 to 17 of I7
							// $display("rotqbii");
							// $display("tmp =      %b",tmp);

							for(int b=0;b<128;b++) begin
								if(b+tmp[0:6] < 128 ) begin
									// $display("b =  %d b+tmp[0:6] = %d ra[b+tmp[0:6]] = %b ",b,b+tmp[0:6],ra[b+tmp[0:6]]);
									rt_delay[0][b] = ra[b+tmp[0:6]];
								end
								else begin
									// $display("b =  %d b+tmp[0:6] = %d ra[b+tmp[0:6]] = %b ",b,b+tmp[0:6],ra[b+tmp[0:6]-128]);
									rt_delay[0][b]=ra[b+tmp[0:6]-128];
								end
							end
							// $display("ra =       %b",ra);
							// $display("rt_delay = %b",rt_delay[0]);
                        end
						11'b00111111100 : begin                 //rotqbyi rt, ra, imm7 Rotate Quadword by Bytes Immediate
							tmp[0:6]  = imm & 7'b0001111;
							// $display("rotqbyi");
							// $display("tmp =      %b",tmp);
							// $display("ra =       %b",ra);
							// $display("rt_delay = %b",rt_delay[0]);
							for(int b=0;b<=15;b++) begin
								if(b+tmp[0:6] < 16 ) begin
									for(int i = b*8;i<(b*8+8);i++) begin
										rt_delay[0][i] = ra[i+tmp[0:6]*8];
										// $display("rt_delay = %h  ra = %b  i = %d b = %d i+tmp*8 = %d",rt_delay[0][i], ra[i+tmp[0:6]*8], i, b,i+tmp[0:6]*8);
									end
								end
								else begin
									// $display(" ");
									for(int i = b*8;i<(b*8+8);i++) begin
										// $display("rt_delay = %b  ra = %b  i = %d b = %d i+tmp*8-16*8 = %d",rt_delay[0][i], ra[i+tmp[0:6]*8-16*8], i, b,i+tmp[0:6]*8-16*8);
										rt_delay[0][i] = ra[i+tmp[0:6]*8-16*8];
									end
								end
								// $display(" ");
							end
							// $display("ra =       %b",ra);
							// $display("rt_delay = %b",rt_delay[0]);
                        end
						default begin
							rt_delay[0] = 0;
							rt_addr_delay[0] = 0;
							reg_write_delay[0] = 0;
						end
					endcase
				end
			end
		end
	end

endmodule