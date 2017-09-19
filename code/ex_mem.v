`include "defines.v"

module ex_mem(
	input	wire clk,
	input wire reset,

	input wire[5:0] stall,

	input wire[`RegAddrBus] ex_wd,
	input wire ex_wreg,
	input wire[`RegBus] ex_wdata,

  	input wire[`AluOpBus] ex_aluop,
	input wire[`RegBus] ex_mem_addr,
	input wire[`RegBus] ex_reg2,

	output reg[`RegAddrBus] mem_wd,
	output reg mem_wreg,
	output reg[`RegBus] mem_wdata,

  	output reg[`AluOpBus] mem_aluop,
	output reg[`RegBus] mem_mem_addr,
	output reg[`RegBus] mem_reg2
);

	always @ (posedge clk) begin
		if(reset == `Enable) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `Disable;
		  	mem_wdata <= `Zero32h;
  			mem_aluop <= `EXE_NOP_OP;
			mem_mem_addr <= `Zero32h;
			mem_reg2 <= `Zero32h;
		end else if(stall[3] == `Stop && stall[4] == `NotStop) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `Disable;
		  	mem_wdata <= `Zero32h;
  			mem_aluop <= `EXE_NOP_OP;
			mem_mem_addr <= `Zero32h;
			mem_reg2 <= `Zero32h;
		end else if(stall[3] == `NotStop) begin
			mem_wd <= ex_wd;
			mem_wreg <= ex_wreg;
			mem_wdata <= ex_wdata;
  			mem_aluop <= ex_aluop;
			mem_mem_addr <= ex_mem_addr;
			mem_reg2 <= ex_reg2;
		end
	end
endmodule
