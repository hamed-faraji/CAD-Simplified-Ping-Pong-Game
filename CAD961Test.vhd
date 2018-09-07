-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity CAD961Test is
	Port(
		--//////////// CLOCK //////////
		CLOCK_50 	: in std_logic;
		CLOCK2_50	: in std_logic;
		CLOCK3_50	: in std_logic;
		CLOCK4_50	: inout std_logic;
		
		--//////////// KEY //////////
		RESET_N	: in std_logic;
		Key 		: in std_logic_vector(3 downto 0);
	
		--//////////// SEG7 //////////
		HEX0	: out std_logic_vector(6 downto 0);
		HEX1	: out std_logic_vector(6 downto 0);
		HEX2	: out std_logic_vector(6 downto 0);
		HEX3	: out std_logic_vector(6 downto 0);
		HEX4	: out std_logic_vector(6 downto 0);
		HEX5	: out std_logic_vector(6 downto 0);
	
		--//////////// LED //////////
		LEDR	: out std_logic_vector(9 downto 0);
	
		--//////////// SW //////////
		SW : in std_logic_vector(9 downto 0);
		
		--//////////// SDRAM //////////
		DRAM_ADDR	: out std_logic_vector (12 downto 0);
		DRAM_BA		: out std_logic_vector (1 downto 0); 
		DRAM_CAS_N	: out std_logic;
		DRAM_CKE		: out std_logic;
		DRAM_CLK		: out std_logic;
		DRAM_CS_N	: out std_logic;
		DRAM_DQ		: inout std_logic_vector(15 downto 0);
		DRAM_LDQM	: out std_logic;
		DRAM_RAS_N	: out std_logic;
		DRAM_UDQM	: out std_logic;
		DRAM_WE_N	: out std_logic;
		
		--//////////// microSD Card //////////
		SD_CLK	: out std_logic;
		SD_CMD	: inout std_logic;
		SD_DATA	: inout std_logic_vector(3 downto 0);
		
		--//////////// VGA //////////
		VGA_B		: out std_logic_vector(3 downto 0);
		VGA_G		: out std_logic_vector(3 downto 0);
		VGA_HS	: out std_logic;
		VGA_R		: out std_logic_vector(3 downto 0);
		VGA_VS	: out std_logic;
		
		--//////////// GPIO_1, GPIO_1 connect to LT24 - 2.4" LCD and Touch //////////
		MyLCDLT24_ADC_BUSY		: in std_logic;
		MyLCDLT24_ADC_CS_N		: out std_logic;
		MyLCDLT24_ADC_DCLK		: out std_logic;
		MyLCDLT24_ADC_DIN			: out std_logic;
		MyLCDLT24_ADC_DOUT		: in std_logic;
		MyLCDLT24_ADC_PENIRQ_N	: in std_logic;
		MyLCDLT24_CS_N				: out std_logic;
		MyLCDLT24_D					: out std_logic_vector(15 downto 0);
		MyLCDLT24_LCD_ON			: out std_logic;
		MyLCDLT24_RD_N				: out std_logic;
		MyLCDLT24_RESET_N			: out std_logic;
		MyLCDLT24_RS				: out std_logic;
		MyLCDLT24_WR_N				: out std_logic
	);
end CAD961Test;

--}} End of automatically maintained section

architecture CAD961Test of CAD961Test is

Component VGA_controller
	port ( CLK_50MHz		: in std_logic;
         VS					: out std_logic;
			HS					: out std_logic;
			RED				: out std_logic_vector(3 downto 0);
			GREEN				: out std_logic_vector(3 downto 0);
			BLUE				: out std_logic_vector(3 downto 0);
			RESET				: in std_logic;
			ColorIN			: in std_logic_vector(11 downto 0);
			ScanlineX		: out std_logic_vector(10 downto 0);
			ScanlineY		: out std_logic_vector(10 downto 0)
  );
end component;

Component VGA_board
	port ( CLK_50MHz		: in std_logic;	
			RESET				: in std_logic;
			key0,key1,key2,key3 : in std_logic;
			ColorOut	: out std_logic_vector(11 downto 0); -- RED & GREEN & BLUE
			SQUAREWIDTH		: in std_logic_vector(7 downto 0);
			ScanlineX		: in std_logic_vector(10 downto 0);
			player1score   : inout std_logic_vector(3 downto 0);
			player2score   : inout std_logic_vector(3 downto 0);
			ScanlineY		: in std_logic_vector(10 downto 0);
			start_stop     : in std_logic;
			speedMulti     : in std_logic_vector(3 downto 0);
			single_double  : in std_logic;
			level          : in std_logic
  );
end component;




function convSEG (N : std_logic_vector(3 downto 0)) return std_logic_vector is
		variable ans:std_logic_vector(6 downto 0);
begin
	Case N is
		when "0000" => ans:="1000000";	 
		when "0001" => ans:="1111001";
		when "0010" => ans:="0100100";
		when "0011" => ans:="0110000";
		when "0100" => ans:="0011001";
		when "0101" => ans:="0010010";
		when "0110" => ans:="0000010";
		when "0111" => ans:="1111000";
		when "1000" => ans:="0000000";
		when "1001" => ans:="0010000";	   
		when "1010" => ans:="0001000";
		when "1011" => ans:="0000011";
		when "1100" => ans:="1000110";
		when "1101" => ans:="0100001";
		when "1110" => ans:="0000110";
		when "1111" => ans:="0001110";				
		when others=> ans:="1111111";
	end case;	
	return ans;
