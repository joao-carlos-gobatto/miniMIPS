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
    instruction                 : in  std_logic_vector (15 downto 0);   -- in data read from memory
    ram_addr                    : out std_logic_vector (15 downto 0);   -- out_reg or alu_out to memory 
    mem_write                   : out std_logic;
  );
end miTo;

architecture rtl of miTo is
  signal decoded_inst_s         : decoded_instruction_type;
  zero_flag_s                   : std_logic;
  is_beq_s                      : std_logic;
  jump_s                        : std_logic;
  branch_s                      : std_logic;
  pc_enable_s                   : std_logic;
  halt_s                        : std_logic;
  decoded_instruction_s         : decoded_instruction_type;
  alu_op_s                      : std_logic;
  data_s                        : std_logic_vector (15 downto 0);
  instruction_s                 : std_logic_vector (15 downto 0);
  ram_addr_s                    : std_logic_vector (15 downto 0);
  reg_write_s                   : std_logic_vector (1 downto 0);
begin

control_unit_i : control_unit
  Port map(
    clk                        => clk,
    rst_n                      => rst_n,
    decoded_inst               => decoded_instruction_s,
    reg_write                  => reg_write_s,
    mem_write                  => mem_write_s,
    mem_read                   => mem_read_s,
    zero_flag                  => zero_flag_s,
    alu_op                     => alu_op_s,
    is_beq                     => is_beq_s,
    jump                       => jump_s,
    branch                     => branch_s,
    pc_enable                  => pc_enable_s,
    halt                       => halt_s
  );

data_path_i : data_path
  Port map (
    clk                        => clk,
    rst_n                      => rst_n,
    decoded_inst               => decoded_inst_s,
    is_beq                     => is_beq_s,
    jump                       => jump_s,
    branch                     => branch_s,
    pc_enable                  => pc_enable_s,
    halt                       => halt_s,
    decoded_instruction        => decoded_instruction_s,
    alu_op                     => alu_op_s,
    zero_flag                  => zero_flag_s,
    instruction                => instruction_s,
    data                       => data_s,
    ram_addr                   => ram_addr_s,
    reg_write                  => reg_write_s,
  );
  
memory_i : memory
  Port map(
    clk                        => clk,
    rst_n                      => rst_n,
    data                       => data_s,
    mem_write                  => mem_write_s,
	  mem_read			             => mem_read_s,
    ram_addr		               => ram_addr_s,
    instruction                => instruction_s
  );
 
end rtl;
