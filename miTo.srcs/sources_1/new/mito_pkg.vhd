----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

package mito_pkg is
  component ula
	Port (
		clk                		: in  std_logic;
		rst_n              		: in  std_logic;
		alu_op             		: in  std_logic;
		s0						: in std_logic_vector(15 downto 0);
		s1						: in std_logic_vector(15 downto 0);
		ula_out					: out std_logic_vector(15 downto 0);
		zero_flag          		: out std_logic
	);
  end component;

  component mito
	Port (
		clk                		: in  std_logic;
		rst_n              		: in  std_logic;
		alu_op             		: in  std_logic;
		s0						: in std_logic_vector(15 downto 0);
		s1						: in std_logic_vector(15 downto 0);
		ula_out					: out std_logic_vector(15 downto 0);
		zero_flag          		: out std_logic
	);
  end component;
  
 component testbench is
	Port (
		clk                		: out  std_logic;
		rst_n              		: out  std_logic;
		alu_op             		: out  std_logic;
		s0						: out std_logic_vector(15 downto 0);
		s1						: out std_logic_vector(15 downto 0);
		ula_out					: in std_logic_vector(15 downto 0);
		zero_flag          		: in std_logic
	); 
  end component;

end mito_pkg;

package body mito_pkg is
end mito_pkg;