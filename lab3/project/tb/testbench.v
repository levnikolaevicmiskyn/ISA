`timescale 1ns/1ps

module testbench();

	wire clk;
	wire rst_n;
	wire dump;
	wire phy_data_mem_wr_en;
	wire [31:0] phy_data_mem_addr;
	wire [31:0] phy_data_mem_in;
	wire [31:0] phy_data_mem_out;
	wire [31:0] phy_instr_mem_in;
	wire [31:0] phy_instr_mem_out;
	wire [31:0] phy_instr_mem_addr;

	// Testbench infrastructure

	riscvProcessor compProc(.clk(clk), 
							.rst_n(rst_n),
							.phy_data_mem_addr(phy_data_mem_addr),
							.phy_instr_mem_addr(phy_instr_mem_addr),
							.phy_data_mem_in(phy_data_mem_in),
							.phy_instr_mem_out(phy_instr_mem_out),
							.phy_data_mem_out(phy_data_mem_out),
							.phy_data_mem_wr_en(phy_data_mem_wr_en));
							
	tbController compControl(.clk(clk), .rst_n(rst_n), .dump(dump));
	
	Memory #(	.SIZE(1024),
				.filename_in("machinecode.txt"), 
				.filename_out("machinecode-dump.txt"))
	compInstrMemory(.clk(clk),
					.dump(1'b0),
					.address(phy_instr_mem_addr),
					.wr_en(1'b0),
					.data_in({32{1'b0}}),
					.data_out(phy_instr_mem_out));
					
	
					
	Memory #(	.SIZE(1024),
				.filename_in("machinedata.txt"), 
				.filename_out("machinedata-dump.txt"))
	compDataMemory(	.clk(clk),
					.dump(dump),
					.address(phy_data_mem_addr),
					.wr_en(phy_data_mem_wr_en),
					.data_in(phy_data_mem_in),
					.data_out(phy_data_mem_out));
					
endmodule
						
