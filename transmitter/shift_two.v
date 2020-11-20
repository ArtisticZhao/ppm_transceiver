`timescale 1ns / 1ps
module shift_two(
    input clk,
    inout rst_n,
    input [7:0] data_in,
    input strobe,
    output reg [1:0] data_out
    );
reg [3:0] st;
reg [7:0] dt;
parameter  s0=4'b0000,
            s1=4'b0001,
            s2=4'b0010,
            s3=4'b0100,
            s4=4'b1000;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        dt <= 8'b00000000;
    else if(strobe)
        dt <= data_in;
end
always@(posedge clk or negedge rst_n) begin
    case(st)
        s0:begin
             data_out[0]=0;
             data_out[1]=0;
        end        
        s1:begin
             data_out[0]=dt[0];
             data_out[1]=dt[1];
        end
        s2:begin
             data_out[0]=dt[2];
             data_out[1]=dt[3];
        end
        s3:begin
             data_out[0]=dt[4];
             data_out[1]=dt[5];
        end
        s4:begin
             data_out[0]=dt[6];
             data_out[1]=dt[7];
        end    
    endcase    
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        st <= s0;
    else 
        case(st)
            s0:begin
                if(strobe)
                    st <= s1;
                else
                    st <= s0;
            end
            s1: st <= s2;
            s2: st <= s3;
            s3: st <= s4;
            default: st <= s0;
        endcase          
end
endmodule
