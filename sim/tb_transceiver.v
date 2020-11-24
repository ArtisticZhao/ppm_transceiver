`timescale 1ns / 1ps
module tb_transceiver ();
reg clk, rst_n;
reg Le;
reg [3:0] N;
reg [7:0] Din;
wire Dout;
wire [7:0] decoder_out;
wire d_en;
wire f_en;
encoder uut(
    .clk(clk),
    .rst_n(rst_n),
    .Le(Le),
    .N(N),
    .Din(Din),
    .Dout(Dout)
    );
PPM uut2 (
    .clk(clk),
    .rst(rst_n),
    .din(Dout),
    .dout(decoder_out),
    .d_en(d_en),
    .f_en(f_en)
);
initial begin
    clk = 1;
    rst_n = 0;
    Le = 0;
    N = 0;
    Din = 8'b0;
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
end
always begin #295 clk = ~clk; end
endmodule