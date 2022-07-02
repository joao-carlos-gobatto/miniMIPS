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
    alu_op       : in  std_logic;
    s0           : in  std_logic_vector(15 downto 0);
    s1           : in  std_logic_vector(15 downto 0);
    ula_out      : out  std_logic_vector(15 downto 0);
    zero_flag    : out  std_logic
  );
end miTo;

architecture rtl of miTo is

  signal alu_op_s : std_logic;
  signal zero_flag_s : std_logic;
  signal s0_s : std_logic_vector(15 downto 0);
  signal s1_s : std_logic_vector(15 downto 0);
  signal alu_out_s : std_logic_vector(15 downto 0);

begin

alu_i : alu
  Port map (
    clk                        => clk_s,
    rst_n                      => rst_n_s,
    alu_op                     => alu_op_s,
    s0                         => s0_s,
    s1                         => s1_s,
    ula_out                    => ula_out_s,
    zero_flag                  => zero_flag_s
  );

  alu_op                      <= alu_op_s;
  s0                          <= s0_s;
  s1                          <= s1_s;
  ula_out                     <= ula_out_s;
  zero_flag                   <= zero_flag_s;
 
end rtl;
