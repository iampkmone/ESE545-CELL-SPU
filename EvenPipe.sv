module EvenPipe(clk, reset, op, format, unit, rt_addr, ra, rb, rc, imm, reg_write, rt_wb, rt_addr_wb, reg_write_wb);
	input			clk, reset;
	
	//RF/FWD Stage
	input [0:10]	op;				//Decoded opcode, truncated based on format
	input [2:0]		format;			//Format of instr, used with op and imm
	input [1:0]		unit;			//Execution unit of instr (0: FP, 1: FX2, 2: Byte, 3: FX1)
	input [0:6]		rt_addr;		//Destination register address
	input [0:127]	ra, rb, rc;		//Values of source registers
	input [0:17]	imm;			//Immediate value, truncated based on format
	input			reg_write;		//Will current instr write to RegTable
	
	//WB Stage
	output [0:127]	rt_wb;			//Output value of Stage 7
	output [0:6]	rt_addr_wb;		//Destination register for rt_wb
	output			reg_write_wb;	//Will rt_wb write to RegTable
	
	
	// TODO : Flesh out and implement execution units, implement forwarding pipeline
	
	
	SinglePrecision fp1(.clk(clk), .reset(reset));
	
	SimpleFixed2 fx2(.clk(clk), .reset(reset));
	
	Byte b1(.clk(clk), .reset(reset));
	
	SimpleFixed1 fx1(.clk(clk), .reset(reset));
	
endmodule