----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

library mito;
use mito.mito_pkg.all;

entity registers_bank is
  Port(
    clk             : in std_logic;
    rst_n           : in std_logic;
    reg_write       : in std_logic;
    data            : in std_logic_vector(15 downto 0);
    addr_dest       : in std_logic_vector(1 downto 0);
    addr_a          : in std_logic_vector(1 downto 0);
    addr_b          : in std_logic_vector(1 downto 0);
    data_to_mem     : out std_logic_vector(15 downto 0);
    s0              : out std_logic_vector(15 downto 0);
    s1              : out std_logic_vector(15 downto 0);
    r0              : out std_logic_vector(15 downto 0);
    r1              : out std_logic_vector(15 downto 0);
    r2              : out std_logic_vector(15 downto 0);
    r3              : out std_logic_vector(15 downto 0) 
  );
  
end registers_bank;

architecture rtl of registers_bank is
  --Registradores e entradas do banco de registradores
  signal r0_s   : std_logic_vector(15 downto 0);
  signal r1_s   : std_logic_vector(15 downto 0);
  signal r2_s   : std_logic_vector(15 downto 0);
  signal r3_s   : std_logic_vector(15 downto 0); 
  
begin        
    --Carga do banco de registradores
    r0 <= r0_s;
    r1 <= r1_s;
    r2 <= r2_s;
    r3 <= r3_s;
    process(clk)
    begin
        if(clk = '1' and clk'event) then
            if(reg_write = '1') then
                case(addr_dest) is
                    when "00" =>
                        r0_s <= data;
                    when "01" =>
                        r1_s <= data; 
                    when "10" => 
                        r2_s <= data;
                    when others =>
                        r3_s <= data;
                end case;
            end if;

            case(addr_a) is
                when "00" => 
                    s0 <= r0_s;
                when "01" => 
                    s0 <= r1_s;
                when "10" => 
                    s0 <= r2_s;
                when others => 
                    s0 <= r3_s;
            end case;

            case(addr_b) is
                when "00" => 
                    s1 <= r0_s;
                    data_to_mem <= r0_s;
                when "01" => 
                    s1 <= r1_s;
                    data_to_mem <= r1_s;
                when "10" => 
                    s1 <= r2_s;
                    data_to_mem <= r2_s;
                when others => 
                    s1 <= r3_s;
                    data_to_mem <= r3_s;
            end case;
        end if;
    end process;
end rtl;