module lsu_hex(
input logic [0:0] clk_i, rst_ni, st_en,
input logic [2:0] datamode, //0: byte, 1: half-word, 2: word
input logic [3:0] addr,
input logic [31:0] data_in,
//output logic [31:0] data_o,
output logic [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7
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
hex0 = mem[4'h0];
hex1 = mem[4'h1];
hex2 = mem[4'h2];
hex3 = mem[4'h3];
hex4 = mem[4'h4];
hex5 = mem[4'h5];
hex6 = mem[4'h6];
hex7 = mem[4'h7];
end
endmodule
