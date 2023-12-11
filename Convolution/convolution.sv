`timescale 1ns / 1ps

module convolution
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

// Signals for indexing
int i,j;

// variables for reseting memory
int k,l;

// variables for convolved memory block
int m,n;

// Variables for convolvving
int a,b;

// State variables
enum logic[1:0] {
    IDLE,
    CONVOLVING
} state, next_state;

// State variables for convolution operation
enum logic[1:0] {
    FILTER_IDLE,
    FILTERING
} filter_state, next_filter_state;

// State forwarding
always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
        state<=IDLE;
        filter_state<=FILTER_IDLE;
    end
    else begin
        state <= next_state;
        filter_state <= next_filter_state;
    end
end

// Next state logic
always_ff @(posedge clk_i) begin
    case (state)
        IDLE: next_state <= valid_i ? CONVOLVING : IDLE;
        CONVOLVING: next_state <= (m == 319 && n == 179) ? IDLE : CONVOLVING;
        default: next_state <= IDLE;
    endcase

    case (filter_state)
        FILTER_IDLE: next_filter_state <= ((i+1)%2==0 && j > 1 ) ? FILTERING : FILTER_IDLE; 
        FILTERING: next_filter_state <= (i < 640 && j < 360 && i%2==0 && j > 0) ? FILTERING : FILTER_IDLE; 
        default: next_filter_state <= FILTER_IDLE;
    endcase
end

// Convolution
always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
        sum <= 'd0;
    end
    else if (state == CONVOLVING && filter_state == FILTERING && m<i) begin
        sum <= (a>0 && b >0 && a < 640 && b < 360 ) ? ( pixels[a-1][b-1]*filter[0][0] + pixels[a][b-1]*filter[1][0]+
                                                    pixels[a-1][b] * filter[0][1] + pixels[a][b]*filter[1][1]) : 0;
        result <= (sum>255) ? 255 : sum;
    end
end


//Memory
always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      for(k=0;k<640;k=k+1) begin
        for (l = 0;l<360 ;l=l+1 ) begin
            pixels[k][l] <= 'd0;
        end
      end
      for(k=0;k<320;k=k+1) begin
        for (l = 0;l<180 ;l=l+1 ) begin
            conv_pixels[k][l] <= 'd0;
        end
      end
      valid_o <= 'd0;
      m <= 0;
      n <= 0;
      a <= 0;
      b <= 0;
    end
    else if(valid_i) begin
      i <= (state == IDLE) ? 0 : i;
      j <= (state == IDLE) ? 0 : j;
      m <= 0;
      n <= 0;
    end
    else if (filter_state == CONVOLVING && m<i) begin
      conv_pixels[m][n] <= result;
      pixels[i][j] <= pixel_i;
      i <= (j == 359) ? i + 1 : i;
      j <= (j == 359) ? 0 : j + 1;
      m <= (n == 179) ? m+1 : m;
      n <= (n == 179) ? 0 : n+1;
      if (m < i) begin
        a <= (b == 359) ? a+1 : a;
        b <= (b == 359) ? b : b+1; 
      end
      valid_o <= (m == 319 && j == 179);
    end
    else begin
        pixels[i][j] <= pixel_i;
        i <= (j == 359) ? i + 1 : i;
        j <= (j == 359) ? 0 : j + 1;
        if (m < i) begin
            a <= (b == 359) ? a+1 : a;
            b <= (b == 359) ? 0 : b+1; 
        end
        m <= m;
        n <= n;
    end
end


// Output logic
always_comb begin
    pixel_o = conv_pixels[0][0];
end
endmodule