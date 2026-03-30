

module counter (
  input logic clk_i,
  input logic rst_ni,

  output logic [7:0] data_o
);
  
  // Now we have a counter here
  logic [7:0] count_d, count_q;

  assign data_o = count_q;

  always_comb begin
    count_d = count_q + 1;
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
      count_q <= 0;
    end
    else begin
      count_q <= count_d;
    end
  end

endmodule