module MEM_MEM_MUX (
    input [4:0] RS2,RD,
    input MW,MD,
    output FWD
);
    assign FWD = ((RS2==RD)&(MW==1'b1)&(MD==1'b1)) ? 1'b1 : 1'b0;    
endmodule