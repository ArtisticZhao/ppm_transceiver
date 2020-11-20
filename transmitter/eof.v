`timescale 1ns / 1ps

module eof(
    input clk,//时钟周期0.59us
    input rst_n,
    input control_eof,
    output reg eof, //sof低电平9.44us 16个时钟周期
    output eof_done
    );
reg [7:0]cnt;
reg flag;
assign eof_done=(cnt==65);
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        eof <= 1;
        cnt <=0;
        flag <=0;
    end
    else begin
        if(control_eof==1)
            flag<=1;
        else if(flag==1)begin       
            cnt<=cnt+1;
            if(cnt<16)
                eof<=1;
            else if(cnt>=16 && cnt<32)
                eof<=1;
            else if(cnt>=32 && cnt<48)
                eof<=0;
            else if(cnt>=48 && cnt<=64)  
                eof<=1;
            else if(cnt==65)begin
                cnt<=0;
                flag <=0;
            end
        end  
    end                         
end
endmodule
