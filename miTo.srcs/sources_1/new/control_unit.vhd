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
        
        zero_flag           : in std_logic;     --Sinaliza 0 na operação matemática feita pela ULA.
        alu_op              : out std_logic;    --Seleciona operação da ULA (ADD, SUB, AND, OR).
        is_beq              : out std_logic;    --Informa se a instrução de branch é BEQ ou se é BNEG.
        jump                : out std_logic;    --Informa se é uma instrução de JUMP.
        branch              : out std_logic;    --Informa se é uma instrução de Branch.
        pc_enable           : out std_logic;    --Escolhe dado vindo do registrador de endereço ou do PC.
        halt                : out std_logic    --Informa parada do processo.
    );
end control_unit;


architecture rtl of control_unit is
    type decoded_instruction_type is (
		I_HALT,
		I_ADD,
		I_SUB,
		I_LOAD,
		I_STORE,
		I_JUMP,
		I_BEQ,
		I_BNE
	);

    type estados is (
        HALT_E,
        ADD,
        SUB,
        LOAD,
        STORE,
        JUMP_E,
        BEQ,
        BNE,
        ULA,        --Estado em que a ULA faz a operação.
        BRANCH_E,     --Estado em que o sistema da um branch.
        FETCH,      --Estado em que a unidade de controle pega a instrução.
        DECODE,     --Control unit decodifica instrução e define o próximo estado.
        PROX        --Prepara os sinais para o próximo FETCH.
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
    process(clk,estado_atual,decoded_instruction, zero_flag)
        begin
            prox_estado <= estado_atual;
            case(estado_atual) is
                when FETCH =>
                    pc_enable <= '0';
                    mem_read <= '1';
                    mem_write <= '0';
                    reg_write <= '0';
                    halt <= '0';
                    jump <= '0';
                    branch <= '0';
                    is_beq <='0';
                    alu_op <='0';
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
                            else
                                prox_estado <= PROX;
                            end if;
                        when I_BNE =>
                            if(zero_flag = '0') then
                                is_beq <= '0';
                                alu_op <= '0';
                                prox_estado <= BRANCH_E;
                            else
                                prox_estado <= PROX;
                            end if;
                        when I_HALT =>
                            halt <= '1';
                            prox_estado <= HALT_E;
                    end case;

                when PROX =>
                    pc_enable <= '0';
                    mem_read <= '0';
                    mem_write <= '0';
                    reg_write <= '0';
                    halt <= '0';
                    jump <= '0';
                    branch <= '0';
                    is_beq <='0';
                    alu_op <='0';
                    prox_estado <= FETCH;

                when LOAD =>
                    mem_read <= '1';
                    reg_write <= '1';
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
                    mem_read <= '0';
                    prox_estado <= PROX;

                when others =>  --HALT
                    halt <= '1';
                    jump <= '0';
                    branch <= '0';
                    pc_enable <='0';
                    is_beq <= '0';
                    alu_op <= '0';
                    reg_write <= '0';
                    mem_read <='0';
                    mem_read <= '0';
                    prox_estado <= HALT_E;
            end case ;
    end process ;
end rtl;
