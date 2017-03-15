library verilog;
use verilog.vl_types.all;
entity DSDProject is
    generic(
        s0              : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        s1              : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        s2              : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        s3              : vl_logic_vector(0 to 1) := (Hi1, Hi1)
    );
    port(
        segments0       : out    vl_logic_vector(6 downto 0);
        segments1       : out    vl_logic_vector(6 downto 0);
        x               : in     vl_logic;
        y               : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of s0 : constant is 1;
    attribute mti_svvh_generic_type of s1 : constant is 1;
    attribute mti_svvh_generic_type of s2 : constant is 1;
    attribute mti_svvh_generic_type of s3 : constant is 1;
end DSDProject;
