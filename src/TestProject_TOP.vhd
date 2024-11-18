
LIBRARY IEEE;--! standard library IEEE (Institute of Electrical and Electronics Engineers)
USE IEEE.std_logic_1164.ALL;--! standard unresolved logic UX01ZWLH-
USE IEEE.numeric_std.ALL;--! for the signed, unsigned types and arithmetic ops

entity TestProject_TOP is
PORT (
    refclk : IN STD_LOGIC;--! reference clock expect 250Mhz
    rst    : IN STD_LOGIC --! sync active high reset. sync -> refclk
);

end entity TestProject_TOP;
architecture rtl of TestProject_TOP is

type m_state_type is (rst_state, wait_cam_ready, wait_stego_ready, wait_stego_confirm, wait_stego_data, wait_axi4_write);

signal cur_state        : m_state_type      := rst_state;
signal next_state       : m_state_type      := rst_state;

-- Constants

constant image_size : natural := 32*32*3*8;
 
constant axi_data_width_log2b     : natural                       := 5;
constant axi_address_width_log2b  : natural                       := 5;

constant message : std_logic_vector(95 downto 0)  := "101101001001001001011110001100101001111111110101000000111010010100001101111110111111001010100001"; 

-- Itterators
signal image_itterator : natural                := 0;

-- AXI4
signal axi4_write_addr          :   std_logic_vector(31 downto 2);
signal axi4_write_data          :   std_logic_vector(31 downto 0);
signal axi4_write_start         :   std_logic;
signal axi4_write_complete      :   std_logic;
signal axi4_write_result        :   std_logic_vector(1 downto 0);

signal AXI_ACLK               : std_logic;
signal AXI_AWADDR             : std_logic_vector(31 downto 0);
signal AXI_AWVALID            : std_logic;
signal AXI_AWREADY            : std_logic                         := '0';
signal AXI_WDATA              : std_logic_vector(31 downto 0);
signal AXI_WVALID             : std_logic;
signal AXI_WREADY             : std_logic                         := '0';
signal AXI_BRESP              : std_logic_vector(1 downto 0)      := (others => '0');
signal AXI_BVALID             : std_logic                         := '0';
signal AXI_BREADY             : std_logic; 

-- Cammera
signal cam_data                 :  std_logic_vector(23 downto 0);
signal cam_valid                :  std_logic;
signal cam_ready                :  std_logic;

-- Stego Block
signal stego_data_in            : std_logic_vector(23 downto 0);
signal stego_data_out           : std_logic_vector(23 downto 0);
signal stego_valid              : std_logic;
signal stego_ready              : std_logic;
signal stego_msg                : std_logic;

-- Data signals
signal cam_read_signal          : boolean           := false;
signal stego_write_signal       : boolean           := false;
signal stego_read_signal        : boolean           := false;
signal axi_write_signal         : boolean           := false;
    
