----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Andrey Fominnnnn
-- 
-- Create Date: 11/18/2024 21:04:00 PM
-- Design Name: 
-- Module Name: stego_tb - Behavioral
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
use IEEE.numeric_std.ALL;

entity stego_tb is
end stego_tb;

architecture Behavioral of stego_tb is
    constant clock_period : time      := 20 ns;

    signal test_done      : boolean;

    signal clk1            : std_logic               := '1';
    signal rst1           : std_logic               := '1';
    
    signal pixel_in1    : std_logic_vector(23 downto 0) := (others => '0');
    signal pixel_valid1 : std_logic := '0';
    signal msg_in1      : std_logic := '1';
    signal pixel_ready1 : std_logic := '0';
    signal pixel_out1   : std_logic_vector(23 downto 0) := (others => '0');

    signal test_check   : boolean := false;
    ------
begin
    test_done <= test_check;

    stego_test : entity work.stego_block
    port map(
        clk => clk1,
        rst => rst1,
        pixel_in => pixel_in1,
        pixel_valid => pixel_valid1,
        msg_in => msg_in1,
        pixel_ready => pixel_ready1,
        pixel_out => pixel_out1
    );
    test_process : process
    begin
        wait for 2 * clock_period;
        test_check <= true;
    end process;
end Behavioral
