library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;

entity AI_player is	
	port( 
	
	squareX,squareY,Board2Y:in std_logic_vector(9 downto 0);
	SquareXMoveDir, SquareYMoveDir,level,single_double,reset:in std_logic;
	SquareXmax: std_logic_vector(9 downto 0);
	SquareYmax: std_logic_vector(9 downto 0);
	board2Yout	:out std_logic_vector(1 downto 0)
	
	);
end AI_player;

architecture AI_player of AI_player is								
signal boardOutTemp : std_logic_vector(1 downto 0) := "11";	
signal tempMode :std_logic_vector(9 downto 0);
signal lastX : std_logic_vector(9 downto 0) := (others => '0');
signal tempDivide :std_logic_vector(9 downto 0);
signal nextPosition :std_logic_vector(9 downto 0);
signal tempPosition :std_logic_vector(9 downto 0);

begin

end AI_player;