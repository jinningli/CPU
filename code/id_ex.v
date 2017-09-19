`include "defines.v"

module id_ex(

	input wire clk,
	input wire reset,

	input wire[`BIT6] stall,

	input wire[`AluOpBus] id_aluop,
	input wire[`AluTypeBus] id_alusel,
	input wire[`RegBus] id_reg1,
	input wire[`RegBus] id_reg2,
	input wire[`RegAddrBus] id_wd,
	input wire id_wreg,
	input wire[`RegBus] id_link_address,
	input wire id_is_in_delayslot,
	input wire next_inst_in_delayslot_i,
	input wire[`RegBus] id_inst,

	output reg[`AluOpBus] ex_aluop,
	output reg[`AluTypeBus] ex_alusel,
	output reg[`RegBus] ex_reg1,
	output reg[`RegBus] ex_reg2,
	output reg[`RegAddrBus] ex_wd,
	output reg ex_wreg,
	output reg[`RegBus] ex_link_address,
   output reg ex_is_in_delayslot,
	output reg is_in_delayslot_o,
	output reg[`RegBus] ex_inst

);

	always @ (posedge clk) begin
		if (reset == `Enable) begin
			ex_aluop <= `EXE_NOP_OP;
			ex_alusel <= `EXE_RES_NOP;
			ex_reg1 <= `Zero32h;
			ex_reg2 <= `Zero32h;
			ex_wd <= `NOPRegAddr;
			ex_wreg <= `Disable;
			ex_link_address <= `Zero32h;
			ex_is_in_delayslot <= `NotDelay;
	    is_in_delayslot_o <= `NotDelay;
	    ex_inst <= `Zero32h;
		end else if(stall[2] == `Stop && stall[3] == `NotStop) begin
			ex_aluop <= `EXE_NOP_OP;
			ex_alusel <= `EXE_RES_NOP;
			ex_reg1 <= `Zero32h;
			ex_reg2 <= `Zero32h;
			ex_wd <= `NOPRegAddr;
			ex_wreg <= `Disable;
			ex_link_address <= `Zero32h;
	    ex_is_in_delayslot <= `NotDelay;
	    ex_inst <= `Zero32h;
		end else if(stall[2] == `NotStop) begin
			ex_aluop <= id_aluop;
			ex_alusel <= id_alusel;
			ex_reg1 <= id_reg1;
			ex_reg2 <= id_reg2;
			ex_wd <= id_wd;
			ex_wreg <= id_wreg;
			ex_link_address <= id_link_address;
			ex_is_in_delayslot <= id_is_in_delayslot;
	    is_in_delayslot_o <= next_inst_in_delayslot_i;
	    ex_inst <= id_inst;
		end
	end

endmodule
