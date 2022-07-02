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
      clk             : in std_logic;
    	rst_n           : in std_logic;
		reg_write		: in std_logic;
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
    ); 
  end component;   
    
  --control signals
  signal clk_s                : std_logic :='0';
  signal rst_n_s              : std_logic := '0';
  signal reg_write_s          : std_logic := '0';
  signal data_s               : std_logic_vector(15 downto 0);
  signal addr_dest_s          : std_logic_vector(1 downto 0);
  signal addr_a_s             : std_logic_vector(1 downto 0);
  signal addr_b_s             : std_logic_vector(1 downto 0);
  signal data_to_mem_s        : std_logic_vector(15 downto 0);
  signal s0_s                 : std_logic_vector(15 downto 0);
  signal s1_s                 : std_logic_vector(15 downto 0);
  signal r0_s                 : std_logic_vector(15 downto 0);
  signal r1_s                 : std_logic_vector(15 downto 0);
  signal r2_s                 : std_logic_vector(15 downto 0);
  signal r3_s                 : std_logic_vector(15 downto 0);       

begin

  miTo_i : miTo
  port map(
    clk             => clk_s,
    rst_n           => rst_n_s,
    reg_write       => reg_write_s,
    data            => data_s,
    addr_dest       => addr_dest_s,
    addr_a          => addr_a_s,
    addr_b          => addr_b_s,
    data_to_mem     => data_to_mem_s,
    s0              => s0_s,
    s1              => s1_s,
    r0              => r0_s,
    r1              => r1_s,
    r2              => r2_s,
    r3              => r3_s
  );

   --clock generator - 100MHZ
  clk_s 	<= not clk_s after 5 ns;

   --reset signal
  rst_n_s	<= '1' after 2 ns,
      '0' after 8 ns;

  reg_write_s	<= not reg_write_s after 10 ns;
  data_s    <= "0011000010000000" after 10 ns,
  "1000011000000001" after 30 ns,
  "0001000010000010" after 50 ns,
  "0010000001000011" after 70 ns;
  addr_dest_s <= "00" after 10 ns,
  "01" after 20 ns,
  "10" after 40 ns,
  "11" after 60 ns;
  addr_a_s <= "00" after 15 ns,
  "01" after 25ns,
  "10" after 55ns,
  "11" after 65ns;
  addr_b_s <= "10" after 15 ns,
  "11" after 25ns,
  "00" after 55ns,
  "01" after 65ns;
end Behavioral;
