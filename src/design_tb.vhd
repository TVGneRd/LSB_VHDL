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
    SIGNAL memory_test_completed : BOOLEAN := false;

    SIGNAL cam_valid : std_logic  := '0';
    SIGNAL cam_ready : std_logic  := '0';
    SIGNAL cam_data : std_logic_vector(23 downto 0);

    SIGNAL last_data : std_logic_vector(23 downto 0);
    

    signal read_addr                : std_logic_vector(31 downto 2)     := (others => '0');
    signal read_data                : std_logic_vector(31 downto 0);
    signal read_start               : std_logic                         := '0';
    signal read_complete            : std_logic;
    signal read_result              : std_logic_vector(1 downto 0);
    signal AXI_1_ARADDR             : std_logic_vector(31 downto 0);
    signal AXI_1_ARLEN              : std_logic_vector(3 downto 0);
    signal AXI_1_ARSIZE             : std_logic_vector(2 downto 0);
    signal AXI_1_ARVALID            : std_logic;
    signal AXI_1_ARREADY            : std_logic                         := '0';
    signal AXI_1_RDATA              : std_logic_vector(31 downto 0)     := (others => '0');
    signal AXI_1_RRESP              : std_logic_vector(1 downto 0)      := (others => '0');
    signal AXI_1_RLAST              : std_logic                         := '0';
    signal AXI_1_RVALID             : std_logic                         := '0';
    signal AXI_1_RREADY             : std_logic;

begin
    test_completed <= memory_test_completed;
    design_1_wrapper_i: entity work.design_1_wrapper
    port map (
        refclk => refclk,
        sys_rst_n => rst,
        
        cam_data => cam_data,
        cam_ready => cam_ready,
        cam_valid => cam_valid,

        s_axi_araddr_0  => AXI_1_ARADDR,
        s_axi_arlen_0  => AXI_1_ARLEN,
        s_axi_arready_0  => AXI_1_ARREADY,
        s_axi_arsize_0  => AXI_1_ARSIZE,
        s_axi_arvalid_0  => AXI_1_ARVALID,
        s_axi_rdata_0  => AXI_1_RDATA,
        s_axi_rlast_0  => AXI_1_RLAST,
        s_axi_rready_0  => AXI_1_RREADY,
        s_axi_rresp_0  => AXI_1_RRESP,
        s_axi_rvalid_0  => AXI_1_RVALID
    );
    
    camera: entity work.cam_block
    port map(
        clk => refclk,
        reset => rst,
        valid => cam_valid, 
        pixel_data => cam_data,
        ready => cam_ready
    );
    
    reader : entity work.axi4_reader
    generic map (
        axi_data_width_log2b    => 5,
        axi_address_width_log2b => 5
    )
    port map (
        clk                     => refclk,
        rst                     => rst,
        read_addr               => read_addr,
        read_data               => read_data,
        read_start              => read_start,
        read_complete           => read_complete,
        read_result             => read_result,
        
        M_AXI_ARADDR            => AXI_1_ARADDR,
        M_AXI_ARLEN             => AXI_1_ARLEN,
        M_AXI_ARSIZE            => AXI_1_ARSIZE,
        M_AXI_ARVALID           => AXI_1_ARVALID,
        M_AXI_ARREADY           => AXI_1_ARREADY,
        M_AXI_RDATA             => AXI_1_RDATA,
        M_AXI_RRESP             => AXI_1_RRESP,
        M_AXI_RLAST             => AXI_1_RLAST,
        M_AXI_RVALID            => AXI_1_RVALID,
        M_AXI_RREADY            => AXI_1_RREADY
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
    
    cam_listen : PROCESS(cam_valid, cam_ready)
    BEGIN
        if cam_valid = '1' and cam_ready = '1' THEN 
            last_data <= cam_data;
        end if;


    END PROCESS cam_listen;
    

    test_bench_main : PROCESS
    BEGIN
    --...
        --reading
        test_completed <= true AFTER 10 us;
        WAIT;
    END PROCESS test_bench_main;

end Behavioral;
