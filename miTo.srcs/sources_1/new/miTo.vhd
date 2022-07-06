----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
library mito;
use mito.mito_pkg.all;

entity miTo is
  Port (
    clk                   : in	std_logic;
    rst_n                 : in	std_logic;
    halt                  : out  std_logic;
    pc_enable             : out  std_logic;
    select_data           : out  std_logic;
    reg_write             : out  std_logic;
    mem_write             : out	std_logic;
    mem_read              : out	std_logic;
    mem_access_inst       : out  std_logic;
    read_decoder          : out  std_logic;
    is_jump               : out std_logic;
    is_branch             : out std_logic;
    is_beq                : out std_logic;
    
    ram_addr              : out	std_logic_vector(6  downto 0);
    instruction           : out	std_logic_vector(15 downto 0);
    addr_a                : out std_logic_vector(1 downto 0);
    addr_b                : out std_logic_vector(1 downto 0);
    addr_dest             : out std_logic_vector(1 downto 0);
    inst_addr             : out std_logic_vector(6 downto 0);
    decoded_instruction   : out decoded_instruction_type;
    estado_atual          : out estados;
    prox_estado           : out estados;
    
    data_to_mem           : out std_logic_vector(15 downto 0);
    s0                    : out std_logic_vector(15 downto 0);
    s1                    : out std_logic_vector(15 downto 0);
    r0                    : out std_logic_vector(15 downto 0);
    r1                    : out std_logic_vector(15 downto 0);
    r2                    : out std_logic_vector(15 downto 0);
    r3                    : out std_logic_vector(15 downto 0);

    ula_op                : out std_logic;
    ula_out               : out std_logic_vector(15 downto 0);
    zero_flag             : out std_logic
  );
end miTo;

architecture rtl of miTo is
signal pc                      : std_logic_vector(6 downto 0) := "0000000";
signal ram_addr_s              : std_logic_vector(6 downto 0) := "0000000";
signal instruction_s           : std_logic_vector(15 downto 0);
signal inst_addr_s             : std_logic_vector(6 downto 0);
signal mux_registers_bank      : std_logic_vector(15 downto 0);
signal data_to_mem_s           : std_logic_vector(15 downto 0);
signal addr_dest_s             : std_logic_vector(1 downto 0);
signal addr_a_s                : std_logic_vector(1 downto 0);
signal addr_b_s                : std_logic_vector(1 downto 0);
signal s0_s                    : std_logic_vector(15 downto 0) := "0000000000000000";
signal s1_s                    : std_logic_vector(15 downto 0) := "0000000000000000";
signal ula_out_s               : std_logic_vector(15 downto 0) := "0000000000000000";
signal decoded_instruction_s   : decoded_instruction_type;
signal is_jump_s               : std_logic;
signal is_branch_s             : std_logic;
signal is_beq_s                : std_logic;
signal zero_flag_s             : std_logic;
signal halt_s                  : std_logic;
signal select_data_s           : std_logic;
signal ula_op_s                : std_logic;
signal reg_write_s             : std_logic;
signal pc_enable_s             : std_logic;
signal mem_write_s             : std_logic;
signal mem_read_s              : std_logic;
signal mem_access_inst_s       : std_logic;
signal read_decoder_s          : std_logic;
signal is_beq_xnor_zero        : std_logic;
signal is_branch_and_valid     : std_logic;
signal is_jump_or_valid_branch : std_logic;

