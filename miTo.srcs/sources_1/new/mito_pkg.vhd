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
	type estados is (
	    FETCH,
	    NOP_E,
	    PROX,
        HALT_E,
        ADD,
        SUB,
        LOAD,
        LOAD1,
        LOAD2,
        LOAD3,
        STORE,
        JUMP_E,
        BEQ,
        BNE,
        ULA,
        BRANCH_E,
        DECODE
    );  
  component data_path
	Port (
		clk                		: in  std_logic;
		rst_n              		: in  std_logic;
		is_beq             		: in  std_logic;
		jump               		: in  std_logic;
		branch             		: in  std_logic;
		pc_enable          		: in  std_logic;
		halt               		: in  std_logic;
		decoded_instruction		: out decoded_instruction_type;
		alu_op             		: in  std_logic;
		is_load           		: in  std_logic;
		zero_flag          		: out std_logic;
		reg_b_out               : out std_logic_vector(15 downto 0);
		instruction           	: in  std_logic_vector (15 downto 0);
		ram_addr              	: out std_logic_vector (7 downto 0);
		reg_write				: in  std_logic
	);
  end component;

  component control_unit
    Port ( 
  		clk                 	: in  std_logic;
        rst_n               	: in  std_logic;
        decoded_instruction  	: in  decoded_instruction_type;
        state_flag              : out estados;
        reg_write           	: out std_logic;
        mem_write           	: out std_logic;
        mem_read            	: out std_logic;
        zero_flag           	: in  std_logic; 
        alu_op              	: out std_logic;
        is_beq              	: out std_logic;
  		is_load					: out std_logic;
        jump                	: out std_logic;
        branch              	: out std_logic;
        pc_enable           	: out std_logic;
        halt                	: out std_logic
  	);
  end component;
  
  component memory is
	Port (        
		clk                 	: in  std_logic;
        rst_n               	: in  std_logic;        
        mem_write           	: in  std_logic;
		mem_read				: in  std_logic;
        ram_addr		    	: in  std_logic_vector(7  downto 0);
		reg_b_out     			: in  std_logic_vector(15 downto 0);
        instruction         	: out std_logic_vector(15 downto 0)
	);
  end component;

  component mito
	Port (
		rst_n                   : in  std_logic;
		clk                     : in  std_logic;
		decoded_instruction		: out decoded_instruction_type;
		state_flag              : out estados;
		alu_op                  : out std_logic;
		instruction             : out std_logic_vector (15 downto 0);
		ram_addr                : out std_logic_vector (7 downto 0);
		mem_write               : out std_logic;
		reg_write               : out std_logic;
		branch                  : out std_logic;
		halt                    : out std_logic
	);
  end component;
  
 component testbench is
	Port (
		clk 					: in  std_logic := '0';
		reset 					: in  std_logic;
		decoded_instruction		: in  decoded_instruction_type;
		state                   : in  estados;
		alu_op                  : in  std_logic;
		branch                  : in  std_logic;
		instruction	 			: in  std_logic_vector (15 downto 0);
		ram_addr		 		: in  std_logic_vector (15 downto 0)
	); 
  end component;

end mito_pkg;

package body mito_pkg is
end mito_pkg;