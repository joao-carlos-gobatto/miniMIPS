----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineer: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mito;
use mito.mito_pkg.all;


entity testebench is

end testebench;

architecture Behavioral of testebench is

  component miTo is
    Port (
      instruction           : in  std_logic_vector (15 downto 0);
      addr_a                : out std_logic_vector(1 downto 0);
      addr_b                : out std_logic_vector(1 downto 0);
      addr_dest             : out std_logic_vector(1 downto 0);
      inst_addr             : out std_logic_vector(6 downto 0);
      decoded_instruction   : out decoded_instruction_type
    ); 
  end component;   
    
  --control signals
  signal clk_s_s                 : std_logic :='0';
  signal instruction_s           : std_logic_vector (15 downto 0);
  signal addr_a_s                : std_logic_vector(1 downto 0);
  signal addr_b_s                : std_logic_vector(1 downto 0);
  signal addr_dest_s             : std_logic_vector(1 downto 0);
  signal inst_addr_s             : std_logic_vector(6 downto 0);
  signal decoded_instruction_s   : decoded_instruction_type;
        
begin
    
  instruction_s <= "0010001100000000" after 10ns,
                   "0100001000101000" after 15ns,
                   "0111000000010001" after 20ns;

  miTo_i : miTo
  port map(
    instruction => instruction_s,
    addr_a  => addr_a_s,
    addr_b  => addr_b_s,
    addr_dest => addr_dest_s,
    inst_addr => inst_addr_s,
    decoded_instruction => decoded_instruction_s
  );
end Behavioral;
