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
        pixel_ready  : out std_logic;
        msg_in       : in std_logic;
        pixel_out    : out std_logic_vector(23 downto 0)
    );
end stego_block;

architecture Behavioral of stego_block is
    --signal data_counter : integer := 0;
    --signal pixel_buffer : STD_LOGIC_VECTOR(23 downto 0);
    signal done_flag : STD_LOGIC := '0';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            done_flag <= '0';
        elsif rising_edge(clk) then
            pixel_out <= pixel_in(23 downto 1) & msg_in;  
            done_flag = '1';
        end if;
    end process;

    pixel_ready <= done_flag;
    pixel_out <= pixel_out;

end Behavioral;
