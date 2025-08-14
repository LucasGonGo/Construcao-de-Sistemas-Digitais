`timescale 1ns / 1ps
module somador_tb ();
	// design inputs and outputs
	reg [3:0] val_a;
	reg [3:0] val_b;
	wire [3:0] val_s;
	wire val_co;
	
	reg [15:0] i, j;

	// DUT instantiation
	somador dut
	(
		.a_i(val_a),
		.b_i(val_b),
		.s_o(val_s),
		.co_o(val_co)
	);

	// test stimulus
	initial begin
		i = 0;
		j = 0;
		
		$dumpfile("somador_tb.vcd");
		$dumpvars(0, somador_tb);	
		
		for (j = 0; j < 16; j = j + 1) begin
			for (i = 0; i < 16; i = i + 1) begin
				#50
				val_a <= i;
				val_b <= j;
			end
		end
		$display("end of simulation");
		$finish(0);
	end
endmodule : somador_tb
