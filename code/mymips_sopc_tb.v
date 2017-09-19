
//`include "defines.v"
//`timescale 1ns/1ps

//module mymips_sopc_tb(
//    input CLK,
//     output wire[`RegBus] prtregs1,
//	output wire[`RegBus] prtregs2,
//	output wire[`RegBus] prtregs3,
//	output wire[`RegBus] prtregs4
//);

//  reg     CLOCK_50;
//  reg     reset;
//  reg[19:0] cnt = 0;

//  initial begin
//    CLOCK_50 = 1'b0;
//    forever if(cnt % 10 == 0) CLOCK_50 = ~CLOCK_50;
//  end

//  initial begin
//    reset = `Enable;
//    if(cnt == 195) reset= `Disable;
//    if(cnt == 5000) $stop;
//  end

//  always @(posedge CLK)begin
//          cnt = cnt + 1;
//  end

//  mymips_sopc mymips_sopc0(
//		.clk(CLOCK_50),
//		.reset(reset),
//            .prtregs1_o(prtregs1),
//            .prtregs2_o(prtregs2),
//            .prtregs3_o(prtregs3),
//            .prtregs4_o(prtregs4)
//	);

//endmodule



`include "defines.v"
`timescale 1ns/1ps

module mymips_sopc_tb(
      output wire[`RegBus] prtregs1,
	output wire[`RegBus] prtregs2,
	output wire[`RegBus] prtregs3,
	output wire[`RegBus] prtregs4
);

  reg     CLOCK_50;
  reg     reset;


  initial begin
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
  end

  initial begin
    reset = `Enable;
    #195 reset= `Disable;
    #5000 $stop;
  end

  mymips_sopc mymips_sopc0(
		.clk(CLOCK_50),
		.reset(reset),
            .prtregs1_o(prtregs1),
            .prtregs2_o(prtregs2),
            .prtregs3_o(prtregs3),
            .prtregs4_o(prtregs4)
	);

endmodule
