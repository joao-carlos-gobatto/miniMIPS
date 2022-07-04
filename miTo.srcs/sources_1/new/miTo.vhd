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
    clk             : in std_logic;
    rst_n           : in std_logic;
    
    reg_write       : in std_logic;
    data            : in std_logic_vector(15 downto 0);
    addr_dest       : in std_logic_vector(1 downto 0);
    addr_a          : in std_logic_vector(1 downto 0);
    addr_b          : in std_logic_vector(1 downto 0);
    data_to_mem     : out std_logic_vector(15 downto 0);
    s0              : out std_logic_vector(15 downto 0);
    s1              : out std_logic_vector(15 downto 0);
    r0              : out std_logic_vector(15 downto 0);
    r1              : out std_logic_vector(15 downto 0);
    r2              : out std_logic_vector(15 downto 0);
    r3              : out std_logic_vector(15 downto 0)

    ula_op          : in  std_logic;
    s0              : in  std_logic_vector(15 downto 0);
    s1              : in  std_logic_vector(15 downto 0);
    ula_out         : out  std_logic_vector(15 downto 0);
    zero_flag       : out  std_logic
  );
end miTo;

architecture rtl of miTo is
begin

registers_bank_i : registers_bank
  Port map (
    clk             => clk,
    reg_write       => reg_write,
    data            => data,
    addr_dest       => addr_dest,
    addr_a          => addr_a,
    addr_b          => addr_b,
    data_to_mem     => data_to_mem,
    s0              => s0,
    s1              => s1,
    r0              => r0,
    r1              => r1,
    r2              => r2,
    r3              => r3
  )
ula_i : ula
  Port map (
    ula_op                     => ula_op,
    s0                         => s0,
    s1                         => s1,
    ula_out                    => ula_out,
    zero_flag                  => zero_flag
  );
 
end rtl;
