library verilog;
use verilog.vl_types.all;
entity pkt_check is
    generic(
        DATA_W          : integer := 8;
        HEAD            : integer := 0;
        \TYPE\          : integer := 1;
        LEN             : integer := 2;
        DATA            : integer := 3;
        FCS             : integer := 4;
        CTRL_PKT_LEN    : integer := 64
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        din             : in     vl_logic_vector;
        dout_vld        : out    vl_logic;
        dout            : out    vl_logic_vector;
        dout_sop        : out    vl_logic;
        dout_eop        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_W : constant is 1;
    attribute mti_svvh_generic_type of HEAD : constant is 1;
    attribute mti_svvh_generic_type of \TYPE\ : constant is 1;
    attribute mti_svvh_generic_type of LEN : constant is 1;
    attribute mti_svvh_generic_type of DATA : constant is 1;
    attribute mti_svvh_generic_type of FCS : constant is 1;
    attribute mti_svvh_generic_type of CTRL_PKT_LEN : constant is 1;
end pkt_check;
