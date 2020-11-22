`timescale 1ns / 1ps
/**
 * This module will buffer the input data!
 * Input signal: Le, N, data_in, shift_two.data_send_done
 * Output signal: shift_two.strobe data_out
 */

module ppm_frame_buffer (
    input            clk,
    input            rst_n,
    input            Le,
    input [3:0]      N,
    input [7:0]      Din,
    input            start_trans,
    input            shift_two_data_send_done,
    output reg       user_recv_done,
    output reg [7:0] data_out,
    output reg       shift_two_strobe,
    output reg       frame_done
);

localparam IDLE          = 4'b1;
localparam RECV_USERDATA = 4'b10;    // read user data input, data len = N
localparam WAIT_TRANS    = 4'b100;   // wait transmitter send SOF done
localparam SEND_TO_SHIFT = 4'b1000;  // start transmit the signal

// buffer
reg [7:0] buffer[0:15];
reg [3:0] state;
reg [3:0] data_in_count;   // buffer of N
reg [3:0] recv_count;

reg strobe_flag;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_in_count <= 4'b0;
        recv_count <= 4'b0;
        frame_done <= 1'b0;
        data_out <= 8'b0;
        shift_two_strobe <= 1'b0;
        strobe_flag <= 1'b1;
        user_recv_done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (Le == 1'b1) begin
                    state <= RECV_USERDATA;
                    data_in_count <= N;
                end
                else begin
                    state <= IDLE;
                end
            end
            RECV_USERDATA: begin
                if (recv_count < data_in_count) begin
                    buffer[recv_count] <= Din;
                    recv_count <= recv_count + 4'b1;
                end
                else begin
                    state <= WAIT_TRANS;
                end
            end
            WAIT_TRANS: begin
                user_recv_done <= 1'b1;
                if (start_trans) begin
                    user_recv_done <= 1'b0;
                    state <= SEND_TO_SHIFT;
                end
                else begin
                    state <= WAIT_TRANS;
                end
            end
            SEND_TO_SHIFT: begin
                shift_two_strobe <= 1'b1;
                if (data_in_count > 4'b0) begin
                    if (shift_two_data_send_done) begin
                        data_in_count <= data_in_count - 1'b1;
                    end
                    data_out <= buffer[data_in_count-1];
                end
                else begin
                    state <= IDLE;
                    frame_done <= 1'b1;
                    shift_two_strobe <= 1'b0;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end
endmodule
