----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Andrey Fominnnnn
-- 
-- Create Date: 11/16/2024 06:33:25 PM
-- Design Name: 
-- Module Name: stego_block - Behavioral
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

entity stego_block is
    port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        pixel_in     : in  std_logic_vector(23 downto 0);
        pixel_valid  : in  std_logic;
        msg_in       : in std_logic;
        pixel_ready  : out std_logic;
        pixel_out    : out std_logic_vector(23 downto 0)
    );
end stego_block;

architecture Behavioral of stego_block is
    --signal data_counter : integer := 0;
    --signal pixel_buffer : STD_LOGIC_VECTOR(23 downto 0);
    type m_state_type is (rst_state, idle, embed, transmitting);

    signal cur_state    : m_state_type := rst_state;
    signal next_state   : m_state_type := rst_state;
    signal done_flag    : STD_LOGIC := '0';
    signal pixel_buffer : std_logic_vector(23 downto 0);
begin
    -- Переход состояний
    state_transition : process(clk, reset)
    begin
        if reset = '1' then
            cur_state       <= rst_state;
        elsif rising_edge(clk) then
            cur_state       <= next_state;
        end if;
    end process;

    -- Внедрение
    embedding : process(clk, reset, cur_state)
    begin
        if reset = '1' then
            done_flag <= '0';
        elsif rising_edge(clk) then
            if cur_state = embed and done_flag = '0' then
                pixel_buffer <= pixel_in(23 downto 1) & msg_in;  
                done_flag <= '1';
            end if;
        end if;
    end process;
    
    -- Выбор следующего состояния
    state_decider : process(cur_state, done_flag, pixel_valid)
    begin
        next_state <= cur_state;
        case cur_state is
            when rst_state =>
                if reset = '0' then
                    next_state <= idle;
                else
                    next_state <= next_state;
                end if; 
            when idle =>
                if pixel_valid = '1' then
                    next_state <= embed;
                else
                    next_state <= next_state;
                end if;
            when embed =>
                if done_flag = '1' then
                    next_state <= transmitting;
                else
                    next_state <= next_state;
                end if;
            when transmitting =>
                if pixel_valid = '0' then
                    next_state <= idle;
                else
                    next_state <= next_state;
                end if;
        end case;
    end process;
    -- Настройка выходных портов
    output_decide : process(cur_state)
    begin
        case cur_state is
        when rst_state =>
            done_flag <= '0';
            pixel_ready <= '0';
            pixel_out <= (others => '0');
        when idle =>
            done_flag <= '0';
            pixel_ready <= '1';
            pixel_out <= (others => '0');
        when embed =>
            pixel_ready <= '0';
            pixel_out <= pixel_buffer;
        when transmitting =>
            done_flag <= '1';
            pixel_out <= pixel_buffer;
            pixel_ready <= '1';
        end case;
    end process;
    --pixel_ready <= done_flag;
    --pixel_out <= pixel_out;

end Behavioral;
