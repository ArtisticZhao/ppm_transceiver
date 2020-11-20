`timescale 1ns / 1ps

module tb_eof( );
reg clk;
reg rst_n;
reg control_eof;
wire eof;
wire eof_done;
eof uut(
        .clk               (clk),
        .rst_n             (rst_n),
        .control_eof       (control_eof),
        .eof               (eof),
        .eof_done          (eof_done)
);
always begin #295 clk = ~clk; end

initial begin
    clk = 0;
    rst_n = 0;
    control_eof = 0;
    #1180
    rst_n = 1;
    # 590
    control_eof=1;
    # 590
    control_eof=0;
    # 590000
    control_eof=1;
    # 590
    control_eof=0;
        
end

endmodule
