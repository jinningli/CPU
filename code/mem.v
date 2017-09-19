
`include "defines.v"

module mem(

	input wire										reset,

	input wire[`RegAddrBus] wd_i,
	input wire wreg_i,
	input wire[`RegBus] wdata_i,
	input wire[`RegBus] hi_i,
	input wire[`RegBus] lo_i,
	input wire                    whilo_i,

  	input wire[`AluOpBus]        aluop_i,
	input wire[`RegBus]          mem_addr_i,
	input wire[`RegBus]          reg2_i,

	input wire[`RegBus]          mem_data_i,

	input wire LLbit_i,
	input wire                  wb_LLbit_we_i,
	input wire                  wb_LLbit_value_i,

	output reg[`RegAddrBus]      wd_o,
	output reg                   wreg_o,
	output reg[`RegBus]					 wdata_o,
	output reg[`RegBus]          hi_o,
	output reg[`RegBus]          lo_o,
	output reg                   whilo_o,

	output reg                   LLbit_we_o,
	output reg                   LLbit_value_o,

	output reg[`RegBus]          mem_addr_o,
	output wire									 mem_we_o,
	output reg[3:0]              mem_sel_o,
	output reg[`RegBus]          mem_data_o,
	output reg                   mem_ce_o

);

  reg LLbit;
	wire[`RegBus] zero32;
	reg                   mem_we;

	assign mem_we_o = mem_we ;
	assign zero32 = `Zero32h;

  //��ȡ���µ�LLbit��ֵ
	always @ (*) begin
		if(reset == `Enable) begin
			LLbit <= 1'b0;
		end else begin
			if(wb_LLbit_we_i == 1'b1) begin
				LLbit <= wb_LLbit_value_i;
			end else begin
				LLbit <= LLbit_i;
			end
		end
	end

	always @ (*) begin
		if(reset == `Enable) begin
			wd_o <= `NOPRegAddr;
			wreg_o <= `Disable;
		  wdata_o <= `Zero32h;
		  hi_o <= `Zero32h;
		  lo_o <= `Zero32h;
		  whilo_o <= `Disable;
		  mem_addr_o <= `Zero32h;
		  mem_we <= `Disable;
		  mem_sel_o <= 4'b0000;
		  mem_data_o <= `Zero32h;
		  mem_ce_o <= `Disable;
		  LLbit_we_o <= 1'b0;
		  LLbit_value_o <= 1'b0;
		end else begin
		  wd_o <= wd_i;
			wreg_o <= wreg_i;
			wdata_o <= wdata_i;
			hi_o <= hi_i;
			lo_o <= lo_i;
			whilo_o <= whilo_i;
			mem_we <= `Disable;
			mem_addr_o <= `Zero32h;
			mem_sel_o <= 4'b1111;
			mem_ce_o <= `Disable;
		  LLbit_we_o <= 1'b0;
		  LLbit_value_o <= 1'b0;
			case (aluop_i)
				`EXE_LB_OP:		begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `Disable;
					mem_ce_o <= `Enable;
					case (mem_addr_i[1:0])
						2'b00:	begin
							wdata_o <= {{24{mem_data_i[31]}},mem_data_i[31:24]};
							mem_sel_o <= 4'b1000;
						end
						2'b01:	begin
							wdata_o <= {{24{mem_data_i[23]}},mem_data_i[23:16]};
							mem_sel_o <= 4'b0100;
						end
						2'b10:	begin
							wdata_o <= {{24{mem_data_i[15]}},mem_data_i[15:8]};
							mem_sel_o <= 4'b0010;
						end
						2'b11:	begin
							wdata_o <= {{24{mem_data_i[7]}},mem_data_i[7:0]};
							mem_sel_o <= 4'b0001;
						end
						default:	begin
							wdata_o <= `Zero32h;
						end
					endcase
				end
				`EXE_LW_OP:		begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `Disable;
					wdata_o <= mem_data_i;
					mem_sel_o <= 4'b1111;
					mem_ce_o <= `Enable;
				end
				`EXE_SB_OP:		begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `Enable;
					mem_data_o <= {reg2_i[7:0],reg2_i[7:0],reg2_i[7:0],reg2_i[7:0]};
					mem_ce_o <= `Enable;
					case (mem_addr_i[1:0])
						2'b00:	begin
							mem_sel_o <= 4'b1000;
						end
						2'b01:	begin
							mem_sel_o <= 4'b0100;
						end
						2'b10:	begin
							mem_sel_o <= 4'b0010;
						end
						2'b11:	begin
							mem_sel_o <= 4'b0001;
						end
						default:	begin
							mem_sel_o <= 4'b0000;
						end
					endcase
				end
				`EXE_SW_OP:		begin
					mem_addr_o <= mem_addr_i;
					mem_we <= `Enable;
					mem_data_o <= reg2_i;
					mem_sel_o <= 4'b1111;
					mem_ce_o <= `Enable;
				end
				default:		begin
				end
			endcase
		end    //if
	end      //always


endmodule
