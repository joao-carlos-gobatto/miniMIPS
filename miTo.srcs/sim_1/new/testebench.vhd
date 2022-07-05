----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineer: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mito;
use mito.mito_pkg.all;

entity testebench is
end testebench;

architecture Behavioral of testebench is
  component miTo is
    Port (
      clk             : in	std_logic;
      rst_n           : in	std_logic;
      halt            : in  std_logic;
      pc_enable       : in  std_logic;
      is_store        : in  std_logic;        
      mem_write       : in	std_logic;
      mem_read        : in	std_logic;
      ram_addr        : out	std_logic_vector(6  downto 0);
      data_to_mem     : in	std_logic_vector(15 downto 0);
      instruction     : out	std_logic_vector(15 downto 0);
      addr_a                : out std_logic_vector(1 downto 0);
      addr_b                : out std_logic_vector(1 downto 0);
      addr_dest             : out std_logic_vector(1 downto 0);
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
    
  --control signals
  signal clk_s          : std_logic :='0';
  signal rst_n_s        : std_logic :='0';
  signal halt_s         : std_logic :='0';
  signal pc_enable_s    : std_logic :='0';
  signal is_store_s     : std_logic :='0';        
  signal mem_write_s    : std_logic :='0';
  signal mem_read_s     : std_logic :='0';
  signal ram_addr_s     : std_logic_vector (6 downto 0) := "0000000";
  signal data_to_mem_s  : std_logic_vector (15 downto 0);
  signal instruction_s  : std_logic_vector (15 downto 0);
  signal decoded_instruction_s : decoded_instruction_type;
  signal estado_atual : estados;
  signal prox_estado : estados;
  signal clk_s_s                 : std_logic :='0';
  signal addr_a_s                : std_logic_vector(1 downto 0);
  signal addr_b_s                : std_logic_vector(1 downto 0);
  signal addr_dest_s             : std_logic_vector(1 downto 0);
  signal inst_addr_s             : std_logic_vector(6 downto 0);
        
begin
                   
  signal clk_s                : std_logic :='0';
  signal rst_n_s              : std_logic := '0';

  signal is_load_s            : std_logic;
  signal reg_write_s          : std_logic := '0';
  signal data_s               : std_logic_vector(15 downto 0);
  signal addr_dest_s          : std_logic_vector(1 downto 0);
  signal addr_a_s             : std_logic_vector(1 downto 0);
  signal addr_b_s             : std_logic_vector(1 downto 0);
  signal data_to_mem_s        : std_logic_vector(15 downto 0);
  signal r0_s                 : std_logic_vector(15 downto 0);
  signal r1_s                 : std_logic_vector(15 downto 0);
  signal r2_s                 : std_logic_vector(15 downto 0);
  signal r3_s                 : std_logic_vector(15 downto 0);
  signal s0_s                 : std_logic_vector(15 downto 0);
  signal s1_s                 : std_logic_vector(15 downto 0);       

  signal alu_op_s                   : std_logic;
  signal ula_out_s                  : std_logic_vector(15 downto 0);
  signal zero_flag_s                : std_logic;
        
begin
  miTo_i : miTo
  port map(
    clk             => clk_s,
    rst_n           => rst_n_s,
    halt            => halt_s,
    pc_enable       => pc_enable_s,
    is_store        => is_store_s,
    mem_write       => mem_write_s,
    mem_read        => mem_read_s,
    ram_addr        => ram_addr_s,
    data_to_mem     => data_to_mem_s,
    instruction     => instruction_s,
    addr_a          => addr_a_s,
    addr_b          => addr_b_s,
    addr_dest       => addr_dest_s,
    inst_addr       => inst_addr_s,
    decoded_instruction => decoded_instruction_s
    is_load         => is_load_s,
    reg_write       => reg_write_s,
    data            => data_s,
    addr_dest       => addr_dest_s,
    addr_a          => addr_a_s,
    addr_b          => addr_b_s,
    data_to_mem     => data_to_mem_s,
    s0              => s0_s,
    s1              => s1_s,
    r0              => r0_s,
    r1              => r1_s,
    r2              => r2_s,
    r3              => r3_s,
    ula_op          => alu_op_s,
    ula_out			=> ula_out_s,
	zero_flag       => zero_flag_s
  );

   --clock generator - 100MHZ
  clk_s 	<= not clk_s after 5 ns;

   --reset signal
  rst_n_s	<= '1' after 2 ns,
      '0' after 8 ns;
      
  data_to_mem_s <= "0101010101010101";

  process (clk_s)
    begin
        if(rst_n_s = '1') then
            estado_atual <= FETCH;
        else
            if(clk_s = '1' and clk_s'event) then
                estado_atual <= prox_estado;
            end if;
        end if;
    end process;
    
  process(clk_s)
  begin
      case(estado_atual) is
          when FETCH =>
              mem_read_s <= '1';
              pc_enable_s <= '0';
              prox_estado <= DECODE;
  
          when DECODE =>
              mem_read_s <= '0';
              pc_enable_s <= '0';
              case decoded_instruction_s is  
                  when I_LOAD =>
--                      is_load_s <= '1';
                      prox_estado <= LOAD;
                  when I_STORE =>
                      is_store_s <= '1';
                      prox_estado <= STORE;
                  when others =>
                      prox_estado <= HALT_E;
              end case;
  
          when LOAD =>
              prox_estado <= PROX;
          
--          when LOAD1 =>
--              prox_estado <= LOAD2;
          
--          when LOAD2 =>
--              reg_write_s <= '1';
--              prox_estado <= LOAD3;
          
--          when LOAD3 =>
--              prox_estado <= PROX;
  
      when STORE =>
          mem_write_s <= '1';
          prox_estado <= STORE1;
          
      when STORE1 =>
          is_store_s <= '0';
          mem_write_s <= '0';
          prox_estado <= PROX;
  
      when PROX =>
          mem_read_s <='0';
          pc_enable_s <= '1';
          prox_estado <= FETCH;
  
      when others =>  --HALT
          if(rst_n_s = '1') then
              halt_s <= '0';
          else
              halt_s <= '1';
              mem_read_s <='0';
              prox_estado <= HALT_E;
          end if;
      end case;
  end process;
end Behavioral;
  reg_write_s	<= '1' after 15 ns,   --LOAD REG 00
                   '0' after 20 ns,
                   '1' after 25 ns,   --LOAD REG 01
                   '0' after 30 ns,
                   '1' after 45 ns,   --ADD REG 00 + REG 01
                   '0' after 50 ns;
  
  data_s    <= "0000000000000011" after 10 ns,
               "0000000000000010" after 20 ns,
               "0000000000000000" after 35 ns;
  
  is_load_s <= '1' after 10ns,
               '0' after 35ns;   
  
  addr_dest_s <= "00" after 10 ns,
  "01" after 20 ns,
  "10" after 30 ns;
  
  addr_a_s <= "00" after 20 ns;
  
  addr_b_s <= "01" after 20 ns,
              "10" after 55 ns;
  
  alu_op_s <= '0' after 35 ns;

end Behavioral;