begin
  ram_addr              <= ram_addr_s;
  instruction           <= instruction_s;
  inst_addr             <= inst_addr_s;
  s0                    <= s0_s;
  s1                    <= s1_s;
  ula_out               <= ula_out_s;
  data_to_mem           <= data_to_mem_s;
  addr_a                <= addr_a_s;
  addr_b                <= addr_b_s;
  addr_dest             <= addr_dest_s;
  decoded_instruction   <= decoded_instruction_s;
  halt                  <= halt_s;
  select_data           <= select_data_s;
  ula_op                <= ula_op_s;
  reg_write             <= reg_write_s;
  pc_enable             <= pc_enable_s;
  mem_write             <= mem_write_s;
  mem_read              <= mem_read_s;
  mem_access_inst       <= mem_access_inst_s;
  read_decoder          <= read_decoder_s;
  zero_flag             <= zero_flag_s;
  is_jump               <= is_jump_s;
  is_branch             <= is_branch_s;
  is_beq                <= is_beq_s;
  is_beq_xnor_zero      <= is_beq_s xnor zero_flag_s;
  is_branch_and_valid   <= is_beq_xnor_zero and is_branch_s;
  is_jump_or_valid_branch <= is_jump_s or is_branch_and_valid;

  program_counter:process(clk)
  begin    
      if(rst_n = '1') then
          pc <= "0000000";
      else
          if(clk='1' and clk'event) then
              if(halt_s = '1') then
                  pc <= pc;
              elsif(pc_enable_s = '1') then
                      pc <= pc + 1;
              elsif(is_jump_or_valid_branch = '1') then
                      pc <= inst_addr_s - 1;
              end if;
          end if;
      end if;
  end process;

  --MUX de endere�o de mem�ria
  ram_mux:process(mem_access_inst_s, inst_addr_s, pc)
  begin
      if(mem_access_inst_s = '1') then
        ram_addr_s <= inst_addr_s;
      else
        ram_addr_s <= pc;
      end if;
  end process;

  --MUX de entrada do banco de registradores
  registers_mux:process(select_data_s,instruction_s,ula_out_s)
  begin
      if(select_data_s='1') then
          mux_registers_bank <= instruction_s;
      else
          mux_registers_bank <= ula_out_s;
      end if;
  end process;

  memory_i : memory
    Port map(
      clk           =>  clk,
      rst_n         =>  rst_n,
      mem_write     =>  mem_write_s,
      mem_read      =>  mem_read_s,
      ram_addr      =>  ram_addr_s,
      data_to_mem   =>  data_to_mem_s,
      instruction   =>  instruction_s
    );

  decoder_i : decoder
    Port map (
      instruction          => instruction_s,
      addr_a               => addr_a_s,
      addr_b               => addr_b_s,
      addr_dest            => addr_dest_s,
      inst_addr            => inst_addr_s,
      read_decoder         => read_decoder_s,
      decoded_instruction  => decoded_instruction_s
    );
    
  registers_bank_i : registers_bank
    Port map (
      clk             => clk,
      reg_write       => reg_write_s,
      data            => mux_registers_bank,
      addr_dest       => addr_dest_s,
      addr_a          => addr_a_s,
      addr_b          => addr_b_s,
      data_to_mem     => data_to_mem_s,
      s0              => s0_s,
      s1              => s1_s,
      r0              => r0,
      r1              => r1,
      r2              => r2,
      r3              => r3
    );
    
  ula_i : ula
    Port map (
      ula_op                     => ula_op_s,
      s0                         => s0_s,
      s1                         => s1_s,
      ula_out                    => ula_out_s,
      zero_flag                  => zero_flag_s
    );

  control_unit_i : control_unit
    Port map (
        --Sinais de controle
        clk                   => clk,
        rst_n                 => rst_n,
        decoded_instruction   => decoded_instruction_s,
        estado_atual          => estado_atual,
        prox_estado           => prox_estado,
        halt                  => halt_s,
        select_data           => select_data_s,
        ula_op                => ula_op_s,
        reg_write		      => reg_write_s,
        pc_enable             => pc_enable_s,
        mem_write             => mem_write_s,
        mem_read              => mem_read_s,
        mem_access_inst       => mem_access_inst_s,
        read_decoder          => read_decoder_s,
        is_jump               => is_jump_s,
        is_branch             => is_branch_s,
        is_beq                => is_beq_s
    );
 
end rtl;