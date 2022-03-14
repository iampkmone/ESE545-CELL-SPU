module OddPipe(clk, reset, op, format, unit, rt_addr, ra, rb, rt_st_odd, imm, reg_write, pc_in, rt_wb, rt_addr_wb, reg_write_wb, pc_wb, branch_taken);
	input			clk, reset;
	
	//RF/FWD Stage
	input [0:10]	op;				//Decoded opcode, truncated based on format
	input [2:0]		format;			//Format of instr, used with op and imm
	input [1:0]		unit;			//Execution unit of instr (0: Perm, 1: LS, 2: Br, 3: Undefined)
	input [0:6]		rt_addr;		//Destination register address
	input [0:127]	ra, rb, rt_st_odd;	//Values of source registers
	input [0:17]	imm;			//Immediate value, truncated based on format
	input			reg_write;		//Will current instr write to RegTable
	input [7:0]		pc_in;			//Program counter from IF stage
	
	//WB Stage
	output logic [0:127]	rt_wb;			//Output value of Stage 7
	output logic [0:6]		rt_addr_wb;		//Destination register for rt_wb
	output logic			reg_write_wb;	//Will rt_wb write to RegTable
	output logic [7:0]		pc_wb;			//New program counter for branch
	output logic			branch_taken;	//Was branch taken?
	
	//Internal Signals
	logic [6:0][0:127]	fw_wb;			//Staging register for forwarded values
	logic [6:0][0:6]	fw_addr_wb;		//Destination register for rt_wb
	logic [6:0]			fw_write_wb;	//Will rt_wb write to RegTable
	
	logic [0:10]		p1_op;			//Multiplexed opcode
	logic [2:0]			p1_format;		//Multiplexed format
	logic				p1_reg_write;	//Multiplexed reg_write
	logic [0:127]		p1_out;			//Output value of p1 Stage 4
	logic [0:6]			p1_addr_out;	//Destination register for rt_wb
	logic				p1_write_out;	//Will rt_wb write to RegTable
	
	logic [0:10]		ls1_op;			//Multiplexed opcode
	logic [2:0]			ls1_format;		//Multiplexed format
	logic				ls1_reg_write;	//Multiplexed reg_write
	logic [0:127]		ls1_out;		//Output value of ls Stage 6
	logic [0:6]			ls1_addr_out;	//Destination register for rt_wb
	logic				ls1_write_out;	//Will rt_wb write to RegTable
	
	//????????????????
	logic [0:10]		br1_op;			//Multiplexed opcode
	logic [2:0]			br1_format;		//Multiplexed format
	logic				br1_reg_write;	//Multiplexed reg_write
	logic [0:127]		br1_out;		//Output value of br1 Stage 1
	logic [0:6]			br1_addr_out;	//Destination register for rt_wb
	logic				br1_write_out;	//Will rt_wb write to RegTable
	
	
	// TODO : Flesh out and implement execution units
	
	
	Permute p1(.clk(clk), .reset(reset), .op(op), .format(format), .rt_addr(rt_addr), .ra(ra), .rb(rb), .imm(imm), .reg_write(reg_write), .rt_wb(p1_out),
		.rt_addr_wb(p1_addr_out), .reg_write_wb(p1_write_out));
	
	LocalStore ls1(.clk(clk), .reset(reset), .op(op), .format(format), .rt_addr(rt_addr), .ra(ra), .rb(rb), .imm(imm), .reg_write(reg_write), .rt_wb(ls1_out),
		.rt_addr_wb(ls1_addr_out), .reg_write_wb(ls1_write_out));
	
	Branch br1(.clk(clk), .reset(reset), .op(op), .format(format), .rt_addr(rt_addr), .ra(ra), .rb(rb), .imm(imm), .reg_write(reg_write), .pc_in(pc_in), .rt_wb(br1_out),
		.rt_addr_wb(br1_addr_out), .reg_write_wb(br1_write_out), .pc_wb(pc_wb), .branch_taken(branch_taken));
	
	always_comb begin
		fp1_op = 0;
		fp1_format = 0;
		fp1_reg_write = 0;
		
		fx2_op = 0;
		fx2_format = 0;
		fx2_reg_write = 0;
		
		b1_op = 0;
		b1_format = 0;
		b1_reg_write = 0;
		
		case (unit)									//Mux to determine which unit will take the instr
			2'b00 : begin							//Instr going to p1
				p1_op = op;
				p1_format = format;
				p1_reg_write = reg_write;
			end
			2'b01 : begin							//Instr going to ls1
				ls1_op = op;
				ls1_format = format;
				ls1_reg_write = reg_write;
			end
			2'b10 : begin							//Instr going to br1
				br1_op = op;
				br1_format = format;
				br1_reg_write = reg_write;
			end
			default :								//Instr going to p1
				p1_op = op;
				p1_format = format;
				p1_reg_write = reg_write;
			end
		endcase
	end
	
	always_ff @(posedge clk) begin
	
		fw_wb[0] <= 0;								//fw0 doesn't exist, just use 0
		fw_addr_wb[0] <= 0;
		fw_write_wb[0] <= 0;
		
		if (reset == 1) begin
			for (i=6; i>0; i=i-1) begin
				fw_wb [i] <= 0;
				fw_addr_wb [i] <= 0;
				fw_write_wb [i] <= 0;
			end
		end
		else begin
			if (br1_write_out == 1) begin			//Replace fw1 with p1 if possible (??????)
				fw_wb[1] <= br1_out;
				fw_addr_wb[1] <= br1_addr_out;
				fw_write_wb[1] <= br1_write_out;
			end
			else begin
				fw_wb[1] <= fw_wb[0];
				fw_addr_wb[1] <= fw_addr_wb[0];
				fw_write_wb[1] <= fw_write_wb[0];
			end
			
			fw_wb[2] <= fw_wb[1];
			fw_addr_wb[2] <= fw_addr_wb[1];
			fw_write_wb[2] <= fw_write_wb[1];
			
			fw_wb[3] <= fw_wb[2];
			fw_addr_wb[3] <= fw_addr_wb[2];
			fw_write_wb[3] <= fw_write_wb[2];
			
			if (p1_write_out == 1) begin			//Replace fw4 with p1 if possible
				fw_wb[4] <= p1_out;
				fw_addr_wb[4] <= p1_addr_out;
				fw_write_wb[4] <= p1_write_out;
			end
			else begin
				fw_wb[4] <= fw_wb[3];
				fw_addr_wb[4] <= fw_addr_wb[3];
				fw_write_wb[4] <= fw_write_wb[3];
			end
			
			fw_wb[5] <= fw_wb[4];
			fw_addr_wb[5] <= fw_addr_wb[4];
			fw_write_wb[5] <= fw_write_wb[4];
			
			if (ls1_write_out == 1) begin			//Replace fw6 with ls1 if possible
				fw_wb[6] <= ls1_out;
				fw_addr_wb[6] <= ls1_addr_out;
				fw_write_wb[6] <= ls1_write_out;
			end
			else begin
				fw_wb[6] <= fw_wb[5];
				fw_addr_wb[6] <= fw_addr_wb[5];
				fw_write_wb[6] <= fw_write_wb[5];
			end
			
			
			rt_wb <= fw_wb[6];
			rt_addr_wb <= fw_addr_wb[6];
			reg_write_wb <= fw_write_wb[6];
		end
	end
	
endmodule