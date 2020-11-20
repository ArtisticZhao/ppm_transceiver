`timescale 1ns / 1ps

module ppm(
    input clk,
    input rst_n,
    input  wire [1:0]   ppm_code,
    
    output reg ppm, //ppm编码输出
    output ppm_done, //ppm编码输出完成 
    output ppm_start //ppm编码输出完成     
);
reg [7:0] cnt;
assign ppm_done=(cnt==129);
assign ppm_start=(cnt==1);
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        ppm <=1;
        cnt <=0;
    end
    else begin
        case(ppm_code)
        00: begin
            cnt<=cnt+1;
            if(cnt<16)
                ppm<=1;
            else if(cnt>=16 && cnt<32)
                ppm<=0;
            else if(cnt>=32 && cnt<48)
                ppm<=1;
            else if(cnt>=48 && cnt<64)  
                ppm<=1;
            else if(cnt>=64 && cnt<80)  
                ppm<=1;    
            else if(cnt>=80 && cnt<96)  
                ppm<=1;  
            else if(cnt>=96 && cnt<112)  
                ppm<=1; 
            else if(cnt>=112 && cnt<=128)  
                ppm<=1;
            else if(cnt==129)
                cnt<=0;
        end
        01:begin
            cnt<=cnt+1;
            if(cnt<16)
                ppm<=1;
            else if(cnt>=16 && cnt<32)
                ppm<=1;
            else if(cnt>=32 && cnt<48)
                ppm<=1;
            else if(cnt>=48 && cnt<64)  
                ppm<=0;
            else if(cnt>=64 && cnt<80)  
                ppm<=1;    
            else if(cnt>=80 && cnt<96)  
                ppm<=1;  
            else if(cnt>=96 && cnt<112)  
                ppm<=1; 
            else if(cnt>=112 && cnt<=128)  
                ppm<=1;
            else if(cnt==129)
                cnt<=0;
        end
        10:begin
            cnt<=cnt+1;
            if(cnt<16)
                ppm<=1;
            else if(cnt>=16 && cnt<32)
                ppm<=1;
            else if(cnt>=32 && cnt<48)
                ppm<=1;
            else if(cnt>=48 && cnt<64)  
                ppm<=1;
            else if(cnt>=64 && cnt<80)  
                ppm<=1;    
            else if(cnt>=80 && cnt<96)  
                ppm<=0;  
            else if(cnt>=96 && cnt<112)  
                ppm<=1; 
            else if(cnt>=112 && cnt<=128)  
                ppm<=1;
            else if(cnt==129)
                cnt<=0;
        end 
        11:begin
            cnt<=cnt+1;
            if(cnt<16)
                ppm<=1;
            else if(cnt>=16 && cnt<32)
                ppm<=1;
            else if(cnt>=32 && cnt<48)
                ppm<=1;
            else if(cnt>=48 && cnt<64)  
                ppm<=1;
            else if(cnt>=64 && cnt<80)  
                ppm<=1;    
            else if(cnt>=80 && cnt<96)  
                ppm<=1;  
            else if(cnt>=96 && cnt<112)  
                ppm<=1; 
            else if(cnt>=112 && cnt<=128)  
                ppm<=0;
            else if(cnt==129)
                cnt<=0;
        end
        endcase                     
    end
end                              
endmodule
