----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

package mito_pkg is  
  component memory is
	Port (        
		clk                 	: in	std_logic;
        rst_n               	: in	std_logic;        
        mem_write           	: in	std_logic;
		mem_read				: in	std_logic;
        ram_addr		    	: in	std_logic_vector(7  downto 0);
		data_to_mem    			: in	std_logic_vector(15 downto 0);
        instruction         	: out	std_logic_vector(15 downto 0)
	);
  end component;

  component mito
	Port (
		clk                 	: in	std_logic;
        rst_n               	: in	std_logic;        
        mem_write           	: in	std_logic;
		mem_read				: in	std_logic;
        ram_addr		    	: in	std_logic_vector(7  downto 0);
		data_to_mem    			: in	std_logic_vector(15 downto 0);
        instruction         	: out	std_logic_vector(15 downto 0)
	);
  end component;
  
 component testbench is
	Port (
		clk                 	: out	std_logic;
        rst_n               	: out	std_logic;        
        mem_write           	: out	std_logic;
		mem_read				: out	std_logic;
        ram_addr		    	: out	std_logic_vector(7  downto 0);
		data_to_mem    			: out	std_logic_vector(15 downto 0);
        instruction         	: in	std_logic_vector(15 downto 0)
	); 
  end component;

end mito_pkg;

package body mito_pkg is
end mito_pkg;