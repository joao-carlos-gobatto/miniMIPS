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
    rst_n                       : in  std_logic;
    clk                         : in  std_logic;
    decoded_instruction         : out decoded_instruction_type;
    instruction                 : out std_logic_vector (15 downto 0);
    ram_addr                    : out std_logic_vector (7 downto 0); 
    mem_write                   : out std_logic;
    reg_write                   : out std_logic;
    halt                        : out std_logic
  );
end miTo;

architecture rtl of miTo is
    type estados is (
        HALT_E,
        ADD,
        SUB,
        LOAD,
        STORE,
        JUMP_E,
        BEQ,
        BNE,
        ULA,        
        BRANCH_E,   
        FETCH,      
        DECODE,     
        PROX        
    );

  signal decoded_instruction_s         : decoded_instruction_type;
  signal zero_flag_s                   : std_logic;
  signal is_beq_s                      : std_logic;
  signal jump_s                        : std_logic;
  signal branch_s                      : std_logic;
  signal is_load_s                     : std_logic;
  signal pc_enable_s                   : std_logic;
  signal halt_s                        : std_logic;
  signal alu_op_s                      : std_logic;
  signal data_s                        : std_logic_vector (15 downto 0);
  signal instruction_s                 : std_logic_vector (15 downto 0);
  signal ram_addr_s                    : std_logic_vector (7 downto 0);
  signal reg_write_s                   : std_logic;
  signal mem_write_s                   : std_logic;
  signal mem_read_s                    : std_logic;
begin

control_unit_i : control_unit
  Port map(
    clk                        => clk,
    rst_n                      => rst_n,
    decoded_instruction        => decoded_instruction_s,
    reg_write                  => reg_write_s,
    mem_write                  => mem_write_s,
    mem_read                   => mem_read_s,
    zero_flag                  => zero_flag_s,
    alu_op                     => alu_op_s,
    is_beq                     => is_beq_s,
    is_load                    => is_load_s,
    jump                       => jump_s,
    branch                     => branch_s,
    pc_enable                  => pc_enable_s,
    halt                       => halt_s
  );

data_path_i : data_path
  Port map (
    clk                        => clk,
    rst_n                      => rst_n,
    is_beq                     => is_beq_s,
    jump                       => jump_s,
    branch                     => branch_s,
    pc_enable                  => pc_enable_s,
    halt                       => halt_s,
    decoded_instruction        => decoded_instruction_s,
    alu_op                     => alu_op_s,
    is_load                    => is_load_s,
    zero_flag                  => zero_flag_s,
    instruction                => instruction_s,
    data                       => data_s,
    ram_addr                   => ram_addr_s,
    reg_write                  => reg_write_s
  );
  
memory_i : memory
  Port map(
    clk                        => clk,
    rst_n                      => rst_n,
    data                       => data_s,
    mem_write                  => mem_write_s,
	mem_read			       => mem_read_s,
    ram_addr		           => ram_addr_s,
    instruction                => instruction_s
  );

  ram_addr  <= ram_addr_s;
  decoded_instruction <= decoded_instruction_s;
 
end rtl;
