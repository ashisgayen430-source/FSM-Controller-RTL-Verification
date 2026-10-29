`timescale 1ns/1ps
module fsm_controller (
    input wire clk,
    input wire rst_n, // Active-low synchronous reset
    input wire start,
    input wire finish,
    output wire busy,
    output wire done
);
    localparam [1:0] IDLE = 2'b00;
    localparam [1:0] ACTIVE = 2'b01;
    localparam [1:0] DONE = 2'b10;

    reg [1:0] state, next_state;

    // State register: updates on rising clock edge.
    always @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state combinational logic.
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:   if (start)  next_state = ACTIVE;
            ACTIVE: if (finish) next_state = DONE;
            DONE:               next_state = IDLE;
            default:            next_state = IDLE;
        endcase
    end

    // Moore outputs depend only on current state.
    assign busy = (state == ACTIVE);
    assign done = (state == DONE);
endmodule
