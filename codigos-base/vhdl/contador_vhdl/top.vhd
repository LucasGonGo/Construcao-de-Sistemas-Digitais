library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top_counter is
	generic (
		COUNT_WIDTH : integer := 8;
		DEB_DELAY : integer := 1000000
	);
	port (
		clk_i : in std_logic;
		rst_i : in std_logic;
		inkey_i : in std_logic;
		count_o : out std_logic_vector(COUNT_WIDTH-1 downto 0)
	);
end top_counter;

architecture top_counter_arch of top_counter is
	signal rstn, debkey : std_logic;
	signal count : std_logic_vector(COUNT_WIDTH-1 downto 0);
begin

	rstn <= not rst_i;
	count_o <= count;
	
	deb0 : entity work.debounce(debounce_arch)
		generic map(DELAY => DEB_DELAY)
		port map (
			clk_i => clk_i,
			rstn_i => rstn,
			key_i => inkey_i,
			debkey_o => debkey
		);

	cnt0 : entity work.count(count_arch)
		generic map(COUNT_WIDTH => COUNT_WIDTH)
		port map (
			clk_i => clk_i,
			rstn_i => rstn,
			next_i => debkey,
			count_o => count
		);
		
end top_counter_arch;
