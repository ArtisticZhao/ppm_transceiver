`timescale 1ns / 1ps
module tb_buffer ();

reg clk;
reg rst_n;
reg Le;
reg [3:0] N;
reg [7:0] Din;
reg start_trans;

wire frame_done;

wire [7:0] data;
wire shift_two_data_send_done;
wire strobe;
wire [1:0] dataout;

ppm_frame_buffer uut (
    .clk(clk),
    .rst_n(rst_n),
    .Le(Le),
    .N(N),
    .Din(Din),
    .start_trans(start_trans),
    .shift_two_data_send_done(shift_two_data_send_done),
    .data_out(data),
    .shift_two_strobe(strobe),
    .frame_done(frame_done)
);

shift_two uut2(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data),
    .strobe(strobe),
    .data_out(dataout),
    .data_send_done(shift_two_data_send_done)
    );

initial begin
    clk = 1;
    rst_n = 0;
    Le = 0;
    N = 0;
    Din = 8'b0;
    start_trans = 0;
    #1180
    rst_n = 1;
    #590;
    // start user data
    Le = 1;
    N = 4;
    #590;
    Le = 0;
    N = 0;
    Din = 8'hc0;
    #590;
    Din = 8'haa;
    #590;
    Din = 8'hdd;
    #590;
    Din = 8'hae;
    #590;
    Din = 8'b0;
    #590;
    #590;
    #590;
    // start transmit to shift_two
    start_trans = 1;
    #590;
    start_trans = 0;
end

always begin #295 clk = ~clk; end

endmodule
