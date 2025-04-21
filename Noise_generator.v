module random_noise_generator (
    input wire clk,        
    input wire rst,        
    input wire noise_en,  
    input wire [3:0] noise_level,
    output reg [7:0] rand_out 
);

    reg [7:0] lfsr; 
    reg [7:0] noise_mask;

   
    always @(posedge clk or posedge rst) begin
        if (rst)
            lfsr <= 8'hA5; // Initial seed
        else begin
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            noise_mask <= 8'b0;
        else begin
            noise_mask[0] <= (lfsr[0] & (noise_level > 4'd0))  ? ~lfsr[0] : 1'b0;
            noise_mask[1] <= (lfsr[1] & (noise_level > 4'd2))  ? ~lfsr[1] : 1'b0;
            noise_mask[2] <= (lfsr[2] & (noise_level > 4'd4))  ? ~lfsr[2] : 1'b0;
            noise_mask[3] <= (lfsr[3] & (noise_level > 4'd6))  ? ~lfsr[3] : 1'b0;
            noise_mask[4] <= (lfsr[4] & (noise_level > 4'd8))  ? ~lfsr[4] : 1'b0;
            noise_mask[5] <= (lfsr[5] & (noise_level > 4'd10)) ? ~lfsr[5] : 1'b0;
            noise_mask[6] <= (lfsr[6] & (noise_level > 4'd12)) ? ~lfsr[6] : 1'b0;
            noise_mask[7] <= (lfsr[7] & (noise_level > 4'd14)) ? ~lfsr[7] : 1'b0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            rand_out <= 8'b0;
        else if (noise_en)
            rand_out <= lfsr ^ noise_mask; // Inject noise
        else
            rand_out <= lfsr; // Clean output
    end

endmodule
