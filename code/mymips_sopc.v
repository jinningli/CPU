
`include "defines.v"

module mymips_sopc(
	input	wire clk,
	input wire reset,
	output wire[`RegBus] prtregs1_o,
	output wire[`RegBus] prtregs2_o,
	output wire[`RegBus] prtregs3_o,
	output wire[`RegBus] prtregs4_o
);

  wire[`InstAddrBus] inst_addr;
  wire[`InstBus] inst;
  wire rom_ce;
  wire mem_we_i;
  wire[`RegBus] mem_addr_i;
  wire[`RegBus] mem_data_i;
  wire[`RegBus] mem_data_o;
  wire[3:0] mem_sel_i;
  wire mem_ce_i;


 mips mips0(
		.clk(clk),
		.reset(reset),

		.rom_addr_o(inst_addr),
		.rom_data_i(inst),
		.rom_ce_o(rom_ce),

		.ram_we_o(mem_we_i),
		.ram_addr_o(mem_addr_i),
		.ram_sel_o(mem_sel_i),
		.ram_data_o(mem_data_i),
		.ram_data_i(mem_data_o),
		.ram_ce_o(mem_ce_i),
		.prtregs1(prtregs1_o),
		.prtregs2(prtregs2_o),
		.prtregs3(prtregs3_o),
		.prtregs4(prtregs4_o)
	);

	inst_rom inst_rom0(
		.ce(rom_ce),
		.addr(inst_addr),
		.inst(inst)
	);

	data_ram data_ram0(
		.clk(clk),
		.ce(mem_ce_i),
		.we(mem_we_i),
		.addr(mem_addr_i),
		.sel(mem_sel_i),
		.data_i(mem_data_i),
		.data_o(mem_data_o)
	);

endmodule
