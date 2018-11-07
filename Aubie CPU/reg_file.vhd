-- Entity: reg_file
--
-- Specification:   
--     Consists of 32 registers numbered 0-31.
--     Performs a single read or write per clock cycle.
--     
--     Propagation Delay = 10 ns.
--     Port Signals: 
--         data_in        ->  dlx_word ; contains data that will be written into a register if readnotwrite = 0
--         readnotwrite   ->  bit ; indicates whether a register read or write will be performed (0 = write, 1 = read)
--         clock          ->  bit ; represents the system clock; reads/writes only performed when clock = 1
--         reg_number     ->  register_index ; indicates which register a read/write will be performed with
--         data_out       ->  dlx_word ; if write is being performed, will be assigned a value contained in a specified register
--                                       if read is being performed, holds no meaningful value
use work.dlx_types.all;
use work.bv_arithmetic.all;

entity reg_file is 
    generic(prop_delay : Time := 10 ns);
    port
    ( 
        data_in              : in dlx_word; 
        readnotwrite         : in bit;
        clock                : in bit;
        reg_number           : in register_index;
        data_out             : out dlx_word
    );
end entity reg_file;

architecture behaviour of reg_file is
    --- Define reg_type as an array of 32 registers, each register being represented by a 32-bit dlx_word
    type reg_type is array (0 to 31) of dlx_word;
begin
    regProcess : process(data_in, readnotwrite, clock, reg_number) is
        ---
        variable temp_data_out_val : dlx_word := x"00000000";
        variable registers : reg_type;
        -- may need index variable if register_index type cannot be used for registers indexing

        begin 
            -- while clock is 0 (i.e. not equal to 1), do nothing
            if clock = '1' then
                case readnotwrite is
                    when '0' =>   -- perform register write
                        registers(bv_to_integer(reg_number)) := data_in;
                    
                    when '1' =>   -- perform register read
                        data_out <= registers(bv_to_integer(reg_number)) after prop_delay;
                end case;
            end if;
        end process;
end architecture;