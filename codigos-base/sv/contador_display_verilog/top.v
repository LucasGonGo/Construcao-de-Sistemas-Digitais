module top_counter
(
	input wire clk_i,
	input wire rst_i,
	input wire inkey_i,
	output wire dspl_a,
	output wire dspl_b,
	output wire dspl_c,
	output wire dspl_d,
	output wire dspl_e,
	output wire dspl_f,
	output wire dspl_g,
	output wire dspl_p,
	output wire [7:0] dspl_an
);

	parameter [31:0] COUNT_WIDTH=8;
	parameter [31:0] DEB_DELAY=1000000;
	parameter [31:0] HALF_MS_COUNT=50000;

	wire rstn; wire debkey;
	wire [COUNT_WIDTH - 1:0] count;
	wire [5:0] dp1; wire [5:0] dp2; wire [5:0] dp3; wire [5:0] dp4; wire [5:0] dp5; wire [5:0] dp6; wire [5:0] dp7; wire [5:0] dp8;
	wire [7:0] anp; wire [7:0] ddp;

	assign rstn =  ~rst_i;

	dspl_drv_8dig #(
		.HALF_MS_COUNT(HALF_MS_COUNT))
	display(
		.clock(clk_i),
		.reset(rst_i),
		.d1(dp1),
		.d2(dp2),
		.d3(dp3),
		.d4(dp4),
		.d5(dp5),
		.d6(dp6),
		.d7(dp7),
		.d8(dp8),
		.an(anp),
		.dec_ddp(ddp)
	);

	assign dp1 = {1'b1,count[3:0],1'b1};
	assign dp2 = {1'b1,count[7:4],1'b1};
	assign dp3 = {6{1'b0}};
	assign dp4 = {6{1'b0}};
	assign dp5 = {6{1'b0}};
	assign dp6 = {6{1'b0}};
	assign dp7 = {6{1'b0}};
	assign dp8 = {6{1'b0}};
	assign dspl_an = anp;
	assign dspl_a = ddp[7];
	assign dspl_b = ddp[6];
	assign dspl_c = ddp[5];
	assign dspl_d = ddp[4];
	assign dspl_e = ddp[3];
	assign dspl_f = ddp[2];
	assign dspl_g = ddp[1];
	assign dspl_p = ddp[0];

	debounce #(
		.DELAY(DEB_DELAY))
	deb0(
		.clk_i(clk_i),
		.rstn_i(rstn),
		.key_i(inkey_i),
		.debkey_o(debkey)
	);

	count #(
		.COUNT_WIDTH(COUNT_WIDTH))
	cnt0(
		.clk_i(clk_i),
		.rstn_i(rstn),
		.next_i(debkey),
		.count_o(count)
	);

endmodule
