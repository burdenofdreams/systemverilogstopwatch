module top (
    input logic clk_in,   // 50 MHz clock from the FPGA board
    input logic reset,    // Reset signal (push button or switch)
    input logic stop,     // Stop signal to pause/resume the stopwatch
    output logic [6:0] seg,  // 7-segment display outputs
    output logic enable,  // Signal for selecting one digit
    output logic enable2  // Signal for selecting the other digit
);
    // Internal signals
    logic clk_out;        // Divided 1 Hz clock
    logic [3:0] ones;     // Ones place counter
    logic [2:0] tens;     // Tens place counter

    // Intermediate signal for stop (toggle on negedge event)
    logic stop_int=0;       // Intermediate stop signal

    // Assign outputs for enable and enable2

    // Clock Divider: Generates 1 Hz clock from 50 MHz input
    clock_divider clk_div_inst (
        .clk_in(clk_in),
        .reset(~reset),      // Directly use the reset signal
        .clk_out(clk_out),
        .stop(stop_int),    // Use intermediate stop signal
		  .clk_mux(enable)
    );

    // Stopwatch Counter: Counts seconds (ones and tens digits)
    kop stopwatch (
        .clk(clk_out),
        .rst(~reset),         // Directly use the reset signal
        .ones(ones),
        .tens(tens)
    );

    // 7-Segment Decoder: Converts binary counters to display segments
    decoder display_decoder (
        .ones(ones),      // Ones place counter
        .tens(tens),      // Tens place counter
        .enable(enable2), // Enable signal driven by ~clk_in (inverted 50 MHz clock)
        .a(seg[0]),       // Segment a
        .b(seg[1]),       // Segment b
        .c(seg[2]),       // Segment c
        .d(seg[3]),       // Segment d
        .e(seg[4]),       // Segment e
        .f(seg[5]),       // Segment f
        .g(seg[6])        // Segment g
    );
	assign enable2=~enable;
    // Always block for stop: Triggered on negedge of stop
    always_ff @(negedge stop) begin
        stop_int <= ~stop_int;     // Toggle intermediate stop logic
    end

endmodule
