----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2024 05:21:21 PM
-- Design Name: 
-- Module Name: m_axi - Behavioral
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
USE ieee.numeric_std.ALL;

entity axi4_writer is
    generic (
        axi_data_width_log2b    :   natural range 5 to 255 := 6;
        axi_address_width_log2b :   natural range 5 to 255 := 5
    );
    port (
        clk                 :   in std_logic;
        rst                 :   in std_logic;
        write_addr          :   in  std_logic_vector(31 downto 0);
        write_data          :   in  std_logic_vector(31 downto 0);
        write_start         :   in  std_logic;
        write_complete      :   out std_logic;
        write_result        :   out std_logic_vector(1 downto 0);
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
end axi4_writer;

ARCHITECTURE Behavioral of axi4_writer is
    type m_state_type is (rst_state, wait_for_start, wait_for_awready_wready, wait_for_awready, wait_for_wready, assert_bready);
    
    signal cur_state        : m_state_type      := rst_state;
    signal next_state       : m_state_type      := rst_state;

    signal write_addr_read  : boolean           := false;
    signal write_data_read  : boolean           := false;
    signal bresp_read       : boolean           := false;
    
begin

    data_safe : process(clk, rst, write_addr_read, write_data_read, bresp_read)
        variable write_addr_safe    : std_logic_vector(write_addr'range);
        variable write_data_safe    : std_logic_vector(write_data'range);
        variable bresp_safe         : std_logic_vector(M_AXI_BRESP'range);
        variable shift_modifier     : natural;
        variable wdata_reg          : std_logic_vector(M_AXI_WDATA'range);
    begin
        if rst = '0' then
            write_addr_safe     := (others => '0');
            write_data_safe     := (others => '0');
            bresp_safe          := (others => '0');
        elsif rising_edge(clk) then
            if write_addr_read then
                write_addr_safe := write_addr;
            end if;
            if write_data_read then
                write_data_safe := write_data;
            end if;
            if bresp_read then
                bresp_safe      := M_AXI_BRESP;
            end if;
        end if;
        if axi_data_width_log2b > 5 then
            shift_modifier  := to_integer(unsigned(write_addr_safe(axi_data_width_log2b - 4 downto 2)))*4;
        else
            shift_modifier := 0;
        end if;
        wdata_reg       := (wdata_reg'left downto write_data_safe'left + 1 => '0') & write_data_safe;
        -- The address is right now aligned to 32 bit and needs to be aligned to 2**axi_data_width_log2b
        -- We want the first axi_data_width_log2b-3 bits to be zero, counted from the right.
        -- Now, it might be the case that axi_data_width_log2b-3 > 32. But that is really weird.
        M_AXI_AWADDR    <= (M_AXI_AWADDR'left downto write_addr_safe'left + 1 => '0') & write_addr_safe(write_addr_safe'left downto axi_data_width_log2b - 3) & (axi_data_width_log2b - 4 downto 0 => '0');
        M_AXI_WDATA     <= std_logic_vector(shift_left(unsigned(wdata_reg), shift_modifier*8));
        write_result    <= bresp_safe;

    end process;

    state_transition : process(clk, rst)
    begin
        if rst = '0' then
            cur_state       <= rst_state;
            cur_state       <= rst_state;
        elsif rising_edge(clk) then
            cur_state       <= next_state;
            cur_state       <= next_state;
            cur_state       <= next_state;
        end if;
    end process;

    state_decider : process(cur_state, write_start, M_AXI_AWREADY, M_AXI_WREADY, M_AXI_BVALID)
    begin
        next_state <= cur_state;
        case cur_state is
            when rst_state =>
                next_state <= wait_for_start;
            when wait_for_start =>
                if write_start = '1' then
                    next_state <= wait_for_awready_wready;
                end if;
            when wait_for_awready_wready =>
                if M_AXI_AWREADY = '1' and M_AXI_WREADY = '1' then
                    next_state <= assert_bready;
                elsif M_AXI_AWREADY = '1' then
                    next_state <= wait_for_wready;
                elsif M_AXI_WREADY = '1' then
                    next_state <= wait_for_awready;
                end if;
            when wait_for_awready =>
                if M_AXI_AWREADY = '1' then
                    next_state <= assert_bready;
                end if;
            when wait_for_wready =>
                if M_AXI_WREADY = '1' then
                    next_state <= assert_bready;
                end if;
            when assert_bready =>
                if M_AXI_BVALID = '1' then
                    next_state <= wait_for_start;
                end if;
        end case;
    end process;

    output_decider : process(cur_state)
    begin
        case cur_state is
            when rst_state =>
                bresp_read          <= false;
                M_AXI_BREADY    <= '0';
                write_complete      <= '0';
                write_addr_read     <= false;
                M_AXI_AWVALID   <= '0';
                write_data_read     <= false;
                M_AXI_WVALID    <= '0';
            when wait_for_start =>
                bresp_read          <= false;
                M_AXI_BREADY    <= '0';
                write_complete      <= '1';
                write_addr_read     <= true;
                M_AXI_AWVALID   <= '0';
                write_data_read     <= true;
                M_AXI_WVALID    <= '0';
            when wait_for_awready_wready =>
                bresp_read          <= true;
                M_AXI_BREADY    <= '0';
                write_complete      <= '0';
                write_addr_read     <= false;
                M_AXI_AWVALID   <= '1';
                write_data_read     <= false;
                M_AXI_WVALID    <= '1';
            when wait_for_awready =>
                bresp_read          <= true;
                M_AXI_BREADY    <= '0';
                write_complete      <= '0';
                write_addr_read     <= false;
                M_AXI_AWVALID   <= '1';
                write_data_read     <= true;
                M_AXI_WVALID    <= '0';
            when wait_for_wready =>
                bresp_read          <= true;
                M_AXI_BREADY    <= '0';
                write_complete      <= '0';
                write_addr_read     <= true;
                M_AXI_AWVALID   <= '0';
                write_data_read     <= false;
                M_AXI_WVALID    <= '1';
            when assert_bready =>
                bresp_read          <= true;
                M_AXI_BREADY    <= '1';
                write_complete      <= '0';
                write_addr_read     <= true;
                M_AXI_AWVALID   <= '0';
                write_data_read     <= true;
                M_AXI_WVALID    <= '0';
        end case;
    end process;
end Behavioral;