module lsu(
input logic [0:0] clk_i, rst_ni, st_en,
input logic [2:0] datamode,
input logic [31:0] sw_i,
input logic [31:0] lsu_addr, lsu_i,
output logic [31:0] lsu_o, lcd,
output logic [31:0] ledr, ledg,
output logic [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7
);

logic [0:0] dmem_wren, ledr_wren, ledg_wren, hex_wren, lcd_wren;
logic [13:0] dmem_addr;
logic [3:0] ledr_addr, ledg_addr, hex_addr, lcd_addr, sw_addr;
logic [31:0] dmem_o, sw_o; //ledr_o, ledg_o, hex_o, lcd_o;

assign dmem_addr = lsu_addr[13:2];
assign ledr_addr = lsu_addr[3:0];
assign ledg_addr = lsu_addr[3:0];
assign hex_addr = lsu_addr[3:0];
assign lcd_addr = lsu_addr[3:0];
assign sw_addr = lsu_addr[3:0];

lsu_dmem dmem(clk_i, dmem_wren, datamode, dmem_addr, lsu_i, dmem_o);
//lsu_rled rled(clk_i, rst_ni, ledr_wren, datamode, ledr_addr, lsu_i, ledr_o, ledr);
lsu_rled rled(clk_i, rst_ni, ledr_wren, datamode, ledr_addr, lsu_i, ledr);
//lsu_gled gled(clk_i, rst_ni, ledg_wren, datamode, ledg_addr, lsu_i, ledg_o, ledg);
lsu_gled gled(clk_i, rst_ni, ledg_wren, datamode, ledg_addr, lsu_i, ledg);
//lsu_hex sevenseg(clk_i, rst_ni, hex_wren, datamode, hex_addr, lsu_i, hex_o, hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7);
lsu_hex sevenseg(clk_i, rst_ni, hex_wren, datamode, hex_addr, lsu_i, hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7);
lsu_lcd lcddisp(clk_i, rst_ni, lcd_wren, datamode, lcd_addr, lsu_i, lcd);
lsu_sw sw(clk_i, rst_ni, sw_addr, sw_i, sw_o);


always_comb begin
if(st_en) begin
lsu_o = 0; //Set LSU output to 0 when write
case(lsu_addr[15:12])
4'h2,4'h3: begin //DMEM region: 0x2000 - 0x3FFF
dmem_wren = 1;
ledr_wren = 0;
ledg_wren = 0;
hex_wren = 0;
lcd_wren = 0;
end

4'h7: begin
casez(lsu_addr[11:0])
12'h00z: begin //Red LED
dmem_wren = 0;
ledr_wren = 1;
ledg_wren = 0;
hex_wren = 0;
lcd_wren = 0;
end
12'h01z: begin //Green LED
dmem_wren = 0;
ledr_wren = 0;
ledg_wren = 1;
hex_wren = 0;
lcd_wren = 0;
end
12'h02z: begin //7-segment
dmem_wren = 0;
ledr_wren = 0;
ledg_wren = 0;
hex_wren = 1;
lcd_wren = 0;
end
12'h03z: begin //LCD
dmem_wren = 0;
ledr_wren = 0;
ledg_wren = 0;
hex_wren = 0;
lcd_wren = 1;
end
default: begin //Null case
dmem_wren = 0;
ledr_wren = 0;
ledg_wren = 0;
hex_wren = 0;
lcd_wren = 0;
end
endcase
end

default: begin //Null case
dmem_wren = 0;
ledr_wren = 0;
ledg_wren = 0;
hex_wren = 0;
lcd_wren = 0;
end
endcase

end else begin //Read operation
dmem_wren = 0;
ledr_wren = 0;
ledg_wren = 0;
hex_wren = 0;
lcd_wren = 0;
case(lsu_addr[15:12])
4'h2,4'h3: begin //DMEM region: 0x2000 - 0x3FFF
lsu_o = dmem_o;
end

4'h7: begin
casez(lsu_addr[11:0])
12'h00z: begin //Red LED
//lsu_o = ledr_o;
lsu_o = ledr;
end
12'h01z: begin //Green LED
//lsu_o = ledg_o;
lsu_o = ledg;
end
//12'h02z: begin //7-segment
//lsu_o = hex_o;
//end
//12'h03z: begin //LCD
//lsu_o = lcd_o;
//end
12'h80z: begin //Switches
lsu_o = sw_o;
end
default: begin //Null case
lsu_o = 0;
end
endcase
end

default: begin //Null case
lsu_o = 0;
end
endcase
end
end
endmodule

