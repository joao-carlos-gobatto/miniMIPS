----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

package mito_pkg is
  	type decoded_instruction_type is (
		I_NOP,
		I_ADD,
		I_SUB,
		I_LOAD,
		I_STORE,
		I_JUMP,
		I_BEQ,
		I_BNE,
		I_HALT
	);
  component decoder
	Port (
		instruction           : in  std_logic_vector (15 downto 0);
		addr_a                : out std_logic_vector(1 downto 0);
		addr_b                : out std_logic_vector(1 downto 0);
		addr_dest                : out std_logic_vector(1 downto 0);
		inst_addr             : out std_logic_vector(6 downto 0);
		decoded_instruction   : out decoded_instruction_type
	);
  end component;

  component mito
	Port (
		instruction           : in  std_logic_vector (15 downto 0);
    	addr_a                : out std_logic_vector(1 downto 0);
    	addr_b                : out std_logic_vector(1 downto 0);
    	addr_dest                : out std_logic_vector(1 downto 0);
    	inst_addr             : out std_logic_vector(6 downto 0);
    	decoded_instruction   : out decoded_instruction_type
	);
  end component;
  
 component testbench is
	Port (
		instruction           : out  std_logic_vector (15 downto 0);
    	addr_a                : in std_logic_vector(1 downto 0);
    	addr_b                : in std_logic_vector(1 downto 0);
    	addr_dest                : in std_logic_vector(1 downto 0);
    	inst_addr             : in std_logic_vector(6 downto 0);
    	decoded_instruction   : in decoded_instruction_type
	); 
  end component;

end mito_pkg;

package body mito_pkg is
end mito_pkg;