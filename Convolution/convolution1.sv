`timescale 1ns / 1ps

module convolution_ai
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
  logic [7:0] conv_pixels [639:0][359:0];

  // Internal signals for indexing
  logic [9:0] i, j;

  // State variable to keep track of convolution operation
  enum logic [1:0] {
    IDLE,
    CONVOLVING
  } state, next_state;

  // State variable to keep track of filter operation
  enum logic [1:0] {
    FILTER_IDLE,
    FILTERING
  } filter_state, next_filter_state;

  // Internal signals for convolution operation
  logic [7:0] result;
  logic signed [15:0] sum;

  // Clock edge detection
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state <= IDLE;
      filter_state <= FILTER_IDLE;
    end else begin
      state <= next_state;
      filter_state <= next_filter_state;
      //i <= (state == IDLE && valid_i) ? 0 : i;
      //j <= (state == IDLE && valid_i) ? 0 : j;
    end
  end

  // Next state and next filter state logic
  always_comb begin
    case (state)
      IDLE: next_state = valid_i ? CONVOLVING : IDLE;
      CONVOLVING: next_state = (i == 639 && j == 359) ? IDLE : CONVOLVING;
      default: next_state = IDLE;
    endcase

    case (filter_state)
      FILTER_IDLE: next_filter_state = (i < 2 && j < 2) ? FILTERING : FILTER_IDLE;
      FILTERING: next_filter_state = (i < 2 && j < 2) ? FILTERING : FILTER_IDLE;
      default: next_filter_state = FILTER_IDLE;
    endcase
  end

  // Convolution logic
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      sum <= 0;
    end else if (state == CONVOLVING && filter_state == FILTERING) begin
      sum <= (i > 0 && j > 0) ? (pixels[i-1][j-1] * filter[0][0] +
                                 pixels[i-1][j]   * filter[0][1] +
                                 pixels[i][j-1]   * filter[1][0] +
                                 pixels[i][j]     * filter[1][1]) : 0;
      result <= (sum > 255) ? 255 : (sum < 0) ? 0 : sum[7:0];
    end
  end

  // Memory and output logic
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      pixels[i][j] <= 0;
      conv_pixels[i][j] <= 0;
      valid_o <= 0;
      i <= 0;
      j <= 0;
    end else if (state == IDLE && valid_i) begin
      pixels[i][j] <= pixel_i;
      i <= (j == 359) ? i + 1 : i;
      j <= (j == 359) ? 0 : j + 1;
    end else if (state == CONVOLVING && filter_state == FILTERING) begin
      conv_pixels[i][j] <= result;
      i <= (j == 359) ? i + 1 : i;
      j <= (j == 359) ? 0 : j + 1;
      valid_o <= (i == 639 && j == 359);
    end
  end

  // Output logic
  always_comb begin
    pixel_o = conv_pixels[i][j];
  end
  
endmodule

