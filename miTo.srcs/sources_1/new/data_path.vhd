----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
library mito;
use mito.mito_pkg.all;

entity data_path is
  Port (
    clk                 : in  std_logic;
    rst_n               : in  std_logic;
    decoded_inst        : out decoded_instruction_type;

    --Sinais de controle gerais
    is_beq              : in std_logic;     --Informa se a instrução de branch é BEQ ou se é BNEG.
    jump                : in std_logic;     --Informa se é uma instrução de JUMP.
    branch              : in std_logic;     --Informa se é uma instrução de Branch.
    pc_en               : in std_logic;     --Escolhe dado vindo do registrador de endereço ou do PC.
    halt                : in std_logic;     --Informa parada do processo.
    
    --Sinais da ULA
    alu_op              : in std_logic_vector (1 downto 0);  --Seleciona operação da ULA (ADD, SUB, AND, OR).
    zero                : in std_logic;     --Saída da ULA é zero
    alu_out             : out std_logic_vector (15 downto 0)  --Saída da ULA

    --Sinais da memória
    saida_memoria       : in  std_logic_vector (15 downto 0);       --Instrução saindo da memória
    entrada_memoria     : in  std_logic_vector (15 downto 0);       --Dado a ser armazenado na memória
    mem_read            : in std_logic;     --Habilita leitura da memória (Para loads).

    --Sinais banco de registrador
    reg_write           : in std_logic;     --Habilita escrita no banco de registradores.
    mem_write           : in std_logic;     --Habilita escrita na memória (Para stores).
    reg0                : out  std_logic_vector (15 downto 0);
    reg1                : out  std_logic_vector (15 downto 0);
    reg2                : out  std_logic_vector (15 downto 0);
    reg3                : out  std_logic_vector (15 downto 0);
    s0                  : in std_logic_vector (15 downto 0);
    s1                  : in std_logic_vector (15 downto 0);
    data                : out std_logic_vector (15 downto 0);

    --Registrador de endereço
    reg_addr            : out std_logic_vector (7 downto 0);
  );
end data_path;

--TODO: Implementar a arquitetura do data_path
architecture rtl of data_path is

  signal data                 : std_logic_vector (15 downto 0);
  signal alu_or_mem_data      : std_logic_vector (15 downto 0);
  signal instruction          : std_logic_vector (31 downto 0); 
  signal mem_addr             : std_logic_vector (8  downto 0); 
  signal program_counter      : std_logic_vector (8  downto 0); 
  signal out_pc_mux           : std_logic_vector (8  downto 0); 
  signal b_alu                : std_logic_vector (15 downto 0);
  signal dr_to_reg            : std_logic_vector (15 downto 0);

  
  -- registradores
  signal reg0                : std_logic_vector (15 downto 0);
  signal reg1                : std_logic_vector (15 downto 0);
  signal reg2                : std_logic_vector (15 downto 0);
  signal reg3                : std_logic_vector (15 downto 0);
  
  signal reg_ula_out         : std_logic_vector (31 downto 0);
  
  -- Reg R0  
  signal reg_op_a     : std_logic_vector(4 downto 0);
  signal reg_a_alu_out: std_logic_vector(15 downto 0);
  
  -- Reg R1  
  signal reg_op_b     : std_logic_vector(4 downto 0);
  signal reg_b_alu_out: std_logic_vector(15 downto 0);

  -- Reg R2  
  signal reg_op_a     : std_logic_vector(4 downto 0);
  signal reg_a_alu_out: std_logic_vector(15 downto 0);
  
  -- Reg R3  
  signal reg_op_b     : std_logic_vector(4 downto 0);
  signal reg_b_alu_out: std_logic_vector(15 downto 0);
    
  -- ALU signals
  signal a_operand    : STD_LOGIC_VECTOR (15 downto 0);      
  signal b_operand    : STD_LOGIC_VECTOR (15 downto 0);   
  signal ula_out      : STD_LOGIC_VECTOR (31 downto 0);
    
begin
    
  --Banco de registradores
  bus_a <= banco_de_reg(conv_integer(a_addr));
  bus_b <= banco_de_reg(conv_integer(b_addr));
  bus_c <= ula_out when (c_sel = '0') else data_in;

  --Mux RAM
  ram_addr <= mem_addr when (addr_sel = '0') else program_counter;

  process (instruction)
  begin
    --decoded_instruction <= I_NOP;
    a_addr <= "00";
    b_addr <= "00";
    c_addr <= "00";
    mem_addr <= instruction(4 downto 0);

    if ((instruction(15 downto 13)) = "101") then
      c_addr <= instruction(5 downto 4);
      elsif (instruction(15 downto 12) = "1000") then
        c_addr <= instruction(6 downto 5);
      elsif (instruction(15 downto 12) = "1001") then
        c_addr <= instruction(3 downto 2);
    end if ;

    if (instruction(15) = '0')  then
      case (instruction(9 downto 8)) is
        when "01" =>
          decoded_instruction <= I_BRANCH;
        when "10" =>
          decoded_instruction <= I_BZERO;
        when "11" =>
          decoded_instruction <= I_BNEG;
        when others => 
          decoded_instruction <= I_NOP;
      end case;

    elsif (instruction(15) = '1') then
      case (instruction(14 downto 7)) is
        when "00100010" =>  --MOVE
          decoded_instruction <= I_MOVE;
        when "01000010" => --ADD
          decoded_instruction <= I_ADD;
        when "01000100" => --SUB
          decoded_instruction <= I_SUB;
        when "01000110" => --AND
          decoded_instruction <= I_AND;
        when "01001000" => --OR
          decoded_instruction <= I_OR;
        when "00000010" => --LOAD
          decoded_instruction <= I_LOAD;
        when "00000100" => --STORE
          decoded_instruction <= I_STORE;
        when others =>
          decoded_instruction <= I_HALT;
      end case;
    end if ;
    
    
    if (instruction(14 downto 7) = "00100010") then --MOVE
      a_addr <= instruction(1 downto 0);
      b_addr <= instruction(1 downto 0);
    elsif (instruction(14 downto 7) = "00000100") then  --STORE
      a_addr <= instruction(6 downto 5);
    else  --Outras operacoes
      a_addr <= instruction(3 downto 2);
      b_addr <= instruction(1 downto 0);  
    end if;
  end process;



  --Controle da ULA
  process(bus_a,bus_b,operation)
    begin
      data_out <= bus_a;
      if (operation = "11") then
        ula_out <=  bus_a and bus_b;--AND   11
      elsif (operation = "10")  then
        ula_out <=  bus_a - bus_b;  --SUB   10
      elsif (operation = "01") then
        ula_out <=  bus_a + bus_b;  --ADD   01
      else
        ula_out <= bus_a or bus_b;  --OR    00
      end if;
  end process;
end rtl;
