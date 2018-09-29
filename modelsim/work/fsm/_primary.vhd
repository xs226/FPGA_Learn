library verilog;
use verilog.vl_types.all;
entity fsm is
    generic(
        HEAD            : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0);
        \TYPE\          : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        LEN             : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0);
        DATA            : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi1);
        FCS             : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        din             : in     vl_logic_vector(7 downto 0);
        dout            : out    vl_logic_vector(7 downto 0);
        dout_sop        : out    vl_logic;
        dout_eop        : out    vl_logic;
        dout_vld        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of HEAD : constant is 1;
    attribute mti_svvh_generic_type of \TYPE\ : constant is 1;
    attribute mti_svvh_generic_type of LEN : constant is 1;
    attribute mti_svvh_generic_type of DATA : constant is 1;
    attribute mti_svvh_generic_type of FCS : constant is 1;
end fsm;