begin
    camera : entity work.cam_block
    port map (
        clk         => refclk,
        reset       => rst,
        pixel_data    => cam_data,
        valid  => cam_valid,
        ready  => cam_ready
    );
    
    stego : entity work.stego_block
    port map (
        clk          => refclk,
        reset        => rst,
        pixel_in     => stego_data_in,
        pixel_out    => stego_data_out,
        pixel_valid  => cam_valid,
        pixel_ready  => cam_ready,
        msg_in       => stego_msg
    );
    
    axi4_1 : entity work.axi4_master
    generic map (
        axi_data_width_log2b    => axi_data_width_log2b,
        axi_address_width_log2b => axi_address_width_log2b
    )
    port map (
        clk                 => refclk,
        rst                 => rst,
        write_addr          => axi4_write_addr,
        write_data          => axi4_write_data,
        
        write_start         => axi4_write_start,
        write_complete      => axi4_write_complete,
        write_result        => axi4_write_result,
        
        M_AXI_ACLK          => AXI_ACLK,
        M_AXI_AWADDR        => AXI_AWADDR,
        M_AXI_AWVALID       => AXI_AWVALID,
        M_AXI_AWREADY       => AXI_AWREADY,
        M_AXI_WDATA         => AXI_WDATA,
        M_AXI_WVALID        => AXI_WVALID,
        M_AXI_WREADY        => AXI_WREADY,
        M_AXI_BRESP         => AXI_BRESP,
        M_AXI_BVALID        => AXI_BVALID,
        M_AXI_BREADY        => AXI_BREADY
    );
    
    data_safe : process(refclk, rst, cam_read_signal, stego_write_signal, stego_read_signal, axi_write_signal)
        variable cam_data_safe      : std_logic_vector(23 downto 0);
        variable stego_data_safe    : std_logic_vector(23 downto 0);
        variable axi4_data_safe     : std_logic_vector(23 downto 0);
    begin
        if rst = '1' then
            cam_data_safe       := (others => '0');
            stego_data_safe     := (others => '0');
        elsif rising_edge(refclk) then
            if cam_read_signal then
                cam_data_safe := cam_data;
            end if;
            if stego_read_signal then
                stego_data_safe := stego_data_out;
            end if; 
        end if;
        
        stego_data_in <= cam_data_safe;
        stego_msg <= message(image_itterator mod message'length);
        axi4_write_data <= B"00000000" & stego_data_safe;
        axi4_write_addr <= std_logic_vector(TO_UNSIGNED(image_itterator * 8 * 3, axi4_write_addr'length));
        
    end process;
    
    state_transition : process(refclk, rst)
    begin
        if rst = '1' then
            cur_state       <= rst_state;
        elsif rising_edge(refclk) then
            cur_state       <= next_state;
        end if;
    end process;

    state_decider : process(rst, cur_state)
    begin
        next_state <= cur_state;
        
        case cur_state is
            when rst_state =>
                if rst = '0' then
                    next_state <= wait_cam_ready;
                end if;  
            when wait_cam_ready =>
                if cam_ready = '1' then
                    next_state <= wait_stego_ready;
                end if;
                
            when wait_stego_ready =>
                if stego_ready = '1' then
                    next_state <= wait_stego_confirm;
                end if;
                
            when wait_stego_confirm =>
                if stego_ready = '0' then
                    next_state <= wait_stego_data;
                end if;
            
            when wait_stego_data =>
                if stego_ready = '1' then
                    next_state <= wait_axi4_write;
                end if;
                
            when wait_axi4_write =>
                if axi4_write_complete = '1' then
                    next_state <= wait_cam_ready;
                end if;
                
        end case;
    end process;

    output_decider : process(cur_state)
    begin
        case cur_state is
            when rst_state =>
                cam_valid                <= '0';
                stego_valid              <= '0';
                axi4_write_start         <= '0';
                
                cam_read_signal          <= false;
                stego_write_signal       <= false;
                stego_read_signal        <= false;
                axi_write_signal         <= false;
                
            when wait_cam_ready =>
                cam_valid                <= '1';
                stego_valid              <= '0';
                axi4_write_start         <= '0';
                
                cam_read_signal          <= true;
                stego_write_signal       <= false;
                stego_read_signal        <= false;
                axi_write_signal         <= false;
                
            when wait_stego_ready =>
                cam_valid                <= '0';
                stego_valid              <= '1';
                axi4_write_start         <= '0';
                
                cam_read_signal          <= false;
                stego_write_signal       <= true;
                stego_read_signal        <= false;
                axi_write_signal         <= false;
                
            when wait_stego_confirm =>
                cam_valid                <= '0';
                stego_valid              <= '0';
                axi4_write_start         <= '0';
                
                cam_read_signal          <= false;
                stego_write_signal       <= false;
                stego_read_signal        <= false;
                axi_write_signal         <= false;
                
            when wait_stego_data =>
                cam_valid                <= '0';
                stego_valid              <= '1';
                axi4_write_start         <= '0';
                
                cam_read_signal          <= false;
                stego_write_signal       <= false;
                stego_read_signal        <= true;
                axi_write_signal         <= false;
                
            when wait_axi4_write =>
                cam_valid                <= '0';
                stego_valid              <= '0';
                axi4_write_start         <= '1';
                
                cam_read_signal          <= false;
                stego_write_signal       <= false;
                stego_read_signal        <= false;
                axi_write_signal         <= true;
        end case;
    end process;

end architecture rtl;
