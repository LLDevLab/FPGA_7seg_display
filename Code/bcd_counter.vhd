library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_counter is
	port(clk: in std_logic := '0'; bcd: out std_logic_vector(3 downto 0) := X"0");
end entity bcd_counter;

architecture bcd_counter_arch of bcd_counter is
begin
	process(clk)
		variable cnt: unsigned(3 downto 0) := X"0";
	begin
		if(rising_edge(clk)) then
			if(cnt(3) = '1' and cnt(0) = '1') then			-- Если отображаемое на дисплее число равно 9и, следующее значение будет 0
				cnt := X"0";
			else
				cnt := cnt + 1;
			end if;
			
			bcd <= std_logic_vector(cnt);
		end if;
	end process;
end bcd_counter_arch;