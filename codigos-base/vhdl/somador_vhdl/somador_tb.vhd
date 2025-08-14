library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture tb of tb is
	signal val_a, val_b, val_s: std_logic_vector(3 downto 0);
	signal val_co: std_logic;
begin
	stimulus: process
	begin
		for j in 0 to 15 loop
			for i in 0 to 15 loop
				wait for 50 ns;
				val_a <= std_logic_vector(to_unsigned(i, 4));
				val_b <= std_logic_vector(to_unsigned(j, 4));
			end loop;
		end loop;
		report "end of simulation" severity failure;

	end process;

	core: entity work.somador
	port map(	a_i => val_a,
			b_i => val_b,
			s_o => val_s,
			co_o => val_co
	);

end tb;

