library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb is
	generic (
		COUNT_WIDTH : integer := 8;
		DEB_DELAY : integer := 250;
		HALF_MS_COUNT : integer := 5
	);
end tb;

architecture tb of tb is
	signal clock, reset, key : std_logic := '0';
	signal dspl_a, dspl_b, dspl_c, dspl_d, dspl_e, dspl_f, dspl_g, dspl_p : std_logic; 
	signal dspl_an : std_logic_vector(7 downto 0);
begin

	reset <= '1', '0' after 500 ns;

	clk: process						-- 100Mhz system clock
	begin
		clock <= not clock;
		wait for 5 ns;
		clock <= not clock;
		wait for 5 ns;
	end process;
	
	
	input: process
	begin
		wait for 20000 ns;
		key <= not key;
		wait for 10 ns;
		key <= not key;
		wait for 20 ns;
		key <= not key;
		wait for 30 ns;
		key <= not key;
		wait for 40 ns;
		key <= not key;
		wait for 50 ns;
		key <= not key;
		wait for 60 ns;
		key <= not key;
		wait for 70 ns;
		key <= not key;
		wait for 80 ns;
		key <= not key;
		wait for 10000 ns;
		key <= not key;
		wait for 50 ns;
		key <= not key;
		wait for 40 ns;
		key <= not key;
		wait for 30 ns;
		key <= not key;
		wait for 30 ns;
		key <= not key;
	end process;
	
	
	core: entity work.top_counter
	generic map(
		COUNT_WIDTH => COUNT_WIDTH,
		DEB_DELAY => DEB_DELAY,
		HALF_MS_COUNT => HALF_MS_COUNT)
	port map (
		clk_i => clock,
		rst_i => reset,
		inkey_i => key,
		dspl_a => dspl_a,
		dspl_b => dspl_b,
		dspl_c => dspl_c,
		dspl_d => dspl_d,
		dspl_e => dspl_e,
		dspl_f => dspl_f,
		dspl_g => dspl_g,
		dspl_p => dspl_p,
		dspl_an => dspl_an
	);


end tb;

