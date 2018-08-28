library verilog;
use verilog.vl_types.all;
entity water_led is
    generic(
        TIME_1S         : integer := 5000000
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        dout            : out    vl_logic_vector(11 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of TIME_1S : constant is 1;
end water_led;
