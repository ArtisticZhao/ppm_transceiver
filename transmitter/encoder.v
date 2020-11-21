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

wire user_recv_done, shift_two_data_send_done, frame_done;
wire [7:0] buffer_data_to_shift;  // buffer to shift_two
wire strobe;
wire dataout;
wire frame_done;

ppm_frame_buffer buffer (
    .clk(clk),
    .rst_n(rst_n),
    .Le(Le),
    .N(N),
    .Din(Din),
    .user_recv_done(user_recv_done),
    .start_trans(start_trans),
    .shift_two_data_send_done(shift_two_data_send_done),
    .data_out(buffer_data_to_shift),
    .shift_two_strobe(strobe),
    .frame_done(frame_done)
);

shift_two shift(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(buffer_data_to_shift),
    .strobe(strobe),
    .data_out(dataout),
    .data_send_done(shift_two_data_send_done)
    );

endmodule
