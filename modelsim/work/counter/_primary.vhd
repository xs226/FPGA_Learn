library verilog;
use verilog.vl_types.all;
entity counter is
    generic(
        NUM             : integer := 3
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        din_vld         : in     vl_logic;
        dout            : out    vl_logic_vector;
        dout_vld        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM : constant is 1;
end counter;
