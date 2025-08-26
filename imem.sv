module imem(
input logic [31:0] imem_addr,
output logic [31:0] imem_data
);

logic [31:0] imem [0:2047];
initial $readmemh ("/earth/class/comparch/ee4423/ca218/Desktop/singlecycle-test/02_test/dump/mem.dump", imem);

always_comb begin
imem_data = imem[imem_addr[12:2]];
end
endmodule
