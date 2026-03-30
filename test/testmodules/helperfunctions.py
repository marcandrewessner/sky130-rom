import cocotb
from cocotb.triggers import RisingEdge

from helperfunctions import reset

# Reset the device for N clock cycles
# clk up up up, release
async def reset(dut, n_clkcycles):
  dut.rst_n.value = 0
  for _ in range(n_clkcycles):
    await RisingEdge(dut.clk)
  dut.rst_n.value = 1