module pc(
input logic [0:0] clk_i, i_rst, write_en,
input logic [31:0] data_i,
output logic [31:0] data_o
);

logic [31:0] pc_reg;
always_ff @ (posedge clk_i or negedge i_rst) begin
if(~i_rst) pc_reg <= 32'd0;
else begin
if(write_en) pc_reg <= data_i;
end
end

always_comb begin
data_o = pc_reg;
end
endmodule


