-------------------------------------------------------------------------------
--
-- Title       : pseudorng
-- Design      : pseudorng_design
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : pseudorng.vhd
-- Generated   : Thu May 17 21:34:17 2018
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {pseudorng} architecture {asdas}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity pseudorng is
	Port ( clock : in STD_LOGIC;
		reset : in STD_LOGIC;
		en : in STD_LOGIC;
		Q : out STD_LOGIC_VECTOR (7 downto 0);
		check: out STD_LOGIC);
	
	--       constant seed: STD_LOGIC_VECTOR(7 downto 0) := "00000001";
end pseudorng;

--}} End of automatically maintained section

architecture asdas of pseudorng is		
	signal temp: STD_LOGIC;
	signal Qt: STD_LOGIC_VECTOR(7 downto 0) := x"01";
begin
	PROCESS(clock)
		variable tmp : STD_LOGIC := '0';
	BEGIN
		
		IF rising_edge(clock) THEN
			IF (reset='1') THEN
				-- credit to QuantumRipple for pointing out that this should not
				-- be reset to all 0's, as you will enter an invalid state
				Qt <= x"01"; 
				--ELSE Qt <= seed;
			ELSIF en = '1' THEN
				tmp := Qt(4) XOR Qt(3) XOR Qt(2) XOR Qt(0);
				Qt <= tmp & Qt(7 downto 1);
			END IF;
			
		END IF;
	END PROCESS;
	-- check <= temp;
	check <= Qt(7);
	Q <= Qt;
	
end asdas;