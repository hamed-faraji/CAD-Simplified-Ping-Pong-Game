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

	function modOperator ( x,y    : in std_logic_vector(9 downto 0))
		return std_logic_vector is
		variable modResult : std_logic_vector(9 downto 0) := (others => '0');
	begin
		modResult := x;
		for i in 0 to 4 loop
			if x >= y then 
		  modResult := modResult - y;
			end if;
		end loop;
		return modResult; 
	end function modOperator;
	
	function divideOperator ( x,y    : in std_logic_vector(9 downto 0))
		return std_logic_vector is
		variable temp : std_logic_vector(9 downto 0) := (others => '0');
		 variable divideResult : std_logic_vector(9 downto 0) := (others => '0');
	begin
		temp := x;
		for i in 0 to 4 loop
			if x >= y then 
		  temp := temp - y;
			divideResult := divideResult+1;
			end if;
		end loop;
		return divideResult; 
	end function divideOperator;

begin

	process(single_double,level,SquareYMoveDir)
	begin 					   
		if single_double = '1' then
		-- AI simple level
			if level = '0' then
				if SquareYMoveDir = '0' then
					boardOutTemp <= "00" ;
				else 
					boardOutTemp <= "01" ; 
				end if;
			else
		-- AI hard level
		
		end if;
		end if;
	end process;

end AI_player;