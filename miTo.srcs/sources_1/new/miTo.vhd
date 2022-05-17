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
      rst_n                  : in  std_logic;
      clk                    : in  std_logic;
      saida_memoria          : in  std_logic_vector (31 downto 0);   -- in data read from memory
      entrada_memoria        : out std_logic_vector (31 downto 0);   -- out_reg or alu_out to memory 
      write_mem_en           : out std_logic
   );
end miTo;

architecture rtl of miTo is

signal decoded_instruction_s    : decoded_instruction_type;
signal flag_z_s                 : std_logic;
signal flag_n_s                 : std_logic;
signal adress_cel_s             : std_logic;
signal alu_b_ind_s              : std_logic;
signal pc_en_s                  : std_logic;
signal ir_en_s                  : std_logic;
signal data_en_s                : std_logic;
signal write_reg_en_s           : std_logic;
signal jmp_sel_s                : std_logic;
signal alu_mem_sel_s            : std_logic;
signal write_mem_en_s           : std_logic;
signal read_mem_en_s            : std_logic;
signal alu_op_s                 : std_logic_vector (5  downto 0);
signal saida_memoria_s          : std_logic_vector (31 downto 0);
signal entrada_memoria_s        : std_logic_vector (31 downto 0);
signal adress_pc_s              : std_logic_vector (8  downto 0);
signal mem_write_sel_s          : std_logic;
signal alu_a_ind_s              : std_logic;

begin

control_unit_i : control_unit
    port map( 
    clk                 => clk,
    rst_n               => rst_n,
    adress_sel          => adress_cel_s,
    alu_b_ind           => alu_b_ind_s,
    pc_en               => pc_en_s,
    ir_en               => ir_en_s,
    data_en             => data_en_s,
    write_reg_en        => write_reg_en_s,
    decoded_inst        => decoded_instruction_s,
    jmp_sel             => jmp_sel_s,
    alu_mem_sel         => alu_mem_sel_s,
    write_mem_en        => write_mem_en_s,
    alu_op              => alu_op_s,
    flag_z              => flag_z_s,
    mem_write_sel       => mem_write_sel_s,
    alu_a_ind           => alu_a_ind_s,
    flag_n              => flag_n_s
    );

data_path_i : data_path
  port map (
    clk                 => clk,
    rst_n               => rst_n,
    adress_sel          => adress_cel_s,
    adress_pc           => adress_pc_s,
    jmp_sel             => jmp_sel_s,
    alu_mem_sel         => alu_mem_sel_s,
    alu_b_ind           => alu_b_ind_s,
    pc_en               => pc_en_s,
    ir_en               => ir_en_s,
    data_en             => data_en_s,
    write_reg_en        => write_reg_en_s,
    alu_op              => alu_op_s,
    decoded_inst        => decoded_instruction_s,
    flag_z              => flag_z_s,
    flag_n              => flag_n_s,
    saida_memoria       => saida_memoria_s,
    entrada_memoria     => entrada_memoria_s,
    alu_a_ind           => alu_a_ind_s,
    mem_write_sel       => mem_write_sel_s
  );
  
memory_i : memory
  port map(
    clk                 => clk,
    rst_n               => rst_n,    
    endereco_memoria    => adress_pc_s,
    escrita             => write_mem_en_s,
    saida_memoria       => saida_memoria_s,
    entrada_memoria     => entrada_memoria_s
  );
 
end rtl;
