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
    clk                   : in std_logic;
    rst_n                 : in std_logic;
    alu_op                : in std_logic;
    s0                    : in  std_logic_vector(15 downto 0);
    s1                    : in  std_logic_vector(15 downto 0);
    zero_flag             : out std_logic;
    ula_out               : out std_logic_vector(15 downto 0)
  );
  
end ula;

architecture rtl of ula is
  signal alu_out_s  : std_logic_vector(15 downto 0);
  
begin  
    process(clk)
    begin
        if(clk = '1' and clk'event) then
            if (alu_op = '1') then
            alu_out_s <=  s0 + s1;
            else
            alu_out_s <=  s0 - s1;
            end if;
            if (alu_res = x"00") then
            zero_flag <= '1';
            else
            zero_flag <= '0';
            end if;
            alu_out <= alu_out_s;
        end if;
    end process;
end rtl;