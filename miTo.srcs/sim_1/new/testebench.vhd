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
      signal clk                    : in  std_logic :='0';
      signal rst_n                  : in  std_logic :='0';
      signal instruction            : out std_logic_vector (15 downto 0);
      signal decoded_instruction    : out decoded_instruction_type;
      signal alu_op                 : out std_logic;
      signal state_flag             : out estados;
      signal ram_addr               : out std_logic_vector (7 downto 0);
      signal mem_write              : out std_logic;
      signal reg_write              : out std_logic;
      signal branch                 : out std_logic;
      signal halt                   : out std_logic         
    ); 
  end component;   
    
  --control signals
  signal clk_s                      : std_logic :='0';
  signal reset_s                    : std_logic;
  signal state_flag_s               : estados;
  signal alu_op_s                   : std_logic;
  signal decoded_instruction_s      : decoded_instruction_type; 
  signal instruction_s              : std_logic_vector (15 downto 0);
  signal ram_addr_s                 : std_logic_vector (7 downto 0);
  signal mem_write_s                : std_logic;
  signal reg_write_s                : std_logic;
  signal branch_s                   : std_logic;
  signal halt_s                     : std_logic;
        
begin

  miTo_i : miTo
  port map(
    clk                      => clk_s,
    rst_n                    => reset_s,   
    decoded_instruction      => decoded_instruction_s,
    alu_op                   => alu_op_s,
    state_flag               => state_flag_s,
    instruction              => instruction_s,
    ram_addr                 => ram_addr_s,
    mem_write                => mem_write_s,
    reg_write                => reg_write_s,
    branch                   => branch_s,
    halt                     => halt_s
  );

   --clock generator - 100MHZ
  clk_s 	<= not clk_s after 5 ns;

   --reset signal
  reset_s	<= '1' after 2 ns,
      '0' after 8 ns;

end Behavioral;
