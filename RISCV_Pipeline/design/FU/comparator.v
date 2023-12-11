`timescale 1ns / 1ps

module comparator (
    input [31:0] A,B,
    output L
);

    wire [31:0] a,b,c,fi,gi,hi;


    first f31(.A(A[31]),.B(B[31]),.a(a[31]),.b(b[31]),.c(c[31]));
    second g31(.a(a[31]),.b(b[31]),.c(c[31]),.fif(1'b0),.gif(1'b1),.hif(1'b0),.fi(fi[31]),.gi(gi[31]),.hi(hi[31]));

    genvar i;
    generate
        for (i=31 ;i>0 ;i=i-1 ) begin
            first fik(.A(A[i-1]),.B(B[i-1]),.a(a[i-1]),.b(b[i-1]),.c(c[i-1]));
            second gik(.a(a[i-1]),.b(b[i-1]),.c(c[i-1]),.fif(fi[i]),.gif(gi[i]),.hif(hi[i]),.fi(fi[i-1]),.gi(gi[i-1]),.hi(hi[i-1]));
        end
    endgenerate

    assign L = hi[0];


endmodule


module first (
    input A,B,
    output a,b,c
);
    assign a = (~B)&(A);
    assign b = (~A)&(B);
    assign c = ~(a^b);
endmodule

module second (
    input a,b,c,fif,gif,hif,
    output fi,gi,hi
);
    assign fi = (a&gif)^fif;
    assign gi = gif&c;
    assign hi = (b&gif)^hif;
endmodule