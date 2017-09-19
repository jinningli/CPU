
`define Enable 1'b1
`define Disable 1'b0
`define Zero32h 32'h00000000
`define Zero6b 6'b000000
`define AluOpBus 7:0
`define AluTypeBus 2:0

`define InstValid 1'b0
`define InstInvalid 1'b1
`define Stop 1'b1
`define NotStop 1'b0

`define Delay 1'b1
`define NotDelay 1'b0

`define True 1'b1
`define False 1'b0

`define Branch 1'b1
`define NotBranch 1'b0

`define BIT4 3:0
`define BIT5 4:0
`define BIT6 5:0
`define BIT8 7:0
`define BIT16 15:0
`define BIT32 31:0

//ָOperator
`define EXE_AND  6'b100100
`define EXE_OR   6'b100101
`define EXE_XOR 6'b100110
`define EXE_ANDI 6'b001100
`define EXE_ORI  6'b001101
`define EXE_XORI 6'b001110
`define EXE_LUI 6'b001111

`define EXE_SLT  6'b101010

`define EXE_SLTI  6'b001010
`define EXE_ADD  6'b100000
`define EXE_SUB  6'b100010
`define EXE_ADDI  6'b001000


`define EXE_J  6'b000010
`define EXE_JR  6'b001000
`define EXE_BEQ  6'b000100
`define EXE_BNE  6'b000101

`define EXE_LB  6'b100000
`define EXE_LW  6'b100011
`define EXE_SB  6'b101000
`define EXE_SW  6'b101011


`define EXE_NOP 6'b000000
`define SSNOP 32'b00000000000000000000000001000000

`define EXE_SPECIAL_INST 6'b000000

//AluOp
`define EXE_AND_OP   8'b00100100
`define EXE_OR_OP    8'b00100101
`define EXE_XOR_OP  8'b00100110
`define EXE_ANDI_OP  8'b01011001
`define EXE_ORI_OP  8'b01011010
`define EXE_XORI_OP  8'b01011011
`define EXE_LUI_OP  8'b01011100

`define EXE_SLT_OP  8'b00101010
`define EXE_SLTI_OP  8'b0101011
`define EXE_ADD_OP  8'b00100000
`define EXE_SUB_OP  8'b00100010
`define EXE_ADDI_OP  8'b01010101

`define EXE_J_OP  8'b01001111
`define EXE_JR_OP  8'b00001000
`define EXE_BEQ_OP  8'b01010001
`define EXE_BNE_OP  8'b01010010

`define EXE_LB_OP  8'b11100000
`define EXE_LW_OP  8'b11100011
`define EXE_SB_OP  8'b11101000
`define EXE_SW_OP  8'b11101011

`define EXE_NOP_OP    8'b00000000

//AluSel
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_ARITHMETIC 3'b100
`define EXE_RES_ARITHMETIC 3'b100
`define EXE_RES_JUMP_BRANCH 3'b110
`define EXE_RES_LOAD_STORE 3'b111

`define EXE_RES_NOP 3'b000


//ָinst_rom
`define InstAddrBus 31:0
`define InstBus 31:0
`define InstMemNum 131071
`define InstMemNumLog2 17

//data_ram
`define DataAddrBus 31:0
`define DataBus 31:0
`define DataMemNum 131071
`define DataMemNumLog2 17
`define ByteWidth 7:0

//regfile
`define RegAddrBus 4:0
`define RegBus 31:0
`define RegWidth 32
`define DoubleRegWidth 64
`define DoubleRegBus 63:0
`define RegNum 32
`define RegNumLog2 5
`define NOPRegAddr 5'b00000
