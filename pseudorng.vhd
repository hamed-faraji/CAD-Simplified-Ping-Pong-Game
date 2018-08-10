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



begin




end asdas;