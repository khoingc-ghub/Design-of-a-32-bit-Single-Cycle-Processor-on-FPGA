module debug_reg(
    input logic clk_i,
    input logic valid_inst,
    input logic [31:0] pc,
    output logic [31:0] pc_o,
    output logic valid_inst_o
);

    logic [31:0] pc_reg;
    logic valid_inst_reg;

    // Always_ff block for clock-triggered assignments
    always_ff @ (posedge clk_i or negedge clk_i) begin
        if (!clk_i) begin
            pc_reg <= 32'h0;           // Reset value on negative edge (optional)
            valid_inst_reg <= 1'b0;    // Reset value on negative edge (optional)
        end else begin
            pc_reg <= pc;
            valid_inst_reg <= valid_inst;
        end
    end

    // Assign outputs
    always_comb begin
        pc_o = pc_reg;
        valid_inst_o = valid_inst_reg;
    end
endmodule
