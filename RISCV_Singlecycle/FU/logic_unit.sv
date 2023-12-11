`timescale 1ns / 1ps

module logic_unit (
    input [1:0] LS,
    input [31:0] A,B,
    output logic [31:0] S
);

always_comb begin
    case (LS)
        2'b00: S = A^B;
        2'b11: S = A&B; 
        2'b10: S = A|B;
    endcase
end
    
endmodule