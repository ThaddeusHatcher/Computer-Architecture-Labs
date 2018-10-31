-- Author: Thaddeus Hatcher
-- Assignment: Lab 2
-- Instructor: Dr. Chapman
-- Due Date: Oct. 3, 2018  11:59 PM
-- Specification: Develop VHDL for the following component. You should define an architecture
--                for the ALU entity given below. You should test your architecture by developing
--                simulation files for the entity. Your architecture should implement the functionality
--                described in this document. To make the simulation results more readable, we will use 
--                a 32-bit datapath.
--                
--                You should use the types from the package "dlx_types" and the conversion and math 
--                routines from the package "bv_arithmetic" in files bva.vhd. The propagation delay 
--                through the ALU should be 15 nanoseconds.
--
--                Arithmetic-Logic Unit: This unit takes in two 32-bit values, and a 4-bit operation 
--                code that specifies which ALU operation (e.g. add, subtract, multiply, etc) is to be
--                performed on the two operands. For non commutative operations like subtract or divide,
--                operand1 always goes on the left of the operator and operand2 on the right.
-- 
--                Operation Codes:  0000 = unsigned add
--                                  0001 = unsigned subtract
--                                  0010 = two's complement add
--                                  0011 = two's complement subtract
--                                  0100 = two's complement multiply
--                                  0101 = two's complement divide
--                                  0110 = logical AND
--                                  0111 = bitwise AND
--                                  1000 = logical OR
--                                  1001 = bitwise OR
--                                  1010 = logical NOT of operand1 (ignore operand2)
--                                  1011 = bitwise NOT of operand1 (ignore operand2)
--                                  1100-1111 = just output all zeroes
--
--                 The unit returns the 32-bit result of the operation and a 4-bit error code. The 
--                 meaning of the error code should be: 
--
--                 0000 = no error
--                 0001 = overflow
--                 0010 = underflow
--                 0011 = divide by zero
--
-- The ALU should be sensitive to changes on all input ports. Note that the ALU is purely combinational
-- logic, no memory, and that there is no clock signal.

use work.dlx_types.all;
use work.bv_arithmetic.all;


entity alu is 
    generic(prop_delay: Time := 15 ns);
    port ( operand1: in dlx_word;
           operand2: in dlx_word; 
           operation: in alu_operation_code;
           result: out dlx_word; 
           error: out error_code );
end entity alu;

architecture behaviour of alu is 
begin
    aluProcess : process(operand1, operand2, operation) is 

    variable temp1: dlx_word := x"00000000";
    variable overflow: boolean;
    variable div_by_zero: boolean;
    variable operand1_non_zero: boolean := false;
    variable operand2_non_zero: boolean := false;

    begin
        if operation = "0000" then
            -- unsigned add
            bv_addu(operand1, operand2, temp1, overflow);
            if overflow = true then
                error <= "0001";
            else -- no error
                error <= "0000";
            end if;
            result <= temp1 after prop_delay;
        elsif operation = "0001" then
            -- unsigned subtract
            bv_subu(operand1, operand2, temp1, overflow);
            if overflow then 
                error <= "0001";
            else -- no error
                error <= "0000";
            end if;
            result <= temp1 after prop_delay;
        elsif operation = "0010" then 
            -- two's complement add
            bv_add(operand1, operand2, temp1, overflow);
            if overflow then
                -- overflow
                if (temp1(31) = '1') and (operand1(31) = '0') and (operand2(31) = '1') then
                    error <= "0001";
                -- underflow
                elsif (temp1(31) = '0') and (operand1(31) = '1') and (operand2(31) = '0') then
                    error <= "0010";
                else -- no error
                    error <= "0000";
                end if;
            end if;
            result <= temp1 after prop_delay;
        elsif operation = "0011" then  
            -- two's complement subtract
            bv_sub(operand1, operand2, temp1, overflow);
            if overflow then
                -- overflow
                if (temp1(31) = '1') and (operand1(31) = '0') and (operand2(31) = '1') then
                    error <= "0001";
                -- underflow
                elsif (temp1(31) = '0') and (operand1(31) = '1') and (operand2(31) = '0') then
                    error <= "0010";
                else -- no error
                    error <= "0000";
                end if;
            end if;
            result <= temp1 after prop_delay;
        elsif operation = "0100" then
            -- two's complement multiply
            bv_mult(operand1, operand2, temp1, overflow);
            if overflow then
                -- overflow
                if (operand1(31) = '0') and (operand2(31) = '1') then
                    error <= "0001";
                -- underflow
                elsif (operand1(31) = '1') and (operand2(31) = '0') then
                    error <= "0010";
                else -- no error
                    error <= "0000";
                end if;
            end if;
            result <= temp1 after prop_delay;
        elsif operation = "0101" then  
            -- two's complement divide
            bv_div(operand1, operand2, temp1, div_by_zero, overflow);
            -- divide by zero
            if div_by_zero then
                error <= "0011";
            -- divide 
            elsif overflow then
                error <= "0001";
            else -- no error
                error <= "0000";
            end if;
            result <= temp1 after prop_delay;
        elsif operation = "0110" then
            -- logical AND
            for i in 31 downto 0 loop
                if (operand1(i) = '1') then
                    operand1_non_zero := true;
                elsif (operand2(i) = '1') then
                    operand2_non_zero := true;
                end if;
            end loop;
            if (operand1_non_zero and operand2_non_zero) then
                temp1 := x"00000001";
            end if;
            result <= temp1 after prop_delay;
        elsif operation = "0111" then
            -- bitwise AND
            for i in 31 downto 0 loop
                temp1(i) := operand1(i) and operand2(i);
            end loop;
            result <= temp1 after prop_delay;
        elsif operation = "1000" then
            -- logical OR
            for i in 31 downto 0 loop
                if (operand1(i) = '1' or operand2(i) = '1') then
                    temp1 := x"00000001";
                    exit;
                end if;
            end loop;
            temp1 := operand1 or operand2;
            result <= temp1 after prop_delay;
        elsif operation = "1001" then
            -- bitwise OR
            for i in 31 downto 0 loop
                temp1(i) := operand1(i) or operand2(i);
            end loop;
            result <= temp1 after prop_delay;
        elsif operation = "1010" then
            -- logical NOT of operand1 (ignore operand2)
            temp1 := not operand1;
            for i in 31 downto 0 loop
                if (temp1(i) = '0') then
                    temp1 := x"00000000";
                end if;
            end loop;
            result <= temp1 after prop_delay;
        elsif operation = "1011" then   
            -- bitwise NOT of operand1 (ignore operand2)
            for i in 31 downto 0 loop
                if (operand1(i) = '1') then
                    temp1(i) := '0';
                elsif (operand1(i) = '0') then
                    temp1(i) := '1';
                end if;
            end loop;
            result <= temp1 after prop_delay;
        else 
            error <= "0000";
            result <= "00000000" after prop_delay;
        end if;
    end process aluProcess;
end architecture;