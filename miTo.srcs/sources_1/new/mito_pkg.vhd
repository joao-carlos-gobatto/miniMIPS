----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;



package mito_pkg is
                                                                                                                                                            --NOVAS
  type decoded_instruction_type is (I_LOAD, I_LOADI, I_STORE, I_ADD, I_SUB, I_AND, I_OR, I_ADDI, I_SUBI, I_MOV, I_MULI, I_JMP, I_BEQ, I_BNE, I_HALT, I_NOP, I_ADDSTORE, I_ADDLOAD, I_SUBSTORE, I_SUBLOAD, I_LUILW, I_LIS, I_LDS, I_MULT);
  
  component data_path
	Port (
		clk                 : in  std_logic;
		rst_n               : in  std_logic;
		adress_sel          : in  std_logic;
		jmp_sel             : in  std_logic;
		alu_mem_sel         : in  std_logic;
		alu_b_ind           : in  std_logic;
		pc_en               : in  std_logic;
		ir_en               : in  std_logic;
		data_en             : in  std_logic;
		write_reg_en        : in  std_logic;
		alu_op              : in  std_logic_vector (5 downto 0);
		decoded_inst        : out decoded_instruction_type;
		adress_pc           : out std_logic_vector (8 downto 0);
		flag_z              : out std_logic;
		flag_n              : out std_logic;
		mem_write_sel       : in  std_logic;
		alu_a_ind           : in  std_logic;
		saida_memoria       : in  std_logic_vector (31 downto 0);   
		entrada_memoria     : out std_logic_vector (31 downto 0) 
	);
  end component;

  component control_unit
    Port ( 
		clk                 : in  std_logic;
		rst_n               : in  std_logic;
		adress_sel          : out std_logic;
		alu_b_ind           : out std_logic;
		pc_en               : out std_logic;
		ir_en               : out std_logic;
		data_en             : out std_logic;
		write_reg_en        : out std_logic;
		jmp_sel             : out std_logic;
		alu_mem_sel         : out std_logic;
		write_mem_en        : out std_logic;
		decoded_inst        : in  decoded_instruction_type;
		mem_write_sel       : out std_logic; 
		alu_op              : out std_logic_vector (5 downto 0);
		flag_z              : in  std_logic;
		alu_a_ind           : out std_logic;
		flag_n              : in  std_logic
	);
  end component;
  
  component memory is
		port(        
          clk               : in  std_logic;
          saida_memoria     : out std_logic_vector (31 downto 0);
          entrada_memoria   : in  std_logic_vector (31 downto 0);
          escrita           : in  std_logic;
          endereco_memoria  : in  std_logic_vector (8  downto 0);
          rst_n             : in  std_logic
		;
          
  end component;

  component mito
  port (
    rst_n        			: in  std_logic;
    clk          			: in  std_logic;
    adress_pc    			: in  std_logic_vector (8  downto 0);
    saida_memoria 			: in  std_logic_vector (31 downto 0);  
    entrada_memoria 		: out std_logic_vector (31 downto 0); 
    write_enable 			: out std_logic
  );
  end component;
  
 component testbench is
  port (
       signal clk 				: in  std_logic := '0';
       signal reset 			: in  std_logic;
       signal saida_memoria 	: in  std_logic_vector (31 downto 0);
       signal entrada_memoriao 	: out std_logic_vector (31 downto 0)
  ); 
  
  end component;   

end mito_pkg;

package body mito_pkg is
end mito_pkg;