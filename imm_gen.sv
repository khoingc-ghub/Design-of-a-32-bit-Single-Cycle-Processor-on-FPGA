module imm_gen(
input logic [31:0] instr,
output logic [31:0] imm
);

always_comb begin
case(instr[6:0])
7'b0010011: begin //I-type (Arithmetic)
if(instr[31]) imm = {20'hFFFFF, instr[31:20]};
else 			  imm = {20'd0,instr[31:20]};
end
7'b0000011: begin //I-type (Load)
if(instr[31]) imm = {20'hFFFFF, instr[31:20]};
else 			  imm = {20'd0,instr[31:20]};
end
7'b1100111: begin //I-type (JALR)
if(instr[31]) imm = {20'hFFFFF, instr[31:20]};
else 			  imm = {20'd0,instr[31:20]};
end
7'b0100011: begin //S-type
if(instr[31]) imm = {20'hFFFFF, instr[31:25], imm[11:7]};
else 			  imm = {20'd0, instr[31:25], imm[11:7]};
end
7'b1100011: begin //B-type
if(instr[31]) imm = {19'h7FFFF, instr[31], instr[7], instr[30:25], instr[11:8], 1'd0};
else 			  imm = {19'h0, instr[31], instr[7], instr[30:25], instr[11:8], 1'd0};
end
7'b1101111: begin //J-type
if(instr[31]) imm = {11'h7FF, instr[31], instr[19:12], instr[20], instr[30:25], instr[24:21], 1'b0};
else 			  imm = {11'h0, instr[31], instr[19:12], instr[20], instr[30:25], instr[24:21], 1'b0};
end
7'b0110111: imm = {instr[31:12], 12'h0}; //U-Type (LUI)
7'b0010111: imm = {instr[31:12], 12'h0}; //U-Type (AUIPC)
default: imm = 32'h0; //If none
endcase
end
endmodule