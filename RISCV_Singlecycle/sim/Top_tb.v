module Top_tb ;

    reg clk,reset;

    riscv_singlecycle #(.DMemInitFile() , .IMemInitFile()) uut(.clk_i(clk),.rst_ni(reset));


    always  begin
        clk = ~clk;
        #10;
    end

    initial begin
        clk =1'b0;
    end

    initial begin
        reset = 1'b0;
        #1;
        reset =1'b1;
        #6270;
        $finish;
        
    end

endmodule