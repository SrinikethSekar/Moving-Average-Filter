module sliding_window_ma #(
    parameter N = 15,                 // Window size
    parameter DATA_WIDTH = 10         // Data width
) (
    input wire clk,                   // Clock signal
    input wire rst,                   // Reset signal
    input wire signed [DATA_WIDTH-1:0] din,  // Input data
    output reg signed [DATA_WIDTH-1:0] dout  // Moving average output
);

    // Register array to store last N values (FIFO)
    reg signed [DATA_WIDTH-1:0] buffer[N-1:0];
    reg signed [DATA_WIDTH+3:0] sum;  // Wider sum register to avoid overflow
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset sum and buffer
            sum <= 0;
            dout <= 0;
            for (i = 0; i < N; i = i + 1)
                buffer[i] <= 0;
        end else begin
            // Subtract oldest value, add new value
            sum <= sum - buffer[N-1] + din;

            // Shift values in buffer (FIFO behavior)
            for (i = N-1; i > 0; i = i - 1) begin
                buffer[i] <= buffer[i-1];
            end
            buffer[0] <= din;

            // Compute average
            dout <= sum / N;
        end
    end

endmodule