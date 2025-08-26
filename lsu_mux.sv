module lsu_mux(
input logic [2:0] lsu_select,
input logic [31:0] lsu_input,
output logic [31:0] ld_data
);

always_comb begin
//LSU bit xtender/reducer
case(lsu_select)
3'd0: begin //Load byte (LB)
if(lsu_input[7]) ld_data = {24'hFFFFFF, lsu_input[7:0]};
else ld_data = {24'h0, lsu_input[7:0]};
end
3'd1: begin //Load half-word (LH)
if(lsu_input[15]) ld_data = {16'hFFFF, lsu_input[15:0]};
else ld_data = {16'h0, lsu_input[15:0]};
end
3'd4: ld_data = {24'h0, lsu_input[7:0]}; //Load byte unsigned (LBU)
3'd5: ld_data = {16'h0, lsu_input[15:0]}; //Load half-word unsigned (LHU)
default: ld_data = lsu_input[31:0]; //Load word (LW) by default
endcase
end
endmodule