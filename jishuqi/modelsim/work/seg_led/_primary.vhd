library verilog;
use verilog.vl_types.all;
entity seg_led is
    generic(
        DATA0           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1);
        DATA1           : vl_logic_vector(0 to 7) := (Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi1, Hi1);
        DATA2           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi1);
        DATA3           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1);
        DATA4           : vl_logic_vector(0 to 7) := (Hi1, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi1);
        DATA5           : vl_logic_vector(0 to 7) := (Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1);
        DATA6           : vl_logic_vector(0 to 7) := (Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        DATA7           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1, Hi1);
        DATA8           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        DATA9           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1);
        TIME_20ms       : integer := 1000000;
        TIME_1s         : integer := 50000000;
        TIME_20us       : integer := 1000
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        segment         : out    vl_logic_vector(7 downto 0);
        segsel          : out    vl_logic_vector(5 downto 0);
        key             : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA0 : constant is 1;
    attribute mti_svvh_generic_type of DATA1 : constant is 1;
    attribute mti_svvh_generic_type of DATA2 : constant is 1;
    attribute mti_svvh_generic_type of DATA3 : constant is 1;
    attribute mti_svvh_generic_type of DATA4 : constant is 1;
    attribute mti_svvh_generic_type of DATA5 : constant is 1;
    attribute mti_svvh_generic_type of DATA6 : constant is 1;
    attribute mti_svvh_generic_type of DATA7 : constant is 1;
    attribute mti_svvh_generic_type of DATA8 : constant is 1;
    attribute mti_svvh_generic_type of DATA9 : constant is 1;
    attribute mti_svvh_generic_type of TIME_20ms : constant is 1;
    attribute mti_svvh_generic_type of TIME_1s : constant is 1;
    attribute mti_svvh_generic_type of TIME_20us : constant is 1;
end seg_led;
