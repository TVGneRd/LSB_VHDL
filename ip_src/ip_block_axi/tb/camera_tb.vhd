----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/26/2024 01:18:52 AM
-- Design Name: 
-- Module Name: camera_tb - Behavioral
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

entity camera_tb is
port (
    test_completed                    : out std_logic;
    clk : in std_logic
     );
end camera_tb;

architecture Behavioral of camera_tb is
    constant clock_period : time      := 20 ns;

    signal test_done      : boolean := false;
    signal rst           : std_logic               := '0';
    
    signal pixel_data    : std_logic_vector(23 downto 0) := (others => '0');
    signal valid   : std_logic := '0';
    signal ready   : std_logic := '0';

    signal test_check     : boolean := false;
    
begin

    test_done <= test_check;
    test_completed <= '1' when test_done else '0';
    

    reset_loop : process
    begin
        wait for 2*clock_period;
        rst <= '1';
        wait;
    end process;

    -- Инстанцирование модуля камеры
    camera_test : entity work.cam_block
    port map(
    valid => valid,
    ready => ready,
    clk => clk,
    reset => rst
    );

    test_process : process
    begin
        wait until rst = '1';
        wait for clock_period;

        -- Тест 1: Проверка начального состояния (idle)
        assert ready = '0' report "Initial state is not idle (ready != 1)!" severity error;

        -- Тест 2: Переход в состояние make_file при valid = '1'
        valid <= '1';
        wait for clock_period;
        assert ready = '0' report "FSM did not transition to make_file (ready != 0)!" severity error;

        -- Тест 3: Переход в состояние transmit
        wait for clock_period;
        assert ready = '1' report "FSM did not transition to transmit (ready != 1)!" severity error;

        -- Тест 4: Переход в состояние wait_valid
        wait for clock_period;
        assert ready = '1' report "FSM did not transition to wait_valid (ready != 0)!" severity error;

        -- Тест 5: Возврат в состояние idle при valid = '0'
        valid <= '0';
        wait for clock_period;
        assert ready = '1' report "FSM did not transition back to idle (ready != 1)!" severity error;

        -- Тест 6: Сброс FSM
       -- rst <= '0';
       -- wait for clock_period;
       -- assert ready = '1' report "FSM did not reset to idle (ready != 1)!" severity error;
        --rst <= '1';
        test_check <= true;
        wait;
    end process;
end Behavioral;
