`include "defines.v"

module mem_wb(

	input	wire clk,
	input wire reset,

	input wire[`BIT6] stall,

	input wire[`RegAddrBus] mem_wd,
	input wire mem_wreg,
	input wire[`RegBus] mem_wdata,
	input wire[`RegBus] mem_hi,
	input wire[`RegBus] mem_lo,
	input wire mem_whilo,

	input wire mem_LLbit_we,
	input wire mem_LLbit_value,

	output reg[`RegAddrBus] wb_wd,
	output reg wb_wreg,
	output reg[`RegBus] wb_wdata,
	output reg[`RegBus] wb_hi,
	output reg[`RegBus] wb_lo,
	output reg wb_whilo,

	output reg wb_LLbit_we,
	output reg wb_LLbit_value
);
	always @ (posedge clk) begin
		if(reset == `Enable) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `Disable;
		  wb_wdata <= `Zero32h;
		  wb_hi <= `Zero32h;
		  wb_lo <= `Zero32h;
		  wb_whilo <= `Disable;
		  wb_LLbit_we <= 1'b0;
		  wb_LLbit_value <= 1'b0;
		end else if(stall[4] == `Stop && stall[5] == `NotStop) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `Disable;
		  wb_wdata <= `Zero32h;
		  wb_hi <= `Zero32h;
		  wb_lo <= `Zero32h;
		  wb_whilo <= `Disable;
		  wb_LLbit_we <= 1'b0;
		  wb_LLbit_value <= 1'b0;
		end else if(stall[4] == `NotStop) begin
			wb_wd <= mem_wd;
			wb_wreg <= mem_wreg;
			wb_wdata <= mem_wdata;
			wb_hi <= mem_hi;
			wb_lo <= mem_lo;
			wb_whilo <= mem_whilo;
		  wb_LLbit_we <= mem_LLbit_we;
		  wb_LLbit_value <= mem_LLbit_value;
		end
	end
endmodule
