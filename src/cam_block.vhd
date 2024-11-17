----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2024 06:33:25 PM
-- Design Name: 
-- Module Name: cam_block - Behavioral
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

entity cam_block is
   port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        data_out    : out std_logic_vector(23 downto 0);
        data_valid  : in std_logic;
        data_ready  : out  std_logic
    );
end cam_block;

architecture Behavioral of cam_block is
    
begin


end Behavioral;
