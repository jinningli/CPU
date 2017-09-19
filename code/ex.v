`include "defines.v"

module ex(
	input wire reset,

	input wire[`AluOpBus] aluop_i,
	input wire[`AluTypeBus] alusel_i,
	input wire[`RegBus] reg1_i,
	input wire[`RegBus] reg2_i,
	input wire[`RegAddrBus] wd_i,
	input wire wreg_i,
	input wire[`RegBus] inst_i,

	input wire[`RegBus] link_address_i,
	input wire is_in_delayslot_i,

	output reg[`RegAddrBus] wd_o,
	output reg wreg_o,
	output reg[`RegBus] wdata_o,

	output wire[`AluOpBus] aluop_o,
	output wire[`RegBus] mem_addr_o,
	output wire[`RegBus] reg2_o,

	output reg stallreq

);

	reg[`RegBus] logicout;
	reg[`RegBus] arithmeticres;
	wire[`RegBus] reg2_i_mux;
	wire[`RegBus] reg1_i_not;
	wire[`RegBus] result_sum;
	wire ov_sum;
	wire reg1_lt_reg2;
	reg stallreq_for_madd_msub;

  assign aluop_o = aluop_i;

  assign mem_addr_o = reg1_i + {{16{inst_i[15]}},inst_i[15:0]};

  assign reg2_o = reg2_i;

	always @ (*) begin
		if(reset == `Enable) begin
			logicout <= `Zero32h;
		end else begin
			case (aluop_i)
				`EXE_OR_OP:			begin
					logicout <= reg1_i | reg2_i;
				end
				`EXE_AND_OP:		begin
					logicout <= reg1_i & reg2_i;
				end
				`EXE_XOR_OP:		begin
					logicout <= reg1_i ^ reg2_i;
				end
				default: begin
					logicout <= `Zero32h;
				end
			endcase
		end
	end

	assign reg2_i_mux = ((aluop_i == `EXE_SUB_OP) || (aluop_i == `EXE_SLT_OP) )
											 ? (~reg2_i)+1 : reg2_i;

	assign result_sum = reg1_i + reg2_i_mux;

	assign ov_sum = ((!reg1_i[31] && !reg2_i_mux[31]) && result_sum[31]) ||
									((reg1_i[31] && reg2_i_mux[31]) && (!result_sum[31]));

	assign reg1_lt_reg2 = ((aluop_i == `EXE_SLT_OP)) ?
												 ((reg1_i[31] && !reg2_i[31]) || (!reg1_i[31] && !reg2_i[31] && result_sum[31]) || (reg1_i[31] && reg2_i[31] && result_sum[31]))
			                                     :
			                                     (reg1_i < reg2_i);

  assign reg1_i_not = ~reg1_i;

	always @ (*) begin
		if(reset == `Enable) begin
			arithmeticres <= `Zero32h;
		end else begin
			case (aluop_i)
				`EXE_SLT_OP:		begin
					arithmeticres <= reg1_lt_reg2 ;
				end
				`EXE_ADD_OP, `EXE_ADDI_OP:		begin
					arithmeticres <= result_sum;
				end
				`EXE_SUB_OP: begin
					arithmeticres <= result_sum;
				end
				default: begin
					arithmeticres <= `Zero32h;
				end
			endcase
		end
	end

  always @ (*) begin
    stallreq = stallreq_for_madd_msub;
  end

 always @ (*) begin
	 wd_o <= wd_i;
	 if(((aluop_i == `EXE_ADD_OP) || (aluop_i == `EXE_ADDI_OP) ||
	      (aluop_i == `EXE_SUB_OP)) && (ov_sum == 1'b1)) begin
	 	wreg_o <= `Disable;
	 end else begin
	  wreg_o <= wreg_i;
	 end

	 case ( alusel_i )
	 	`EXE_RES_LOGIC:		begin
	 		wdata_o <= logicout;
	 	end
	 	`EXE_RES_ARITHMETIC:	begin
	 		wdata_o <= arithmeticres;
	 	end
	 	`EXE_RES_JUMP_BRANCH:	begin
	 		wdata_o <= link_address_i;
	 	end
	 	default:					begin
	 		wdata_o <= `Zero32h;
	 	end
	 endcase
 end

endmodule
