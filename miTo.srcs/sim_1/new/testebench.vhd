----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineer: Newton Jr
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mito;
use mito.mito_pkg.all;


entity testebench is

end testebench;

architecture Behavioral of testebench is

    component miTo is
    port (
         signal clk             : in  std_logic :='0';
         signal rst_n           : in  std_logic :='0';
         signal saida_memoria   : in  std_logic_vector (31 downto 0);
         signal entrada_memoria : out std_logic_vector (31 downto 0)         
    ); 
    
    end component;   
     
        -- control signals
        signal clk_s            : std_logic :='0';
        signal reset_s          : std_logic;
        signal saida_memoria_s  : std_logic_vector (31 downto 0);
        signal entrada_memoria_s: std_logic_vector (31 downto 0);
        
    begin
    
      miTo_i : miTo
      port map(
        clk                 => clk_s,
        rst_n               => reset_s,   
        saida_memoria       => saida_memoria_s,
        entrada_memoria     => entrada_memoria_s
      );

    -- clock generator - 100MHZ
    clk_s 	<= not clk_s after 5 ns;
    
    -- reset signal
    reset_s		<= '1' after 2 ns,
		   '0' after 4 ns;	

end Behavioral;
