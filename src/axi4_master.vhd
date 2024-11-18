library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity axi4_master is
    generic (
        axi_data_width_log2b    :   natural range 5 to 255 := 6;
        axi_address_width_log2b :   natural range 5 to 255 := 5
    );
    port (
        clk                 :   in  std_logic;
        rst                 :   in  std_logic;
        write_addr          :   in  std_logic_vector(31 downto 2);
        write_data          :   in  std_logic_vector(31 downto 0);
     
        write_start         :   in  std_logic;
        write_complete      :   out std_logic;
        write_result        :   out std_logic_vector(1 downto 0);
        write_mask          :   in  std_logic_vector(3 downto 0);
      
        -- Global Signals
        M_AXI_ACLK          :   out std_logic;
        -- No reset
        -- Write address channel signals
        M_AXI_AWADDR        :   out std_logic_vector(2**axi_address_width_log2b - 1 downto 0);
        M_AXI_AWVALID       :   out std_logic;
        M_AXI_AWREADY       :   in  std_logic;
        -- Write data channel signals
        M_AXI_WDATA         :   out std_logic_vector(2**axi_data_width_log2b - 1 downto 0);
        M_AXI_WVALID        :   out std_logic;
        M_AXI_WREADY        :   in  std_logic;
        --  Write response channel signals
        M_AXI_BRESP         :   in  std_logic_vector(1 downto 0);
        M_AXI_BVALID        :   in  std_logic;
        M_AXI_BREADY        :   out std_logic
    );
end axi4_master;

architecture Behavioral of work.axi4_master is
begin
    -- Instantiate the writer
    writer : entity work.axi4_writer
    generic map (
        axi_data_width_log2b    => axi_data_width_log2b,
        axi_address_width_log2b => axi_address_width_log2b
    )
    port map (
        clk                 => clk,
        rst                 => rst,
        write_addr          => write_addr,
        write_data          => write_data,
        write_start         => write_start,
        write_complete      => write_complete,
        write_result        => write_result,
        M_AXI_AWADDR        => M_AXI_AWADDR,
        M_AXI_AWVALID       => M_AXI_AWVALID,
        M_AXI_AWREADY       => M_AXI_AWREADY,
        M_AXI_WDATA         => M_AXI_WDATA,
        M_AXI_WVALID        => M_AXI_WVALID,
        M_AXI_WREADY        => M_AXI_WREADY,
        M_AXI_BRESP         => M_AXI_BRESP,
        M_AXI_BVALID        => M_AXI_BVALID,
        M_AXI_BREADY        => M_AXI_BREADY
    );
end Behavioral;