----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mito;
use mito.mito_pkg.all;

entity miTo is
  Port (
    clk             : in	std_logic;
    rst_n           : in	std_logic;
    halt            : in    std_logic;
    pc_enable       : in    std_logic;
    is_store        : in    std_logic;        
    mem_write       : in	std_logic;
	mem_read        : in	std_logic;
    ram_addr        : in	std_logic_vector(7  downto 0);
	data_to_mem     : in	std_logic_vector(15 downto 0);
    instruction     : out	std_logic_vector(15 downto 0)
  );
end miTo;

architecture rtl of miTo is
signal program_counter : std_logic_vector(7 downto 0);

begin
--PC
process(clk)
begin
    if(clk='1' and clk'event) then
        if(halt = '1') then
            program_counter <= program_counter;
        else
            program_counter <= program_counter + '1';
        end if;
    else
        if(rst_n = '1') then
            program_counter <= "00000000";
        end if;
    end if;
end process;

memory_i : memory
  Port map(
    clk           =>  clk,
    rst_n         =>  rst_n,
    mem_write     =>  mem_write,
    mem_read      =>  mem_read,
    ram_addr      =>  ram_addr,
    data_to_mem   =>  data_to_mem,
    instruction   =>  instruction
  );
 
end rtl;
