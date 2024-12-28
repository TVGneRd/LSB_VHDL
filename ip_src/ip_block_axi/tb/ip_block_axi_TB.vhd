
LIBRARY IEEE;--! standard library IEEE (Institute of Electrical and Electronics Engineers)
USE IEEE.std_logic_1164.ALL;--! standard unresolved logic UX01ZWLH-
USE IEEE.numeric_std.ALL;--! for the signed, unsigned types and arithmetic ops

entity ip_block_axi_TB is
  GENERIC (
    EDGE_CLK : TIME := 2 ns
  );
end entity ip_block_axi_TB;
architecture rtl of ip_block_axi_TB is
  SIGNAL rst   : STD_LOGIC := '0';
  SIGNAL refclk : STD_LOGIC := '0';
  SIGNAL test_completed : BOOLEAN := false;
  SIGNAL test_axi_comleted : STD_LOGIC := '0';
  SIGNAL test_stego_comleted : STD_LOGIC := '0';
  SIGNAL test_camera_comleted : STD_LOGIC := '0';
    COMPONENT ip_block_axi_TOP IS
      PORT (
        refclk : IN  STD_LOGIC;--! reference clock expect 250Mhz
        rst    : IN  STD_LOGIC--! sync active high reset. sync -> refclk
      );
    END COMPONENT;
begin
  test_completed <= test_axi_comleted = '1' and test_stego_comleted = '1' and test_camera_comleted ='1';
   axi4_tb : entity work.tb_axi4
    port map (
        clk                 => refclk,
        test_completed      => test_axi_comleted
    );
    
    stego_tb : entity work.stego_tb
    port map (
        clk                 => refclk,
        test_completed      => test_stego_comleted
    );
    
    camera_tb : entity work.camera_tb
    port map (
        clk                 => refclk,
        test_completed      => test_camera_comleted
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

end architecture rtl;
