----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mito;
use mito.mito_pkg.all;

entity miTo is
  Port (
    instruction           : in  std_logic_vector (15 downto 0);       --Instrução saindo da memória
    addr_a                : out std_logic_vector(1 downto 0);
    addr_b                : out std_logic_vector(1 downto 0);
    addr_dest             : out std_logic_vector(1 downto 0);
    inst_addr             : out std_logic_vector(6 downto 0);
    decoded_instruction   : out decoded_instruction_type   --Instrução decodificada pelo decoder.
  );
end miTo;

architecture rtl of miTo is
begin
decoder_i : decoder
  Port map (
    instruction          => instruction,
    addr_a               => addr_a,
    addr_b               => addr_b,
    addr_dest            => addr_dest,
    inst_addr            => inst_addr,
    decoded_instruction  => decoded_instruction
  );
 
end rtl;