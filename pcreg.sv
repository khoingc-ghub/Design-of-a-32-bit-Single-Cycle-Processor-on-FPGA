module pcreg(
	input logic i_clk,
	input logic i_rst,
	input logic [31:0] pc_debug,
	output logic [31:0] o_pc_debug
);

always @(posedge i_clk) begin
	if (!i_rst) o_pc_debug <= 32'h00000000;
	else o_pc_debug <= pc_debug;
	end
endmodule
