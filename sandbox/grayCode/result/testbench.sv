module test;
  
  reg [3:0] in;
  wire [3:0] out;
  integer i;
  
  top inst(.bin_i(in),.gray_o(out));
  
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(1); // The '1' means it dumps the top level. Use '0' to dump all hierarchy levels.
    
    for(i=0; i<16; i=i+1) begin
      in = i;
      $display("in:%04b, out:%04b",in, out);
      #5;
    end

    #10 $finish; // Add a delay and finish the simulation!
    
  end
endmodule
