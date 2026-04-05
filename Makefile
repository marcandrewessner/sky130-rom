.DEFAULT_GOAL := all
TEST_RUNNER   := cd test && python -m runner
TESTS         := $(shell $(TEST_RUNNER) list-tests)

KLAYOUT_TECH := $(PDK_ROOT)/ciel/sky130/versions/8afc8346a57fe1ab7934ba5a6056ea8b43078e71/sky130A/libs.tech/klayout/tech/sky130A.lyp

.PHONY: all build test $(TESTS)

all: test build

# Run librelane and create a symlink to the latest run. (Note: -librelane => dont stop if error)
build:
	-librelane --flow classic librelane_config.json
	@ln -sfn $$(basename $$(ls -dt runs/RUN_* | head -1)) runs/LAST_RUN

# Run all discovered testmodules
test: $(TESTS)

# One target per testmodule — run with: make test_<name>
$(TESTS):
	$(TEST_RUNNER) run $@


# Open tools
.PHONY: open-klayout-gds open-gds
open-klayout-gds:
	klayout build/klayout_gds/*.gds -l $(KLAYOUT_TECH)

open-gds:
	klayout build/gds/*.gds -l $(KLAYOUT_TECH)

.PHONY: clean
clean::
	@rm -rf test/sim_build
	@rm -rf runs/*