module lsu_sw(
input logic [0:0] clk_i, rst_ni,
input logic [3:0] addr,
input logic [31:0] sw_i,
output logic [31:0] sw_o
);

logic [7:0] mem [0:15];

initial mem = '{default: 8'h0};
always_ff @ (posedge clk_i or negedge rst_ni) begin
if(~rst_ni) mem <= '{default: 8'h0};
else begin
mem[4'h0] <= sw_i[7:0];
mem[4'h1] <= sw_i[15:8];
mem[4'h2] <= sw_i[23:16];
//mem[4'h2] <= 8'h0;
mem[4'h2] <= sw_i[31:24];
//mem[4'h3] <= 8'h0;
mem[4'h4] <= 8'h0;
mem[4'h5] <= 8'h0;
mem[4'h6] <= 8'h0;
mem[4'h7] <= 8'h0;
mem[4'h8] <= 8'h0;
mem[4'h9] <= 8'h0;
mem[4'hA] <= 8'h0;
mem[4'hB] <= 8'h0;
mem[4'hC] <= 8'h0;
mem[4'hD] <= 8'h0;
mem[4'hE] <= 8'h0;
mem[4'hF] <= 8'h0;
end
end

always_comb begin
sw_o = {mem[addr + 4'h3], mem[addr + 4'h2], mem[addr + 4'h1], mem[addr]};
end
endmodule
