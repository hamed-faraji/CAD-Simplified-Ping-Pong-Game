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




  signal random : STD_LOGIC_VECTOR (7 downto 0);


begin

GA_pseudorng: pseudorng
			port map(
				clock => CLK_50Mhz,
				reset => RESET,
				en => '1',
				Q => random
			);





end Behavioral;