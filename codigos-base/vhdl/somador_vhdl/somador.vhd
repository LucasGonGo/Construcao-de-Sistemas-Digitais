library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity somador is
	port (
		a_i: in std_logic_vector(3 downto 0);
		b_i: in std_logic_vector(3 downto 0);
		s_o: out std_logic_vector(3 downto 0);
		co_o: out std_logic
	);
end somador;

architecture somador_arch of somador is
	signal a_s, b_s, s_s : std_logic_vector(4 downto 0);
begin
	a_s <= '0' & a_i;
	b_s <= '0' & b_i;
	s_s <= a_s + b_s;
	s_o <= s_s(3 downto 0);
	co_o <= s_s(4);
end somador_arch;