end function convSEG;

signal Counter : integer;
signal ScanlineX,ScanlineY	: std_logic_vector(10 downto 0);
signal ColorTable	: std_logic_vector(11 downto 0);
signal player1score_show : std_logic_vector(3 downto 0);
signal player2score_show : std_logic_vector(3 downto 0);
signal countValue : std_logic_vector(6 downto 0):= "0000000";
signal win : std_logic := '0';
signal speedTimer : std_logic_vector(3 downto 0) := "0000";




begin


	 --------- VGA Controller -----------
	 VGA_Control: vga_controller
			port map(
				CLK_50MHz	=> CLOCK3_50,
				VS				=> VGA_VS,
				HS				=> VGA_HS,
				RED			=> VGA_R,
				GREEN			=> VGA_G,
				BLUE			=> VGA_B,
				RESET			=> not RESET_N,
				ColorIN		=> ColorTable,
				ScanlineX	=> ScanlineX,
				ScanlineY	=> ScanlineY
			);
			
			--------- Moving board -----------
		VGA_BR: VGA_board
			port map(
				CLK_50MHz		=> CLOCK3_50,
				RESET				=> not RESET_N,
				key0 				=> key(0),
				key1  			=> key(1),
				key2 				=> key(2),
				key3 				=> key(3),
				ColorOut	      => ColorTable,
				SQUAREWIDTH		=> "00011001",
				ScanlineX		=> ScanlineX,
				player1score   => player1score_show,
				player2score   => player2score_show,
				ScanlineY		=> ScanlineY,
				start_stop     => SW(0) and (not win) ,
				speedMulti     => speedTimer,
				single_double  => SW(1),
				level          => SW(2)
				
			);
			
		--------- 7Segment Show ------------	
		Process(CLOCK_50, RESET_N)
		begin
			if (RESET_N = '0') then
				Counter <= 0; -- reset timer for counter 
				countValue <= "0000000"; -- reset seconds has elapsed
				speedTimer <= (others => '0');
			elsif (rising_edge(CLOCK_50)) then
				if SW(0) = '1' and win = '0' then
				
					if Counter = 40000000 then
						Counter <= 0;
						countValue <= countValue + 1;
						if countValue = 1 then
							speedTimer <= speedTimer+1;
						end if;
						if countValue = 15 then
							speedTimer <= speedTimer+1;
						end if;
						if countValue = 30 then
							speedTimer <= speedTimer+1;
						end if;
						if countValue = 45 then
							speedTimer <= speedTimer+1;
						end if;
						if countValue = 60 then
							speedTimer <= speedTimer+1;
						end if;
						if countValue = 75 then
							countValue <= "0000000";
							Counter <= 0;
						end if;		
					else
						Counter <= Counter +1;
					end if;
				end if; 
			end if;
		end process;
		
		process(CLOCK_50, RESET_N)
		begin
			if (RESET_N = '0') then
				HEX2 <= convSEG("0000");
				HEX3 <= convSEG("0000");
				second <="0000";
				minute<="000";
			elsif (rising_edge(CLOCK_50)) then
				if counter = 40000000 then
					-- timer
					if second = "1001" then
						minute <= minute+1;
						second <="0000";
						HEX2 <= convSEG(second);	
						HEX3 <= convSEG("0"&minute); 
					else
						second <= second+1;
						HEX2 <= convSEG(second);	
						HEX3 <= convSEG("0"&minute); 
					end if;
				end if;
			end if;
		end process;
		
		process(player1score_show,player2score_show,check,win,RESET_N)
		begin
			if (RESET_N = '0' or (check = '1' and win='0'and wintemp = '0')) then
				HEX0 <= convSEG("0001");
				HEX1 <= convSEG("0010");
				HEX4 <= convSEG("0011");
				HEX5 <= convSEG("0011");
				win <= '0';
				check <= '1';
			elsif (SW(0) = '1' or check = '0') then 	
				if player2score_show < 10 then  
					HEX0 <= convSEG(player2score_show);
					HEX1 <= convSEG("0000");
				else
					HEX1 <= convSEG("0001");
					Hex0 <= convSEG("000" & player2score_show(0));
					if player2score_show(0) = '1' then
						win <= '1';
					end if;
				end if;
				if  player1score_show < 10 then 
					HEX4 <= convSEG(player1score_show);
					HEX5 <= convSEG("0000");
				else   
					HEX5 <= convSEG("0001");
					Hex4 <= convSEG("000" & player1score_show(0));
					if player1score_show(0) = '1' then
						win <= '1';
					end if;
				end if;
				check <= '0';
				else
			end if;
			-- check for end game by finishing time
			if countValue = 75 then 
				win <= '1'; 
			end if;
		end process;
		process(wintemp,RESET_N)
		begin
			if RESET_N = '0' then 
				wintemp <= '0';
			elsif SW(0) = '1' then
				wintemp <= '1';
			else
				wintemp <= '0';
			end if;
		end process;
		-- show LED after win = 1
		
	 LEDR <= (others => '1') when win = '1'
	 else (others => '0');	
	 
end CAD961Test;