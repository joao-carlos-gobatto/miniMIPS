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
    pc_enable           : in std_logic;     --Escolhe dado vindo do registrador de endereço ou do PC.
    halt                : in std_logic;     --Informa parada do processo.
    decoded_instruction : out decoded_instruction_type;   --Instrução decodificada pelo decoder.
    
    --Sinais da ULA
    alu_op              : in std_logic;
    zero_flag           : out std_logic;     --Indica que a operação matemática feita na ULA deu zero.

    --Sinais da memória
    data                  : out std_logic_vector(15 downto 0);        --Dado saindo do reg2 para memória
    instruction           : in  std_logic_vector (15 downto 0);       --Instrução saindo da memória
    ram_addr              : out  std_logic_vector (15 downto 0);       --Dado a ser armazenado na memória
  );
end data_path;

--TODO: Implementar a arquitetura do data_path
architecture rtl of data_path is
  type reg_bank_type is array(natural range <>) of std_logic_vector(15 downto 0);
  signal banco_de_reg         : reg_bank_type(1 to 0);
  signal program_counter      : std_logic_vector(7 downto 0);
  signal reg_addr             : std_logic_vector(7 downto 0);
  signal s0 	                : std_logic_vector(15 downto 0);
  signal s1                   : std_logic_vector(15 downto 0);
  signal ula_out              : std_logic_vector(15 downto 0);
    
begin
    
  --Banco de registradores
  s0 <= banco_de_reg(conv_integer(a_addr));
  s1 <= banco_de_reg(conv_integer(b_addr));
  data <= ula_out when (reg_write = '1');

  --Decoder
  process (instruction)
  begin
    a_addr <= "00";
    b_addr <= "00";
    c_addr <= "00";
    reg_addr <= instruction(7 downto 0);

    if (instruction(15) = "0") then 
      case(instruction(14 downto 13)) is 
        when "01" =>
         decoded_instruction <= I_ADD
        when "10" =>
         decoded_instruction <= I_BEQ
        when "11" =>
         decoded_instruction <= I_LOAD
        when others =>
         decoded_instruction <= I_HALT
      end case;

    elsif (instruction(15) = "1") then 
      case(instruction(14 downto 13)) is 
        when "01" =>
         decoded_instruction <= I_SUB
        when "10" =>
         decoded_instruction <= I_BNE
        when "11" =>
         decoded_instruction <= I_STORE
        when others =>
         decoded_instruction <= I_JUMP
      end case;
    end if ;

    case(instruction(14 downto 13)) is 
      when "01" =>  --ADD e SUB
        c_addr <= instruction(12 downto 11);
        a_addr <= instruction(10 downto 9);
        b_addr <= instruction(8 downto 7);
      when "10" =>  --BEQ E BNE
        a_addr <= instruction(12 downto 11);
        b_addr <= instruction(10 downto 9);
      when "11" =>
        if(instruction(15) = "0") then --LOAD
        c_addr <= instruction(12 downto 11);
        reg_addr <= instruction(7 downto 0);
        else --STORE
        a_addr <= instruction(12 downto 11);
        b_addr <= instruction(12 downto 11);
        reg_addr <= instruction(7 downto 0);
        endif
      when others =>  --JUMP E HALT
        reg_addr <= instruction(7 downto 0);
    end case;
  end process


  --Mux da RAM
  ram_addr <= reg_addr when (pc_enable = '1') else program_counter;


  --Mux Jump or (Branch and XNOR)
  process(clk,rst_n)
    if(rst_n = '1') then
      PC <= x"00";
    else
      if (jump or (branch and (not(is_beq XOR zero))) then
        PC <= reg_addr;
      else
        if(halt = '1') then
          PC <= PC;
        else
          PC <= PC + 1;
        endif;
      endif;
    endif;
  end process;

  --Controle da ULA
  process(s0,s1,alu_op)
  begin
    data_out <= bus_a;
    if (operation = "1") then
      ula_out <=  s0 + s1;  --ADD
    else
      ula_out <=  s0 - s1;  --SUB
    end if;
    if (ula_out = x"00") then
      zero_flag <= '1';
    else
      zero_flag <= '0';
    end if;
  end process;
end rtl;
