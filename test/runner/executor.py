from pathlib import Path
from .discovery import find_testbench, TestbenchNotFoundError
from .sources import get_verilog_sources
from .paths import TESTBENCH_ROOT, WAVES_ROOT, DUMPWAVE_OUT, DUMPWAVE_TEMPLATE

from cocotb_tools.runner import get_runner


def run_test(testmodule, fst_wave=True):
  tb = find_testbench(testmodule)
  sources = get_verilog_sources()
  if fst_wave:
    sources = sources + [build_dumpwave(testmodule, tb)]
  # TODO: configure and invoke cocotb runner
  print(f"running {testmodule} against {tb} with sources {sources}")
  runner = get_runner("icarus")
  runner.build(
      sources=sources,
      hdl_toplevel=tb,
      always=True,
  )
  runner.test(hdl_toplevel=tb, test_module=testmodule)

def build_dumpwave(testmodule, testbench, depth=0):
  """Render the dumpwave template for testmodule and write it to /tmp/__dumpwave__.sv."""
  wavepath = (WAVES_ROOT / f"{testmodule}.fst").resolve()
  rendered = DUMPWAVE_TEMPLATE.read_text().format(
    WAVEPATH  = wavepath,
    DEPTH     = depth,
    TESTBENCH = testbench,
  )
  DUMPWAVE_OUT.write_text(rendered)
  return DUMPWAVE_OUT