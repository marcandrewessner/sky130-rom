.DEFAULT_GOAL := all
TEST_RUNNER   := cd test && python -m runner
TESTS         := $(shell $(TEST_RUNNER) list-tests)

.PHONY: all build test clean $(TESTS)

all: test build

build:
	librelane --flow classic librelane_config.json

# Run all discovered testmodules
test: $(TESTS)

clean::
	@rm -rf test/sim_build
	@rm -f test/testmodules/results.xml

# One target per testmodule — run with: make test_<name>
$(TESTS):
	$(TEST_RUNNER) run $@
