`timescale 1ns / 1ps

module tb_sof( );
reg clk;
reg rst_n;
reg control_sof;
wire sof;
wire sof_done;
sof uut(
        .clk               (clk),
        .rst_n             (rst_n),
        .control_sof       (control_sof),
        .sof               (sof),
        .sof_done          (sof_done)
);

always begin #295 clk = ~clk; end

initial begin
    clk = 0;
    rst_n = 0;
    control_sof = 0;
    #1180
    rst_n = 1;
    # 590
    control_sof=1;
    # 590
    control_sof=0;
    # 590000
    control_sof=1;
    # 590
    control_sof=0;

end

endmodule
