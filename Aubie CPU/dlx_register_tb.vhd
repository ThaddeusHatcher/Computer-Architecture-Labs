use work.bv_arithmetic.all;
use work.dlx_types.all;

entity dlx_register_tb is
end dlx_register_tb;

architecture test of dlx_register_tb is
    component dlx_register is 
        port
        (
            in_val   : in dlx_word; 
            clock    : in bit;
            out_val  : out dlx_word
        );
        end component dlx_register;

    -- Inputs -- 
    signal in_val   : dlx_word := x"00000000";
    signal clock    : bit := '0';

    -- Outputs --
    signal out_val  : dlx_word;

    constant TIME_DELTA 	: time := 20 ns;
    
	type T_bit_map is array(bit) of character;
	constant C_BIT_MAP: T_bit_map := ('0', '1');

    type reg_type is array (0 to 31) of dlx_word;
    
begin 
    uut: dlx_register
        port map 
        (
            in_val  =>  in_val,
            clock   =>  clock,
            out_val =>  out_val
        );

        clock <= '1', '0' after 100 ns;
        in_val <= x"11111111", x"22222222" after 25 ns, x"33333333" after 50 ns, x"44444444" after 75 ns;

        stimulus_process: process

        begin
            wait for 200 ns;
            wait;
        end process;
end test;