`include "defines.v"

module pc_reg(
	input wire clk,
	input wire reset,

	input wire[`BIT6] stall,

	input wire _branchFlag, //jump flag
	input wire[`RegBus] _branchTargetAddr,  //jump to where

	output reg[`InstAddrBus] pc,
	output reg ce
);

	always @ (posedge clk) begin
		if (ce == `Disable) begin
			pc <= 32'h00000000;
		end else if(stall[0] == `NotStop) begin
		//not stop because of hazard
		  	if(_branchFlag == `Branch) begin
					pc <= _branchTargetAddr; //if branch, jump to branch
				end else begin
		  		pc <= pc + 4'h4; //else, fetch pc normally
		  	end
		end
	end

	always @ (posedge clk) begin
		if (reset == `Enable) begin
			ce <= `Disable;
		end else begin
			ce <= `Enable;
		end
	end

endmodule
