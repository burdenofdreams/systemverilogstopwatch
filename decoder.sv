module decoder (
    input logic [3:0] ones,   // 4-bit input for ones counter
    input logic [2:0] tens,   // 3-bit input for tens counter
    input logic enable,       // Enable signal for the decoder
    output logic a, b, c, d, e, f, g  // Outputs for 7-segment display
);
    logic [3:0] dig; // 4-bit logic for the display input, controlled by the mux

    // MUX to select between ones and tens based on enable using the conditional operator
    always_comb begin
        dig = (enable) ? ones : {1'b0, tens};  // Select ones if enable is high, otherwise select tens (pad with 0)
    end

    // Segment 'b'
    logic b1, b2;
    xor(b1, dig[1], dig[0]);
    and(b2, b1, dig[2]);
    not(b, b2);

    // Segment 'c'
    logic not1, not2, not4, not8;
    not(not1, dig[0]);
    not(not2, dig[1]);
    not(not4, dig[2]);
    not(not8, dig[3]);

    logic c1;
    or(c1, dig[0], dig[2]);
    or(c, not2, c1);

    // Segment 'a'
    logic a1, a2, a3, a4, a5;
    and(a1, dig[2], dig[0]);
    or(a2, dig[3], dig[1]);
    or(a3, c1, dig[1]);
    not(a4, a3);
    or(a5, a4, a2);
    or(a, a5, a1);

    // Segment 'd'
    logic d1, d2, d3, d4, d5, d6, d7, d8, d9;
    and(d1, dig[1], not1);
    and(d2, not2, not1);
    and(d3, d2, not4);
    or(e, d3, d1);  // e
    and(d4, not2, dig[2]);
    and(d5, d4, dig[0]);
    or(d6, e, d5);
    and(d7, not4, not8);
    and(d8, d7, dig[1]);
    or(d9, d8, dig[3]);
    or(d, d9, d6);

    // Segment 'f'
    or(f1, d2, dig[3]);
    and(f2, d1, dig[2]);
    or(f3, d4, f2);
    or(f, f1, f3);

    // Segment 'g'
    logic g1;
    or(g1, d9, d4);
    or(g, g1, d1);

endmodule
