`timescale 1ns / 1ps
module Data_mem_tb #(Depth = 128 , Width = 32, DMemInitFile="/home/omer/Desktop/Dersler-git/Dersler/MTH-RISCV/RISCV/FilesToRead/Data.mem")();
    
    // IO signals for module
    logic clk_i,rst_ni;
    logic we0_tb;
    logic [Width-1:0] wr_din0_tb;
    logic [(Width/8)-1:0] wr_strb_tb,rd_strb_tb;
    logic [$clog2(Depth)-1:0] rd_addr0_tb,wr_addr0_tb;
    wire  [Width-1:0] rd_dout0_tb;

    //Test memory
    logic [Width-1:0] mem_test [Depth-1:0];

    //Variable for loops
    int i;

    Data_mem #(.Depth(Depth),.Width(Width),.DMemInitFile(DMemInitFile)) uut (.clk(clk_i),.reset(rst_ni),.we0(we0_tb),.wr_din0(wr_din0_tb),
    .wr_strb(wr_strb_tb),.rd_strb(rd_strb_tb),.rd_addr0(rd_addr0_tb),.wr_addr0(wr_addr0_tb),.rd_dout0(rd_dout0_tb));

    // variable for file operation
    int fd;
    // Generating the clock
    always begin
        clk_i = ~clk_i;
        #5;
    end
    initial begin
        clk_i = 1'b1;
    end

    //Testbench
    initial begin
        $readmemh(DMemInitFile,mem_test);
        fd = $fopen("/home/omer/Desktop/Dersler-git/Dersler/MTH-RISCV/RISCV/logs/DataMemory.log","w");

        rst_ni = 1'b0;
        we0_tb= 1'b0;
        wr_din0_tb ='d0;
        wr_strb_tb = 'd0;
        rd_addr0_tb = 'd0;
        wr_addr0_tb = 'd0;
        rd_strb_tb = 'd0;
        #10;
        rst_ni = 1'b1;

        // Testing for LB instruction


        // testing the read for strb=0001
        $fwrite(fd,"  STRB = 0001 \n\n");
        rd_strb_tb = 4'b0001;
        for (i =0 ;i<Depth ;i=i+1 ) begin
            rd_addr0_tb = i;
            #5;
            $fwrite(fd,"Expected value is = %d, The result is = %d",{24'd0,mem_test[i][7:0]}, rd_dout0_tb);
            if ({24'd0,mem_test[i][7:0]} == rd_dout0_tb) begin
                $fdisplay(fd,"  True  for %d" , i);
            end
            else begin
                $fdisplay(fd,"  False for %d ", i);
            end
            $fdisplay(fd,"\n--------------------------");
            #5;
        end

        // testing the read for strb=0010
        $fwrite(fd,"  STRB = 0010 \n\n");
        rd_strb_tb = 4'b0010;
        for (i =0 ;i<Depth ;i=i+1 ) begin
            rd_addr0_tb = i;
            #5;
            $fwrite(fd,"Expected value is = %d, The result is = %d",{16'd0,mem_test[i][7:0],8'd0}, rd_dout0_tb);
            if ({16'd0,mem_test[i][15:8],8'd0} == rd_dout0_tb) begin
                $fdisplay(fd,"  True  for %d" , i);
            end
            else begin
                $fdisplay(fd,"  False for %d ", i);
            end
            $fdisplay(fd,"\n--------------------------");
            #5;
        end

        // testing the read for strb=0100
        $fwrite(fd,"  STRB = 0100 \n\n");
        rd_strb_tb = 4'b0100;
        for (i =0 ;i<Depth ;i=i+1 ) begin
            rd_addr0_tb = i;
            #5;
            $fwrite(fd,"Expected value is = %d, The result is = %d",{8'd0,mem_test[i][23:16],16'd0}, rd_dout0_tb);
            if ({8'd0,mem_test[i][23:16],16'd0} == rd_dout0_tb) begin
                $fdisplay(fd,"  True  for %d" , i);
            end
            else begin
                $fdisplay(fd,"  False for %d ", i);
            end
            $fdisplay(fd,"\n--------------------------");
            #5;
        end

        // testing the read for strb=1000
        $fwrite(fd,"STRB = 1000 \n\n");
        rd_strb_tb = 4'b1000;
        for (i =0 ;i<Depth ;i=i+1 ) begin
            rd_addr0_tb = i;
            #5;
            $fwrite(fd,"Expected value is = %d, The result is = %d",{mem_test[i][31:24],24'd0}, rd_dout0_tb);
            if ({mem_test[i][31:24],24'd0} == rd_dout0_tb) begin
                $fdisplay(fd,"  True  for %d" , i);
            end
            else begin
                $fdisplay(fd,"  False for %d ", i);
            end
            $fdisplay(fd,"\n--------------------------");
            #5;
        end

        // Testing for LH instruction
        
        //testing for strb = 0011
        $fwrite(fd,"STRB = 0011 \n\n");
        rd_strb_tb = 4'b0011;
        for (i =0 ;i<Depth ;i=i+1 ) begin
            rd_addr0_tb = i;
            #5;
            $fwrite(fd,"Expected value is = %d, The result is = %d",{16'd0,mem_test[i][15:0]}, rd_dout0_tb);
            if ({16'd0,mem_test[i][15:0]} == rd_dout0_tb) begin
                $fdisplay(fd,"   True  for %d" , i);
            end
            else begin
                $fdisplay(fd,"   False for %d ", i);
            end
            $fdisplay(fd,"\n--------------------------");
            #5;
        end

        //testing for strb = 0011
        $fwrite(fd,"STRB = 0011 \n\n");
        rd_strb_tb = 4'b0011;
        for (i =0 ;i<Depth ;i=i+1 ) begin
            rd_addr0_tb = i;
            #5;
            $fwrite(fd,"Expected value is = %d, The result is = %d",{16'd0,mem_test[i][15:0]}, rd_dout0_tb);
            if ({16'd0,mem_test[i][15:0]} == rd_dout0_tb) begin
                $fdisplay(fd,"   True  for %d" , i);
            end
            else begin
                $fdisplay(fd,"   False for %d ", i);
            end
            $fdisplay(fd,"\n--------------------------");
            #5;
        end

        //testing fro strb == 0110
        $fwrite(fd,"STRB = 0110 \n\n");
        rd_strb_tb = 4'b0110;
        for (i =0 ;i<Depth ;i=i+1 ) begin
            rd_addr0_tb = i;
            #5;
            $fwrite(fd,"Expected value is = %d, The result is = %d",{8'd0,mem_test[i][23:8],8'd0}, rd_dout0_tb);
            if ({8'd0,mem_test[i][23:8],8'd0} == rd_dout0_tb) begin
                $fdisplay(fd,"   True  for %d" , i);
            end
            else begin
                $fdisplay(fd,"   False for %d ", i);
            end
            $fdisplay(fd,"\n--------------------------");
            #5;
        end

        //testing fro strb == 1100
        $fwrite(fd,"STRB = 1100 \n\n");
        rd_strb_tb = 4'b1100;
        for (i =0 ;i<Depth ;i=i+1 ) begin
            rd_addr0_tb = i;
            #5;
            $fwrite(fd,"Expected value is = %d, The result is = %d",{mem_test[i][31:16],16'd0}, rd_dout0_tb);
            if ({mem_test[i][31:16],16'd0} == rd_dout0_tb) begin
                $fdisplay(fd,"   True  for %d" , i);
            end
            else begin
                $fdisplay(fd,"   False for %d ", i);
            end
            $fdisplay(fd,"\n--------------------------");
            #5;
        end

        //Testing for LW
        //testing fro strb == 1111
        $fwrite(fd,"STRB = 1111 \n\n");
        rd_strb_tb = 4'b1111;
        for (i =0 ;i<Depth ;i=i+1 ) begin
            rd_addr0_tb = i;
            #5;
            $fwrite(fd,"Expected value is = %d, The result is = %d",mem_test[i], rd_dout0_tb);
            if (mem_test[i] == rd_dout0_tb) begin
                $fdisplay(fd,"   True  for %d" , i);
            end
            else begin
                $fdisplay(fd,"   False for %d ", i);
            end
            $fdisplay(fd,"\n--------------------------");
            #5;
        end

        $fclose(fd);
        $finish;

    end

endmodule