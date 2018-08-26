library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity VGA_board is
  port ( CLK_50MHz		: in std_logic;
			RESET				: in std_logic;
			key0,key1,key2,key3 : in std_logic;
			ColorOut			: out std_logic_vector(11 downto 0); -- RED & GREEN & BLUE
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
end VGA_board;

architecture Behavioral of VGA_board is

Component pseudorng
	Port ( clock : in STD_LOGIC;
			reset : in STD_LOGIC;
			en : in STD_LOGIC;
			Q : out STD_LOGIC_VECTOR (7 downto 0)
			);
end component;
Component AI_player
	port (
	board2Y,
	squareX,
	squareY:in std_logic_vector(9 downto 0);
	SquareXMoveDir,
	SquareYMoveDir,
	level,
	reset,
	single_double:in std_logic;
	SquareXmax: std_logic_vector(9 downto 0);
	SquareYmax: std_logic_vector(9 downto 0);
	board2Yout	:out std_logic_vector(1 downto 0)
  );
end component;

  signal ColorOutput: std_logic_vector(11 downto 0);
  signal SquareX: std_logic_vector(9 downto 0) := "0000001011";  
  signal SquareY: std_logic_vector(9 downto 0) := "0011110000";  
  signal board1X: std_logic_vector(9 downto 0) := "0000000011";  
  signal board1Y: std_logic_vector(9 downto 0) := "0010111110";
  signal board2X: std_logic_vector(9 downto 0) := "1001111111";  
  signal board2Y: std_logic_vector(9 downto 0) := "0010111110";
  signal SquareXMoveDir, SquareYMoveDir: std_logic := '0';
  --constant SquareWidth: std_logic_vector(4 downto 0) := "11001";
  constant SquareXmin: std_logic_vector(9 downto 0) := "0000000001";
  signal SquareXmax: std_logic_vector(9 downto 0); -- := "1010000000"-SquareWidth;
  constant SquareYmin: std_logic_vector(9 downto 0) := "0000000001";
  signal SquareYmax: std_logic_vector(9 downto 0); -- := "0111100000"-SquareWidth;
  
  constant boardYmin: std_logic_vector(9 downto 0) := "0000000001";
  signal boardXmax: std_logic_vector(9 downto 0); -- := "1010000000"-SquareWidth;
  signal boardYmax: std_logic_vector(9 downto 0); -- := "1010000000"-SquareWidth;


  
  signal ColorSelect: std_logic_vector(2 downto 0) := "001";
  signal Prescaler: std_logic_vector(30 downto 0) := (others => '0');
  signal Prescaler1: std_logic_vector(30 downto 0) := (others => '0');
  signal Prescaler2: std_logic_vector(30 downto 0) := (others => '0');
  
  signal midlineX: std_logic_vector(9 downto 0) := "0101000000";
  signal midlineY: std_logic_vector(9 downto 0) := "0000000000";
  signal midlineWidth: std_logic_vector(9 downto 0) := "0000000111";
  signal random : STD_LOGIC_VECTOR (7 downto 0);
  
  signal player1scoreflag : std_logic :='0';
  signal player2scoreflag : std_logic :='0';
  signal AIMoveDir : std_logic_vector(1 downto 0) := "11";


begin

GA_pseudorng: pseudorng
			port map(
				clock => CLK_50Mhz,
				reset => RESET,
				en => '1',
				Q => random
			);
			
			VGA_player : AI_player
			port map(
				board2Y        => board2Y,
				reset				=> RESET,
				squareX			=> SquareX,
				squareY			=> SquareY,
				SquareXMoveDir => SquareXMoveDir,
				SquareYMoveDir => SquareYMoveDir,
				level          => level,
				single_double  => single_double,
				SquareXmax     => SquareXmax,
				SquareYmax 		=> SquareYmax,
				board2Yout     => AIMoveDir
			);
			
			
			process(CLK_50Mhz, RESET)
	begin
		if RESET = '1' then
			Prescaler1 <= (others => '0');
			board1X <= "0000000111";
			board1Y <= "0010111110";
		elsif rising_edge(CLK_50Mhz) then
		if start_stop = '1' then 
			Prescaler1 <= Prescaler1 + 1;	 
			if Prescaler1 = "111111011111100000" then  -- Activated every 0,004 sec (4 msec)
				if key0 = '0' then
					if board1Y < BoardYmax then
						board1Y <= board1Y + 1;
					else
						board1Y  <= BoardYmax ;
					end if;
				elsif key1 = '0' then
					if board1Y > SquareYmin then
						board1Y <= board1Y - 1;
					else
						board1Y <= "0000000000";
					end if;	 
				end if;
				Prescaler1 <= (others => '0');
			end if;
			end if;
		end if;
	end process;





end Behavioral;