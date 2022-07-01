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
        decoded_instruction : in  decoded_instruction_type;

        reg_write           : out std_logic;    --Habilita escrita no banco de registradores.
        mem_write           : out std_logic;    --Habilita escrita na memória (Para stores).
        mem_read            : out std_logic;    --Habilita leitura da memória (Para loads).
        state_flag          : out estados;
        
        zero_flag           : in std_logic;     --Sinaliza 0 na operação matemática feita pela ULA.
        alu_op              : out std_logic;    --Seleciona operação da ULA (ADD, SUB, AND, OR).
        is_beq              : out std_logic;    --Informa se a instrução de branch é BEQ ou se é BNEG.
        is_load             : out std_logic;    --Informa se a instrução é Load.
        jump                : out std_logic;    --Informa se é uma instrução de JUMP.
        branch              : out std_logic;    --Informa se é uma instrução de Branch.
        pc_enable           : out std_logic;    --Escolhe dado vindo do registrador de endereço ou do PC.
        halt                : out std_logic    --Informa parada do processo.
    );
end control_unit;


architecture rtl of control_unit is
    signal estado_atual : estados;
    signal prox_estado : estados;

begin
    process (clk)
    begin
        if(rst_n = '1') then
            estado_atual <= FETCH;
        else
            if(clk = '1' and clk'event) then
                estado_atual <= prox_estado;
                state_flag <= estado_atual;
            end if;
        end if;
    end process;
    
    process(estado_atual)
        begin
            case(estado_atual) is
                when FETCH =>
                    pc_enable <= '0';
                    mem_read <= '1';
                    prox_estado <= DECODE;
        
                when DECODE =>
                    mem_read <= '0';
                    case decoded_instruction is
                        when I_ADD =>
                            alu_op <= '1';
                            prox_estado <= ULA;
        
                        when I_SUB =>
                            alu_op <= '0';
                            prox_estado <= ULA;
        
                        when I_LOAD =>
                            is_load <= '1';
                            prox_estado <= LOAD;
        
                        when I_STORE =>
                            prox_estado <= STORE;
        
                        when I_JUMP =>
                            prox_estado <= JUMP_E;
        
                        when I_BEQ =>
                            if(zero_flag = '1') then
                                is_beq <= '1';
                                alu_op <= '0';
                                prox_estado <= BRANCH_E;
                            end if;
                        when I_BNE =>
                            if(zero_flag = '0') then
                                is_beq <= '0';
                                alu_op <= '0';
                                prox_estado <= BRANCH_E;
                            end if;
                        when I_HALT =>
                            prox_estado <= HALT_E;
                        when others =>
                            prox_estado <= NOP_E;
                    end case;
        
            when LOAD =>
                prox_estado <= LOAD1;
                
            when LOAD1 =>
                prox_estado <= LOAD2;
                
            when LOAD2 =>
                reg_write <= '1';
                prox_estado <= LOAD3;
                
            when LOAD3 =>
                prox_estado <= PROX;
        
            when STORE =>
                mem_write <= '1';
                prox_estado <= PROX;
        
            when JUMP_E => 
                jump <= '1';
                prox_estado <= PROX;
        
            when BRANCH_E =>
                branch <= '1';
                prox_estado <= PROX;
        
            when ULA =>
                reg_write <= '1';
                prox_estado <= PROX;
            
            when NOP_E =>
                prox_estado <= FETCH;
        
            when HALT_E =>  --HALT
                if(rst_n = '1') then
                    halt <= '0';
                    prox_estado <= PROX;
                else
                    halt <= '1';
                    jump <= '0';
                    branch <= '0';
                    is_beq <= '0';
                    alu_op <= '0';
                    reg_write <= '0';
                    mem_read <='0';
                    prox_estado <= HALT_E;
                end if;
                
            when others => --PROX
                mem_write <= '0';
                jump <= '0';
                branch <= '0';
                is_beq <='0';
                is_load <= '0';
                alu_op <= '0';
                reg_write <= '0';
                pc_enable <= '1';
                prox_estado <= FETCH;
            end case;
    end process;
end rtl;
