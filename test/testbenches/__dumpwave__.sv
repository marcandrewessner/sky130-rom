module __dumpwave__;
  initial begin
    $dumpfile("{WAVEPATH}");
    $dumpvars({DEPTH}, {TESTBENCH});
  end
endmodule
