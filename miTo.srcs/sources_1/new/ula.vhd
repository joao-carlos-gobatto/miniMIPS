----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

library mito;
use mito.mito_pkg.all;

entity ula is
  Port(
    ula_op                : in std_logic;
    s0                    : in  std_logic_vector(15 downto 0);
    s1                    : in  std_logic_vector(15 downto 0);
    zero_flag             : out std_logic;
    ula_out               : out std_logic_vector(15 downto 0)
  );
  
end ula;

architecture rtl of ula is
  signal ula_out_s  : std_logic_vector(15 downto 0);
  
begin  
    ula_out <= ula_out_s;
    process(s0,s1,ula_op)
    begin
        if (ula_op = '1') then
            ula_out_s <=  s0 + s1;
        else
            ula_out_s <=  s0 - s1;
        end if;
    end process;
    
    process(ula_out_s)
    begin
        if (ula_out_s = x"00") then
            zero_flag <= '1';
        else
            zero_flag <= '0';
        end if;
    end process;
end rtl;