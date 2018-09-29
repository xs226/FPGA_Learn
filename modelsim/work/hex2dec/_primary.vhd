library verilog;
use verilog.vl_types.all;
entity hex2dec is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        din             : in     vl_logic_vector(3 downto 0);
        din_vld         : in     vl_logic;
        dout            : out    vl_logic_vector(7 downto 0);
        dout_vld        : out    vl_logic
    );
end hex2dec;
