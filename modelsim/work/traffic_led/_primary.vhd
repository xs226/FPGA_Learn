library verilog;
use verilog.vl_types.all;
entity traffic_led is
    generic(
        TIME_1S         : integer := 5000000;
        TIME_4S         : integer := 4
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        led_east        : out    vl_logic_vector(2 downto 0);
        led_south       : out    vl_logic_vector(2 downto 0);
        led_west        : out    vl_logic_vector(2 downto 0);
        led_north       : out    vl_logic_vector(2 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of TIME_1S : constant is 1;
    attribute mti_svvh_generic_type of TIME_4S : constant is 1;
end traffic_led;
