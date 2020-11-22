`timescale 1ns / 1ps

module ppm(
    input clk,
    input rst_n,
    input  wire [1:0]   ppm_code,
    input ppm_strobe,

    output reg ppm, //ppm编码输出
    output ppm_done //ppm编码输出完成
);
localparam IDLE = 2'b01;
localparam TRANS_PPM = 2'b10;
reg [1:0] state;
reg [7:0] cnt;
assign ppm_done=(cnt==127);
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        state <= IDLE;
        ppm <= 1;
        cnt <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (ppm_strobe) begin
                    state <= TRANS_PPM;
                end else begin
                    state <= IDLE;
                end
            end
            TRANS_PPM: begin
                case(ppm_code)
                2'b00: begin
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
                    else if(cnt>=112 && cnt<127)
                        ppm<=1;
                    else begin
                        cnt<=0;
                        if (ppm_strobe) begin
                            state <= TRANS_PPM;
                        end else
                            state <= IDLE;
                    end
                end
                2'b01:begin
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
                    else if(cnt>=112 && cnt<127)
                        ppm<=1;
                    else begin
                        cnt<=0;
                        if (ppm_strobe) begin
                            state <= TRANS_PPM;
                        end else
                            state <= IDLE;
                    end
                end
                2'b10:begin
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
                    else if(cnt>=112 && cnt<127)
                        ppm<=1;
                    else begin
                        cnt<=0;
                        if (ppm_strobe) begin
                            state <= TRANS_PPM;
                        end else
                            state <= IDLE;
                    end
                end
                2'b11:begin
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
                    else if(cnt>=112 && cnt<127)
                        ppm<=0;
                    else begin
                        cnt<=0;
                        if (ppm_strobe) begin
                            state <= TRANS_PPM;
                        end else
                            state <= IDLE;
                    end
                end
                endcase
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end
endmodule

