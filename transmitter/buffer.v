`timescale 1ns / 1ps
/**
 * This module will buffer the input data!
 * Input signal: Le, N, data_in, shift_two.data_send_done
 * Output signal: shift_two.strobe data_out
 */

module ppm_frame_buffer (
    input       clk,
    input       rst_n,
    input       Le,
    input [3:0] N,
    input [7:0] Din,
    input       shift_two_data_send_done,
    output      data_out,
    output      shift_two_strobe,
    output      frame_done
);

localparam IDLE          = 3'b1;
localparam RECV_USERDATA = 3'b10;
localparam SEND_TO_SHIFT = 3'b100;

// buffer
reg [7:0] buffer[0:15];
reg [2:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end
    else begin
        case (state)
            IDLE: begin
                if (Le == 1'b1) begin
                    state <= RECV_USERDATA;
                end
                else begin
                    state <= state;
                end
            end
            default: begin
                
            end
        endcase
    end
end
endmodule
