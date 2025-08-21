library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity count is          
	generic(COUNT_WIDTH: integer := 8);
	port(
		clk_i: in std_logic;
		rstn_i: in std_logic;
		next_i: in std_logic;
		count_o: out std_logic_vector(COUNT_WIDTH-1 downto 0)
	);
end count;

architecture count_arch of count is
	signal count_reg: std_logic_vector(COUNT_WIDTH-1 downto 0);
	signal next_i_dly: std_logic;
begin
	process(clk_i, rstn_i)
	begin
		if rstn_i = '0' then
			count_reg <= (others => '0');
			next_i_dly <= '0';
		elsif clk_i'event and clk_i = '1' then
			next_i_dly <= next_i;
			if next_i = '1' and next_i_dly = '0' then
				count_reg <= count_reg + 1;
			end if;
		end if;
	end process;
	
	count_o <= count_reg;
	
end count_arch;
