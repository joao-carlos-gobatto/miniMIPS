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
    clk                 : in std_logic;
    rst_n               : in std_logic;

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
    ram_addr              : out std_logic_vector (7 downto 0);       --Dado a ser armazenado na memória
    
    --Sinais do Banco de Registradores
    reg_write             : in std_logic;
    is_load               : in std_logic
  );
  
end data_path;

architecture rtl of data_path is
  type reg_bank_type is array(natural range <>) of std_logic_vector(15 downto 0);
  signal banco_de_reg         : reg_bank_type(0 to 1);
  signal program_counter      : std_logic_vector(7 downto 0);
  signal reg_addr             : std_logic_vector(7 downto 0);
  signal inst_addr            : std_logic_vector(7 downto 0);
  signal reg_addr_out         : std_logic_vector(7 downto 0);
  signal reg_data             : std_logic_vector(15 downto 0);
  signal reg_data_out         : std_logic_vector(15 downto 0);
  signal reg_instruction      : std_logic_vector(15 downto 0);
  signal reg_instruction_out  : std_logic_vector(15 downto 0);
  signal reg_in_a             : std_logic_vector(15 downto 0);
  signal reg_in_b             : std_logic_vector(15 downto 0);
  signal reg_ula_out          : std_logic_vector(15 downto 0);
  signal a_addr               : std_logic_vector(1 downto 0);
  signal b_addr               : std_logic_vector(1 downto 0);
  signal c_addr               : std_logic_vector(1 downto 0);
  signal s0   	              : std_logic_vector(15 downto 0);
  signal s1                   : std_logic_vector(15 downto 0);
  signal reg_out_a            : std_logic_vector(15 downto 0);
  signal reg_out_b            : std_logic_vector(15 downto 0);
  signal ula_out              : std_logic_vector(15 downto 0);
  signal zero                 : std_logic;
    
begin

  ram_addr <= instruction(7 downto 0) when pc_enable = '1' else 
              program_counter when pc_enable = '0';
              
  pc:process(clk)
  begin
    if (rst_n = '1') then
       program_counter <= (others => '0');
    else
       program_counter <= program_counter + 1;
    end if;     
  end process pc;
  
  ula_out_register : process(clk)
    begin
      if (clk'event and clk ='1') then
        reg_ula_out <= ula_out;
      end if;
    end process;

  instruction_register : process(clk)
    begin
      if (clk'event and clk ='1') then
        reg_instruction <= instruction;
        reg_instruction_out <= reg_instruction;
      end if;
    end process;

  s0 <= banco_de_reg(conv_integer(a_addr));
  a_register : process(clk)
    begin
      if (clk'event and clk ='1') then
        reg_in_a <= s0;
        reg_out_a <= reg_in_a;
      end if;
    end process;

  s1 <= banco_de_reg(conv_integer(b_addr));
  b_register : process(clk)
    begin
      if (clk'event and clk ='1') then
        reg_in_b <= s1;
        reg_out_b <= reg_in_b;
      end if;
    end process;

  addr_register : process(clk)
    begin
      if (clk'event and clk ='1') then
        reg_addr <= inst_addr;
        reg_addr_out <= reg_addr;
      end if;
    end process;

  data_register : process(clk)
    begin
      if (clk'event and clk ='1') then
        reg_data <= instruction;
        reg_data_out <= reg_data;
      end if;
    end process;

  --Mux do dado
  process(is_load)
  begin
    if(is_load = '1') then
      data <= reg_data_out;
    else 
      data <= reg_out_b;
    end if;
  end process;

  --Decoder
  process (instruction)
  begin
    a_addr <= "00";
    b_addr <= "00";
    c_addr <= "00";
    inst_addr <= instruction(7 downto 0);
    if (instruction(15) = '0') then 
      case(instruction(14 downto 13)) is 
        when "01" =>
         decoded_instruction <= I_ADD;
        when "10" =>
         decoded_instruction <= I_BEQ;
        when "11" =>
         decoded_instruction <= I_LOAD;
        when others =>
         decoded_instruction <= I_HALT;
      end case;
    elsif (instruction(15) = '1') then 
      case(instruction(14 downto 13)) is 
        when "01" =>
         decoded_instruction <= I_SUB;
        when "10" =>
         decoded_instruction <= I_BNE;
        when "11" =>
         decoded_instruction <= I_STORE;
        when others =>
         decoded_instruction <= I_JUMP;
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
        if(instruction(15) = '0') then --LOAD
        c_addr <= instruction(12 downto 11);
        reg_addr <= instruction(7 downto 0);
        else --STORE
        a_addr <= instruction(12 downto 11);
        b_addr <= instruction(12 downto 11);
        reg_addr <= instruction(7 downto 0);
        end if;
      when others =>  --JUMP E HALT
        reg_addr <= instruction(7 downto 0);
    end case;
  end process;

  --Mux Jump or (Branch and XNOR)
  process(rst_n, jump,branch, is_beq, zero, halt, reg_addr, program_counter)
  begin
    if(rst_n = '1') then
      program_counter <= x"00";
    else
      if(jump = '1') then
        program_counter <= reg_addr;
      elsif(not(is_beq = '1' XOR zero = '1')) then
        if(branch = '1') then
            program_counter <= reg_addr;
        end if;
      else
        if(halt = '1') then
          program_counter <= program_counter;
        else
          program_counter <= program_counter + 1;
        end if;
      end if;
    end if;
  end process;

  --Controle da ULA
--    process(s0,s1,alu_op)
--    begin
--      data <= s1;
--      if (alu_op = '1') then
--        ula_out <=  reg_out_a + reg_out_b;  --ADD
--      else
--        ula_out <=  reg_out_a + reg_out_b;  --SUB
--      end if;
--      if (ula_out = x"00") then
--        zero_flag <= '1';
--        zero <= '1';
--      else
--        zero_flag <= '0';
--        zero <= '1';
--      end if;
--    end process;
end rtl;
