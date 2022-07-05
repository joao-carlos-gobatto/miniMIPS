----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineer: Newton Jr
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.ALL;
library mito;
use mito.mito_pkg.all;

entity memory is
	port(		
        clk                 : in  std_logic;
        mem_write           : in  std_logic;
		mem_read			: in  std_logic;
        rst_n               : in  std_logic;        
        data_to_mem	        : in  std_logic_vector(15 downto 0);
        ram_addr		    : in  std_logic_vector(6  downto 0);
        instruction         : out std_logic_vector(15 downto 0)
    );
        
end memory;

architecture rtl of memory is

	-- 256 words of 1 byte (8 bits)
	subtype palavra is std_logic_vector(15 downto 0);
	type memory is array (0 to 127) of palavra;
	signal mem : memory;
	
begin 

process(clk, rst_n)	
begin
	if(rst_n = '1') then
			mem(0)    <= "1111000000000010"; --STORE
			mem(1)    <= "0110000000000000";
			mem(2)    <= "0000000000000000";
			mem(3)    <= "0000000000000000";
			mem(4)    <= "0000000000000000";
			mem(5)    <= "0000000000000000";
			mem(6)    <= "0000000000000000";
			mem(7)    <= "0000000000000000";
			mem(8)    <= "0000000000000000";
			mem(9)    <= "0000000000000000";
			mem(10)   <= "0000000000000000";
			mem(11)   <= "0000000000000000";
			mem(12)   <= "0000000000000000";
			mem(13)   <= "0000000000000000";
			mem(14)   <= "0000000000000000";
			mem(15)   <= "0000000000000000"; 
			mem(16)   <= "0000000000000000"; 
			mem(17)   <= "0000000000000000"; 
			mem(18)   <= "0000000000000000"; 
			mem(19)   <= "0000000000000000"; 
			mem(20)   <= "0000000000000000";
			mem(21)   <= "0000000000000000"; 
			mem(22)   <= "0000000000000000";
			mem(23)   <= "0000000000000000";
			mem(24)   <= "0000000000000000"; 
			mem(25)   <= "0000000000000000"; 
			mem(26)   <= "0000000000000000"; 
			mem(27)   <= "0000000000000000";      
			mem(28)   <= "0000000000000000"; 
			mem(29)   <= "0000000000000000"; 
			mem(30)   <= "0000000000000000"; 
			mem(31)   <= "0000000000000000"; 
			mem(32)   <= "0000000000000000";  
			mem(33)   <= "0000000000000000"; 
			mem(34)   <= "0000000000000000"; 
			mem(35)   <= "0000000000000000";
			mem(36)   <= "0000000000000000";
			mem(37)   <= "0000000000000000";
			mem(38)   <= "0000000000000000";
			mem(39)   <= "0000000000000000";
			mem(40)   <= "0000000000000000";
			mem(41)   <= "0000000000000000";
			mem(42)   <= "0000000000000000";
			mem(43)   <= "0000000000000000";
			mem(44)   <= "0000000000000000";
			mem(45)   <= "0000000000000000";
			mem(46)   <= "0000000000000000";
			mem(47)   <= "0000000000000000";
			mem(48)   <= "0000000000000000";
			mem(49)   <= "0000000000000000";
			mem(50)   <= "0000000000000000";
			mem(51)   <= "0000000000000000"; 
			mem(52)   <= "0000000000000000";
			mem(53)   <= "0000000000000000";
			mem(54)   <= "0000000000000000";
			mem(55)   <= "0000000000000000";
			mem(56)   <= "0000000000000000";
			mem(57)   <= "0000000000000000";
			mem(58)   <= "0000000000000000";
			mem(59)   <= "0000000000000000";
			mem(60)   <= "0000000000000000";
			mem(61)   <= "0000000000000000";
			mem(62)   <= "0000000000000000";
			mem(63)   <= "0000000000000000";
			mem(64)   <= "0000000000000000";
			mem(65)   <= "0000000000000000";
			mem(66)   <= "0000000000000000"; 
			mem(67)   <= "0000000000000000";
			mem(68)   <= "0000000000000000"; 
			mem(69)   <= "0000000000000000";
			mem(70)   <= "0000000000000000";
			mem(71)   <= "0000000000000000";
			mem(72)   <= "0000000000000000";
			mem(73)   <= "0000000000000000";
			mem(74)   <= "0000000000000000"; 
			mem(75)   <= "0000000000000000";
			mem(76)   <= "0000000000000000";
			mem(77)   <= "0000000000000000";
			mem(78)   <= "0000000000000000"; 
			mem(79)   <= "0000000000000000";
			mem(80)   <= "0000000000000000"; 
			mem(81)   <= "0000000000000000";
			mem(82)   <= "0000000000000000";  
			mem(83)   <= "0000000000000000";
			mem(84)   <= "0000000000000000";
			mem(85)   <= "0000000000000000";
			mem(86)   <= "0000000000000000";
			mem(87)   <= "0000000000000000";
			mem(88)   <= "0000000000000000";
			mem(89)   <= "0000000000000000";
			mem(90)   <= "0000000000000000";
			mem(91)   <= "0000000000000000";
			mem(92)   <= "0000000000000000";
			mem(93)   <= "0000000000000000";
			mem(94)   <= "0000000000000000";
			mem(95)   <= "0000000000000000";
			mem(96)   <= "0000000000000000";
			mem(97)   <= "0000000000000000";
			mem(98)   <= "0000000000000000";
			mem(99)   <= "0000000000000000";
			mem(100)  <= "0000000000000000"; 
			mem(101)  <= "0000000000000000";
			mem(102)  <= "0000000000000000"; 
			mem(103)  <= "0000000000000000";
			mem(104)  <= "0000000000000000";
			mem(105)  <= "0000000000000000";
			mem(106)  <= "0000000000000000";
			mem(107)  <= "0000000000000000";
			mem(108)  <= "0000000000000000";
			mem(109)  <= "0000000000000000";
			mem(110)  <= "0000000000000000";
			mem(111)  <= "0000000000000000";
			mem(112)  <= "0000000000000000";
			mem(113)  <= "0000000000000000";
			mem(114)  <= "0000000000000000";
			mem(115)  <= "0000000000000000";
			mem(116)  <= "0000000000000000";
			mem(117)  <= "0000000000000000";
			mem(118)  <= "0000000000000000";
			mem(119)  <= "0000000000000000";
			mem(120)  <= "0000000000000000";
			mem(121)  <= "0000000000000000";
			mem(122)  <= "0000000000000000";
			mem(123)  <= "0000000000000000";
			mem(124)  <= "0000000000000000";
			mem(125)  <= "0000000000000000";
			mem(126)  <= "0000000000000000";
			mem(127)  <= "0000000000000000";
	else
        if(mem_read = '1') then
            instruction <= mem(to_integer(unsigned(ram_addr)));
        elsif (mem_write = '1') then
            mem(to_integer(unsigned(ram_addr))) <= data_to_mem;
        end if;
	end if;
end process;

end rtl;
