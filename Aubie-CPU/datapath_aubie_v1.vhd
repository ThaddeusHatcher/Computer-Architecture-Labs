-- datapath_aubie.vhd

-- entity reg_file (lab 2)
use work.dlx_types.all; 
use work.bv_arithmetic.all;  

entity reg_file is
     port (data_in: in dlx_word; readnotwrite,clock : in bit; 
	   data_out: out dlx_word; reg_number: in register_index );
end entity reg_file; 

architecture behavior of reg_file is
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
                      data_out <= registers(bv_to_integer(reg_number));
              end case;
          end if;
      end process regProcess;
end architecture behavior;

-- entity alu (lab 3) 
use work.dlx_types.all; 
use work.bv_arithmetic.all; 

entity alu is 
     generic(prop_delay : Time := 5 ns);
     port(operand1, operand2: in dlx_word; operation: in alu_operation_code; 
          result: out dlx_word; error: out error_code); 
end entity alu; 

architecture behavior of alu is 
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
        elsif operation = "1100" then
            -- for STO or STOR operation
            temp1 := operand1;
            result <= temp1 after prop_delay;
        else 
            error <= "0000";
            result <= x"00000000" after prop_delay;
        end if;
    end process aluProcess;
end architecture behavior;
-- alu_operation_code values
-- 0000 unsigned add
-- 0001 signed add
-- 0010 2's compl add
-- 0011 2's compl sub
-- 0100 2's compl mul
-- 0101 2's compl divide
-- 0110 logical and
-- 0111 bitwise and
-- 1000 logical or
-- 1001 bitwise or
-- 1010 logical not (op1) 
-- 1011 bitwise not (op1)
-- 1100-1111 output all zeros

-- error code values
-- 0000 = no error
-- 0001 = overflow (too big positive) 
-- 0010 = underflow (too small neagative) 
-- 0011 = divide by zero 

-- entity dlx_register (lab 3)
use work.dlx_types.all; 

entity dlx_register is
     generic(prop_delay : Time := 5 ns);
     port(in_val: in dlx_word; clock: in bit; out_val: out dlx_word);
end entity dlx_register;

architecture behavior of dlx_register is
  begin
      dlxReg_process : process(in_val, clock) is
          begin
              -- if clock = 1
              if clock = '1' then
                  -- once clock equal to 1, set out_val equal to in_val
                  out_val <= in_val;
              end if;
          end process dlxReg_process;
  end architecture behavior; 

-- entity pcplusone
use work.dlx_types.all;
use work.bv_arithmetic.all; 

entity pcplusone is
	generic(prop_delay: Time := 5 ns); 
	port (input: in dlx_word; clock: in bit;  output: out dlx_word); 
end entity pcplusone; 

architecture behavior of pcplusone is 
begin
	plusone: process(input,clock) is  -- add clock input to make it execute
		variable newpc: dlx_word;
		variable error: boolean; 
	begin
	   if clock'event and clock = '1' then
	  	bv_addu(input,"00000000000000000000000000000001",newpc,error);
		output <= newpc after prop_delay; 
	  end if; 
	end process plusone; 
end architecture behavior; 


-- entity mux
use work.dlx_types.all; 

entity mux is
     generic(prop_delay : Time := 5 ns);
     port (input_1,input_0 : in dlx_word; which: in bit; output: out dlx_word);
end entity mux;

architecture behavior of mux is
begin
   muxProcess : process(input_1, input_0, which) is
   begin
      if (which = '1') then
         output <= input_1 after prop_delay;
      else
         output <= input_0 after prop_delay;
      end if;
   end process muxProcess;
end architecture behavior;
-- end entity mux

-- entity threeway_mux 
use work.dlx_types.all; 

entity threeway_mux is
     generic(prop_delay : Time := 5 ns);
     port (input_2,input_1,input_0 : in dlx_word; which: in threeway_muxcode; output: out dlx_word);
end entity threeway_mux;

architecture behavior of threeway_mux is
begin
   muxProcess : process(input_1, input_0, which) is
   begin
      if (which = "10" or which = "11" ) then
         output <= input_2 after prop_delay;
      elsif (which = "01") then 
	 output <= input_1 after prop_delay; 
       else
         output <= input_0 after prop_delay;
      end if;
   end process muxProcess;
end architecture behavior;
-- end entity mux

  
-- entity memory
use work.dlx_types.all;
use work.bv_arithmetic.all;

entity memory is
  
  port (
    address : in dlx_word;
    readnotwrite: in bit; 
    data_out : out dlx_word;
    data_in: in dlx_word; 
    clock: in bit); 
end memory;

architecture behavior of memory is

begin  -- behavior

  mem_behav: process(address,clock) is
    -- note that there is storage only for the first 1k of the memory, to speed
    -- up the simulation
    type memtype is array (0 to 1024) of dlx_word;
    variable data_memory : memtype;
  begin
    -- fill this in by hand to put some values in there
    -- some instructions
    data_memory(0) :=  X"30200000"; --LD R4, 0x100
    data_memory(1) :=  X"00000100"; -- address 0x100 for previous instruction
    data_memory(2) :=  "00000000000110000100010000000000"; -- ADDU R3,R1,R2

    data_memory(2) :=  X"30080000"; -- LD R1, 0x101 = 257
    data_memory(3) :=  X"00000101"; -- address 0x101 for previous instruction
    -- R1 = Contents of Mem Addd x101 = x"AA00FF00"

    data_memory(4) :=  X"30100000"; -- LD R2, 0x102 = 258 
    data_memory(5) :=  X"00000102"; -- address 0x102 for previous instruction
    
    data_memory(6) :=  "00000000000110000100010000000000"; -- ADDU R3,R1 R2
    -- R3 = Contents of (R1 + R2) = x"AA00FF01"

    data_memory(7) :=  "00100000000000001100000000000000"; -- STO R3, 0x103
    data_memory(8) :=  x"00000103"; -- address 0x103 for previous instruction
    -- Mem Addr x"103" = data_memory(259) := contents of R3 = x"AA00FF01"

    -- some data
    -- note that this code runs every time an input signal to memory changes, 
    -- so for testing, write to some other locations besides these
    data_memory(256) := "01010101000000001111111100000000";
    data_memory(257) := "10101010000000001111111100000000";
    data_memory(258) := "00000000000000000000000000000001";


   
    if clock = '1' then
      if readnotwrite = '1' then
        -- do a read
        data_out <= data_memory(bv_to_natural(address)) after 5 ns;
      else
        -- do a write
        data_memory(bv_to_natural(address)) := data_in; 
      end if;
    end if;


  end process mem_behav; 

end behavior;
-- end entity memory


