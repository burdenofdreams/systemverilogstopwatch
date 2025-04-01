module kop (
    input logic clk,      // Clock signal from clock divider
    input logic rst,      // Reset signal
    output logic [3:0] ones,  // Output signal for ones
    output logic [2:0] tens   // Output signal for tens
);
    logic [3:0] s;         // Intermediate signal for ones calculations
    logic [2:0] c;         // Intermediate carry signals for ones

    logic [2:0] ts;        // Intermediate signal for tens calculations
    logic [1:0] tc;        // Intermediate carry signals for tens

    // Logic for ones counter
    not u1(s[0], ones[0]);            // NOT gate for s[0]
    and u2(c[0], ones[0], 1'b1);      // AND gate for c[0] (ones[0] AND 1)

    xor u3(s[1], ones[1], c[0]);      // XOR gate for s[1]
    and u4(c[1], ones[1], c[0]);      // AND gate for c[1]

    xor u5(s[2], ones[2], c[1]);      // XOR gate for s[2]
    and u6(c[2], ones[2], c[1]);      // AND gate for c[2]

    xor u7(s[3], ones[3], c[2]);      // XOR gate for ones[3]

    // Logic for tens counter
    not t1(ts[0], tens[0]);            // NOT gate for ts[0]
    and t2(tc[0], tens[0], 1'b1);      // AND gate for tc[0] (tens[0] AND 1)

    xor t3(ts[1], tens[1], tc[0]);    // XOR gate for ts[1]
    and t4(tc[1], tens[1], tc[0]);    // AND gate for tc[1]

    xor t5(ts[2], tens[2], tc[1]);    // XOR gate for ts[2]

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            ones <= 4'b0000;  // Reset ones to 0000 when reset is high
            tens <= 3'b000;   // Reset tens to 000 when reset is high
        end else begin
            // If ones reaches 1001, reset it to 0000 and increment tens
            if (ones == 4'b1001) begin
                ones <= 4'b0000;
                if (tens == 3'b101) begin  // Check if tens equals 5 (binary 101)
                    tens <= 3'b000;  // Reset tens to 000 when it reaches 5
                end else begin
                    tens <= ts;  // Update tens with the value of ts
                end
            end else begin
                ones <= s;    // Update ones with the value of s
            end
        end
    end
endmodule
