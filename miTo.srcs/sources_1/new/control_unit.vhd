----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
library mito;
use mito.mito_pkg.all;

entity control_unit is
    Port ( 
        clk                 : in  std_logic;
        rst_n               : in  std_logic;
        decoded_inst        : in  decoded_instruction_type;

        reg_write           : out std_logic;    --Habilita escrita no banco de registradores.
        mem_write           : out std_logic;    --Habilita escrita na memória (Para stores).
        mem_read            : out std_logic;    --Habilita leitura da memória (Para loads).

        alu_op              : out std_logic_vector(1 downto 0);     --Seleciona operação da ULA (ADD, SUB, AND, OR).
        is_beq              : out std_logic;    --Informa se a instrução de branch é BEQ ou se é BNEG.
        jump                : out std_logic;    --Informa se é uma instrução de JUMP.
        branch              : out std_logic;    --Informa se é uma instrução de Branch.
        pc_en               : out std_logic;    --Escolhe dado vindo do registrador de endereço ou do PC.
        halt                : out std_logic;    --Informa parada do processo.
    );
end control_unit;


architecture rtl of control_unit is
    architecture rtl of control_unit is
    type estados is (
    HALT,
    ADD,
    SUB,
    LOAD,
    STORE,
    JUM,
    BEQ,
    BNE
    );
    signal estado_atual : estados;
    signal prox_estado : estados;

begin
    process (clk)
        begin
            if (clk'event and clk='1') then
                if (rst_n='0') then
                    estado_atual <= FETCH;
                else
                    estado_atual <= prox_estado;
                end if;
            end if;
    end process;
    
    process(clk,estado_atual)
        begin
            prox_estado <= estado_atual;
            case(estado_atual) is
                when FETCH =>
                    --ram_write_enable <= '0';
                    addr_sel <= '1';
                    c_sel <= '0';
                    ir_enable <= '1';
                    flags_reg_enable <= '0';
                    pc_enable <='0';
                    write_reg_enable <='0';
                    halt <= '0';
                    prox_estado <= DECODE;
                when DECODE =>
                    ir_enable <= '0';
                    case decoded_instruction is
                        when I_NOP =>
                            prox_estado <= NOP;
                            
                        when I_MOVE =>
                            prox_estado <= MOVE;
                        
                        when I_STORE =>
                            prox_estado <= STORE;
                            
                        when I_LOAD =>
                            prox_estado <= LOAD;

                        when I_OR =>
                            operation <= "00";
                            prox_estado <= ULA;

                        when I_ADD =>
                            operation <= "01";
                            prox_estado <= ULA;

                        when I_SUB =>
                            operation <= "10";
                            prox_estado <= ULA;

                        when I_AND =>
                            operation <= "11";
                            prox_estado <= ULA;

                        when I_BRANCH =>
                            prox_estado <= BRANCHI;

                        when I_BNEG =>
                            if (neg_op = '1') then
                                prox_estado <= BRANCHI;
                            else
                                prox_estado <= PROX;
                            end if;
                        when I_BZERO =>
                            if (zero_op = '1') then
                                prox_estado <= BRANCHI;
                            else
                                prox_estado <= PROX;
                            end if;
                        when others =>
                            prox_estado <= HALTI;
                    end case;
                
                when NOP =>
                    ir_enable <= '0';
                    flags_reg_enable <= '0';
                    branch <= '0';
                    pc_enable <='0';
                    halt <= '0';
                    write_reg_enable <='0';
                    prox_estado <= PROX;

                when HALTI =>
                    ir_enable <= '0';
                    flags_reg_enable <= '0';
                    branch <= '0';
                    pc_enable <='0';
                    write_reg_enable <='0';
                    halt <= '1';
                    prox_estado <= HALTI;

                when LOAD =>
                    ir_enable <= '0';
                    flags_reg_enable <= '0';
                    addr_sel <= '0';
                    branch <= '0';
                    halt <= '0';
                    write_reg_enable <= '0';
                    prox_estado <= LOAD1;
                    
                when LOAD1 =>
                    c_sel <= '1';
                    write_reg_enable <= '1';
                    prox_estado <= PROX;

                when STORE =>
                    addr_sel <= '0';    
                    ram_write_enable <= '1';
                    prox_estado <= PROX;      

                when MOVE =>
                    ir_enable <= '0';
                    flags_reg_enable <= '0';
                    operation <= "00";
                    c_sel <= '0';
                    halt <= '0';
                    write_reg_enable <= '1';
                    prox_estado <= PROX;
                    
                when ULA =>
                    c_sel <= '0';
                    write_reg_enable <= '1';
                    ir_enable <= '0';
                    flags_reg_enable <= '1';
                    prox_estado <= PROX;

                when BRANCHI =>
                    branch <= '1';
                    ir_enable <= '0';
                    flags_reg_enable <= '0';
                    addr_sel <= '0';  
                    prox_estado <= PROX;

                when PROX =>       
                    ir_enable <= '0';
                    flags_reg_enable <= '0';
                    pc_enable <='1';
                    addr_sel <= '1';
                    halt <= '0';
                    write_reg_enable <='0';
                    ram_write_enable <='0';
                    prox_estado <= PROX1;
            
                when others =>  --PROX1
                    branch <= '0';
                    ir_enable <= '0';
                    flags_reg_enable <= '0';
                    pc_enable <='0';
                    halt <= '0';
                    write_reg_enable <='0';
                    prox_estado <= FETCH;
            end case ;
    end process ;
end rtl;
