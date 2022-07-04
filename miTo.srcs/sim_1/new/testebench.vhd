----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineer: Newton Jr
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
      clk             : in	std_logic;
      rst_n           : in	std_logic;
      halt            : in    std_logic;
      pc_enable       : in    std_logic;
      is_store        : in    std_logic;        
      mem_write       : in	std_logic;
      mem_read        : in	std_logic;
      jump_addr       : in	std_logic_vector(7  downto 0);
      ram_addr        : out	std_logic_vector(7  downto 0);
      data_to_mem     : in	std_logic_vector(15 downto 0);
      instruction     : out	std_logic_vector(15 downto 0)
    ); 
  end component;   
    
  --control signals
  signal clk_s          : std_logic :='0';
  signal rst_n_s        : std_logic :='0';
  signal halt_s         : std_logic :='0';
  signal pc_enable_s    : std_logic :='0';
  signal is_store_s     : std_logic :='0';        
  signal mem_write_s    : std_logic :='0';
  signal mem_read_s     : std_logic :='0';
  signal jump_addr_s    : std_logic_vector(7  downto 0);
  signal ram_addr_s     : std_logic_vector (7 downto 0) := "00000000";
  signal data_to_mem_s  : std_logic_vector (15 downto 0);
  signal instruction_s  : std_logic_vector (15 downto 0);
        
begin

  miTo_i : miTo
  port map(
    clk             => clk_s,
    rst_n           => rst_n_s,
    halt            => halt_s,
    pc_enable       => pc_enable_s,
    is_store        => is_store_s,
    mem_write       => mem_write_s,
    mem_read        => mem_read_s,
    jump_addr       => jump_addr_s,
    ram_addr        => ram_addr_s,
    data_to_mem     => data_to_mem_s,
    instruction     => instruction_s
  );

   --clock generator - 100MHZ
  clk_s 	<= not clk_s after 5 ns;
  
  pc_enable_s <= not pc_enable_s after 5 ns;

   --reset signal
  rst_n_s	<= '1' after 2 ns,
      '0' after 8 ns;
  
  mem_read_s <= '1' after 15 ns,
                '0' after 20 ns,
                '1' after 25 ns,
                '0' after 30 ns,
                '1' after 45 ns,
                '0' after 50 ns;

  data_to_mem_s <= "0101010101010101" after 25ns;
  
  mem_write_s <= '1' after 35ns,
                 '0' after 40ns;

end Behavioral;
