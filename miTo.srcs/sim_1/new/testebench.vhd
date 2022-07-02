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
      clk                		: in  std_logic;
      rst_n              		: in  std_logic;
      ula_op             		: in  std_logic;
      s0						        : in std_logic_vector(15 downto 0);
      s1						        : in std_logic_vector(15 downto 0);
      ula_out					      : out std_logic_vector(15 downto 0);
      zero_flag          		: out std_logic        
    ); 
  end component;   
    
  --control signals
  signal clk_s                      : std_logic :='0';
  signal reset_s                    : std_logic;
  signal alu_op_s                   : std_logic;
  signal s0_s                       : std_logic_vector(15 downto 0);
  signal s1_s                       : std_logic_vector(15 downto 0);
  signal ula_out_s                  : std_logic_vector(15 downto 0);
  signal zero_flag_s                : std_logic;
        
begin
  miTo_i : miTo
  port map(
    clk                      => clk_s,
    rst_n                    => reset_s,   
    ula_op                   => alu_op_s,
		s0						           => s0_s,
		s1						           => s1_s,
		ula_out					         => ula_out_s,
		zero_flag          		   => zero_flag_s
  );

   --clock generator - 100MHZ
  clk_s 	<= not clk_s after 5 ns;

   --reset signal
  reset_s	<= '1' after 2 ns,
      '0' after 8 ns;

  s0_s <= "0000000000000001" after 10 ns;
  s1_s <= "0000000000000001" after 10 ns;
  alu_op_s <= '0' after 10 ns;

end Behavioral;
