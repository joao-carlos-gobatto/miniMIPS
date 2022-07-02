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
    rst_n        : in  std_logic;
    clk          : in  std_logic;
    ula_op       : in  std_logic;
    s0           : in  std_logic_vector(15 downto 0);
    s1           : in  std_logic_vector(15 downto 0);
    ula_out      : out  std_logic_vector(15 downto 0);
    zero_flag    : out  std_logic
  );
end miTo;

architecture rtl of miTo is
begin

ula_i : ula
  Port map (
    clk                        => clk,
    rst_n                      => rst_n,
    ula_op                     => ula_op,
    s0                         => s0,
    s1                         => s1,
    ula_out                    => ula_out,
    zero_flag                  => zero_flag
  );
 
end rtl;
