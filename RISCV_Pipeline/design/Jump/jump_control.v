module jump_control (
    input [6:0] opcode,
    output reset
);

    assign reset = (opcode == 7'b1101111) ? 1'b0 : (opcode == 7'b1100111) ? 1'b0 : 1'b1;

endmodule