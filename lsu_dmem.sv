module lsu_dmem(
input logic [0:0] clk_i, st_en,
input logic [2:0] datamode,
input logic [13:0] addr,
input logic [31:0] data_in,
output logic [31:0] data_o
);

logic [7:0] mem [8192:16383];

initial mem = '{default: 8'h0};
always_ff @ (posedge clk_i) begin
if(st_en) begin
case(datamode)
3'd0: begin
mem[addr] <= data_in[7:0];
end
3'd1: begin
mem[addr] <= data_in[7:0];
mem[addr + 4'h1] <= data_in[15:8];
end
default: begin
mem[addr] <= data_in[7:0];
mem[addr + 4'h1] <= data_in[15:8];
mem[addr + 4'h2] <= data_in[23:16];
mem[addr + 4'h3] <= data_in[31:24];
end
endcase
end
end

always_comb begin
data_o = {mem[addr + 4'h3], mem[addr + 4'h2], mem[addr + 4'h1], mem[addr]};
end
endmodule
