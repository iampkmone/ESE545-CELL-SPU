module SimpleFixed1(clk, reset, op, format, rt_addr, ra, rb, imm, reg_write, rt_wb, rt_addr_wb, reg_write_wb);
	input			clk, reset;

	//RF/FWD Stage
	input [0:10]	op;				//Decoded opcode, truncated based on format
	input [2:0]		format;			//Format of instr, used with op and imm
	input [0:6]		rt_addr;		//Destination register address
	input [0:127]	ra, rb;			//Values of source registers
	input [0:17]	imm;			//Immediate value, truncated based on format
	input			reg_write;		//Will current instr write to RegTable

	//WB Stage
	output logic [0:127]	rt_wb;			//Output value of Stage 3
	output logic [0:6]		rt_addr_wb;		//Destination register for rt_wb
	output logic			reg_write_wb;	//Will rt_wb write to RegTable

	//Internal Signals
	logic [1:0][0:127]	rt_delay;			//Staging register for calculated values
	logic [1:0][0:6]	rt_addr_delay;		//Destination register for rt_wb
	logic [1:0]			reg_write_delay;	//Will rt_wb write to RegTable

	logic [6:0]		i;				//7-bit counter for loops
	logic signed [31:0] max_value_32 = 32'h7FFFFFFF;
	logic signed [31:0] min_value_32 = 32'h80000000;


	logic signed [31:0] max_value_16 = 16'h7FFF;
	logic signed [31:0] min_value_16 = 16'h8000;
	logic signed [0:31] mask =1<<31;

	// TODO : Implement all instr

	always_ff @(posedge clk) begin
		if (reset == 1) begin
			rt_wb = 0;
			rt_addr_wb = 0;
			reg_write_wb = 0;
			rt_delay[1] <= 0;
			rt_addr_delay[1] <= 0;
			reg_write_delay[1] <= 0;
			rt_delay[0] <= 0;
			rt_addr_delay[0] <= 0;
			reg_write_delay[0] <= 0;
		end
		else begin
			rt_wb <= rt_delay[1];
			rt_addr_wb <= rt_addr_delay[1];
			reg_write_wb <= reg_write_delay[1];
			rt_delay[1] <= rt_delay[0];
			rt_addr_delay[1] <= rt_addr_delay[0];
			reg_write_delay[1] <= reg_write_delay[0];

			rt_wb = rt_delay[1];
			rt_addr_wb = rt_addr_delay[1];
			reg_write_wb = reg_write_delay[1];

			if (format == 0 && op == 0) begin					//nop : No Operation (Execute)
				rt_delay[0] = 0;
				rt_addr_delay[0] = 0;
				reg_write_delay[0] = 0;
			end
			else begin
				rt_addr_delay[0] = rt_addr;
				reg_write_delay[0] = reg_write;
				if (format == 0) begin
					case (op)
						11'b00011001000 : begin					//ah : Add Halfword
							for (i=0; i<8; i=i+1) begin
								rt_delay[0][(i*16) +: 16] = $signed(ra[(i*16) +: 16]) + $signed(rb[(i*16) +: 16]);
								$display("add word  ra = %b rb = %b rt_delay[0] =  %b", $signed(ra[(i*16) +: 16]) ,$signed(rb[(i*16) +: 16]),rt_delay[0][(i*16) +: 16]);
							end
						end
						11'b00011000000 : begin					//ah : Add Word
							// $display("add word");
							for (i=0; i<4; i=i+1) begin
								if(($signed(ra[(i*32) +: 32]) & mask[0:31] ) ^ ($signed(rb[(i*32) +: 32]) & mask[0:31] )==0) begin
									if($signed(ra[(i*32) +: 32]) > 0 && ((max_value_32[31:0] - $signed(ra[(i*32) +: 32])) <= $signed(rb[(i*32) +: 32]))) begin
										rt_delay[0][(i*32) +: 32] = max_value_32;
										$display("pos ");

									end
									else if($signed(ra[(i*32) +: 32]) < 0 && ($signed(ra[(i*32) +: 32])==min_value_32[31:0] || $signed(rb[(i*32) +: 32])==min_value_32[31:0]  || ((min_value_32[31:0]-$signed(ra[(i*32) +: 32])) >= $signed(rb[(i*32) +: 32])))) begin
										rt_delay[0][(i*32) +: 32] = min_value_32;
										$display("neg ");
									end
									else begin
										$display("non overflow ");

										rt_delay[0][(i*32) +: 32] = $signed(ra[(i*32) +: 32]) + $signed(rb[(i*32) +: 32]);
									end
								end
								else begin
										$display("sign mismatch");

										rt_delay[0][(i*32) +: 32] = $signed(ra[(i*32) +: 32]) + $signed(rb[(i*32) +: 32]);
								end
								// rt_delay[0][(i*32) +: 32] = $signed(ra[(i*32) +: 32]) + $signed(rb[(i*32) +: 32]);
								// rt_delay[0][(i*32) +: 32] = (ra[(i*32) +: 32]) + (rb[(i*32) +: 32]);
								$display("add word  ra = %d rb = %d rt_delay[0] =  %d min_value_32[31:0] %d max_value_32[31:0] %d", $signed(ra[(i*32) +: 32]) ,$signed(rb[(i*32) +: 32]),rt_delay[0][(i*32) +: 32],min_value_32[31:0],max_value_32[31:0]);
								$display("add word  ra = %h rb = %h rt_delay[0] =  %h min_value_32[31:0] %b max_value_32[31:0] %b", $signed(ra[(i*32) +: 32]) ,$signed(rb[(i*32) +: 32]),rt_delay[0][(i*32) +: 32],min_value_32[31:0],max_value_32[31:0]);
								// $display("add word  ra = %b rb = %b rt_delay[0] =  %b", (ra[(i*32) +: 32]) ,(rb[(i*32) +: 32]),rt_delay[0][(i*32) +: 32]);
							end
							$display("ra %h rb %h rt_delay %h ",ra,rb,rt_delay[0]);
						end
						11'b00011000001 : begin // and
							$display("and");
							rt_delay[0] =  ra & rb;
							$display("ra = %h",ra);
							$display("rb = %h",rb);
							$display("rt_delay = %h",rt_delay[0]);
						end
						11'b00001000001 : begin // or
							$display("or");
							rt_delay[0] =  ra | rb;
							$display("ra = %h",ra);
							$display("rb = %h",rb);
							$display("rt_delay = %h",rt_delay[0]);
						end
						11'b01001000001 : begin // xor
							rt_delay[0] =  ra ^ rb;
							$display("xor");
							$display("ra = %h",ra);
							$display("rb = %h",rb);
							$display("rt_delay = %h",rt_delay[0]);
						end
						11'b00011001001 : begin // nand
							rt_delay[0] =  ~(ra & rb);
							$display("nand");
							$display("ra = %h",ra);
							$display("rb = %h",rb);
							$display("rt_delay = %h",rt_delay[0]);
						end
						11'b01111010000 : begin // ceqb rt, ra, rb Compare Equal Byte
							if(ra==rb) begin
								rt_delay[0]=128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
							end
							else begin
								rt_delay[0]=128'h00000000000000000000000000000000;
							end
							$display("ceqb rt, ra, rb");
							$display("ra = %h",ra);
							$display("rb = %h",rb);
							$display("rt_delay = %h",rt_delay[0]);
						end
						11'b01111001000 : begin // ceqh rt, ra, rb Compare Equal Halfword

							for(int i = 0;i<16;i=i+2) begin
								if(ra[(i*8) +: 16]==rb[(i*8) +: 16]) begin
									rt_delay[0][(i*8) +: 16] = 16'hFFFF;
								end
								else begin
									rt_delay[0][(i*8) +: 16] = 16'h0000;
								end
								// $display(" ra[(i*8) +: 16] = %b %d",ra[(i*8) +: 16],(i*8));
								// $display(" rb[(i*8) +: 16] = %b",rb[(i*8) +: 16]);
								// $display(" rt_delay[(i*8) +: 16] = %b",rt_delay[0][(i*8) +: 16]);
							end
							$display("ceqh rt, ra, rb");
							$display("ra =       %h",ra);
							$display("rb =       %h",rb);
							$display("rt_delay = %h",rt_delay[0]);

						end
						11'b01111000000 : begin // ceq rt, ra, rb Compare Equal Word

							for(int i = 0;i<16;i=i+4) begin
								if(ra[(i*8) +: 32]==rb[(i*8) +: 32]) begin
									rt_delay[0][(i*8) +: 32] = 32'hFFFFFFFF;
								end
								else begin
									rt_delay[0][(i*8) +: 32] = 32'h00000000;
								end
								// $display(" ra[(i*8) +: 32] = %b %d",ra[(i*8) +: 32],(i*8));
								// $display(" rb[(i*8) +: 32] = %b",rb[(i*8) +: 32]);
								// $display(" rt_delay[(i*8) +: 32] = %b",rt_delay[0][(i*8) +: 32]);
							end
							$display("ceq rt, ra, rb");
							$display("ra =       %h",ra);
							$display("rb =       %h",rb);
							$display("rt_delay = %h",rt_delay[0]);
						end
						11'b01001010000 : begin // cgtb rt, ra, rb Compare Greater Than Byte

							for(int i = 0;i<16;i=i+1) begin
								if($signed(ra[(i*8) +: 8])>$signed(rb[(i*8) +: 8])) begin
									rt_delay[0][(i*8) +: 8] = 8'hFF;
								end
								else begin
									rt_delay[0][(i*8) +: 8] = 8'h00;
								end
								// $display(" ra[(i*8) +: 8] = %b %d",ra[(i*8) +: 8],(i*8));
								// $display(" rb[(i*8) +: 8] = %b",rb[(i*8) +: 8]);
								// $display(" rt_delay[(i*8) +: 8] = %b",rt_delay[0][(i*8) +: 8]);
							end
							$display("cgtb rt, ra, rb");
							$display("ra =       %h",ra);
							$display("rb =       %h",rb);
							$display("rt_delay = %h",rt_delay[0]);
						end
						11'b01001001000 : begin // cgth rt, ra, rb Compare Greater Than Halfword
							for(int i = 0;i<16;i=i+2) begin
								if($signed(ra[(i*8) +: 16])>$signed(rb[(i*8) +: 16])) begin
									rt_delay[0][(i*8) +: 16] = 16'hFFFF;
								end
								else begin
									rt_delay[0][(i*8) +: 16] = 16'h0000;
								end
								// $display(" ra[(i*8) +: 16] = %b %d",ra[(i*8) +: 16],(i*8));
								// $display(" rb[(i*8) +: 16] = %b",rb[(i*8) +: 16]);
								// $display(" rt_delay[(i*8) +: 16] = %b",rt_delay[0][(i*8) +: 16]);
							end
							$display("cgth rt, ra, rb");
							$display("ra =       %h",ra);
							$display("rb =       %h",rb);
							$display("rt_delay = %h",rt_delay[0]);
						end
						11'b01001000000 : begin // cgt rt, ra, rb Compare Greater Than Word
							for(int i = 0;i<16;i=i+4) begin
								if($signed(ra[(i*8) +: 32])>$signed(rb[(i*8) +: 32])) begin
									rt_delay[0][(i*8) +: 32] = 32'hFFFFFFFF;
								end
								else begin
									rt_delay[0][(i*8) +: 32] = 32'h00000000;
								end
								// $display(" ra[(i*8) +: 32] = %b %d",ra[(i*8) +: 32],(i*8));
								// $display(" rb[(i*8) +: 32] = %b",rb[(i*8) +: 32]);
								// $display(" rt_delay[(i*8) +: 32] = %b",rt_delay[0][(i*8) +: 32]);
							end
							$display("cgt rt, ra, rb");
							$display("ra =       %h",ra);
							$display("rb =       %h",rb);
							$display("rt_delay = %h",rt_delay[0]);
						end
						11'b01011010000 : begin // clgtb rt, ra, rb Compare Logical Greater Than Byte
							for(int i = 0;i<16;i=i+1) begin
								if(ra[(i*8) +: 8]>rb[(i*8) +: 8]) begin
									rt_delay[0][(i*8) +: 8] = 8'hFF;
								end
								else begin
									rt_delay[0][(i*8) +: 8] = 8'h00;
								end
								// $display(" ra[(i*8) +: 8] = %b %d",ra[(i*8) +: 8],(i*8));
								// $display(" rb[(i*8) +: 8] = %b",rb[(i*8) +: 8]);
								// $display(" rt_delay[(i*8) +: 8] = %b",rt_delay[0][(i*8) +: 8]);
							end
							$display("clgtb rt, ra, rb");
							$display("ra =       %h",ra);
							$display("rb =       %h",rb);
							$display("rt_delay = %h",rt_delay[0]);
						end
						11'b01011001000 : begin // clgth rt, ra, rb Compare Logical Greater Than Halfword
							for(int i = 0;i<16;i=i+2) begin
								if(ra[(i*8) +: 16]>rb[(i*8) +: 16]) begin
									rt_delay[0][(i*8) +: 16] = 16'hFFFF;
								end
								else begin
									rt_delay[0][(i*8) +: 16] = 16'h0000;
								end
								// $display(" ra[(i*8) +: 16] = %b %d",ra[(i*8) +: 16],(i*8));
								// $display(" rb[(i*8) +: 16] = %b",rb[(i*8) +: 16]);
								// $display(" rt_delay[(i*8) +: 16] = %b",rt_delay[0][(i*8) +: 16]);
							end
							$display("clgth rt, ra, rb");
							$display("ra =       %h",ra);
							$display("rb =       %h",rb);
							$display("rt_delay = %h",rt_delay[0]);
						end
						11'b01011000000 : begin // clgt rt, ra, rb Compare Logical Greater Than Word
							for(int i = 0;i<16;i=i+4) begin
								if(ra[(i*8) +: 32]>rb[(i*8) +: 32]) begin
									rt_delay[0][(i*8) +: 32] = 32'hFFFFFFFF;
								end
								else begin
									rt_delay[0][(i*8) +: 32] = 32'h00000000;
								end
								// $display(" ra[(i*8) +: 32] = %b %d",ra[(i*8) +: 32],(i*8));
								// $display(" rb[(i*8) +: 32] = %b",rb[(i*8) +: 32]);
								// $display(" rt_delay[(i*8) +: 32] = %b",rt_delay[0][(i*8) +: 32]);
							end
							$display("clgt rt, ra, rb");
							$display("ra =       %h",ra);
							$display("rb =       %h",rb);
							$display("rt_delay = %h",rt_delay[0]);
						end
						default begin
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
				else if (format == 4) begin //RI10-type
					case(op)
						8'b00010110 : begin // andbi rt, ra, imm10 And Byte Immediate
							$display("andbi");
							for(int i=0;i<15;i=i+1) begin
								rt_delay[0][(i*8) +: 8] = ra[(i*8) +: 8] & (imm & 16'h00FF);
							end
							// rt_delay[0] =  ra & rb;
							$display("ra = %h",ra);
							$display("imm10 = %b %b ",imm, (imm[10:17]));
							$display("rt_delay = %h",rt_delay[0]);
						end
						default begin
							rt_delay[0] = 0;
							rt_addr_delay[0] = 0;
							reg_write_delay[0] = 0;
						end

					endcase
				end
				//else if (format == 5) begin
				//end
				//else if (format == 6) begin
				//end
			end
		end
	end
endmodule