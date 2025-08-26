module lsu_lcd(
input logic [0:0] clk_i, rst_ni, st_en,
input logic [2:0] datamode, //0: byte, 1: half-word, 2: word
input logic [3:0] addr,
input logic [31:0] data_in,
//output logic [31:0] data_o, lcd
output logic [31:0] data_o
);

logic [7:0] mem [0:15];

initial mem = '{default: 8'h0};
always_ff @ (posedge clk_i or negedge rst_ni) begin
if(~rst_ni) mem = '{default: 8'h0};
else if(st_en) begin
case(datamode)
3'd0: begin //Write Byte
mem[addr] <= data_in[7:0];
end
3'd1: begin //Write Half-Word
mem[addr] <= data_in[7:0];
mem[addr + 4'h1] <= data_in[15:8];
end
default: begin //Write Word
mem[addr] <= data_in[7:0];
mem[addr + 4'h1] <= data_in[15:8];
mem[addr + 4'h2] <= data_in[23:16];
mem[addr + 4'h3] <= data_in[31:24];
end
endcase
end
end

always_comb begin
//data_o = {mem[addr + 4'h3], mem[addr + 4'h2], mem[addr + 4'h1], mem[addr]};
//lcd = {mem[4'h3], mem[4'h2], mem[4'h1], mem[4'h0]};
data_o = {mem[4'h3], mem[4'h2], mem[4'h1], mem[4'h0]};
end
endmodule
