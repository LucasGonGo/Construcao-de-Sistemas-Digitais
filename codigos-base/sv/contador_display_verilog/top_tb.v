`timescale 1ns / 1ps
module top_tb #(
	parameter [31:0] COUNT_WIDTH = 8,
	parameter [31:0] DEB_DELAY = 250,
	parameter [31:0] HALF_MS_COUNT = 5
) ();
	// clock and reset
	reg clock;
	reg reset;
	
	// design inputs and outputs
	reg key;
	wire dspl_a, dspl_b, dspl_c, dspl_d, dspl_e, dspl_f, dspl_g, dspl_p;
	wire [7:0] dspl_an;
	
	reg [15:0] i;

	// DUT instantiation
	top_counter #(
		.COUNT_WIDTH(COUNT_WIDTH),
		.DEB_DELAY(DEB_DELAY),
		.HALF_MS_COUNT(HALF_MS_COUNT)
	) dut (
		.clk_i(clock),
		.rst_i(reset),
		.inkey_i(key),
		.dspl_a(dspl_a),
		.dspl_b(dspl_b),
		.dspl_c(dspl_c),
		.dspl_d(dspl_d),
		.dspl_e(dspl_e),
		.dspl_f(dspl_f),
		.dspl_g(dspl_g),
		.dspl_p(dspl_p),
		.dspl_an(dspl_an)
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
		forever #5 clock = ~clock;
	end

	// test stimulus
	initial begin
		i = 0;
		key = 1'b0;
		
		$dumpfile("top_tb.vcd");
		$dumpvars(0, top_tb);	
		
		for (i = 0; i < 10; i = i + 1) begin
			$monitor("time=%1d, loop=%1d", $time, i);
			#20000
			key = ~key;
			#10
			key = ~key;
			#20
			key = ~key;
			#30
			key = ~key;
			#40
			key = ~key;
			#50
			key = ~key;
			#60
			key = ~key;
			#70
			key = ~key;
			#80
			key = ~key;
			#10000
			key = ~key;
			#50
			key = ~key;
			#40
			key = ~key;
			#30
			key = ~key;
			#30
			key = ~key;
		end
		$display("end of simulation");
		$finish(0);
	end
endmodule : top_tb
