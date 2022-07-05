----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

library mito;
use mito.mito_pkg.all;

entity decoder is
  Port(
    instruction           : in  std_logic_vector (15 downto 0);       --Instrução saindo da memória
    addr_a                : out std_logic_vector(1 downto 0);
    addr_b                : out std_logic_vector(1 downto 0);
    addr_dest             : out std_logic_vector(1 downto 0);
    inst_addr             : out std_logic_vector(6 downto 0);
    read_decoder        : in  std_logic;
    decoded_instruction   : out decoded_instruction_type   --Instrução decodificada pelo decoder.
  );
  
end decoder;

architecture rtl of decoder is
  
begin
    --Decoder
    decoder: process(instruction)
    begin
        if(read_decoder = '1') then
            case(instruction(15 downto 13)) is
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
                when others=>
                    decoded_instruction <= I_STORE;
            end case;
            addr_dest <= instruction(12 downto 11);
            addr_a <= instruction(10 downto 9);
            addr_b <= instruction(8 downto 7);
            inst_addr <= instruction(6 downto 0);
        end if;
    end process;
      
end rtl;