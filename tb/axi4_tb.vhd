library STD;
use std.textio.ALL;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity tb_axi4 is
end tb_axi4;

architecture Behavioral of tb_axi4 is
    constant clock_period               : time := 20 ns;

    signal test_done                    : boolean;

    signal clk                          : std_logic                     := '1';
    signal rst                          : std_logic                     := '1';

    -- AXI 1
    -- Constants
    constant axi_1_data_width_log2b     : natural                       := 5;
    constant axi_1_address_wdith_log2b  : natural                       := 5;
    -- The signals for axi4_acp_1
    signal AXI_1_write_test_done    : boolean := false;
    signal AXI_1_write_addr         : std_logic_vector(31 downto 2)     := (others => '0');
    signal AXI_1_write_data         : std_logic_vector(31 downto 0)     := (others => '0');
    signal AXI_1_write_start        : std_logic                         := '0';
    signal AXI_1_write_complete     : std_logic;
    signal AXI_1_write_result       : std_logic_vector(1 downto 0);
    signal AXI_1_ACLK               : std_logic;
    signal AXI_1_AWADDR             : std_logic_vector(31 downto 0);
    signal AXI_1_AWVALID            : std_logic;
    signal AXI_1_AWREADY            : std_logic                         := '0';
    signal AXI_1_WDATA              : std_logic_vector(31 downto 0);
    signal AXI_1_WVALID             : std_logic;
    signal AXI_1_WREADY             : std_logic                         := '0';
    signal AXI_1_BRESP              : std_logic_vector(1 downto 0)      := (others => '0');
    signal AXI_1_BVALID             : std_logic                         := '0';
    signal AXI_1_BREADY             : std_logic;
    
    -- AXI 2
    -- Constants
    constant axi_2_data_width_log2b     : natural                           := 6;
    constant axi_2_address_wdith_log2b  : natural                           := 5;
    -- The signals for axi4_acp_1
    signal AXI_2_write_test_done    : boolean := false;
    signal AXI_2_write_addr         : std_logic_vector(31 downto 2)     := (others => '0');
    signal AXI_2_write_data         : std_logic_vector(31 downto 0)     := (others => '0');
    signal AXI_2_write_start        : std_logic                         := '0';
    signal AXI_2_write_complete     : std_logic;
    signal AXI_2_write_result       : std_logic_vector(1 downto 0);
      signal AXI_2_ACLK               : std_logic;
    signal AXI_2_AWADDR             : std_logic_vector(31 downto 0);
    signal AXI_2_AWVALID            : std_logic;
    signal AXI_2_AWREADY            : std_logic                         := '0';
    signal AXI_2_WDATA              : std_logic_vector(63 downto 0);
    signal AXI_2_WVALID             : std_logic;
    signal AXI_2_WREADY             : std_logic                         := '0';
    signal AXI_2_BRESP              : std_logic_vector(1 downto 0)      := (others => '0');
    signal AXI_2_BVALID             : std_logic                         := '0';
    signal AXI_2_BREADY             : std_logic;
