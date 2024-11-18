library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cam_block is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        valid : in STD_LOGIC;  -- Внешний сигнал valid
        pixel_data : out STD_LOGIC_VECTOR(23 downto 0);
        ready : out STD_LOGIC
    );
end cam_block;

architecture Behavioral of cam_block is
    type state_type is (idle, make_file, transmit, reset_state);
    signal current_state, next_state : state_type;
    constant IMAGE_WIDTH : integer := 32;  -- Ширина изображения
    constant IMAGE_HEIGHT : integer := 32; -- Высота изображения
    -- Пример массива данных (замените на реальные данные)
    type pixel_array is array (0 to IMAGE_WIDTH * IMAGE_HEIGHT - 1) of STD_LOGIC_VECTOR(23 downto 0);
    constant image_data : pixel_array := (
        x"FF0000", x"FE0001", x"FD0002", x"FC0003", x"FB0004", x"FA0005", x"F90006", x"F80007",
        x"F70008", x"F60009", x"F5000A", x"F4000B", x"F3000C", x"F2000D", x"F1000E", x"F0000F",
        x"EF0010", x"EE0011", x"ED0012", x"EC0013", x"EB0014", x"EA0015", x"E90016", x"E80017",
        x"E70018", x"E60019", x"E5001A", x"E4001B", x"E3001C", x"E2001D", x"E1001E", x"E0001F",
        x"DF0020", x"DE0021", x"DD0022", x"DC0023", x"DB0024", x"DA0025", x"D90026", x"D80027",
        x"D70028", x"D60029", x"D5002A", x"D4002B", x"D3002C", x"D2002D", x"D1002E", x"D0002F",
        x"CF0030", x"CE0031", x"CD0032", x"CC0033", x"CB0034", x"CA0035", x"C90036", x"C80037",
        x"C70038", x"C60039", x"C5003A", x"C4003B", x"C3003C", x"C2003D", x"C1003E", x"C0003F",
        x"BF0040", x"BE0041", x"BD0042", x"BC0043", x"BB0044", x"BA0045", x"B90046", x"B80047",
        x"B70048", x"B60049", x"B5004A", x"B4004B", x"B3004C", x"B2004D", x"B1004E", x"B0004F",
        x"AF0050", x"AE0051", x"AD0052", x"AC0053", x"AB0054", x"AA0055", x"A90056", x"A80057",
        x"A70058", x"A60059", x"A5005A", x"A4005B", x"A3005C", x"A2005D", x"A1005E", x"A0005F",
        x"9F0060", x"9E0061", x"9D0062", x"9C0063", x"9B0064", x"9A0065", x"990066", x"980067",
        x"970068", x"960069", x"95006A", x"94006B", x"93006C", x"92006D", x"91006E", x"90006F",
        x"8F0070", x"8E0071", x"8D0072", x"8C0073", x"8B0074", x"8A0075", x"890076", x"880077",
        x"870078", x"860079", x"85007A", x"84007B", x"83007C", x"82007D", x"81007E", x"80007F",
        x"7F0080", x"7E0081", x"7D0082", x"7C0083", x"7B0084", x"7A0085", x"790086", x"780087",
        x"770088", x"760089", x"75008A", x"74008B", x"73008C", x"72008D", x"71008E", x"70008F",
        x"6F0090", x"6E0091", x"6D0092", x"6C0093", x"6B0094", x"6A0095", x"690096", x"680097",
        x"670098", x"660099", x"65009A", x"64009B", x"63009C", x"62009D", x"61009E", x"60009F",
        x"5F00A0", x"5E00A1", x"5D00A2", x"5C00A3", x"5B00A4", x"5A00A5", x"5900A6", x"5800A7",
        x"5700A8", x"5600A9", x"5500AA", x"5400AB", x"5300AC", x"5200AD", x"5100AE", x"5000AF",
        x"4F00B0", x"4E00B1", x"4D00B2", x"4C00B3", x"4B00B4", x"4A00B5", x"4900B6", x"4800B7",
        x"4700B8", x"4600B9", x"4500BA", x"4400BB", x"4300BC", x"4200BD", x"4100BE", x"4000BF",
        x"3F00C0", x"3E00C1", x"3D00C2", x"3C00C3", x"3B00C4", x"3A00C5", x"3900C6", x"3800C7",
        x"3700C8", x"3600C9", x"3500CA", x"3400CB", x"3300CC", x"3200CD", x"3100CE", x"3000CF",
        x"2F00D0", x"2E00D1", x"2D00D2", x"2C00D3", x"2B00D4", x"2A00D5", x"2900D6", x"2800D7",
        x"2700D8", x"2600D9", x"2500DA", x"2400DB", x"2300DC", x"2200DD", x"2100DE", x"2000DF",
        x"1F00E0", x"1E00E1", x"1D00E2", x"1C00E3", x"1B00E4", x"1A00E5", x"1900E6", x"1800E7",
        x"1700E8", x"1600E9", x"1500EA", x"1400EB", x"1300EC", x"1200ED", x"1100EE", x"1000EF",
        x"0F00F0", x"0E00F1", x"0D00F2", x"0C00F3", x"0B00F4", x"0A00F5", x"0900F6", x"0800F7",
        x"0700F8", x"0600F9", x"0500FA", x"0400FB", x"0300FC", x"0200FD", x"0100FE", x"0000FF",
        others => x"000000"
    );
    
    signal pixel_index : integer := 0;
    signal transmit_done : boolean := false;
begin

    -- State register
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= reset_state;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Next state logic
    process(current_state, valid, reset)
    begin
        case current_state is
            when idle =>
                if valid = '1' then
                    next_state <= make_file;
                else
                    next_state <= idle;
                end if;

            when make_file =>
                next_state <= transmit;

            when transmit =>
                if valid = '1' then
                    next_state <= transmit;
                elsif valid = '0' and transmit_done then
                    if pixel_index < image_data'length - 1 then
                        next_state <= transmit;
                    else
                        next_state <= reset_state;
                    end if;
                else
                    next_state <= transmit;
                end if;

            when reset_state =>
                next_state <= idle;

            when others =>
                next_state <= idle;
        end case;
    end process;

    -- Output logic
    process(current_state, valid)
    begin
        case current_state is
            when idle =>
                ready <= '1';
                pixel_data <= (others => '0');

            when make_file =>
                ready <= '0';
                pixel_data <= (others => '0');

            when transmit =>
                if valid = '1' then
                    ready <= '1';
                    pixel_data <= image_data(pixel_index);
                else
                    ready <= '0';
                    pixel_data <= (others => '0');
                end if;

            when reset_state =>
                ready <= '0';
                pixel_data <= (others => '0');

            when others =>
                ready <= '0';
                pixel_data <= (others => '0');
        end case;
    end process;

    -- Pixel index update
    process(clk, reset)
    begin
        if reset = '1' then
            pixel_index <= 0;
            transmit_done <= false;
        elsif rising_edge(clk) then
            if current_state = transmit then
                if valid = '1' then
                    transmit_done <= true;
                elsif valid = '0' and transmit_done then
                    transmit_done <= false;
                    if pixel_index < image_data'length - 1 then
                        pixel_index <= pixel_index + 1;
                    else
                        pixel_index <= 0;
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;