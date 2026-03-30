import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge


def test_counter(dut):
  cocotb.log.info(dut)
  assert 1==1