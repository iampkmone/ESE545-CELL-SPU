module CellSPU(clk, reset);
	input	clk, reset;
	
	Pipes p0(.clk(clk), .reset(reset));
	
endmodule
