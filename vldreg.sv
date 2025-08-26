module vldreg(

input logic i_clk,
input logic i_rst_n,
input logic insn_vld,
output logic o_insn_vld
);

always @(posedge i_clk) begin 
	o_insn_vld <= insn_vld;
	end
endmodule
