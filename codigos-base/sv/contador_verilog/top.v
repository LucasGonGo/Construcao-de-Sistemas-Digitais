module top_counter #(
	parameter [31:0] COUNT_WIDTH = 8,
	parameter [31:0] DEB_DELAY = 1000000
) (
	input wire clk_i,
	input wire rst_i,
	input wire inkey_i,
	output wire [COUNT_WIDTH - 1:0] count_o
);

	wire rstn; wire debkey;
	wire [COUNT_WIDTH - 1:0] count;

	assign rstn = ~rst_i;
	assign count_o = count;
	
	debounce #(
		.DELAY(DEB_DELAY)
	) deb0 (
		.clk_i(clk_i),
		.rstn_i(rstn),
		.key_i(inkey_i),
		.debkey_o(debkey)
	);

	count #(
		.COUNT_WIDTH(COUNT_WIDTH)
	) cnt0 (
		.clk_i(clk_i),
		.rstn_i(rstn),
		.next_i(debkey),
		.count_o(count)
	);

endmodule
