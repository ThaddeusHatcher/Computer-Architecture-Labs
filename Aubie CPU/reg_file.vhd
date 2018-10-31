use work.dlx_types.all;
use work.bv_arithmetic.all;

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

entity reg_file is 
    generic(prop_delay : Time := 10 ns);
    port
    ( 
        data_in              : in dlx_word; 
        readnotwrite, clock  : in bit;
        reg_number           : in register_index
        data_out             : out dlx_word;
    );
end entity reg_file;

architecture behaviour of reg_file is
begin
    regProcess : process(data_in, readnotwrite, clock, reg_number) is
        
        --- Define reg_type as an array of 32 registers, each register being represented by a 32-bit dlx_word
        type reg_type is array (0 to 31) of dlx_word;
        ---
        variable temp_data_out_val : dlx_word := x"00000000"
        variable registers : reg_type;
        -- may need index variable if register_index type cannot be used for registers indexing

        begin 
            -- while clock is 0 (i.e. not equal to 1), do nothing
            while (clock /= "1") loop
            end loop;

            case readnotwrite is
                when "0" =>   -- perform register write
                    registers(register_index) := data_in;
                    
                when "1" =>   -- perform register read
                    data_out <= registers(register_index) after prop_delay;
            end case;

        end process
end architecture

entity dlx_register is 
    port
    (
        in_val   : in dlx_word;
        clock    : in bit;
        out_val  : out dlx_word;
    )
end entity dlx_register;

-- 32-bit Single Value Register:  
--      This will be used everywhere in the chip that a temporary value should be stored. 
architecture behaviour of dlx_register is
begin
    dlxReg_process : process(in_val, clock, out_val) is
        begin
            -- while clock is 0 (i.e. not equal to 1), do nothing
            while (clock /= "1") loop
            end loop;   
            -- once clock equal to 1, set out_val equal to in_val
            out_val <= in_val;
        end process
end architecture