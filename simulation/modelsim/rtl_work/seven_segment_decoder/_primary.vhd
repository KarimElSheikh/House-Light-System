library verilog;
use verilog.vl_types.all;
entity seven_segment_decoder is
    port(
        segments        : out    vl_logic_vector(6 downto 0);
        num             : in     vl_logic_vector(3 downto 0)
    );
end seven_segment_decoder;
