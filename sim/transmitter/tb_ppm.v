`timescale 1ns / 1ps

module tb_ppm( );
    reg clk;
    reg rst_n;
    reg [1:0] ppm_code;
    wire ppm;
    wire ppm_done;
    reg ppm_start;
ppm uut(
    .clk      (clk     )          ,
    .rst_n    (rst_n   )          ,
    .ppm_code (ppm_code)          ,
    .ppm      (ppm     )          ,
    .ppm_done (ppm_done)          ,
    .ppm_strobe(ppm_start)
);
always begin #295 clk = ~clk; end

initial begin
    clk = 1;
    rst_n = 0;
    ppm_start = 0;
    #1180
    rst_n = 1;
    ppm_code=2'b00;
    # 590;
    ppm_start = 1;
    # 590;
    ppm_start = 1;


end

endmodule
