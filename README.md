# Aubie CPU

## Cycle-by-Cycle Semantics of Aubie CPU Instructions

### All instructions in state 1 and 2

State 1: Load the 32-bit memory word stored at the address in PC to the Instruction Register:
         `Mem[PC] -> InstrReg`
         
State 2: Decide which instruction you have by looking at opcode portion of Instruction Register.

```
ALU: go to state 3
LDI or LD: go to state 7
STO: go to state 9
STOR: go to state 14
JMP or JZ: go to state 16
NOOP: go to state 16
```

### ALU Instructions

State 3: copy operand1 value from register file to  Op1 register: `Regs[IR[op1]] -> Op1`. Go to state 4.

State 4: copy operand2 value from register file to Op2 register: `Regs[IR[op2]] -> Op2`. Go to state 5.

State 5: copy ALU output into result register: `ALUout -> Result`. Go to state 6.

State 6: copy Result back into the destination register, copy PC + 1 to PC: `Result -> Regs[IR[dest]]`, `PC + 1 -> PC`. Go to state 1.

### STO Instructions

State 9: increment PC: `PC + 1 -> PC`. Go to state 10.

State 10: load memory at address given by PC to the Addr register: `Mem[PC] -> Addr`. Go to state 11.

State 11: Store contents of src register ot address in memory given by Addr register, and increment the PC: `Regs[IR[src]] -> Mem[Addr]`, `PC + 1 -> PC`. Go to state 1.

### LD instruction

State 7: Increment PC: `PC + 1 -> PC`. Copy memory specified by PC into Addr register: `Mem[PC] -> Addr`. Go to state 8.

State 8: Copy immed register into the dest register: `Immed -> Regs[IR[dest]]`. Increment PC: `PC + 1 -> PC`. Go to state 1.

### STOR instruction

State 14: copy contents of dest reg into Addr register: `Regs[IR[dest]] -> Addr`. Go to state 15.

State 15: copy contents of op1 register to Memory address specified by Addr: `Regs[IR[op1]] -> Mem[Addr]`. Increment PC: `PC + 1 -> PC`. Go to state 1.

### LDR instruction

State 12: copy contents of op1 reg to Addr register: `Regs[IR[op1]] -> Addr`. Go to state 13.

State 13: copy contents of memory specified by Addr register to dest register: `Mem[Addr] -> Regs[IR[dest]]`. Increment PC: `PC + 1 -> PC`. Go to state 1.

### JMP instruction

State 16: Increment PC: `PC + 1 -> PC`. Go to state 17.

State 17: Load memory specified by PC to Addr register: `Mem[PC] -> Addr`. Go to state 18.

State 18: Load Addr to PC: `Addr -> PC`. Go to state 1.

### JZ instruction

State 16: Increment PC: `PC + 1 -> PC`. Go to state 17.

State 17: Load memory specified by PC to Addr register: `Mem[PC] -> Addr`. Copy register op1 to control: `Regs[IR[op1]] -> Ctl`. Go to state 18.

State 18: If `Result == 0`, copy Addr to PC: `Addr -> PC`. Else, increment PC: `PC + 1 -> PC`. Go to state 1.

### NOOP instruction

State 19: Increment PC: `PC + 1 -> PC`. Go to state 1. 


## Datapath Elements

The memory of the Aubie is 32-bits wide (i.e. a dlx_word is stored at every address).
Can do one read or one write per cycle. 

Note: Bit 31 is the most significant bit, and bit 0 is the least significant bite of a memory word.

### ALU

This unit takes in two 32-bit values, and a 4-bit operation code that specifies which ALU operation (e.g. add, subtract, multiply, etc) is to be performed on the two operands. 
For non-commutative operations like subtract or divide, operand1 always goes on the left of the operator and operand2 on the right.

Entity declaration:

```
entity alu is
  port(
       operand1  : in dlx_word;
       operand2  : in dlx_word;
       operation : in alu_operation_code;
       result    : out dlx_word;
       error     : out error_code
      );
end entity alu;
```

OPCODES

| Mnemonic          | Opcode | Meaning |
|-------------------|--------|---------|
| ADDU dest,op1,op2 | 0x00   | unsigned add |
| SUBU dest,op1,op2 | 0x01   | unsigned subtract |
| ADD  dest,op1,op2 | 0x02   | two's complement add |
| SUB  dest,op1,op2 | 0x03   | two's complement subtract |
| MUL  dest,op1,op2 | 0x04   | two's complement multiply |
| DIV  dest,op1,op2 | 0x05   | two's complement divide |
| ANDL dest,op1,op2 | 0x06   | logical AND |
| ANDB dest,op1,op2 | 0x07   | bitwise AND |
| ORL  dest,op1,op2 | 0x08   | logical OR |
| ORB  dest,op1,op2 | 0x09   | bitwise OR |
| NOTL dest,op1,op2 | 0x0A   | logical NOT (op1) |
| NOTB dest,op1,op2 | 0x0B   | bitwise NOT (op1) |

This unit returns the 32-bit result of the operation and a 4-bit error code. The meaning of the error code should be:

```
0000 = no error
0001 = overflow
0010 = underflow
0011 = divide by zero
```

The ALU should be sensitive to changes on all the input ports. Note that the ALU is purely combinational logic, no memory, and that there is no clock signal.

### Registers

#### Register File
The file consists of 32 registers numbered 0-31. In a given clock cycle one value can be read or one value can be written (not both). The propagation delay through the register file is 10 nanoseconds for a read operation and (zero for a write, but write has no output). 
The reg_number is a five-bit number that specifies which register is being read or written. If a read is being done (readnotwrite is 1), the data_in input is ignored, and the value in register reg_number is copied to the data_out port. If a write is being done (readnotwrite is 0), the value present on data_in is copied into register number reg_number. 
The data_out port does not have a meaningful value for a write.

