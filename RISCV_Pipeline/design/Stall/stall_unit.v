module stall_unit (
    input [4:0] RD,RS1,RS2,
    input MD,
    output reset
);
    assign reset = (MD&((RS1==RD)|(RS2==RD))) ? 1'b1 : 1'b0;
endmodule