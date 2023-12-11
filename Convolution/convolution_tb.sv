`timescale 1ns / 1ps


module testbench;


    reg clk_i;
    reg rst_ni;
    reg valid_i;
    reg [7:0] pixel_i;
    wire valid_o;
    wire [7:0] pixel_o;

    convolution_ls uut(.clk_i(clk_i),.rst_ni(rst_ni),.valid_i(valid_i),
    .pixel_i(pixel_i),.valid_o(valid_o),.pixel_o(pixel_o));

      // Clock generation
    always begin
    #5 clk_i = ~clk_i;
    end

    initial begin
        clk_i = 1'b0;
    end

integer i;

    initial begin
        rst_ni = 1'b0;
        valid_i = 1'b0;
        pixel_i = 8'd0;
        #5;
        rst_ni = 1'b1;
        valid_i = 1'b1;
        pixel_i = 8'd20;
        #10;
        for(i=0;i<230401;i=i+1) begin
            rst_ni = 1'b1;
            valid_i = 1'b0;
            pixel_i = 8'd20+i%180;
            #10;
        end
        rst_ni = 1'b1;
        valid_i = 1'b0;
        pixel_i = 8'd0;
        #50000;
        $finish;
        
    end
endmodule