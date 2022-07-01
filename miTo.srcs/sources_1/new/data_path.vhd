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
    reg_b_out             : out std_logic_vector(15 downto 0);        --Dado saindo do reg2 para memória
    instruction           : in  std_logic_vector (15 downto 0);       --Instrução saindo da memória
    ram_addr              : out std_logic_vector (7 downto 0);       --Dado a ser armazenado na memória
    
    --Sinais do Banco de Registradores
    reg_write             : in std_logic;
    is_load               : in std_logic
  );
  
end data_path;

architecture rtl of data_path is
  --Registradores e entradas do banco de registradores
  signal r0 : std_logic_vector(15 downto 0);
  signal r1 : std_logic_vector(15 downto 0);
  signal r2 : std_logic_vector(15 downto 0);
  signal r3 : std_logic_vector(15 downto 0); 
  signal addr_a   : std_logic_vector(1 downto 0);
  signal addr_b   : std_logic_vector(1 downto 0);
  signal addr_c   : std_logic_vector(1 downto 0);
  signal data     : std_logic_vector(15 downto 0);
  
  --Registrador de endere�o de mem�ria
  signal reg_addr : std_logic_vector(7 downto 0);
  
  --Outros
  signal pc       : std_logic_vector(7 downto 0);
  signal inst_reg : std_logic_vector(15 downto 0);
  signal reg_data :std_logic_vector(15 downto 0);
  signal reg_a    : std_logic_vector(15 downto 0);
  signal reg_b    : std_logic_vector(15 downto 0);
  signal alu_res  : std_logic_vector(15 downto 0);
  
begin
    program_counter:process(clk)
    begin
        if(rst_n = '1') then
            pc <= "00000000";
        else
            if(clk = '1' and clk'event) then
                if(pc_enable = '1') then
                    if(halt='1') then
                        pc <= pc;
                    else                        
                        pc <= pc + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
   
    ram_gets_pc:process(clk)
    begin
        if(clk='1' and clk'event) then
            if(is_load = '1') then
                ram_addr <= reg_addr;
            else
                ram_addr <= pc;
            end if;
        end if;
    end process;
    
    reg_addr_load: process(clk)
    begin
        if(clk='1' and clk'event) then
            reg_addr <= instruction(7 downto 0);
        end if;
    end process;
        
    inst_load: process(clk)
    begin
        if(clk='1' and clk'event) then
            inst_reg <= instruction;
        end if;
    end process;
    
    --Decoder
    decoder: process(clk)
    begin
        case(inst_reg(15 downto 13)) is
            when "000"=>
                decoded_instruction <= I_HALT;
            when "001"=>
                decoded_instruction <= I_ADD;
            when "010"=>
                decoded_instruction <= I_BEQ;
            when "011"=>
                decoded_instruction <= I_LOAD;
            when "100"=>
                decoded_instruction <= I_JUMP;
            when "101"=>
                decoded_instruction <= I_SUB;
            when "110"=>
                decoded_instruction <= I_BNE;
            when "111"=>
                decoded_instruction <= I_STORE;
            when others =>
                decoded_instruction <= I_NOP;
        end case;
        addr_c <= inst_reg(12 downto 11);
        addr_a <= inst_reg(11 downto 10);
        addr_b <= inst_reg(9 downto 8);
    end process;

    --Reg data
    data_register:process(clk)
    begin
        if(clk = '1' and clk'event) then
            reg_data <= instruction;
        end if;
    end process;
    
    --Mux is Load
    mux_load:process(clk)
    begin
        if(is_load = '1') then
            data <= reg_data;
        else
            data <= alu_res;
        end if;
    end process;
    
    --Carga do banco de registradores
    load_registers:process(clk)
    begin
        if(clk = '1' and clk'event) then
            if(reg_write = '1') then
                case(addr_c) is
                    when "00" =>
                        r0 <= data;
                    when "01" =>
                        r1 <= data; 
                    when "10" => 
                        r2 <= data;
                    when others =>
                        r3 <= data;
                end case;
            end if;
        end if;
    end process;
    
    --Seleciona o registrador a passar dados para a ula pelo caminho reg_a
    set_reg_a:process(clk)
    begin
        if(clk = '1' and clk'event) then
            case(addr_a) is
                when "00" => 
                    reg_a <= r0;
                when "01" => 
                    reg_a <= r1;
                when "10" => 
                    reg_a <= r2;
                when others => 
                    reg_a <= r3;
            end case;
        end if;
    end process;
    
    --Seleciona o registrador a passar dados para a ula pelo caminho reg_b
    set_reg_b:process(clk)
    begin
        if(clk = '1' and clk'event) then
            case(addr_b) is
                when "00" => 
                    reg_b <= r0;
                when "01" => 
                    reg_b <= r1;
                when "10" => 
                    reg_b <= r2;
                when others => 
                    reg_b <= r3;
            end case;
        end if;
    end process;
    
    --SSa�da Reg_b para mem�ria
    reg_b_process:process(clk)
    begin
        if(clk = '1' and clk'event) then
            reg_b_out <= reg_b;
        end if;
    end process;
  
    --Controle da ULA
    process(clk)
    begin
    if(clk = '1' and clk'event) then
        if (alu_op = '1') then
          alu_res <=  reg_a + reg_b;  --ADD
        else
          alu_res <=  reg_a - reg_b;  --SUB
        end if;
        if (alu_res = x"00") then
          zero_flag <= '1';
        else
          zero_flag <= '0';
        end if;
    end if;
    end process;
end rtl;