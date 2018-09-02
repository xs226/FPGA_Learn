library verilog;
use verilog.vl_types.all;
entity fsm is
    generic(
        IDLE            : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0);
        S1              : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        S2              : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        en              : in     vl_logic;
        dout            : out    vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of S1 : constant is 1;
    attribute mti_svvh_generic_type of S2 : constant is 1;
end fsm;
