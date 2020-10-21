`timescale 1ns/1ps

module testbench();
	localparam N = 8;
	
	localparam [N-1:0] b1 = 53;
	localparam [N-1:0] b0 = 53;
	localparam [N-1:0] a1 = 21;
	
 	wire clk;
	wire rst_n;
	wire end_sim;
	
	wire [N-1:0] input_data;
	wire [N-1:0] output_data;
	
	wire vin;
	wire vout;
	
	// Testbench infrastructure
	clk_gen 
		comp_CG(.END_SIM(end_sim), .CLK(clk), .RST_N(rst_n));
	dataGen 
		#(.NB(N))
		comp_dataGen(
			.clk(clk), 
			.rst_n(rst_n), 
			.data_out(input_data), 
			.end_sim(end_sim),
			.vout(vin)
		);
	dataSink 
		#(.NB(8))
		comp_dataSink(
			.clk(clk),
			.rst_n(rst_n),
			.vout(vout),
			.vin(vin),
			.din(output_data)
		);
		
	// IIR filter
	IIRFilter comp_IIRFilter(
		.CLK(clk),
		.RST_n(rst_n),
		.b1(b1),
		.b0(b0),
		.a1(a1),
		.VIN(vin),
		.DIN(input_data),
		.DOUT(output_data),
		.VOUT(vout)
	);
endmodule
