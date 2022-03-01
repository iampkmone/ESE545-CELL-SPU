module Pipes(clk, reset);
	input	clk, reset;
	
	RegisterTable r0(.clk(clk), .reset(reset));
	
	EvenPipe e0(.clk(clk), .reset(reset));
	
	OddPipe o0(.clk(clk), .reset(reset));
	
endmodule