module singlecycle(
input logic [31:0] i_io_sw,
output logic [31:0] o_io_lcd,
output logic [31:0] o_io_ledg,
output logic [31:0] o_io_ledr,
output logic [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
output logic [31:0] o_pc_debug,
output logic [0:0] o_insn_vld,
input logic [0:0] i_clk, i_rst
);

//PC wires
logic [31:0] pc, pc_next;
//IMEM wire
logic [31:0] instr;
//Regfile wires
logic [31:0] rs1_data, rs2_data;
//Immediate generator wire
logic [31:0] imm;
//ALU wire
logic [31:0] operand_a, operand_b, alu_data;
//LSU wires
logic [31:0] lsu_i, lsu_o, ld_data;
//WBMUX wire
logic [31:0] wb_data;
//Control unit wires
logic [0:0] br_less, br_equal, pc_sel, rd_wren, br_unsigned, op_a_sel, op_b_sel, mem_wren;
logic [1:0] wb_sel;
logic [3:0] alu_op;
//PC 
logic [0:0] instr_valid;

//Module zone
pc programcounter(i_clk, i_rst, 1'd1, pc_next, pc);
imem ins_memory(pc, instr);
regfile registers(i_clk, i_rst, rd_wren, instr[19:15], instr[24:20], instr[11:7], wb_data, rs1_data, rs2_data);
imm_gen immediate(instr, imm);
brcomp branch(rs1_data, rs2_data, br_unsigned, br_less, br_equal);
alu arith_logic(alu_op, operand_a, operand_b, alu_data);
lsu memory(i_clk, i_rst, mem_wren, instr[14:12], i_io_sw, alu_data, rs2_data, lsu_o, o_io_lcd, o_io_ledr, o_io_ledg, o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7);
lsu_mux concatenator(instr[14:12], lsu_o, ld_data);
ctrl_unit control(instr, br_less, br_equal, pc_sel, rd_wren, br_unsigned, op_a_sel, op_b_sel, mem_wren, wb_sel, alu_op, instr_valid);
//debug_reg debug(i_clk, instr_valid, pc, o_pc_debug, o_insn_vld);
vldreg ins(i_clk, i_rst, instr_valid, o_insn_vld); 
pcreg pcdebug(i_clk, i_rst, pc, o_pc_debug);

always_comb begin
//PC branch mux
case(pc_sel)
default: pc_next = pc + 32'd4;
1'd1: pc_next = alu_data;
endcase

//ALU operand mux
case(op_a_sel)
default: operand_a = rs1_data;
1'd1: operand_a = pc;
endcase

case(op_b_sel)
default: operand_b = rs2_data;
1'd1: operand_b = imm;
endcase

//Write back mux
case(wb_sel)
default: wb_data = alu_data;
2'd0: wb_data = ld_data;
2'd2: wb_data = pc + 32'd4;
endcase
end
endmodule
