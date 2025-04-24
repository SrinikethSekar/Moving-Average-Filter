module top(
            input   wire        clk     ,
            input   wire        reset   ,
            output  wire [9:0]  signal   ,
            input   wire        noise_en,
            input   wire [3:0] noise_level  
    );

    reg [9:0] addr;
    wire [7:0] data;
    wire [7:0] rand_out;
    sine_rom sine(
                    .addr(addr),
                    .data(data)
                  );
    
    random_noise_generator noise(                      
    .clk         ( clk            ),       
    .rst         ( reset            ),       
    .noise_en    ( noise_en       ),       
    .noise_level ( noise_level    ),     
    .rand_out    ( rand_out       )      
                  );
              always @(posedge clk)
                  begin 
                      if(reset)
                          addr <= 0;
                      else
                          begin
                                  addr <= addr + 1'b1;
                          end
                  end

                                  assign signal = data + rand_out;
endmodule