begin

    test_done <= AXI_1_write_test_done and AXI_2_write_test_done;

    axi4_1 : entity work.axi4_master
    generic map (
        axi_data_width_log2b    => axi_1_data_width_log2b,
        axi_address_width_log2b => axi_1_address_wdith_log2b
    )
    port map (
        clk                 => clk,
        rst                 => rst,
        write_addr          => AXI_1_write_addr,
        write_data          => AXI_1_write_data,
        
        write_start         => AXI_1_write_start,
        write_complete      => AXI_1_write_complete,
        write_result        => AXI_1_write_result,
        
        M_AXI_ACLK          => AXI_1_ACLK,
        M_AXI_AWADDR        => AXI_1_AWADDR,
        M_AXI_AWVALID       => AXI_1_AWVALID,
        M_AXI_AWREADY       => AXI_1_AWREADY,
        M_AXI_WDATA         => AXI_1_WDATA,
        M_AXI_WVALID        => AXI_1_WVALID,
        M_AXI_WREADY        => AXI_1_WREADY,
        M_AXI_BRESP         => AXI_1_BRESP,
        M_AXI_BVALID        => AXI_1_BVALID,
        M_AXI_BREADY        => AXI_1_BREADY
    );

    axi4_2 : entity work.axi4_master
    generic map (
        axi_data_width_log2b    => axi_2_data_width_log2b,
        axi_address_width_log2b => axi_2_address_wdith_log2b
    )
    port map (
        clk                 => clk,
        rst                 => rst,
        write_addr          => AXI_2_write_addr,
        write_data          => AXI_2_write_data,
       
        write_start         => AXI_2_write_start,
        write_complete      => AXI_2_write_complete,
        write_result        => AXI_2_write_result,
       
        M_AXI_ACLK          => AXI_2_ACLK,
        M_AXI_AWADDR        => AXI_2_AWADDR,
        M_AXI_AWVALID       => AXI_2_AWVALID,
        M_AXI_AWREADY       => AXI_2_AWREADY,
        
        M_AXI_WDATA         => AXI_2_WDATA,
        M_AXI_WVALID        => AXI_2_WVALID,
        M_AXI_WREADY        => AXI_2_WREADY,
        M_AXI_BRESP         => AXI_2_BRESP,
        M_AXI_BVALID        => AXI_2_BVALID,
        M_AXI_BREADY        => AXI_2_BREADY
    );


    -- Clk generator, simply switch flanks every half period
    clock_gen : process
    begin
        if not (test_done) then
            -- 1/2 duty cycle
            clk <= not clk;
            wait for clock_period/2;
        else
            wait;
        end if;
    end process;

    reset_loop : process
    begin
        wait for 2*clock_period;
        rst <= '0';
        wait;
    end process;

    write_loop_1 : process
        constant write_addr : unsigned(AXI_1_write_addr'RANGE)  := to_unsigned(21, AXI_1_write_addr'length );
        constant write_data : unsigned(AXI_1_write_data'RANGE)  := to_unsigned(14, AXI_1_write_data'length );
        constant bresp      : unsigned(AXI_1_BRESP'RANGE)       := to_unsigned(3, AXI_1_BRESP'length );
    begin
        -- Give all inputs sensible defaults
        AXI_1_write_addr        <= (others => '0');
        AXI_1_write_data        <= (others => '0');
        AXI_1_write_start       <= '0';
        AXI_1_AWREADY           <= '0';
        AXI_1_WREADY            <= '0';
        AXI_1_BRESP             <= (others => '0');
        AXI_1_BVALID            <= '0';
        wait for clock_period;
        -- Reset is still enabled, test the reset outputs
        assert AXI_1_write_complete = '0' severity error;
        -- AXI_1_write_result
        -- AXI_1_AWADDR
        assert AXI_1_AWVALID = '0' severity error;
        -- AXI_1_WDATA
        -- AXI_1_WSTRB
        assert AXI_1_WVALID = '0' severity error;
        assert AXI_1_BREADY = '0' severity error;
        wait until rst = '0';
        wait for clock_period;
        -- Writer should be in start state
        AXI_1_write_addr        <= std_logic_vector(write_addr);
        AXI_1_write_data        <= std_logic_vector(write_data);
        AXI_1_write_start       <= '1';
        AXI_1_AWREADY           <= '1';
        AXI_1_WREADY            <= '0';
        -- AXI_1_BRESP
        -- AXI_1_BVALID
        assert AXI_1_write_complete = '1' severity error;
        -- AXI_1_write_result
        -- AXI_1_AWADDR
        assert AXI_1_AWVALID = '0' severity error;
        -- AXI_1_WDATA
        assert AXI_1_WVALID = '0' severity error;
        assert AXI_1_BREADY = '0' severity error;

        wait for clock_period;
        -- Writer should now be sending data
        AXI_1_write_addr        <= (others => '0');
        AXI_1_write_data        <= (others => '0');
        AXI_1_write_start       <= '0';
        AXI_1_AWREADY           <= '1';
        AXI_1_WREADY            <= '1';
        -- AXI_1_BRESP
        -- AXI_1_BVALID
        assert AXI_1_write_complete = '0' severity error;
        -- AXI_1_write_result
        assert AXI_1_AWVALID = '1' severity error;
        assert AXI_1_AWADDR = std_logic_vector(write_addr) & "00";
        assert AXI_1_WDATA = std_logic_vector(resize(write_data, AXI_1_WDATA'length));
        assert AXI_1_WVALID = '1' severity error;
        -- AXI_1_BREADY

        wait for clock_period;
        -- Now the writer should be ready to receive the feedback
        --AXI_1_write_addr        <= write_addr;
        --AXI_1_write_data        <= write_data
        AXI_1_write_start       <= '0';
        AXI_1_AWREADY           <= '0';
        AXI_1_WREADY            <= '0';
        AXI_1_BRESP             <= std_logic_vector(bresp);
        AXI_1_BVALID            <= '1';
        assert AXI_1_write_complete = '0' severity error;
        -- AXI_1_write_result
        assert AXI_1_AWVALID = '0' severity error;
        -- AXI_1_AWADDR
        -- AXI_1_WDATA  
        -- AXI_1_WSTRB
        assert AXI_1_WVALID = '0' severity error;
        -- AXI_1_BREADY
        wait for clock_period;
        -- Now the writer should be ready to receive the feedback

        wait for clock_period;
        -- The writer should have finished operating
        --AXI_1_write_addr        <= write_addr;
        --AXI_1_write_data        <= write_data
        AXI_1_write_start       <= '0';
        AXI_1_AWREADY           <= '0';
        AXI_1_WREADY            <= '0';
        AXI_1_BRESP             <= (others => '0');
        AXI_1_BVALID            <= '0';
        assert AXI_1_write_complete = '1' severity error;
        assert AXI_1_write_result = std_logic_vector(bresp);
        -- AXI_1_AWVALID
        -- AXI_1_AWADDR
        -- AXI_1_WDATA
        -- AXI_1_WSTRB
        -- AXI_1_WVALID
        assert AXI_1_BREADY = '0' severity error;

        AXI_1_write_test_done <= true;
        wait;

    end process;

    write_loop_2 : process
        -- Make sure the write_addr's lsb is 1
        constant write_addr : unsigned(AXI_2_write_addr'RANGE)  := to_unsigned(21, AXI_2_write_addr'length );
        constant write_data : unsigned(AXI_2_write_data'RANGE)  := to_unsigned(14, AXI_2_write_data'length );
        constant bresp      : unsigned(AXI_2_BRESP'RANGE)       := to_unsigned(3, AXI_2_BRESP'length );
    begin
        -- Give all inputs sensible defaults
        AXI_2_write_addr        <= (others => '0');
        AXI_2_write_data        <= (others => '0');
        AXI_2_write_start       <= '0';
        AXI_2_AWREADY           <= '0';
        AXI_2_WREADY            <= '0';
        AXI_2_BRESP             <= (others => '0');
        AXI_2_BVALID            <= '0';
        wait for clock_period;
        -- Reset is still enabled, test the reset outputs
        assert AXI_2_write_complete = '0' severity error;
        -- AXI_2_write_result
        -- AXI_2_AWADDR
        assert AXI_2_AWVALID = '0' severity error;
        -- AXI_2_WDATA
        -- AXI_2_WSTRB
        assert AXI_2_WVALID = '0' severity error;
        assert AXI_2_BREADY = '0' severity error;
        wait until rst = '0';
        wait for clock_period;
        -- Writer should be in start state
        AXI_2_write_addr        <= std_logic_vector(write_addr);
        AXI_2_write_data        <= std_logic_vector(write_data);
        AXI_2_write_start       <= '1';
        AXI_2_AWREADY           <= '1';
        AXI_2_WREADY            <= '0';
        -- AXI_2_BRESP
        -- AXI_2_BVALID
        assert AXI_2_write_complete = '1' severity error;
        -- AXI_2_write_result
        -- AXI_2_AWADDR
        assert AXI_2_AWVALID = '0' severity error;
        -- AXI_2_WDATA
        -- AXI_2_WSTRB
        assert AXI_2_WVALID = '0' severity error;
        assert AXI_2_BREADY = '0' severity error;

        wait for clock_period;
        -- Writer should now be sending data
        AXI_2_write_addr        <= (others => '0');
        AXI_2_write_data        <= (others => '0');
        AXI_2_write_start       <= '0';
        AXI_2_AWREADY           <= '1';
        AXI_2_WREADY            <= '1';
        -- AXI_2_BRESP
        -- AXI_2_BVALID
        assert AXI_2_write_complete = '0' severity error;
        -- AXI_2_write_result
        assert AXI_2_AWVALID = '1' severity error;
        assert AXI_2_AWADDR = std_logic_vector(write_addr(write_addr'left downto 3)) & "000";
        assert AXI_2_WDATA = std_logic_vector(write_data) & (31 downto 0 => '0');
        assert AXI_2_WVALID = '1' severity error;
        -- AXI_2_BREADY

        wait for clock_period;
        -- Now the writer should be ready to receive the feedback
        --AXI_2_write_addr        <= write_addr;
        --AXI_2_write_data        <= write_data
        AXI_2_write_start       <= '0';
        AXI_2_AWREADY           <= '0';
        AXI_2_WREADY            <= '0';
        AXI_2_BRESP             <= std_logic_vector(bresp);
        AXI_2_BVALID            <= '1';
        assert AXI_2_write_complete = '0' severity error;
        -- AXI_2_write_result
        assert AXI_2_AWVALID = '0' severity error;
        -- AXI_2_AWADDR
        -- AXI_2_WDATA
        assert AXI_2_WVALID = '0' severity error;
        -- AXI_2_BREADY
        wait for clock_period;
        -- Now the writer should be ready to receive the feedback

        wait for clock_period;
        -- The writer should have finished operating
        --AXI_2_write_addr        <= write_addr;
        --AXI_2_write_data        <= write_data
        AXI_2_write_start       <= '0';
        AXI_2_AWREADY           <= '0';
        AXI_2_WREADY            <= '0';
        AXI_2_BRESP             <= (others => '0');
        AXI_2_BVALID            <= '0';
        assert AXI_2_write_complete = '1' severity error;
        assert AXI_2_write_result = std_logic_vector(bresp);
        -- AXI_2_AWVALID
        -- AXI_2_AWADDR
        -- AXI_2_WDATA
        -- AXI_2_WVALID
        assert AXI_2_BREADY = '0' severity error;
        AXI_2_write_test_done <= true;
        wait;
    end process;

end Behavioral;