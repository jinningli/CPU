`include "defines.v"

module inst_rom(
	input wire ce,
	input wire[`InstAddrBus] addr,
	output reg[`InstBus] inst
);
	reg[`InstBus]  inst_mem[0:`InstMemNum-1];
	initial begin
//	inst_mem[0] = 32'h34010020;
//	inst_mem[1] = 32'h20210002;
//	inst_mem[2] = 32'h34211100;
//	inst_mem[3] = 32'h30210012;
//	inst_mem[4] = 32'h3821f012;
//	inst_mem[5] = 32'h34021001;
//	inst_mem[6] = 32'h00220822;
//	inst_mem[7] = 32'h340200ff;
//	inst_mem[8] = 32'h00410820;
//	inst_mem[9] = 32'h34020f00;
//	inst_mem[10] = 32'h00220824;
//	inst_mem[11] = 32'h3402f10f;
//	inst_mem[12] = 32'h00410826;
//	inst_mem[13] = 32'h2821f010;
//	inst_mem[14] = 32'h34020001;
//	inst_mem[15] = 32'h0022082a;
//	inst_mem[16] = 32'h3c02aabb;
//	inst_mem[17] = 32'h3442ccdd;
//	inst_mem[18] = 32'hac020008;
//	inst_mem[19] = 32'h00210826;
//	inst_mem[20] = 32'h34010008;
//	inst_mem[21] = 32'h80210000;
//	inst_mem[22] = 32'h342100f0;
//	inst_mem[23] = 32'ha0010008;
//	inst_mem[24] = 32'h8c010008;
//	inst_mem[25] = 32'h3403000a;
//	inst_mem[26] = 32'h34040001;
//	inst_mem[27] = 32'h00641822;
//	inst_mem[28] = 32'h1460fffe;
//	inst_mem[29] = 32'h00000000;
//	inst_mem[30] = 32'h08000000;
//	inst_mem[31] = 32'h00000000;
	$readmemh("inst_rom.data", inst_mem);
//	$readmemh("arithmetic.data", inst_mem);
//	$readmemh("br_jp.data", inst_mem);
//	$readmemh("ld_st.data", inst_mem);
//	$readmemh("logic.data", inst_mem);
//	$readmemh("set.data", inst_mem);
end
	always @ (*) begin
		if (ce == `Disable) begin
			inst <= `Zero32h;
	  end else begin
		  inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
		end
	end

endmodule
