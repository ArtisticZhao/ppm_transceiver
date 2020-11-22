`timescale 1ns / 1ps

module sof(
    input clk,//时钟周期0.59us
    input rst_n,
    input control_sof,
    output reg sof, //sof低电�?9.44us 16个时钟周�?
    output sof_done
    );
reg [7:0]cnt;
reg flag;
assign sof_done=(cnt==123);
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        sof <= 1;
        cnt <=0;
        flag <=0;
    end
    else begin
        if(control_sof==1)
            flag<=1;
        else if(flag==1)begin       
            cnt<=cnt+1;
            if(cnt<16)
                sof<=0;
            else if(cnt>=16 && cnt<32)
                sof<=1;
            else if(cnt>=32 && cnt<48)
                sof<=1;
            else if(cnt>=48 && cnt<64)  
                sof<=1;
            else if(cnt>=64 && cnt<80)  
                sof<=1;    
            else if(cnt>=80 && cnt<96)  
                sof<=0;  
            else if(cnt>=96 && cnt<112)  
                sof<=1; 
            else if(cnt>=112 && cnt<=128)  
                sof<=1;
            else if(cnt==129)begin
                cnt<=0;
                flag <=0;
            end
        end  
    end                         
end
endmodule
