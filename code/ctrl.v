`include "defines.v"

module ctrl(
	input wire reset,
	input wire IDStallRequest,
	input wire EXStallRequest,
	output reg[`BIT6] stall
);
	integer i;
	always @ (*) begin
		if(reset == `Enable) begin
			stall <= `Zero6b;
		end else if(EXStallRequest == `Stop) begin
			for(i = 0; i < 4; i = i + 1) begin
				stall[i] = `True;
			end
		end else if(IDStallRequest == `Stop) begin
			for(i = 0; i < 3; i = i + 1) begin
				stall[i] = `True;
			end
		end else begin
			stall <= `Zero6b;
		end
	end
endmodule
