library verilog;
use verilog.vl_types.all;
entity array_key is
    generic(
        TIME_20ms       : integer := 5000000;
        TIME_1ms        : integer := 5000000
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        key_col         : in     vl_logic_vector(3 downto 0);
        key_row         : out    vl_logic_vector(3 downto 0);
        key_num         : out    vl_logic_vector(3 downto 0);
        key_vld         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of TIME_20ms : constant is 1;
    attribute mti_svvh_generic_type of TIME_1ms : constant is 1;
end array_key;
