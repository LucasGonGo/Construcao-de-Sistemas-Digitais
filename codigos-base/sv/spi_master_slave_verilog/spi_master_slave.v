// file:          spi_master_slave.vhd
// description:   SPI master slave interface
// date:          01/2019
// author:        Sergio Johann Filho <sergio.filho@pucrs.br>
//
// This is a simple SPI master / slave interface that works in SPI MODE 0.
// Chip select logic is not included and selects the operating mode (spi_ssn_i <= '0'
// for slave mode and spi_ssn_i <= '1' for master mode). The usual terminology of the
// clock and data buses (SCK, MISO and MOSI) is changed because the interface can act
// in both modes. So, the SPI clock bus works in either direction and MISO, MOSI data
// buses are changed to DI and DO respectively.
// no timescale needed

module spi_master_slave#(
	parameter [7:0] BYTE_SIZE = 8
) (
	// core interface
	input wire clk_i,
	input wire rst_i,
	input wire [BYTE_SIZE - 1:0] data_i,	// parallel data in (clocked on rising spi_clk after last bit)
	output wire [BYTE_SIZE - 1:0] data_o,	// parallel data output (clocked on rising spi_clk after last bit)
	output reg data_valid_o,		// data valid (read / write finished)
	input wire wren_i,			// data write enable, starts transmission when interface is idle
	input wire [8:0] clk_div_i,		// SPI clock divider
	// SPI interface
	input wire spi_ssn_i,			// spi slave select negated input
	input wire spi_clk_i,			// spi slave clock input
	output reg spi_clk_o,			// spi master clock output
	output reg spi_do_o,			// spi mosi (master mode) or miso (slave mode)
	input wire spi_di_i			// spi miso (master mode) or mosi (slave mode)
);
	parameter [2:0] idle = 0, data1 = 1, clock1 = 2, data2 = 3, clock2 = 4, sdata1 = 5, sdata2 = 6, done = 7;

	reg [2:0] state;
	reg [BYTE_SIZE - 1:0] data_reg;
	reg [8:0] clk_cnt;
	reg [8:0] counter;
	wire fsm_trigger;

	always @(posedge clk_i, posedge rst_i) begin
		if (rst_i == 1'b1) begin
			clk_cnt <= {9{1'b0}};
		end else begin
			if ((clk_cnt < clk_div_i)) begin
				clk_cnt <= clk_cnt + 1;
			end
			else begin
				clk_cnt <= {9{1'b0}};
			end
		end
	end

	assign fsm_trigger = clk_cnt == 9'b000000000 || spi_ssn_i == 1'b0 ? 1'b1 : 1'b0;
  
	always @(posedge clk_i, posedge rst_i) begin
		if (rst_i == 1'b1) begin
			data_reg <= {((BYTE_SIZE - 1)-(0)+1){1'b0}};
			counter <= {9{1'b0}};
			data_valid_o <= 1'b0;
			spi_clk_o <= 1'b0;
			spi_do_o <= 1'b0;
		end else begin
			if ((fsm_trigger == 1'b1)) begin
				case(state)
				idle : begin
					counter <= {9{1'b0}};
					spi_clk_o <= 1'b0;
					spi_do_o <= 1'b0;
					data_valid_o <= 1'b0;
					data_reg <= data_i;
				end
				data1 : begin
					data_valid_o <= 1'b0;
					spi_do_o <= data_reg[BYTE_SIZE - 1];
				end
				clock1 : begin
					spi_clk_o <= 1'b1;
				end
				data2 : begin
					data_reg <= {data_reg[BYTE_SIZE - 2:0],spi_di_i};
				end
				clock2 : begin
					spi_clk_o <= 1'b0;
					counter <= counter + 1;
				end
				sdata1 : begin
					data_valid_o <= 1'b0;
					spi_do_o <= data_reg[BYTE_SIZE - 1];
				end
				sdata2 : begin
					if ((spi_clk_i == 1'b0)) begin
						data_reg <= {data_reg[BYTE_SIZE - 2:0],spi_di_i};
						spi_do_o <= data_reg[BYTE_SIZE - 1];
						counter <= counter + 1;
					end
				end
				done : begin
					counter <= {9{1'b0}};
					data_valid_o <= 1'b1;
					spi_do_o <= 1'b0;
				end
				default : begin
				end
				endcase
			end
		end
	end

	assign data_o = data_reg;
	
	always @(posedge clk_i, posedge rst_i) begin
		if (rst_i == 1'b1) begin
			state <= idle;
		end else begin
			if ((fsm_trigger == 1'b1)) begin
				case(state)
				idle : begin
					if ((spi_ssn_i == 1'b1)) begin
						if ((wren_i == 1'b1)) begin
							state <= data1;
						end
					end
					else begin
						state <= sdata1;
					end
				end
				data1 : begin
					state <= clock1;
				end
				clock1 : begin
					state <= data2;
				end
				data2 : begin
					state <= clock2;
				end
				clock2 : begin
					if ((counter < (BYTE_SIZE - 1))) begin
						state <= data1;
					end
					else begin
						state <= done;
					end
				end
				sdata1 : begin
					if ((spi_clk_i == 1'b1)) begin
						state <= sdata2;
					end
				end
				sdata2 : begin
					if ((spi_clk_i == 1'b0)) begin
						if ((counter < (BYTE_SIZE - 1))) begin
							state <= sdata1;
						end
						else begin
							state <= done;
						end
					end
				end
				done : begin
					if ((spi_ssn_i == 1'b1)) begin
						if ((wren_i == 1'b0)) begin
							state <= idle;
						end
					end
					else begin
						if ((spi_clk_i == 1'b1)) begin
							state <= sdata1;
						end
					end
				end
				default : begin
				end
				endcase
			end
		end
	end

endmodule
