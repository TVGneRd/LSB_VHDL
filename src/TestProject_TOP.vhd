
LIBRARY IEEE;--! standard library IEEE (Institute of Electrical and Electronics Engineers)
USE IEEE.std_logic_1164.ALL;--! standard unresolved logic UX01ZWLH-
USE IEEE.numeric_std.ALL;--! for the signed, unsigned types and arithmetic ops

entity TestProject_TOP is
PORT (
    refclk : IN STD_LOGIC;--! reference clock expect 250Mhz
    rstn   : IN STD_LOGIC --! sync active low reset. sync -> refclk
);

end entity TestProject_TOP;
architecture rtl of TestProject_TOP is
begin
    design_1_wrapper_i: entity work.design_1_wrapper
    port map (
        refclk => refclk,
        sys_rst_n => rstn
    );
  
end architecture rtl;
