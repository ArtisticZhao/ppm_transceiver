`timescale 1ns / 1ps
module encoder(
    input       clk,
    input       rst_n,
    input       Le,
    input [3:0] N,
    input [7:0] Din,
    output      Dout
    );

localparam IDLE                = 5'b1;
localparam USER_DATA           = 5'b10;
localparam TRANSMIT_SOF        = 5'b100;
localparam TRANSMIT_FRAME_DATA = 5'b1000;
localparam TRANSMIT_EOF        = 5'b10000;


endmodule
