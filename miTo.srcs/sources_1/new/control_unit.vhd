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
        halt                  : out  std_logic;
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
    signal estado_atual : estados;
    signal prox_estado  : estados;
begin  
  process (clk)
    begin
        if(rst_n = '1') then
            estado_atual <= FETCH;
        else
            if(clk = '1' and clk'event) then
                estado_atual <= prox_estado;
            end if;
        end if;
    end process;
    
  process(clk)
  begin
      case(estado_atual) is
          when FETCH =>
              mem_read <= '1';
              read_decoder <= '1';
              pc_enable <= '0';
              prox_estado <= DECODE;
  
          when DECODE =>
              read_decoder <= '0';
              mem_read <= '0';
              pc_enable <= '0';
              case decoded_instruction is
                  when I_LOAD =>
                    prox_estado <= LOAD;
                    
                  when I_ADD =>
                    ula_op <= '1';
                    prox_estado <= ULA1;
                    
                  when I_SUB =>
                    ula_op <= '0';
                    prox_estado <= ULA1;
                    
                  when I_STORE =>
                      prox_estado <= STORE;
                  when others =>
                      prox_estado <= HALT_E;
              end case;
  
      when LOAD =>
          select_data <= '1';
          mem_access_inst <= '1';
          mem_read <= '1';
          prox_estado <= LOAD1;
      
      when LOAD1 =>
          reg_write <= '1';
          prox_estado <= LOAD2;
          
      when LOAD2 =>
          mem_read <= '0';
          select_data <= '0';
          mem_access_inst <= '0';
          reg_write <= '0';
          prox_estado <= PROX;
  
      when STORE =>
          mem_access_inst <= '1';
          mem_write <= '1';
          prox_estado <= STORE1;
          
      when STORE1 =>
          mem_access_inst <= '0';
          mem_write <= '0';
          prox_estado <= PROX;

      when ULA1 =>
        select_data <= '0';
        reg_write <= '1';
        prox_estado <= ULA2;
        
      when ULA2 =>
        reg_write <= '0';
        prox_estado <= PROX;
  
      when PROX =>
          pc_enable <= '1';
          prox_estado <= FETCH;
  
      when others =>  --HALT
          if(rst_n = '1') then
              halt <= '0';
          else
              halt <= '1';
              mem_read <='0';
              prox_estado <= HALT_E;
          end if;
      end case;
  end process;
end Behavioral;