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
        --Sinais de controle
        clk                   : in	std_logic;
        rst_n                 : in	std_logic;
        halt                  : out  std_logic;
        is_jump               : out std_logic;
        is_branch             : out std_logic;
        is_beq                : out std_logic;
        select_data           : out  std_logic;        
        ula_op                : out  std_logic;
        reg_write		      : out  std_logic;
        pc_enable             : out  std_logic;
        mem_write             : out	std_logic;
        mem_read              : out	std_logic;
        mem_access_inst       : out  std_logic;
        read_decoder          : out  std_logic;
        estado_atual          : out estados;
        prox_estado           : out estados;
        

        --Sinais memória
        ram_addr              : out	std_logic_vector(6  downto 0);
        instruction           : out	std_logic_vector(15 downto 0);

        --Sinais Decoder
        addr_a                : out std_logic_vector(1 downto 0);
        addr_b                : out std_logic_vector(1 downto 0);
        addr_dest             : out std_logic_vector(1 downto 0);
        inst_addr             : out std_logic_vector(6 downto 0);
        decoded_instruction   : out decoded_instruction_type;
        
        --Sinais Banco de registradores
        data_to_mem           : out	std_logic_vector(15 downto 0);
        r0                    : out std_logic_vector(15 downto 0);
        r1                    : out std_logic_vector(15 downto 0);
        r2                    : out std_logic_vector(15 downto 0);
        r3                    : out std_logic_vector(15 downto 0);
        s0                    : out std_logic_vector(15 downto 0);
        s1                    : out std_logic_vector(15 downto 0);

        --Sinais ULA
        ula_out			      : out std_logic_vector(15 downto 0);
        zero_flag             : out std_logic        
    ); 
  end component;   
    
  --Sinais de controle
  signal clk_s                   : std_logic :='0';
  signal rst_n_s                 : std_logic :='0';
  signal halt_s                  : std_logic :='0';
  signal is_jump_s               : std_logic;
  signal is_branch_s             : std_logic;
  signal is_beq_s                : std_logic;
  signal select_data_s           : std_logic :='0';        
  signal ula_op_s                : std_logic;
  signal reg_write_s             : std_logic :='0';
  signal pc_enable_s             : std_logic :='0';
  signal mem_write_s             : std_logic :='0';
  signal mem_read_s              : std_logic :='0';
  signal mem_access_inst_s       : std_logic :='0';
  signal estado_atual_s          : estados;
  signal prox_estado_s           : estados;

  --Sinais Memória
  signal ram_addr_s              : std_logic_vector (6 downto 0) := "0000000";
  signal instruction_s           : std_logic_vector (15 downto 0);
  
  --Sinais Decoder
  signal addr_a_s                : std_logic_vector(1 downto 0);
  signal addr_b_s                : std_logic_vector(1 downto 0);
  signal addr_dest_s             : std_logic_vector(1 downto 0);
  signal inst_addr_s             : std_logic_vector(6 downto 0);
  signal read_decoder_s          : std_logic := '0';
  signal decoded_instruction_s   : decoded_instruction_type;

  --Sinais Banco de Registradores
  signal data_to_mem_s           : std_logic_vector (15 downto 0);
  signal r0_s                    : std_logic_vector(15 downto 0);
  signal r1_s                    : std_logic_vector(15 downto 0);
  signal r2_s                    : std_logic_vector(15 downto 0);
  signal r3_s                    : std_logic_vector(15 downto 0);
  signal s0_s                    : std_logic_vector(15 downto 0);
  signal s1_s                    : std_logic_vector(15 downto 0);       

  --Sinais ULA
  signal ula_out_s               : std_logic_vector(15 downto 0);
  signal zero_flag_s             : std_logic;

begin

   --clock generator - 100MHZ
  clk_s 	<= not clk_s after 5 ns;

   --reset signal
  rst_n_s	<= '1' after 2 ns,
      '0' after 8 ns;

  miTo_i : miTo
  port map(
    --Controle
    clk                     => clk_s,
    rst_n                   => rst_n_s,
    halt                    => halt_s,
    is_jump                 => is_jump_s,
    is_branch               => is_branch_s,
    is_beq                  => is_beq_s,
    select_data             => select_data_s,
    ula_op                  => ula_op_s,
    reg_write               => reg_write_s,
    pc_enable               => pc_enable_s,
    mem_write               => mem_write_s,
    mem_read                => mem_read_s,
    mem_access_inst         => mem_access_inst_s,
    read_decoder            => read_decoder_s,

    --Memória
    ram_addr                => ram_addr_s,
    instruction             => instruction_s,

    --Decoder
    addr_a                  => addr_a_s,
    addr_b                  => addr_b_s,
    addr_dest               => addr_dest_s,
    inst_addr               => inst_addr_s,
    decoded_instruction     => decoded_instruction_s,
    estado_atual            => estado_atual_s,
    prox_estado             => prox_estado_s,

    --Banco de Registradores
    data_to_mem             => data_to_mem_s,
    r0                      => r0_s,
    r1                      => r1_s,
    r2                      => r2_s,
    r3                      => r3_s,
    s0                      => s0_s,
    s1                      => s1_s,

    --ULA
    ula_out			        => ula_out_s,
	zero_flag               => zero_flag_s
  );
end Behavioral;
