 `timescale 1ns/1ns
module tb_PPM_top ();

reg clk,rst;
reg din;
wire [7:0]dout;
wire d_en,f_en;

reg [7:0] mem[40:0];  
integer i,j;

initial begin
$readmemb("C:/Users/hkcre/Desktop/ppm_transceiver/sim/receiver/mem.txt",mem);
for(i=0;i<41;i=i+1)
    for(j=7;j>=0;j=j-1) begin
        #9440 
        din=mem[i][j];
        $display("mem[%0d][%0d]=%b",i,j,mem[i][j]);
    end
end

always #295 clk=~clk;

initial begin
    clk=0;
    rst=1;
    #200
    rst=0;
    #259
    rst=1;   
end

PPM ut1(
    .clk(clk),
    .rst(rst),
    .din(din),
    .d_en(d_en),
    .f_en(f_en),
    .dout(dout)
    );
                 
endmodule