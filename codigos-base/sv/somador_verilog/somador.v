module somador
(
	input wire [3:0] a_i,
	input wire [3:0] b_i,
	output wire [3:0] s_o,
	output wire co_o
);

	wire [4:0] a_s; wire [4:0] b_s; wire [4:0] s_s;

	assign a_s = {1'b0,a_i};
	assign b_s = {1'b0,b_i};
	assign s_s = a_s + b_s;
	assign s_o = s_s[3:0];
	assign co_o = s_s[4];

endmodule
