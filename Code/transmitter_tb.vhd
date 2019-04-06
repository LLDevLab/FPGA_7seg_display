library ieee;
use ieee.std_logic_1164.all;

entity transmitter_tb is end;

architecture transmitter_tb_arch of transmitter_tb is
	component transmitter is
		port(enable: in boolean; clk: in std_logic; digit_pos: in std_logic_vector(7 downto 0); digit: std_logic_vector(7 downto 0); sclk, dio: out std_logic; ready: buffer boolean);
	end component;

	signal clk: std_logic := '1';
	signal enable_s: boolean;
	signal sclk_s, dio_s: std_logic;
	signal ready_s: boolean;
begin
	enable_s <= true after 20 ns, false after 30 ns;
	clk <= not clk after 5 ns;

	transmitter1: transmitter port map(enable_s, clk, X"80", "11001001", sclk_s, dio_s, ready_s);
end transmitter_tb_arch;