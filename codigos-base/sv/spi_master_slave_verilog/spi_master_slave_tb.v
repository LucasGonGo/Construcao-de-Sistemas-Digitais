`timescale 1ns / 1ps
module spi_master_slave_tb #(
	parameter [7:0] BYTE_SIZE = 8
) ();
	// clock and reset
	reg clock;
	reg reset;
	
	// design inputs and outputs
	reg spi_ssn; reg we; reg spi_di; reg spi_clki;
	wire [BYTE_SIZE-1:0] in;
	wire [BYTE_SIZE-1:0] out;
	wire [8:0] clk_div;
	
	reg [15:0] i;
	
	// DUT instantiation
	spi_master_slave #(
		.BYTE_SIZE(BYTE_SIZE)
	) dut (
		.clk_i(clock),
		.rst_i(reset),
		.data_i(in),
		.data_o(out),
		.data_valid_o(valid),
		.wren_i(we),
		.clk_div_i(clk_div),
		.spi_ssn_i(spi_ssn),
		.spi_clk_i(spi_clki),
		.spi_clk_o(spi_clko),
		.spi_do_o(spi_do),
		.spi_di_i(spi_di)
	);

	// reset generation
	initial begin
		reset = 1'b1;
		#500
		reset = 1'b0;
	end

	// clock generation
	initial begin
		clock = 1'b0;
		forever #20 clock = ~clock;
	end
	
	assign clk_div = 9'b000000001;
	//assign in = {(BYTE_SIZE){'ha1}};
	assign in = 8'ha1;

	// test stimulus
	initial begin
		spi_ssn = 1'b1;
		#5600
		spi_ssn = 1'b0;
	end
	
	initial begin
		we = 1'b0;
		#1002
		we = 1'b1;
		#3600
		we = 1'b0;
	end
	
	initial begin
		spi_di = 1'b0;
		#6050 spi_di = 1'b1;
		#200 spi_di = 1'b1;
		#200 spi_di = 1'b1;
		#200 spi_di = 1'b1;
		#200 spi_di = 1'b0;
		#200 spi_di = 1'b0;
		#200 spi_di = 1'b0;
		#200 spi_di = 1'b0;
		#200 spi_di = 1'b1;
		#200 spi_di = 1'b1;
		#200 spi_di = 1'b0;
		#200 spi_di = 1'b0;
		#200 spi_di = 1'b0;
		#200 spi_di = 1'b0;
		#200 spi_di = 1'b1;
		#200 spi_di = 1'b1;
	end
	
	initial begin
		spi_clki = 1'b0;
		#5900
		for (i = 0; i < 16; i = i + 1) begin
			#200
			spi_clki = ~spi_clki;
		end
		#800
		for (i = 0; i < 16; i = i + 1) begin
			#200
			spi_clki = ~spi_clki;
		end
	end
	
	initial begin
		$dumpfile("spi_master_slave_tb.vcd");
		$dumpvars(0, spi_master_slave_tb);	
		#15000
		$display("end of simulation");
		$finish(0);
	end
	
endmodule : spi_master_slave_tb
