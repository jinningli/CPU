`include "defines.v"

module mips(

	input	wire clk,
	input wire reset,


	input wire[`RegBus] rom_data_i,
	output wire[`RegBus] rom_addr_o,
	output wire rom_ce_o,

	input wire[`RegBus] ram_data_i,
	output wire[`RegBus] ram_addr_o,
	output wire[`RegBus] ram_data_o,
	output wire ram_we_o,
	output wire[3:0] ram_sel_o,
	output wire[3:0] ram_ce_o,

	output wire[`RegBus] prtregs1,
	output wire[`RegBus] prtregs2,
	output wire[`RegBus] prtregs3,
	output wire[`RegBus] prtregs4
);

	wire[`InstAddrBus] pc;
	wire[`InstAddrBus] id_pc_i;
	wire[`InstBus] id_inst_i;

	wire[`AluOpBus] id_aluop_o;
	wire[`AluTypeBus] id_alusel_o;
	wire[`RegBus] id_reg1_o;
	wire[`RegBus] id_reg2_o;
	wire id_wreg_o;
	wire[`RegAddrBus] id_wd_o;
	wire id_is_in_delayslot_o;
  	wire[`RegBus] id_link_address_o;
  	wire[`RegBus] id_inst_o;

	wire[`AluOpBus] ex_aluop_i;
	wire[`AluTypeBus] ex_alusel_i;
	wire[`RegBus] ex_reg1_i;
	wire[`RegBus] ex_reg2_i;
	wire ex_wreg_i;
	wire[`RegAddrBus] ex_wd_i;
	wire ex_is_in_delayslot_i;
  	wire[`RegBus] ex_link_address_i;
  	wire[`RegBus] ex_inst_i;

	wire ex_wreg_o;
	wire[`RegAddrBus] ex_wd_o;
	wire[`RegBus] ex_wdata_o;
	wire[`AluOpBus] ex_aluop_o;
	wire[`RegBus] ex_mem_addr_o;
	wire[`RegBus] ex_reg1_o;
	wire[`RegBus] ex_reg2_o;

	wire mem_wreg_i;
	wire[`RegAddrBus] mem_wd_i;
	wire[`RegBus] mem_wdata_i;
	wire[`AluOpBus] mem_aluop_i;
	wire[`RegBus] mem_mem_addr_i;
	wire[`RegBus] mem_reg1_i;
	wire[`RegBus] mem_reg2_i;

	wire mem_wreg_o;
	wire[`RegAddrBus] mem_wd_o;
	wire[`RegBus] mem_wdata_o;

	wire wb_wreg_i;
	wire[`RegAddrBus] wb_wd_i;
	wire[`RegBus] wb_wdata_i;

  	wire reg1_read;
  	wire reg2_read;
  	wire[`RegBus] reg1_data;
  	wire[`RegBus] reg2_data;
  	wire[`RegAddrBus] reg1_addr;
  	wire[`RegAddrBus] reg2_addr;
	// wire[`RegBus] reg2print[0:`RegNum - 1]
	// wire[`RegBus] reg2print1,
	// wire[`RegBus] reg2print2,
	// wire[`RegBus] reg2print3,
	// wire[`RegBus] reg2print4

	wire is_in_delayslot_i;
	wire is_in_delayslot_o;
	wire next_inst_in_delayslot_o;
	wire id_branch_flag_o;
	wire[`RegBus] branch_target_address;

	wire[5:0] stall;
	wire IDStallRequest;
	wire EXStallRequest;

	pc_reg pc_reg0(
		.clk(clk),
		.reset(reset),
		.stall(stall),
		._branchFlag(id_branch_flag_o),
		._branchTargetAddr(branch_target_address),
		.pc(pc),
		.ce(rom_ce_o)
	);

  assign rom_addr_o = pc;

	if_id if_id0(
		.clk(clk),
		.reset(reset),
		.stall(stall),
		._pc(pc),
		._inst(rom_data_i),
		.pc_(id_pc_i),
		.inst_(id_inst_i)
	);

	id id0(
		.reset(reset),
		.pc_i(id_pc_i),
		.inst_i(id_inst_i),

  		.ex_aluop_i(ex_aluop_o),
		.reg1_data_i(reg1_data),
		.reg2_data_i(reg2_data),

		.ex_wreg_i(ex_wreg_o),
		.ex_wdata_i(ex_wdata_o),
		.ex_wd_i(ex_wd_o),

		.mem_wreg_i(mem_wreg_o),
		.mem_wdata_i(mem_wdata_o),
		.mem_wd_i(mem_wd_o),

	  	.is_in_delayslot_i(is_in_delayslot_i),

		.reg1_read_o(reg1_read),
		.reg2_read_o(reg2_read),
		.reg1_addr_o(reg1_addr),
		.reg2_addr_o(reg2_addr),

		.aluop_o(id_aluop_o),
		.alusel_o(id_alusel_o),
		.reg1_o(id_reg1_o),
		.reg2_o(id_reg2_o),
		.wd_o(id_wd_o),
		.wreg_o(id_wreg_o),
		.inst_o(id_inst_o),

	 	.next_inst_in_delayslot_o(next_inst_in_delayslot_o),
		.branch_flag_o(id_branch_flag_o),
		.branch_target_address_o(branch_target_address),
		.link_addr_o(id_link_address_o),

		.is_in_delayslot_o(id_is_in_delayslot_o),

		.stallreq(IDStallRequest)
	);

	regfile regfile1(
		.clk (clk),
		.reset (reset),
		.we	(wb_wreg_i),
		.waddr (wb_wd_i),
		.wdata (wb_wdata_i),
		.re1 (reg1_read),
		.raddr1 (reg1_addr),
		.rdata1 (reg1_data),
		.re2 (reg2_read),
		.raddr2 (reg2_addr),
		.rdata2 (reg2_data),
		.prtregs1_o(prtregs1),
		.prtregs2_o(prtregs2),
		.prtregs3_o(prtregs3),
		.prtregs4_o(prtregs4)
	);

	id_ex id_ex0(
		.clk(clk),
		.reset(reset),

		.stall(stall),

		.id_aluop(id_aluop_o),
		.id_alusel(id_alusel_o),
		.id_reg1(id_reg1_o),
		.id_reg2(id_reg2_o),
		.id_wd(id_wd_o),
		.id_wreg(id_wreg_o),
		.id_link_address(id_link_address_o),
		.id_is_in_delayslot(id_is_in_delayslot_o),
		.next_inst_in_delayslot_i(next_inst_in_delayslot_o),
		.id_inst(id_inst_o),

		.ex_aluop(ex_aluop_i),
		.ex_alusel(ex_alusel_i),
		.ex_reg1(ex_reg1_i),
		.ex_reg2(ex_reg2_i),
		.ex_wd(ex_wd_i),
		.ex_wreg(ex_wreg_i),
		.ex_link_address(ex_link_address_i),
  		.ex_is_in_delayslot(ex_is_in_delayslot_i),
		.is_in_delayslot_o(is_in_delayslot_i),
		.ex_inst(ex_inst_i)
	);

	ex ex0(
		.reset(reset),

		.aluop_i(ex_aluop_i),
		.alusel_i(ex_alusel_i),
		.reg1_i(ex_reg1_i),
		.reg2_i(ex_reg2_i),
		.wd_i(ex_wd_i),
		.wreg_i(ex_wreg_i),
		.inst_i(ex_inst_i),

	  	.link_address_i(ex_link_address_i),
		.is_in_delayslot_i(ex_is_in_delayslot_i),

		.wd_o(ex_wd_o),
		.wreg_o(ex_wreg_o),
		.wdata_o(ex_wdata_o),

		.aluop_o(ex_aluop_o),
		.mem_addr_o(ex_mem_addr_o),
		.reg2_o(ex_reg2_o),

		.stallreq(EXStallRequest)

	);

  ex_mem ex_mem0(
		.clk(clk),
		.reset(reset),
 		.stall(stall),

		.ex_wd(ex_wd_o),
		.ex_wreg(ex_wreg_o),
		.ex_wdata(ex_wdata_o),
  		.ex_aluop(ex_aluop_o),
		.ex_mem_addr(ex_mem_addr_o),
		.ex_reg2(ex_reg2_o),

		.mem_wd(mem_wd_i),
		.mem_wreg(mem_wreg_i),
		.mem_wdata(mem_wdata_i),
  		.mem_aluop(mem_aluop_i),
		.mem_mem_addr(mem_mem_addr_i),
		.mem_reg2(mem_reg2_i)
	);

	mem mem0(
		.reset(reset),

		.wd_i(mem_wd_i),
		.wreg_i(mem_wreg_i),
		.wdata_i(mem_wdata_i),
  		.aluop_i(mem_aluop_i),
		.mem_addr_i(mem_mem_addr_i),
		.reg2_i(mem_reg2_i),
		.mem_data_i(ram_data_i),
		.wd_o(mem_wd_o),
		.wreg_o(mem_wreg_o),
		.wdata_o(mem_wdata_o),
		.mem_addr_o(ram_addr_o),
		.mem_we_o(ram_we_o),
		.mem_sel_o(ram_sel_o),
		.mem_data_o(ram_data_o),
		.mem_ce_o(ram_ce_o)
	);

	mem_wb mem_wb0(
		.clk(clk),
		.reset(reset),
    		.stall(stall),

		.mem_wd(mem_wd_o),
		.mem_wreg(mem_wreg_o),
		.mem_wdata(mem_wdata_o),

		.wb_wd(wb_wd_i),
		.wb_wreg(wb_wreg_i),
		.wb_wdata(wb_wdata_i)
	);

	ctrl ctrl0(
		.reset(reset),
		.IDStallRequest(IDStallRequest),
		.EXStallRequest(EXStallRequest),
		.stall(stall)
	);

endmodule
