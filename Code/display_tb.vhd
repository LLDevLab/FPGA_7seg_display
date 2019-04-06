library ieee;
use ieee.std_logic_1164.all;

entity display_tb is end;

architecture display_tb_arch of display_tb is
	component display is
		port(clk: in std_logic; sclk, rclk, dio: out std_logic);
	end component;
	
	signal clk: std_logic := '0';
	signal sclk_s, rclk_s, dio_s: std_logic;
begin
	dispaly1: display port map(clk, sclk_s, rclk_s, dio_s);
	
	clk <= not clk after 5 ns;

end display_tb_arch;