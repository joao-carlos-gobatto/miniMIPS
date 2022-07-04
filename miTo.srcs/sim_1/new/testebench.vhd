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
    Port (
      clk             : in	std_logic;
      rst_n           : in	std_logic;
      halt            : in    std_logic;
      pc_enable       : in    std_logic;
      is_store        : in    std_logic;        
      mem_write       : in	std_logic;
      mem_read        : in	std_logic;
      jump_addr       : in	std_logic_vector(7  downto 0);
      ram_addr        : out	std_logic_vector(7  downto 0);
      data_to_mem     : in	std_logic_vector(15 downto 0);
      instruction     : out	std_logic_vector(15 downto 0)
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
  signal jump_addr_s    : std_logic_vector(7  downto 0);
  signal ram_addr_s     : std_logic_vector (7 downto 0) := "00000000";
  signal data_to_mem_s  : std_logic_vector (15 downto 0);
  signal instruction_s  : std_logic_vector (15 downto 0);
  signal decoded_instruction_s : decoded_instruction_type := I_HALT;
  signal estado_atual : estados := HALT_E;
  signal prox_estado : estados;

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
    jump_addr       => jump_addr_s,
    ram_addr        => ram_addr_s,
    data_to_mem     => data_to_mem_s,
    instruction     => instruction_s
  );

   --clock generator - 100MHZ
  clk_s 	<= not clk_s after 5 ns;

   --reset signal
  rst_n_s	<= '1' after 2 ns,
      '0' after 8 ns;
  
  decoded_instruction_s <= I_STORE after 25ns;
  jump_addr_s <= "00000011" after 35ns;
  data_to_mem_s <= "0101010101010101" after 45ns;

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
    if(clk_s = '1' and clk_s'event) then
          case(estado_atual) is
              when FETCH =>
                  mem_read_s <= '1';
                  pc_enable_s <= '0';
                  prox_estado <= DECODE;
      
              when DECODE =>
                  mem_read_s <= '0';
                  case decoded_instruction_s is  
    --                  when I_LOAD =>
    --                      is_load_s <= '1';
    --                      prox_estado <= LOAD;
                      when I_STORE =>
                          is_store_s <= '1';
                          prox_estado <= STORE;
                      when others =>
                          prox_estado <= HALT_E;
                  end case;
      
--          when LOAD =>
--              prox_estado <= LOAD1;
              
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
    end if;
  end process;
end Behavioral;
