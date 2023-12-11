`timescale 1ns / 1ps

module convolution_ls
#(parameter int filter [2][2] = '{'{1, 0},'{0,1}})
//parameter logic filter [2][2] = '{'{1, 0},'{0,1}}; // array size is fixed but values are configurable.
(
input logic clk_i, // input clock
input logic rst_ni, // logic-0 asserted async reset
input logic valid_i, // asserted when pixels are loaded into the module
input [7:0] pixel_i, // pixel values loaded
output logic valid_o, // asserted when the convolution is done
output logic [7:0] pixel_o // convolved pixel values
);

  // Internal memory for storing input pixels
logic [7:0] pixels [639:0][359:0];

// Internal memory for storing convolved pixels
logic [7:0] conv_pixels [319:0][179:0];

// Internal signals for every convolution operation
logic [7:0] result;
logic [15:0] sum;

// Values for indexing
int i,j;
int a,b;
int m,n;
int k,l;


// Delay state exit signal
logic delay_e;

// State variables
enum logic[2:0] {
    IDLE,
    LOADING,
    DELAY1,
    DELAY2,
    CONVOLVING,
    TRANSMIT
} state, next_state;



// State forwarding
always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
        state<=IDLE;
    end
    else begin
        state <= next_state;
    end
end


// Next state logic
always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
        next_state <= IDLE;
    end
    else begin
        case (next_state)
            IDLE: next_state <= (valid_i) ? LOADING : IDLE;
            LOADING: next_state <= (i == 639 && j == 359) ? DELAY1 : LOADING;
            DELAY1: next_state <=  DELAY2 ;
            DELAY2: next_state <= CONVOLVING;
            CONVOLVING: next_state <= (k == 319 && l == 179) ? TRANSMIT : CONVOLVING;
            TRANSMIT: next_state <= (a == 319 && b == 178) ? IDLE : TRANSMIT;
            default: next_state <= IDLE;
        endcase
    end
end

// Convolution
always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
        sum <= 'd0;
        result <= 'd0;
    end
    else if(state == DELAY1 | state == DELAY2) begin
        sum <= (m >= 0 && m < 320) ? ( (pixels[(2*m)][(2*n)]*filter[0][0] + pixels[(2*m)+1][(2*n)]*filter[1][0]+
                                                    pixels[(2*m)][(2*n)+1] * filter[0][1] + pixels[(2*m)+1][(2*n)+1]*filter[1][1])/4) : 0;
        result <= (sum>255) ? 255 : sum;
    end
    else if (state == CONVOLVING) begin
        sum <= (m >= 0 && m < 320) ? ( (pixels[(2*m)][(2*n)]*filter[0][0] + pixels[(2*m)+1][(2*n)]*filter[1][0]+
                                                    pixels[(2*m)][(2*n)+1] * filter[0][1] + pixels[(2*m)+1][(2*n)+1]*filter[1][1])/4) : 0;
        result <=(sum>255) ? 255 : sum ;
    end
    else begin
        sum <= 'd0;
        result <= sum;
    end
end

//Memory
always_ff @(posedge clk_i or negedge rst_ni) begin
    // Reseting the memories
    if (!rst_ni) begin
        for(m=0;m<640;m=m+1) begin
            for (n = 0;n<360 ;n=n+1 ) begin
                pixels[m][n] <= 'd0;
            end
        end
        for(m=0;m<320;m=m+1) begin
            for (n = 0;n<180 ;n=n+1 ) begin
                conv_pixels[m][n] <= 'd0;
            end
        end
        valid_o <= 'd0;
        i <= 'd0;
        j <= 'd0;
        m <= 'd0;
        n <= 'd0;
        k <= 'd0;
        l <= 'd0;
        a <= 'd0;
        b <= 'd0;
    end
    // Setting initial values 
    else if(valid_i) begin
        i <= (state == IDLE) ? 0 : i;
        j <= (state == IDLE) ? 0 : j;
        m <= (state == IDLE) ? 0 : m;
        n <= (state == IDLE) ? 0 : n;
        k <= (state == IDLE) ? 0 : k;
        l <= (state == IDLE) ? 0 : l;
    end
    //Loading the pixel values
    else if(state == LOADING) begin
        pixels[i][j] <= pixel_i;
        i <= (j == 359) ? i + 1 : i;
        j <= (j == 359) ? 0 : j + 1;
    end
    else if (state == DELAY1 | state == DELAY2) begin
        m <= (n == 179) ? m+1 : m;
        n <= (n == 179) ? 0 : n+1;
        conv_pixels[k][l] <= result;
    end
    else if (state == CONVOLVING) begin
        conv_pixels[k][l] <= result;
        m <= (n == 179) ? m+1 : m;
        n <= (n == 179) ? 0 : n+1;
        k <= (l == 179) ? k+1 : k;
        l <= (l == 179) ? 0 : l+1;
        valid_o <= (k == 319 && l == 179);
    end
    // Output phase
    else if (state == TRANSMIT) begin
        pixel_o <= conv_pixels[a][b];
        a <= (b == 179) ? a+1 : a;
        b <= (b == 179) ? 0 : b+1;
    end
    else begin
        pixel_o <= 'd0;
    end
end

endmodule