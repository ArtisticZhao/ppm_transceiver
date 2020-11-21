`timescale 1ns / 1ps

module tb_shift_two();

reg clk, rst_n;
reg [7:0] data_in;
reg strobe;
wire [1:0] data_out;
wire data_send_done;
// initial the module
shift_two uut(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in),
    .strobe(strobe),
    .data_out(data_out),
    .data_send_done(data_send_done)
    );

initial begin
    clk = 0;
    rst_n = 0;
    data_in = 8'b01101100;
    strobe = 0;
    #1180
    rst_n = 1;
    #590
    strobe = 1;
//    #590
//    strobe = 0;
end

always begin #295 clk = ~clk; end

endmodule
