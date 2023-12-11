`timescale 1ns / 1ps
module Imm_Generator_tb;

    logic [31:0] instruction_tb;
    wire [31:0] Imm_tb;

    logic [31:0] mem_test [127:0];
    ImmGenerator uut (.instruction(instruction_tb),.Imm(Imm_tb));

    //File variable
    int fd;

    // Lop variable
    int i;

    logic [31:0] Imm_U,Imm_J,Imm_B,Imm_I,Imm_S;
    initial begin
        

        fd = $fopen("C:/Users/omer/Documents/GitHub/Dersler/MTH-RISCV/RISCV/logs/Imm_generator.log","w");
        $readmemh("C:/Users/omer/Documents/GitHub/Dersler/MTH-RISCV/RISCV/FilesToRead/Instruction_bublesort.instr",mem_test);
        //Test variables
        for (i =0 ;i<40 ;i=i+1 ) begin
            instruction_tb = mem_test[i];
            #2;
        end
        $fclose(fd);
        $finish;
        
    end
    
    always @(instruction_tb) begin
        #1;
        //ASSIGNING VALUES OF IMMEDIATE ACCORDING TO THEIR TYPES 
        Imm_U = {instruction_tb[31:12],12'd0};
        Imm_J = {11'd0,instruction_tb[31],instruction_tb[19:12],instruction_tb[20],instruction_tb[30:21],1'd0};
        Imm_B = {19'd0,instruction_tb[31],instruction_tb[7],instruction_tb[30:25],instruction_tb[11:8],1'd0};
        Imm_I = {20'd0,instruction_tb[31:20]};
        Imm_S = {20'd0,instruction_tb[31:25],instruction_tb[11:7]};

        case (instruction_tb[6:0])
        7'b0110111,7'b0010111: begin  //U type
            $fwrite(fd,"U type        ");
            if (Imm_tb == Imm_U) begin
                $fwrite(fd,"TRUE\n\n");
            end
            else begin
                $fwrite(fd,"FALSE\n\n");
            end
            end
            7'b1101111: begin // J type
                $fwrite(fd,"J type        ");
                if (Imm_tb == Imm_J) begin
                    $fwrite(fd,"TRUE\n\n");
                end
                else begin
                    $fwrite(fd,"FALSE\n\n");
                end
                end  
                7'b1100011: begin // B type
                    $fwrite(fd,"B type        ");
                if (Imm_tb == Imm_B) begin
                    $fwrite(fd,"TRUE\n\n");
                end
                else begin
                    $fwrite(fd,"FALSE\n\n");
                end
                end  
                7'b1100111,7'b0000011,7'b0010011: begin // I Type
                    $fwrite(fd,"I type        ");
                if (Imm_tb == Imm_I) begin
                    $fwrite(fd,"TRUE\n\n");
                end
                else begin
                    $fwrite(fd,"FALSE\n\n");
                end
                end
                7'b0100011: begin // S type
                    $fwrite(fd,"S type        ");
                if (Imm_tb == Imm_S) begin
                    $fwrite(fd,"TRUE\n\n");
                end
                else begin
                    $fwrite(fd,"FALSE\n\n");
                end
                end
            default: begin
                $fwrite(fd,"R type     ");
                if (Imm_tb == 32'd0) begin
                    $fwrite(fd,"TRUE\n\n");
                end
                else begin
                    $fwrite(fd,"FALSE\n\n");
                end
            end
        endcase
    end
endmodule