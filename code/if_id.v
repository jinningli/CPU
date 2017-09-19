`include "defines.v"

module if_id(
	input wire clk,
	input wire reset,

	input wire[5:0] stall,

	input wire[`InstAddrBus] _pc,
	input wire[`InstBus] _inst,
	output reg[`InstAddrBus] pc_,
	output reg[`InstBus] inst_
);

	always @ (posedge clk) begin
		if (reset == `Enable) begin
			pc_ <= `Zero32h;
			inst_ <= `Zero32h;
		end else if(stall[1] == `Stop && stall[2] == `NotStop) begin
			pc_ <= `Zero32h;
			inst_ <= `Zero32h;
	  end else if(stall[1] == `NotStop) begin
		  pc_ <= _pc;
		  inst_ <= _inst;
		end
	end

endmodule
