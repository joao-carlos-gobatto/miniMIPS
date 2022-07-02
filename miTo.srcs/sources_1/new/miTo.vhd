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
end miTo;

architecture rtl of miTo is

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
  signal decoded_instruction_s         : decoded_instruction_type;
  signal state_flag_s                  : estados;
  signal zero_flag_s                   : std_logic;
  signal is_beq_s                      : std_logic;
  signal jump_s                        : std_logic;
  signal branch_s                      : std_logic;
  signal is_load_s                     : std_logic;
  signal pc_enable_s                   : std_logic;
  signal halt_s                        : std_logic;
  signal alu_op_s                      : std_logic;
  signal reg_b_out_s                   : std_logic_vector (15 downto 0);
  signal instruction_s                 : std_logic_vector (15 downto 0);
  signal ram_addr_s                    : std_logic_vector (7 downto 0);
  signal reg_write_s                   : std_logic;
  signal mem_write_s                   : std_logic;
  signal mem_read_s                    : std_logic;
begin

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
    reg_b_out                  => reg_b_out_s,
    ram_addr                   => ram_addr_s,
    reg_write                  => reg_write_s
  );

  alu_op                      <= alu_op_s;
  decoded_instruction         <= decoded_instruction_s;
  state_flag                  <= state_flag_s;
  instruction                 <= instruction_s;
  ram_addr                    <= ram_addr_s;
  mem_write                   <= mem_write_s;
  reg_write                   <= reg_write_s;
  branch                      <= branch_s;
  halt                        <= halt_s;
 
end rtl;
