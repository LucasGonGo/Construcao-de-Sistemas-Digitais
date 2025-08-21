library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top_counter is
	generic (
		COUNT_WIDTH : integer := 8;
		DEB_DELAY : integer := 1000000;
		HALF_MS_COUNT : integer := 50000
	);
	port (
		clk_i : in std_logic;
		rst_i : in std_logic;
		inkey_i : in std_logic;
		dspl_a : out std_logic;
		dspl_b : out std_logic;
		dspl_c : out std_logic;
		dspl_d : out std_logic;
		dspl_e : out std_logic;
		dspl_f : out std_logic;
		dspl_g : out std_logic;
		dspl_p : out std_logic;
		dspl_an : out std_logic_vector(7 downto 0)
	);
end top_counter;

architecture top_counter_arch of top_counter is
	signal rstn, debkey : std_logic;
	signal count : std_logic_vector(COUNT_WIDTH-1 downto 0);
	signal dp1, dp2, dp3, dp4, dp5, dp6, dp7, dp8 : std_logic_vector(5 downto 0);
	signal anp, ddp : std_logic_vector(7 downto 0);
begin

	rstn <= not rst_i;

	display : entity work.dspl_drv_8dig(dspl_drv_8dig)
		generic map (HALF_MS_COUNT => HALF_MS_COUNT)
		port map (
			clock => clk_i,
			reset => rst_i,
			d1 => dp1,
			d2 => dp2,
			d3 => dp3,
			d4 => dp4,
			d5 => dp5,
			d6 => dp6,
			d7 => dp7,
			d8 => dp8,
			an => anp,
			dec_ddp => ddp
		);
		
	dp1 <= '1' & count(3 downto 0) & '1';
	dp2 <= '1' & count(7 downto 4) & '1';
	dp3 <= (others => '0');
	dp4 <= (others => '0');
	dp5 <= (others => '0');
	dp6 <= (others => '0');
	dp7 <= (others => '0');
	dp8 <= (others => '0');
	dspl_an <= anp;
	dspl_a <= ddp(7);
	dspl_b <= ddp(6);
	dspl_c <= ddp(5);
	dspl_d <= ddp(4);
	dspl_e <= ddp(3);
	dspl_f <= ddp(2);
	dspl_g <= ddp(1);
	dspl_p <= ddp(0);
	
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
