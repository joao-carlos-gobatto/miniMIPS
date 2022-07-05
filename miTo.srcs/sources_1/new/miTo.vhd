----------------------------------------------------------------------------------
-- Company: UERGS
-- Engineers: Débora Silva Garcia e João Carlos Gobatto da Cunha
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
library mito;
use mito.mito_pkg.all;

entity miTo is
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
    addr_dest             : out std_logic_vector(1 downto 0);
    inst_addr             : out std_logic_vector(6 downto 0);
    decoded_instruction   : out decoded_instruction_type
    clk             : in std_logic;
    rst_n           : in std_logic;
    
    is_load         : in std_logic;
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
    r3              : out std_logic_vector(15 downto 0);

    ula_op          : in  std_logic;
    ula_out         : out  std_logic_vector(15 downto 0);
    zero_flag       : out  std_logic
  );
end miTo;

architecture rtl of miTo is
signal pc : std_logic_vector(6 downto 0) := "0000000";
signal ram_addr_s : std_logic_vector(6 downto 0) := "0000000";
signal instruction_s  : std_logic_vector(15 downto 0);
signal inst_addr_s    : std_logic_vector(6 downto 0);

begin

ram_addr <= ram_addr_s;
instruction <= instruction_s;
inst_addr <= inst_addr_s;

program_counter:process(clk)
begin    
    if(rst_n = '1') then
        pc <= "0000000";
    else
        if(clk='1' and clk'event) then
            if(halt = '1') then
                pc <= pc;
            else
                if(pc_enable = '1') then
                    pc <= pc + 1;
                end if;
            end if;
        end if;
    end if;
end process;

store_mux:process(is_store, pc, inst_addr_s)
begin
    if(is_store = '1') then
        ram_addr_s <= inst_addr_s;
    else
        ram_addr_s <= pc;
    end if;
end process;

memory_i : memory
  Port map(
    clk           =>  clk,
    rst_n         =>  rst_n,
    mem_write     =>  mem_write,
    mem_read      =>  mem_read,
    ram_addr      =>  ram_addr_s,
    data_to_mem   =>  data_to_mem,
    instruction   =>  instruction_s
  );

decoder_i : decoder
  Port map (
    instruction          => instruction_s,
    addr_a               => addr_a,
    addr_b               => addr_b,
    addr_dest            => addr_dest,
    inst_addr            => inst_addr_s,
    decoded_instruction  => decoded_instruction
  );
signal mux_registers_bank : std_logic_vector(15 downto 0);
signal s0_s : std_logic_vector(15 downto 0) := "0000000000000000";
signal s1_s : std_logic_vector(15 downto 0) := "0000000000000000";
signal ula_out_s : std_logic_vector(15 downto 0) := "0000000000000000";


begin

s0 <= s0_s;
s1 <= s1_s;
ula_out <= ula_out_s;

--MUX de entrada do banco de registradores
process(clk)
begin
    if(is_load='1') then
        mux_registers_bank <= data;
    else
        mux_registers_bank <= ula_out_s;
    end if;
end process;

registers_bank_i : registers_bank
  Port map (
    clk             => clk,
    reg_write       => reg_write,
    data            => mux_registers_bank,
    addr_dest       => addr_dest,
    addr_a          => addr_a,
    addr_b          => addr_b,
    data_to_mem     => data_to_mem,
    s0              => s0_s,
    s1              => s1_s,
    r0              => r0,
    r1              => r1,
    r2              => r2,
    r3              => r3
  );
  
ula_i : ula
  Port map (
    ula_op                     => ula_op,
    s0                         => s0_s,
    s1                         => s1_s,
    ula_out                    => ula_out_s,
    zero_flag                  => zero_flag
  );
 
end rtl;