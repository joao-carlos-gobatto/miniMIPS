----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineer: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mito;
use mito.mito_pkg.all;

entity control_unit is
    Port (
        --Sinais de controle
        clk                   : in	std_logic;
        rst_n                 : in	std_logic;
        decoded_instruction   : in decoded_instruction_type;
        estado_atual          : out estados;
        prox_estado           : out estados;
        halt                  : out  std_logic;
        is_jump               : out std_logic;
        is_branch             : out std_logic;
        is_beq                : out std_logic;
        select_data           : out  std_logic;        
        ula_op                : out  std_logic;
        reg_write		      : out  std_logic;
        pc_enable             : out  std_logic;
        mem_write             : out	 std_logic;
        mem_read              : out	 std_logic;
        mem_access_inst       : out  std_logic;
        read_decoder          : out  std_logic
    ); 
  end control_unit;

architecture Behavioral of control_unit is
    signal estado_atual_s : estados;
    signal prox_estado_s  : estados;
begin
  estado_atual <= estado_atual_s;
  prox_estado  <= prox_estado_s;
  
  process (clk)
    begin
        if(rst_n = '1') then
            estado_atual_s <= FETCH;
        else
            if(clk = '1' and clk'event) then
                estado_atual_s <= prox_estado_s;
            end if;
        end if;
    end process;
    
  process(clk)
  begin
      case(estado_atual_s) is
          when FETCH =>
              mem_read <= '1';
              read_decoder <= '1';
              pc_enable <= '0';
              prox_estado_s <= DECODE;
  
          when DECODE =>
              read_decoder <= '0';
              mem_read <= '0';
              pc_enable <= '0';
              case decoded_instruction is
                  when I_LOAD =>
                    prox_estado_s <= LOAD;
                    
                  when I_ADD =>
                    ula_op <= '1';
                    prox_estado_s <= ULA1;
                    
                  when I_SUB =>
                    ula_op <= '0';
                    prox_estado_s <= ULA1;
                    
                  when I_JUMP =>
                    prox_estado_s <= JUMP;
                  
                  when I_BEQ =>
                    prox_estado_s <= BEQ;
                  
                  when I_BNE =>
                    prox_estado_s <= BNE;
                    
                  when I_STORE =>
                      prox_estado_s <= STORE;
                  when others =>
                      prox_estado_s <= HALT_E;
              end case;
  
      when LOAD =>
          select_data <= '1';
          mem_access_inst <= '1';
          mem_read <= '1';
          prox_estado_s <= LOAD1;
      
      when LOAD1 =>
          reg_write <= '1';
          prox_estado_s <= LOAD2;
          
      when LOAD2 =>
          mem_read <= '0';
          select_data <= '0';
          mem_access_inst <= '0';
          reg_write <= '0';
          prox_estado_s <= PROX;
  
      when STORE =>
          mem_access_inst <= '1';
          mem_write <= '1';
          prox_estado_s <= STORE1;
          
      when STORE1 =>
          mem_access_inst <= '0';
          mem_write <= '0';
          prox_estado_s <= PROX;

      when ULA1 =>
        select_data <= '0';
        reg_write <= '1';
        prox_estado_s <= ULA2;
        
      when ULA2 =>
        reg_write <= '0';
        prox_estado_s <= PROX;
        
      when JUMP =>
        is_jump <= '1';
        prox_estado_s <= JUMP1;
        
      when JUMP1 =>
        is_jump <= '0';
        prox_estado_s <= PROX;
        
      when BEQ =>
        is_jump <= '0';
        is_beq <= '1';
        is_branch <= '1';
        ula_op <= '0';
        prox_estado_s <= BRANCH;
        
      when BNE =>
        is_jump <= '0';
        is_beq <= '0';
        is_branch <= '1';
        ula_op <= '0';
        prox_estado_s <= BRANCH;
        
      when BRANCH =>
        is_beq <= '0';
        is_branch <= '0';
        prox_estado_s <= PROX;
  
      when PROX =>
          pc_enable <= '1';
          prox_estado_s <= FETCH;
  
      when others =>  --HALT
          if(rst_n = '1') then
              halt <= '0';
          else
              halt <= '1';
              mem_read <='0';
              prox_estado_s <= HALT_E;
          end if;
      end case;
  end process;
end Behavioral;