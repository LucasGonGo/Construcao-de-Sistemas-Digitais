module count #(
	parameter [31:0] COUNT_WIDTH = 8
) (
	input wire clk_i,
	input wire rstn_i,
	input wire next_i,
	output wire [COUNT_WIDTH - 1:0] count_o
);
	reg [COUNT_WIDTH - 1:0] count_reg;
	reg next_i_dly;

	always @(posedge clk_i, negedge rstn_i) begin
		if (rstn_i == 1'b0) begin
			count_reg <= {(COUNT_WIDTH){1'b0}};
			next_i_dly <= 1'b0;
		end else begin
			next_i_dly <= next_i;
			if (next_i == 1'b1 && next_i_dly == 1'b0) begin
				count_reg <= count_reg + 1;
			end
		end
	end

	assign count_o = count_reg;

endmodule
