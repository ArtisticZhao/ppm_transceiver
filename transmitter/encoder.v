`timescale 1ns / 1ps
module encoder(
    input       clk,
    input       rst_n,
    input       Le,
    input [3:0] N,
    input [7:0] Din,
    output  reg Dout
    );

// signal from buffer
wire user_recv_done;
wire shift_two_data_send_done;
wire [7:0] buffer_data_to_shift;  // buffer to shift_two
wire strobe;
wire frame_done;
reg start_trans;
// signal ppm
wire[1:0] ppm_code;
// eof
reg control_eof;
wire eof_done;
wire eof;
// sof
reg control_sof;
wire sof;
wire sof_done;
// ppm
wire ppm;
wire ppm_done;
wire control_ppm;

// --- state mechine to ctrl send process
localparam IDLE                = 5'b1;
localparam TRANSMIT_SOF        = 5'b100;
localparam TRANSMIT_FRAME_DATA = 5'b1000;
localparam TRANSMIT_EOF        = 5'b10000;

reg [3:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        control_sof <= 1'b0;
        control_eof <= 1'b0;
        start_trans <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (user_recv_done) begin
                    state <= TRANSMIT_SOF;
                    control_sof <= 1'b1;
                end else begin
                    state <= IDLE;
                end
            end
            TRANSMIT_SOF: begin
                control_sof <= 1'b0;
                if (sof_done) begin
                    state <= TRANSMIT_FRAME_DATA;
                    start_trans <= 1'b1;
                end
                else begin
                    state <= TRANSMIT_SOF;
                end
            end
            TRANSMIT_FRAME_DATA: begin
                start_trans <= 1'b0;
                if (frame_done) begin
                    state <= TRANSMIT_EOF;
                    control_eof <= 1'b1;
                end
                else begin
                    state <= TRANSMIT_FRAME_DATA;
                end
            end
            TRANSMIT_EOF: begin
                control_eof <= 1'b0;
                if (eof_done) begin
                    state <= IDLE;
                end
                else begin
                    state <= TRANSMIT_EOF;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end


ppm_frame_buffer buffer (
    .clk(clk),
    .rst_n(rst_n),
    .Le(Le),
    .N(N),
    .Din(Din),
    .user_recv_done(user_recv_done),
    .start_trans(start_trans),
    .shift_two_data_send_done(shift_two_data_send_done),
    .data_out(buffer_data_to_shift),
    .shift_two_strobe(strobe),
    .frame_done(frame_done)
);

shift_two shift(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(buffer_data_to_shift),
    .strobe(strobe),
    .symbol_strobe(control_ppm),
    .data_out(ppm_code),
    .data_send_done(shift_two_data_send_done)
    );

sof sof_gen(
        .clk               (clk),
        .rst_n             (rst_n),
        .control_sof       (control_sof),
        .sof               (sof),
        .sof_done          (sof_done)
);

eof eof_gen(
        .clk               (clk),
        .rst_n             (rst_n),
        .control_eof       (control_eof),
        .eof               (eof),
        .eof_done          (eof_done)
);

ppm ppm_data(
    .clk      (clk     ),
    .rst_n    (rst_n   ),
    .ppm_code (ppm_code),
    .ppm      (ppm     ),
    .ppm_done (ppm_done),
    .ppm_strobe(control_ppm)
);

// combine eof sof ppm
always @(*) begin
    case (state)
        TRANSMIT_SOF: begin
            Dout = sof;
        end
        TRANSMIT_FRAME_DATA: begin
            Dout = ppm;
        end
        TRANSMIT_EOF: begin
            Dout = eof;
        end
        default: begin
            Dout = 1'b1; // ppm define high level of bus as idle state
        end
    endcase
end
endmodule