Entity declaration:

```
entity reg_file is
  port(
      data_in       : in dlx_word;
      readnotwrite  : in bit;
      reg_number    : in register_index;
      clock         : in bit;
      data_out      : out dlx_word
  );
end entity reg_file;
```

#### 32-bit single-value register

This will be used everywhere in the chip that a temporary value should be stored. The register should be sensitive to all inputs. If `clock` is one, the value present at `in_val` should be copied to `out_val`. When `clock` goes to zero, the output value is frozen until `clock` goes high again.

Entity declaration:

```
entity dlx_register is
  port(
      in_val  : in dlx_word;
      clock   : in bit;
      out_val : out dlx_word
  );
```
### 2-way mux

Controlled by a one-bit signal from controller.

### 3-way mux

Controlled by a two-bit signal from controller.

### PC incrementer
Combinational logic that adds one (unsigned) to its (32-bit) input.

## Instruction Set

The opcode is always found in the high order 8 bits of an instruction word (bits 31 to 24). Some instructions are one dlx-word long, and some are two words long. In addition to the opcode, the first word may hold a number of register numbers for source and destination registers. The second word contains either a 32-bit immediate value for the load immediate (LDI) instruction or it holds an address for the store (STO), load (LD), jump (JMP), or jump-if-zero (JZ) instructions.

### ALU Instructions

1 dlx-word long (1 address)

FORMAT, word 1

|     Opcode    |      Dest     |      Op1      |      Op2      |    Not used   |
| ------------- | ------------- | ------------- | ------------- | ------------- |
|  Bits 31-24   |   Bits 23-19  |   Bits 18-14  |   Bits 13-9   |   Bits 8-0    |

Perform the operation on registers `op1` and `op2` and put the result in register `dest`.

Examples

```
ADDU R1,R2,R3     encodes as 0x00088300
NOTB R7,R8,R9     encodes as 0x0b3a1200
```

### STORE Instructions

2 dlx-words long, stored in 2 consecutive addresses in memory

FORMAT, word 1

|     Opcode    | Dest not used |      Op1      | Op2 not used  |    Not used   |
| ------------- | ------------- | ------------- | ------------- | ------------- |
|  Bits 31-24   |   Bits 23-19  |   Bits 18-14  |   Bits 13-9   |   Bits 8-0    |

word 2

|  Address                                                                      |
| ----------------------------------------------------------------------------- |
|  Bits 31-0                                                                    |

```
STO op1,address   0x20    put contents of reg op1 in memory specified by address (word 2 of instruction)
```

Example 

```
STO R2,0x12341234    encodes as 0x20008000, 0x12341234
```

### LOAD Instructions

2 dlx-words long, stored in 2 consecutive addresses in memory

FORMAT, word 1

|     Opcode    |      Dest     | Op1 not used  | Op2 not used  |    Not used   |
| ------------- | ------------- | ------------- | ------------- | ------------- |
|  Bits 31-24   |   Bits 23-19  |   Bits 18-14  |   Bits 13-9   |   Bits 8-0    |

word 2

|  Address                                                                      |
| ----------------------------------------------------------------------------- |
|  Bits 31-0                                                                    |

```
LD dest,address   0x30    load contents of `addr` to register `dest`

LDI dest,#imm     0x31    load value `imm` into reg. `dest`
```

Examples
```
LD  R5,0x00004412    encodes as 0x30280000,0x00004412
LDI R1,#0x12121212   encodes as 0x31080000,0x12121212
```

### Register Indirect Load and Store

These do load and store using the contents of a register to specify the address. For STOR, the dest register holds the address to which to store the contents of reg. op1. For LDR, the op1 reg holds the address to load the contents from into the dest register.

1 dlx word long

Format, word 1

|     Opcode    |      Dest     |      Op1      | Op2 not used  |    Not used   |
| ------------- | ------------- | ------------- | ------------- | ------------- |
|  Bits 31-24   |   Bits 23-19  |   Bits 18-14  |   Bits 13-9   |   Bits 8-0    |

```
STOR (dest),op1    0x22    put contents of reg op1 in address given by contents of dest reg
LDR  dest,(op1)    0x32    load contents of addr given by register op1 into reg. dest
```

Examples
```
STOR (R7),R8    encodes as 0x223a0000
LDR R11,(R12)   encodes as 0x325b0000
```

### JUMP Operations

Either unconditional (JMP) or condition (JZ) jump to an address given in the 2nd word of the instruction.

2 dlx words long, stored in two consecutive addresses in memory

Format, word1

|     Opcode    | Dest not used |      Op1      | Op2 not used  |    Not used   |
| ------------- | ------------- | ------------- | ------------- | ------------- |
|  Bits 31-24   |   Bits 23-19  |   Bits 18-14  |   Bits 13-9   |   Bits 8-0    |

word 2

|  Address                                                                      |
| ----------------------------------------------------------------------------- |
|  Bits 31-0                                                                    |

```
JMP addr         0x40   unconditional jump to addr
JZ  op1,addr     0x41   jump to addr if op1 == 0
```

Examples

```
JMP 0x11111111      encodes as 0x40000000,0x11111111
JZ  R7,0x22220000   encodes as 0x41380000,0x22220000
```

### Misc Operations

No Operation, 1 dlx word long

|  Opcode                               |                 Not Used              |
| --------------------------------------|-------------------------------------- |
|  Bits 31-24                           |                 Bits 23-0            |

```
NOOP   0x10   do nothing at all
```

Example

```
NOOP encodes as 0x10000000
```
