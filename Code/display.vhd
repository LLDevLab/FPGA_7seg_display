library ieee;
use ieee.std_logic_1164.all;

entity display is
	port(clk: in std_logic; sclk, rclk, dio: out std_logic := '0');
end entity display;

architecture display_arch of display is
	component delay is
		generic (delay_cnt: integer); 
		port(clk: in std_logic; out_s: out std_logic := '0');
	end component;
	
	component bcd_counter is
		port(clk: in std_logic; bcd: out std_logic_vector(3 downto 0));
	end component;
	
	component bcd_to_7seg is
		port(bcd: in std_logic_vector(3 downto 0); disp_out: out std_logic_vector(7 downto 0));
	end component;
	
	component transmitter is
		port(enable: in boolean; clk: in std_logic; digit_pos: in std_logic_vector(7 downto 0); digit: std_logic_vector(7 downto 0); sclk, dio: out std_logic; ready: buffer boolean);
	end component;
	
	signal sec_s: std_logic := '0';
	signal bcd_counter_s: std_logic_vector(3 downto 0) := X"0";
	signal disp_out_s: std_logic_vector(7 downto 0) := X"00";
	
	signal tr_enable_s: boolean;
	signal tr_ready_s: boolean;
	signal tr_data_s: std_logic_vector(7 downto 0) := X"00";
	
	-- Этот флаг, совместно с tr_ready_s контролирует установку и сброс rclk сигнала 
	signal disp_refresh_s: boolean;							
	
	signal transfer_clk: std_logic := '0';
begin
	sec_delay: delay 
				generic map(25_000_000)	
				port map(clk, sec_s);
				
	transfer_delay: delay 
				generic map(10)								
				port map(clk, transfer_clk);
				
	
	bcd_counter1: bcd_counter port map(sec_s, bcd_counter_s);
	
	bcd_to_7seg1: bcd_to_7seg port map(bcd_counter_s, disp_out_s);
	
	transmitter1: transmitter port map(tr_enable_s, transfer_clk, X"10", tr_data_s, sclk, dio, tr_ready_s);
	
	tr_proc: process(transfer_clk)
		variable prev_disp: std_logic_vector(7 downto 0);
		variable rclk_v: std_logic := '0';
	begin
		if(rising_edge(transfer_clk)) then
			if(tr_ready_s) then								-- Если передатчик готов к передаче следующей порции данных
				if(not (prev_disp = disp_out_s)) then		-- Если передаваемые данные не были только что переданы 
					prev_disp := disp_out_s;
					tr_data_s <= disp_out_s;				-- Помещаем передаваемые данные в шину данных передатчика
					tr_enable_s <= true;					-- Запускаем передачу данных
				end if;
			else
				disp_refresh_s <= true;
				
				-- Флаг запуска передачи данных нужно снять до завершения передачи, по этому снимаю его по приходу следующего частотного сигнала
				tr_enable_s <= false;						
			end if;
			
			if(rclk_v = '1') then
				disp_refresh_s <= false;
			end if;
			
			if(tr_ready_s and disp_refresh_s) then			-- 
				rclk_v := '1';
			else
				rclk_v := '0';
			end if;
			
			rclk <= rclk_v;
		end if;		
	end process tr_proc;
	
end display_arch;