-- Author: Thaddeus Hatcher
-- Assignment: Lab 4
-- Instructor: Dr. Chapman
-- Due Date: Dec. 5, 2018  11:59 PM
-- Specification: 

use work.bv_arithmetic.all; 
use work.dlx_types.all; 

entity aubie_controller is
	generic(prop_delay			  : Time := 5 ns;
			extended_prop_delay   : Time := 15 ns;
			extended_prop_delay2  : Time := 20 ns
			);
	port(ir_control		: in dlx_word;
	     alu_out		: in dlx_word; 
	     alu_error		: in error_code; 
		 clock			: in bit; 
		 
	     regfilein_mux			: out threeway_muxcode; 
	     memaddr_mux			: out threeway_muxcode; 
	     addr_mux				: out bit; 
		 pc_mux					: out threeway_muxcode; -- Program Counter Multiplexer -> send value to Program Counter from addr_reg (addr_out), 
		 								   --							  -> pcplusone_out (PC increment), or Memory for Jump instr (mem_out)
	     alu_func				: out alu_operation_code; -- type of ALU operation
	     regfile_index			: out register_index; -- Register number; range: (0, 31)
		 regfile_readnotwrite	: out bit; -- 0 = read -> data_out ; 1 = write -> data_in

		 regfile_clk			: out bit; -- reg_file clock
	     mem_clk				: out bit; -- Memory clock
	     mem_readnotwrite		: out bit; -- 0 = read -> data_out ; 1 = write -> data_in
	     ir_clk					: out bit; -- Instruction Register clock
	     imm_clk				: out bit; -- Immediate Register clock
	     addr_clk				: out bit; -- Address Register clock
         pc_clk					: out bit; -- Program Counter clock
	     op1_clk				: out bit; -- Operand1 clock
	     op2_clk				: out bit; -- Operand2 clock
	     result_clk				: out bit  -- Result Register clock
	     ); 
end aubie_controller; 

