`include "defines.v"
//Register 32 in total


module regfile(
	input wire clk,
	input wire reset,

	//write register
	input wire	we,     // write enable
	input wire[`RegAddrBus] waddr,     //write address
	input wire[`RegBus] wdata,     //date to write

	//read register
	input wire	re1,    //read enable
	input wire[`RegAddrBus] raddr1,
	output reg[`RegBus] rdata1,

	//read register 2
	input wire re2,    //read enable 2
	input wire[`RegAddrBus] raddr2,
	output reg[`RegBus] rdata2,

	output wire[`RegBus] prtregs1_o,
	output wire[`RegBus] prtregs2_o,
	output wire[`RegBus] prtregs3_o,
	output wire[`RegBus] prtregs4_o
);
	reg[`RegBus]  regs[0:`RegNum - 1];

	assign prtregs1_o = regs[1];
	assign prtregs2_o = regs[2];
	assign prtregs3_o = regs[3];
	assign prtregs4_o = regs[4];

	always @ (posedge clk) begin
		if (reset == `Disable) begin
			if((we == `Enable) && (waddr != `RegNumLog2'h0)) begin
				regs[waddr] <= wdata;
			end
		end
	end

	always @ (*) begin
		if(reset == `Enable) begin
			  rdata1 <= `Zero32h;
	  end else if(raddr1 == `RegNumLog2'h0) begin
	  		rdata1 <= `Zero32h;
	  end else if((raddr1 == waddr) && (we == `Enable)
	  	            && (re1 == `Enable)) begin
	  	  rdata1 <= wdata;
	  end else if(re1 == `Enable) begin
	      rdata1 <= regs[raddr1];
	  end else begin
	      rdata1 <= `Zero32h;
	  end
	end

	always @ (*) begin
		if(reset == `Enable) begin
			  rdata2 <= `Zero32h;
	  end else if(raddr2 == `RegNumLog2'h0) begin
	  		rdata2 <= `Zero32h;
	  end else if((raddr2 == waddr) && (we == `Enable)
	  	            && (re2 == `Enable)) begin
	  	  rdata2 <= wdata;
	  end else if(re2 == `Enable) begin
	      rdata2 <= regs[raddr2];
	  end else begin
	      rdata2 <= `Zero32h;
	  end
	end

endmodule
