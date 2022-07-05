----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

package mito_pkg is  

    type decoded_instruction_type is (
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
        STORE1,
        STORE2,
        STORE3,
        JUMP_E,
        BEQ,
        BNE,
        ULA,
        BRANCH_E,
        DECODE
    );
    
  component memory is
	Port (        
		clk                 	: in	std_logic;
        rst_n               	: in	std_logic;        
        mem_write           	: in	std_logic;
		mem_read				: in	std_logic;
        ram_addr		    	: in	std_logic_vector(6  downto 0);
		data_to_mem    			: in	std_logic_vector(15 downto 0);
        instruction         	: out	std_logic_vector(15 downto 0)
  );
  end component;

  component decoder
	Port (
		instruction           : in  std_logic_vector (15 downto 0);
		addr_a                : out std_logic_vector(1 downto 0);
		addr_b                : out std_logic_vector(1 downto 0);
		addr_dest             : out std_logic_vector(1 downto 0);
		inst_addr             : out std_logic_vector(6 downto 0);
		decoded_instruction   : out decoded_instruction_type
package mito_pkg is
  	
  component registers_bank
	Port (
		clk             : in std_logic;
		reg_write		: in std_logic;
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
  end component;
  component ula
	Port (
		ula_op             		: in  std_logic;
		s0						: in std_logic_vector(15 downto 0);
		s1						: in std_logic_vector(15 downto 0);
		ula_out					: out std_logic_vector(15 downto 0);
		zero_flag          		: out std_logic
	);
  end component;

  component mito
	Port (
		clk             : in	std_logic;
        rst_n           : in	std_logic;
        halt            : in    std_logic;
        pc_enable       : in    std_logic;
        is_store        : in    std_logic;        
        mem_write       : in	std_logic;
        mem_read        : in	std_logic;
        ram_addr        : out	std_logic_vector(6  downto 0);
        data_to_mem     : in	std_logic_vector(15 downto 0);
        instruction     : out	std_logic_vector(15 downto 0);
    	addr_a                : out std_logic_vector(1 downto 0);
    	addr_b                : out std_logic_vector(1 downto 0);
    	addr_dest                : out std_logic_vector(1 downto 0);
    	inst_addr             : out std_logic_vector(6 downto 0);
    	decoded_instruction   : out decoded_instruction_type
		clk             : in std_logic;
    	rst_n           : in std_logic;
        
        is_load         : in std_logic;
		reg_write		: in std_logic;
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
    	r3              : out std_logic_vector(15 downto 0);

		ula_op          : in  std_logic;
		ula_out			: out std_logic_vector(15 downto 0);
		zero_flag       : out std_logic
	);
  end component;
  
 component testbench is
	Port (
		clk             : out	std_logic;
        rst_n           : out	std_logic;
        halt            : out    std_logic;
        pc_enable       : out    std_logic;
        is_store        : out    std_logic;        
        mem_write       : out	std_logic;
        mem_read        : out	std_logic;
        ram_addr        : in	std_logic_vector(6  downto 0);
        data_to_mem     : out	std_logic_vector(15 downto 0);
		instruction           : out  std_logic_vector (15 downto 0);
    	addr_a                : in std_logic_vector(1 downto 0);
    	addr_b                : in std_logic_vector(1 downto 0);
    	addr_dest                : in std_logic_vector(1 downto 0);
    	inst_addr             : in std_logic_vector(6 downto 0);
    	decoded_instruction   : in decoded_instruction_type
		clk             : out std_logic;
    	rst_n           : out std_logic;

        is_load         : out std_logic;
		reg_write		: out std_logic;
    	data            : out std_logic_vector(15 downto 0);
    	addr_dest       : out std_logic_vector(1 downto 0);
    	addr_a          : out std_logic_vector(1 downto 0);
    	addr_b          : out std_logic_vector(1 downto 0);
    	data_to_mem     : in std_logic_vector(15 downto 0);
    	s0              : in std_logic_vector(15 downto 0);
    	s1              : in std_logic_vector(15 downto 0);
    	r0              : in std_logic_vector(15 downto 0);
    	r1              : in std_logic_vector(15 downto 0);
    	r2              : in std_logic_vector(15 downto 0);
    	r3              : in std_logic_vector(15 downto 0);

		ula_op          : out  std_logic;
		ula_out			: in std_logic_vector(15 downto 0);
		zero_flag       : in std_logic
	); 
  end component;
end mito_pkg;
package body mito_pkg is
end mito_pkg;