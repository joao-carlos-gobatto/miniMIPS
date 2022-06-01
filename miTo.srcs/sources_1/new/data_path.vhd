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
  Port(
    clk                   : in std_logic;
    rst_n                 : in std_logic;

    --Sinais de controle gerais
    is_beq                : in std_logic;     --Informa se a instrução de branch é BEQ ou se é BNEG.
    jump                  : in std_logic;     --Informa se é uma instrução de JUMP.
    branch                : in std_logic;     --Informa se é uma instrução de Branch.
    pc_enable             : in std_logic;     --Escolhe dado vindo do registrador de endereço ou do PC.
    halt                  : in std_logic;     --Informa parada do processo.
    decoded_instruction   : out decoded_instruction_type;   --Instrução decodificada pelo decoder.
    
    --Sinais da ULA
    alu_op                : in std_logic;
    zero_flag             : out std_logic;     --Indica que a operação matemática feita na ULA deu zero.

    --Sinais da memória
    data                  : out std_logic_vector(15 downto 0);        --Dado saindo do reg2 para memória
    instruction           : in  std_logic_vector (15 downto 0);       --Instrução saindo da memória
    ram_addr              : out std_logic_vector (7 downto 0);       --Dado a ser armazenado na memória
    
    --Sinais do Banco de Registradores
    reg_write             : in std_logic;
    is_load               : in std_logic
  );
  
end data_path;

architecture rtl of data_path is
  signal reg_addr : std_logic_vector(7 downto 0);
  signal pc       : std_logic_vector(7 downto 0);
  signal inst_reg : std_logic_vector(15 downto 0);
    
begin

    program_counter:process(clk)
    begin
        if(rst_n='1') then
            pc <= "00000000";
        else
            if(clk'event or clk='1') then
                pc <= pc + 1;
            end if;
        end if;
    end process;
    
    ram_addr <= pc;
    
    inst_load: process(clk)
    begin
        inst_reg <= instruction;
    end process;
    
    --Decoder
    decoded_instruction <= I_HALT when instruction(15 downto 13) = "000" else
          I_ADD  when instruction(15 downto 13) = "001" else
          I_BEQ    when instruction(15 downto 13) = "010" else
          I_LOAD    when instruction(15 downto 13) = "011" else
          I_JUMP    when instruction(15 downto 13) = "100" else
          I_SUB     when instruction(15 downto 13) = "101" else
          I_BNE    when instruction(15 downto 13) = "110" else
          I_STORE    when instruction(15 downto 13) = "111";

end rtl;
