// Bin2 gray
module top(
  input logic [3:0] bin_i,
  output logic [3:0] gray_o
);
  
  // Binary to Gray conversion
  function automatic logic [3:0] bin2gray (input logic [3:0] bin);
    return bin ^ (bin >> 1);
  endfunction
  
  assign gray_o = bin2gray(bin_i);

endmodule