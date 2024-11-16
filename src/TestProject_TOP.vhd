
LIBRARY IEEE;--! standard library IEEE (Institute of Electrical and Electronics Engineers)
USE IEEE.std_logic_1164.ALL;--! standard unresolved logic UX01ZWLH-
USE IEEE.numeric_std.ALL;--! for the signed, unsigned types and arithmetic ops

entity TestProject_TOP is
PORT (
  refclk : IN STD_LOGIC;--! reference clock expect 250Mhz
  rst    : IN STD_LOGIC--! sync active high reset. sync -> refclk
);
end entity TestProject_TOP;
architecture rtl of TestProject_TOP is

-- Signals

signal M_AXI_write_addr         : std_logic_vector(31 downto 2)     := (others => '0');
signal M_AXI_write_data         : std_logic_vector(31 downto 0)     := (others => '0');
signal M_AXI_write_start        : std_logic                         := '0';
signal M_AXI_write_complete     : std_logic;
signal M_AXI_write_result       : std_logic_vector(1 downto 0);
signal M_AXI_write_mask         : std_logic_vector(3 downto 0)      := (others => '1');
signal M_AXI_BRESP              : std_logic_vector(1 downto 0)      := (others => '0');

-- Constants

constant s2_check_data : std_logic_vector(7 downto 0) :="11001010";
constant s2_check_addr : std_logic_vector(7 downto 0) :="00000001";
 
constant axi_data_width_log2b     : natural                       := 5;
constant axi_address_width_log2b  : natural                       := 5;

constant write_addr : unsigned(M_AXI_write_addr'RANGE)  := to_unsigned(21, M_AXI_write_addr'length );
constant write_data : unsigned(M_AXI_write_data'RANGE)  := to_unsigned(14, M_AXI_write_data'length );
constant bresp      : unsigned(M_AXI_BRESP'RANGE)       := to_unsigned(3, M_AXI_BRESP'length );


begin
    -- Instantiate the writer


end architecture rtl;
