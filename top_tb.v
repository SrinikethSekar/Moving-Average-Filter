module top_tb;
    reg   clk           ;
    reg   reset         ;
    wire [9:0]  signal  ;
    reg   noise_en      ;
    reg  [3:0] noise_level   ;
    wire [9:0] filtered_out    ;


    
  top inst (
      .clk          ( clk),
      .reset        (reset),
      .signal       (signal),
      .noise_en     (noise_en),
      .noise_level  (noise_level)
      );
 sliding_window_ma swma1(
      .clk      (   clk     )     ,
      .rst      ( reset     )     ,    
      .din      (    signal )     ,
      .dout     ( filtered_out)     
      );
 
  always #5 clk = ~clk;

  initial begin
      reset = 1;
          clk = 0;
          #10;
              reset = 0;
              noise_en = 1'b1;
              noise_level = 4'd10;
                  $dumpfile("dump.vcd");
                  $dumpvars;

                  #300000;
                  $finish;
  end
endmodule
                  
 
testbench