architecture behavior of aubie_controller is
begin
	behav: process(clock) is 
		type state_type is range 1 to 20; 
		variable state		  : state_type := 1; 
		variable opcode		  : byte; 
		variable destination  : register_index;
		variable operand1 			  : register_index;
		variable operand2 			  : register_index; 
		variable passthru_op1	  : alu_operation_code := "1100";

	begin
		if clock'event and clock = '1' then
		   opcode := ir_control(31 downto 24);
		   destination := ir_control(23 downto 19);
		   operand1 := ir_control(18 downto 14);
		   operand2 := ir_control(13 downto 9); 
		   case state is
			when 1 => -- State 1 -> fetch the instruction, for all types
				-- Load the 32-bit memory word stored at the address in the PC to the
				-- 			Instruction Register: Mem[PC] -> InstrReg

				-- get memaddr_in from pc -- 
				memaddr_mux 	 <= "00" after prop_delay; 
				addr_mux 		 <= '1'  after prop_delay;
				mem_readnotwrite <= '1'  after prop_delay;
				-- turn on clocks for mem, ir -- 
				mem_clk 		 <= '1'  after prop_delay; 
				ir_clk 			 <= '1'  after prop_delay;
				-- turn off clocks for everything else -- 
				regfile_clk 	 <= '0'  after prop_delay;
				imm_clk 		 <= '0'  after prop_delay;
				addr_clk		 <= '0'  after prop_delay;
				pc_clk 			 <= '0'  after prop_delay;
				op1_clk 		 <= '0'  after prop_delay;
				op2_clk 		 <= '0'  after prop_delay;
				result_clk 		 <= '0'  after prop_delay;
				-- Go to state 2.
				state := 2; 
			when 2 => -- State 2
				-- Decide which instruction you have by looking at opcode portion of Instruction Register
				-- ALU: go to state 3			STOR: go to state 14
				-- LDI or LD: go to state 7		JMP or JZ: go to state 16
				-- STO: go to state 9			NOOP: go to state 19
				-- LDR: go to state 12
			 	if opcode(7 downto 4) = "0000" then -- ALU op
					state := 3; 
				elsif opcode = X"20" then  -- STO 
				elsif opcode = X"30" or opcode = X"31" then -- LD or LDI
					state := 7;
				elsif opcode = X"22" then -- STOR
					state := 9;
				elsif opcode = X"32" then -- LDR
					state := 12;
				elsif opcode = X"40" or opcode = X"41" then -- JMP or JZ
					state := 16;
				elsif opcode = X"10" then -- NOOP
					state := 19;
				else -- error
				end if; 
			when 3 => -- State 3
				-- Copy operand 1 value from register file to Op1 register:
				--				Regs[IR[op1]] -> Op1
				--				Go to state 4.
				
				regfile_index 		 <= operand1    after prop_delay;
				regfile_readnotwrite <= '1' 	    after prop_delay;
				-- turn on clocks for regfile, ir, op1 --
				regfile_clk 		 <= '1' 	    after prop_delay;
				op1_clk 			 <= '1' 	    after prop_delay;
				-- turn off clocks for ir, mem (turned on in state 1, not in use in state 3) --
				ir_clk				 <= '0'			after prop_delay;
				mem_clk    			 <= '0' 		after prop_delay;
				-- Go to state 4.
				state := 4; 		 
			when 4 => -- State 4	 
				-- Copy operand 2 value from the register file to Op2 register:
				--				Regs[IR[op2]] -> Op2 
				--				Go to state 5.
				regfile_index 		 <= operand2  after prop_delay;
				regfile_readnotwrite <= '1' 	  after prop_delay;
				-- turn off clock for op1, turn on clock for op2 --
				op1_clk 			 <= '0' 	  after prop_delay;
				op2_clk 			 <= '1' 	  after prop_delay;
				-- Go to state 5.
         		state := 5; 
			when 5 => -- State 5
				--	Copy ALU output into result register
				--				ALUout -> Result
				--				Go to state 6.
				alu_func    <= opcode(3 downto 0) after prop_delay;
				-- turn on clock for result reg --
				result_clk  <= '1' 			   	  after prop_delay;
				-- turn off clocks for regfile, ir, op2 -- 
				regfile_clk <= '0' 			      after prop_delay;
				ir_clk 		<= '0' 				  after prop_delay;
				op2_clk 	<= '0' 				  after prop_delay;
				-- Go to state 6.
            	state := 6; 
			when 6 => -- State 6
				-- Copy Result back into the destination register, copy PC + 1 to PC.
				--				Result -> Regs[IR[dest]]
				--				PC + 1 -> PC
				--				Go to state 1

				-- get result_out from result reg and store in destination reg --
				regfilein_mux 		 <= "00" 		after prop_delay;
				regfile_index 		 <= destination after prop_delay;
				regfile_readnotwrite <= '0' 		after prop_delay;
				-- turn ON clock for regfile -- 
				regfile_clk   		 <= '1' 		after prop_delay;
				-- incrememnt Program Counter by 1 --
				pc_mux 				 <= b"00" 		after prop_delay;
				pc_clk 				 <= '1'  		after prop_delay;
				-- turn off clock for result reg --
				result_clk 			 <= '0'			after prop_delay;
				-- Go to state 1.
            	state := 1; 
			when 7 => -- State 7
				-- LD (Opcode = 0x30): Increment PC. Copy memory specified by PC into Addr register.
				--				PC + 1 -> PC
				--				Mem[PC] -> Addr
				if (opcode = x"30") then
					-- increment Program Counter by 1 -- 
					pc_mux 			 <= "00" 		after prop_delay;
					pc_clk 			 <= '1'  		after prop_delay;
					-- get memaddr_in from pc and send to addr reg
					memaddr_mux 	 <= "00" 		after prop_delay;
					addr_mux 		 <= '1'  		after prop_delay;
					mem_readnotwrite <= '1'  		after prop_delay;
					-- turn ON clocks for pc, addr (mem_clk already on from state 1)
					pc_clk 			 <= '1' 		after prop_delay;
					addr_clk 		 <= '1' 		after prop_delay;
					-- turn OFF clock for ir (all others already off from state 1)
					ir_clk 			 <= '0' 		after prop_delay;
				-- LDI (Opcode = 0x31): Increment PC. Copy memory specified by PC into Immediate register.
				--				PC + 1 -> PC
				--				Mem[PC] -> Immed
				elsif (opcode = x"31") then
					-- increment Program Counter by 1 -- 
					pc_mux 			 <= "00" 		after prop_delay;
					pc_clk 			 <= '1' 		after prop_delay;
					-- get memaddr_in from pc and send to imm reg -- 
					memaddr_mux 	 <= "00" 		after prop_delay;
					mem_readnotwrite <= '1' 		after prop_delay;
					-- turn ON clocks for pc, imm (mem_clk already on from state 1) -- 
					pc_clk 			 <= '1' 		after prop_delay;
					imm_clk 		 <= '1' 		after prop_delay;
					-- turn OFF clock for ir (all others already off from state 1) --
					ir_clk 			 <= '0' 		after prop_delay;
				end if;
				-- Go to state 8.	
				state := 8; 
			when 8 => -- State 8
				-- LD (Opcode = 0x30): Copy memory location specified by Addr to the dest register.
				--				Mem[Addr] -> Regs[IR[dest]]
				--				PC + 1 -> PC		
				if (opcode = x"30") then
					-- get mem_out from mem to regfile -- 
					regfilein_mux 		 <= "01" 		after prop_delay;
					regfile_index 		 <= destination after prop_delay;
					regfile_readnotwrite <= '0' 		after prop_delay;
					-- turn ON clock for regfile --
					regfile_clk 		 <= '1' 		after prop_delay;
					-- increment Program Counter by 1 --
					pc_clk 				 <= '0' 		after prop_delay, 
											'1' 		after extended_prop_delay; 
					pc_mux 				 <= "00" 		after extended_prop_delay;

				-- LDI: Copy immed register into the dest register.
				--  	 		Immed -> Regs[[IR[dest]] 
				--				PC + 1 -> PC
				elsif (opcode = x"31") then
					-- get value from imm reg to regfile --
					regfilein_mux 		 <= "10" 		after prop_delay;
					regfile_index 		 <= destination after prop_delay;
					regfile_readnotwrite <= '0' 		after prop_delay;
					-- turn ON clock for regfile --
					regfile_clk 		 <= '1' 		after prop_delay;
					-- turn OFF clock for mem --
					mem_clk 			 <= '0' 		after prop_delay;
					-- increment Program Counter by 1 --
					pc_clk 				 <= '0' 		after prop_delay, 
											'1' 		after extended_prop_delay;
					pc_mux 				 <= "00" 		after extended_prop_delay;
				end if;
				-- Go to state 1.
				state := 1; 
			when 9 => -- State 9 
				-- STO: increment Program Counter by 1
				pc_mux 					 <= "00" 		after prop_delay;
				pc_clk 					 <= '1'  		after prop_delay;
				-- Go to state 10.
				state := 10;
			when 10 => -- State 10
				-- STO: Load memory at address given by PC to the Addr register:
				--			Mem[PC] -> Addr
				
				-- get address from pc and give to addr reg
				pc_mux 					 <= "00" 		after prop_delay;
				addr_mux 				 <= '1' 		after prop_delay;
				-- turn ON clocks for addr reg (mem clk already turned ON in State 1)
				addr_clk 				 <= '1' 		after prop_delay;
				-- turn OFF clocks for ir, pc (all others already turned OFF in prev states)
				ir_clk 					 <= '0' 		after prop_delay;
				pc_clk 					 <= '0' 		after prop_delay;
				-- Go to state 11.
				state := 11;
			when 11 => -- State 11
				-- STO: Store contents of src register to address in memory given by Addr register. Increment the PC. 
				--			Regs[IR[src]] -> Mem[Addr]
				--			PC + 1 -> PC
				-- get address in from addr reg using memaddr_mux --
				memaddr_mux 			 <= "01" 		 after prop_delay;
				mem_readnotwrite		 <= '0'			 after prop_delay;
				-- to get src (op1) to mem as data_in, will send thru alu and result reg
				regfile_index			 <= operand1	 after prop_delay;
				regfile_readnotwrite	 <= '1'			 after prop_delay;
				alu_func				 <= passthru_op1 after extended_prop_delay;
				-- turn ON clocks for regfile, result; turn off clock for result reg later to freeze value
				regfile_clk				 <= '1'			 after prop_delay;
				result_clk				 <= '1'			 after extended_prop_delay,
											'0'			 after extended_prop_delay2;
				op1_clk					 <= '1'			 after prop_delay,
										    '0'			 after extended_prop_delay;
				-- turn OFF clock for addr (freeze addr reg value)
				addr_clk				 <= '0'			 after prop_delay;
				-- increment Program Counter by 1
				pc_clk					 <= '0'			 after prop_delay;
				pc_mux					 <= "00" 		 after prop_delay;

				-- Go to state 1.		 				
				state := 1;				 				
			when 14 => -- State 14		 				
				-- STOR: Copy contents of dest reg into Addr register.
				--			Regs[IR[dest]] -> Addr		
				regfile_index 			 <= destination after prop_delay;
				regfile_readnotwrite 	 <= '1' 		after prop_delay;
				addr_mux 				 <= '0' 		after prop_delay;
				-- turn ON clocks for addr, regfile
				addr_clk 				 <= '1' 		after prop_delay;
				regfile_clk 			 <= '1' 		after prop_delay;
				-- turn OFF clocks for mem, ir
				mem_clk 				 <= '0' 		after prop_delay;
				ir_clk					 <= '0'			after prop_delay;
				-- Go to state 14.
				state := 15;
			when 15 => -- State 15
				-- STOR: Copy contents of op1 register to Memory address specified by Addr. Increment PC.
				--			Regs[IR[op1]] -> Mem[Addr]
				--			PC + 1 -> PC

				regfile_index <= operand1 after prop_delay;
				regfile_readnotwrite <= '1' after prop_delay; 
				alu_func <= passthru_op1 after extended_prop_delay;
				memaddr_mux <= "01" after prop_delay; --> get current val in addr reg for memaddr_in
				mem_readnotwrite <= '0' after prop_delay;
				-- turn ON clocks for mem, op1, result
				mem_clk <= '1' after prop_delay;
				result_clk				 <= '1'			 after extended_prop_delay,
											'0'			 after extended_prop_delay2;
				op1_clk					 <= '1'			 after prop_delay,
										    '0'			 after extended_prop_delay;
				-- turn OFF clocks for addr
				addr_clk <= '0' after prop_delay;
				-- increment Program Counter by 1
				pc_clk <= '0' after prop_delay;
				pc_mux <= "00" after prop_delay;
				-- Go to state 1.
				state := 1;
			when others => null; 
		   end case; 
		elsif clock'event and clock = '0' then
			-- reset all the register clocks
		   -- your code here				
		end if; 
	end process behav;
end behavior;	