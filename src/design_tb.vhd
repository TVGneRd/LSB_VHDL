----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2024 12:39:11 AM
-- Design Name: 
-- Module Name: design_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity design_tb is
GENERIC (
    EDGE_CLK : TIME := 2 ns
  );
--  Port ( );
end design_tb;

architecture Behavioral of design_tb is
    SIGNAL rst   : STD_LOGIC := '0';
    SIGNAL refclk : STD_LOGIC := '0';
    SIGNAL test_completed : BOOLEAN := false;
begin
    design_1_wrapper_i: entity work.design_1_wrapper
    port map (
        refclk => refclk,
        sys_rst_n => rst
    );
  
    test_clk_generator : PROCESS
    BEGIN
        IF NOT test_completed THEN
            refclk <= NOT refclk;
            WAIT for EDGE_CLK;
        ELSE
            WAIT;
        END IF;
    END PROCESS test_clk_generator;
    
    reset_up : PROCESS
    BEGIN
        WAIT for 10ns;
        rst <= NOT rst;
        WAIT for 1us;
        rst <= NOT rst;
        WAIT;
    END PROCESS reset_up;
    
    test_bench_main : PROCESS
    BEGIN
        test_completed <= true AFTER 10 us;
        WAIT;
    END PROCESS test_bench_main;

end Behavioral;
