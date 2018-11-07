use work.bv_arithmetic.all;
use work.dlx_types.all;

entity reg_file_tb is
end reg_file_tb;

architecture test of reg_file_tb is

	component reg_file is
		--generic ( prop_delay: time := 10 ns );
        port
        ( 
            data_in              : in dlx_word; 
            readnotwrite         : in bit;
            clock                : in bit;
            reg_number           : in register_index;
            data_out             : out dlx_word
        );
    	end component reg_file;

	-- Inputs --
	signal clock         : bit := '0';
	signal readnotwrite  : bit := '0';
	signal reg_number    : register_index := "00000";
	signal data_in       : dlx_word := x"00000000";
	
	-- Outputs --	
	signal data_out      : dlx_word;

	-- Time interval between signal changes
	constant TIME_DELTA 	: time := 20 ns;
  
	-- Used for converting a single binary bit to string format for assertion output --
	type T_bit_map is array(bit) of character;
	constant C_BIT_MAP: T_bit_map := ('0', '1');

	type reg_type is array (0 to 31) of dlx_word;


begin
	uut: reg_file 
		port map (
			clock          => 	clock,
			readnotwrite   => 	readnotwrite,
			reg_number     => 	reg_number,
			data_in        => 	data_in,
			data_out       => 	data_out
		);
		
		clock		 <= '1', '0' after 150 ns;
		readnotwrite 	 <= '0', '1' after 25 ns, '0' after 50 ns, '1' after 75 ns, '0' after 100 ns, '0' after 125 ns;
        
        -- Target first 3 in regsiters array
		reg_number 	 <= "00000", "00001" after 50 ns, "00010" after 100 ns; 
		data_in		 <= x"11111111", x"22222222" after 50 ns, x"33333333" after 100 ns, x"44444444" after 150 ns, x"55555555" after 200 ns, x"00000000" after 250 ns;

	  -- Test
	  stimulus_process: process

	  begin
	    	-- Check UUT response --
		
		wait for 200 ns; -- Let all input signals propagate
	    wait; -- Terminate so we don't continue run -all   
  	  end process;
end test;