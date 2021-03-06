`timescale 1ns/1ps

module testbench();
	localparam N = 32;
	
	wire clk, end_sim;
	wire [N-1:0] input_data;
	wire [N-1:0] output_data;
	
	// Testbench infrastructure
	clk_gen comp_CG	(
						.CLK(clk)
					);
					
	dataGen 
		#(.N(N))
		comp_dataGen(
			.clk(clk),  
			.end_sim(end_sim),
			.data_out(input_data)
		);
		
	dataSink 
		#(.N(N))
		comp_dataSink(
			.clk(clk),
			.end_sim(end_sim),
			.din(output_data)
		);
		
	FPmul comp_FPmul(
						.FP_A(input_data),
						.FP_B(input_data),
						.clk(clk),
						.FP_Z(output_data)
					);
endmodule
