`timescale 1ns / 1ps
module shift_two(
    input            clk,
    input            rst_n,
    input [7:0]      data_in,
    input            strobe,
    output reg [1:0] data_out,
    output reg       data_send_done
    );

parameter IDLE = 4'b0000,
          s1   = 4'b0001,
          s2   = 4'b0010,
          s3   = 4'b0100,
          s4   = 4'b1000;

reg [3:0] st;
reg [7:0] dt;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        dt <= 8'b00000000;
    else if(strobe)
        dt <= data_in;
end

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 2'b0;
    end
    else begin
        case(st)
            IDLE:begin
                 data_out[0]<=0;
                 data_out[1]<=0;
            end
            s1:begin
                 data_out[0]<=dt[0];
                 data_out[1]<=dt[1];
            end
            s2:begin
                 data_out[0]<=dt[2];
                 data_out[1]<=dt[3];
            end
            s3:begin
                 data_out[0]<=dt[4];
                 data_out[1]<=dt[5];
            end
            s4:begin
                 data_out[0]<=dt[6];
                 data_out[1]<=dt[7];
            end
        endcase
    end
end

reg [6:0] count;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        st <= IDLE;
        count <= 4'b0;
    end else
        case(st)
            IDLE:begin
                if(strobe)
                    st <= s1;
                else
                    st <= IDLE;
            end
            s1: begin
                if (count==7'b1111111) begin
                    st <= s2;
                    count <= 4'b0;
                end else
                    count <= count + 1;
            end
            s2: begin
                if (count==7'b1111111) begin
                    st <= s3;
                    count <= 4'b0;
                end else
                    count <= count + 1;
            end
            s3: begin
                if (count==7'b1111111) begin
                    st <= s4;
                    count <= 4'b0;
                end else
                    count <= count + 1;
            end
            s4: begin
                if (count==7'b1111111) begin
                    st <= IDLE;
                    count <= 4'b0;
                end else
                    count <= count + 1;
            end
            default: st <= IDLE;
        endcase
end

wire data_send_done_d;
assign data_send_done_d = (st==s4)&&(count==7'b1111111);
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        data_send_done <= 1'b0;
    end
    else begin
        data_send_done <= data_send_done_d;
    end
end
endmodule
