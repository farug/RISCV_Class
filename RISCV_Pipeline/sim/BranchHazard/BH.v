module BH_tb ;
    
    reg clk,reset,resetpc,we0;
    reg [8:0] wr_addr0;
    reg [31:0] wr_din0;
    
    Top_Module_Pipe TMP(.clk(clk),.reset(reset),.we0(we0),.resetpc(resetpc),
    .wr_addr0(wr_addr0),.wr_din0(wr_din0));

    reg [31:0] mem [127:0];

    integer i;

    initial begin
        $readmemh("C:/Users/omer/Documents/GitHub/RISCV_Class/RISCV_Pipeline/sim/BranchHazard/BH.hex",mem);
    end

    always begin
        clk = ~clk;
        #10;
    end

    initial begin
        clk = 1'b1;
    end


    initial begin
        
        reset = 1'b0;
        resetpc = 1'b0;
        we0 = 1'b0;
        wr_addr0 = 7'd0;
        wr_din0 = 'd0;
        #10;
        reset = 1'b1;
        we0 = 1'b1;
        for (i =0 ;i<10 ;i=i+1 ) begin
            we0 = 1'b1;
            wr_addr0 = 4*i;
            wr_din0 = mem[i];
            #20;
            we0=1'b0;
        end

        
        resetpc = 1'b1;
        we0 = 1'b0;
        #12145;
        $finish;
    end
endmodule