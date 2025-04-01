module clock_divider (
    input logic clk_in,    // 50 MHz input clock
    input logic reset,     // Active high reset
    output logic clk_out,  // Divided clock (1 Hz output)
	output logic clk_mux,
    input logic stop
);
    // Parameter to calculate the number of clock cycles for 1 Hz output
    parameter integer DIVISOR = 50_000_000; // Divide 50 MHz to 1 Hz

    // Counter register
    logic [31:0] counter;
	 logic [20:0] countermux;
    // Clock output logic
    always_ff @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 1;
        end else if (stop) begin
            counter <= counter;
        end else if (counter == DIVISOR/2) begin
            counter <= 0;
            clk_out <= ~clk_out; // Toggle output clock
        end else begin
            counter <= counter + 1;
        end
    end
	always_ff @(posedge clk_in) begin
        if (countermux == DIVISOR/100) begin
            countermux <= 0;
            clk_mux <= ~clk_mux; // Toggle output clock
        end else begin
            countermux <= countermux + 1;
        end
    end
endmodule
