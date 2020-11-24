module ppm_decoder(
    input        clk,
    input        rst,
    input        din,
    output [7:0] dout,
    output       d_en,   // byte received
    output       f_en);  // frame start

reg [3:0] sample_count;   // sample at 15
reg [2:0] symbol_count;   // get symbol at 8
reg [2:0] byte_count;     // get byte at = 4

reg [7:0] PPM_code;  // PPM code
reg [7:0] raw_code;  // raw code

reg cstate, nstate;

localpar      SOF=8'b01111011,
               EOF=4'b1101,
               d_00=8'b10111111,
               d_01=8'b11101111,
               d_10=8'b11111011,
               d_11=8'b11111110,
endmodule