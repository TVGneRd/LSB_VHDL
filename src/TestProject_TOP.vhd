
LIBRARY IEEE;--! standard library IEEE (Institute of Electrical and Electronics Engineers)
USE IEEE.std_logic_1164.ALL;--! standard unresolved logic UX01ZWLH-
USE IEEE.numeric_std.ALL;--! for the signed, unsigned types and arithmetic ops

entity TestProject_TOP is
PORT (
    refclk : IN STD_LOGIC;--! reference clock expect 250Mhz
    rstn   : IN STD_LOGIC; --! sync active low reset. sync -> refclk
    
    cam_data : in STD_LOGIC_VECTOR ( 23 downto 0 );
    cam_ready : in STD_LOGIC;
    cam_valid : out STD_LOGIC;
    
    s_axi_araddr_0 : in STD_LOGIC_VECTOR ( 14 downto 0 );
    s_axi_arlen_0 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_arready_0 : out STD_LOGIC;
    s_axi_arsize_0 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arvalid_0 : in STD_LOGIC;
    s_axi_rdata_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rlast_0 : out STD_LOGIC;
    s_axi_rready_0 : in STD_LOGIC;
    s_axi_rresp_0 : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid_0 : out STD_LOGIC
);

end entity TestProject_TOP;
architecture rtl of TestProject_TOP is
begin
    design_1_wrapper_i: entity work.design_1_wrapper
    port map (
        refclk => refclk,
        sys_rst_n => rstn,
        
        cam_data => cam_data,
        cam_ready => cam_ready,
        cam_valid => cam_valid,

        s_axi_araddr_0      => s_axi_araddr_0,
        s_axi_arlen_0       => s_axi_arlen_0,
        s_axi_arready_0     => s_axi_arready_0,
        s_axi_arsize_0      => s_axi_arsize_0,
        s_axi_arvalid_0     => s_axi_arvalid_0,
        s_axi_rdata_0       => s_axi_rdata_0,
        s_axi_rlast_0       => s_axi_rlast_0,
        s_axi_rready_0      => s_axi_rready_0,
        s_axi_rresp_0       => s_axi_rresp_0,
        s_axi_rvalid_0      => s_axi_rvalid_0
    );
  
end architecture rtl;
