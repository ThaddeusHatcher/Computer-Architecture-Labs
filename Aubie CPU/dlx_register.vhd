-- 32-bit Single Value Register:  
--      This will be used everywhere in the chip that a temporary value should be stored. 

use work.dlx_types.all;
use work.bv_arithmetic.all;

entity dlx_register is 
    port
    (
        in_val   : in dlx_word; 
        clock    : in bit;
        out_val  : out dlx_word
    );
end entity dlx_register;

architecture behaviour of dlx_register is
begin
    dlxReg_process : process(in_val, clock) is
        begin
            -- if clock = 1
            if clock = '1' then
                -- once clock equal to 1, set out_val equal to in_val
                out_val <= in_val;
            else 
                out_val <= x"00000000";
            end if;
        end process;
end architecture;