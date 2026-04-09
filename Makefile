.DEFAULT_GOAL := all

TEST_RUNNER   := cd test && python -m runner
TESTS         := $(shell $(TEST_RUNNER) list-tests)
PDK_FAMILY		:= sky130
PDK_VERSION		:= 8afc8346a57fe1ab7934ba5a6056ea8b43078e71
PDK_PATH			:= $(shell ciel path --pdk $(PDK_FAMILY) $(PDK_VERSION)) #using PDK_PATH and not PDK_ROOT because PDK_ROOT is used for ciel
PDK_PATH			:= $(strip $(PDK_PATH))

.PHONY: all build test $(TESTS) init-env

all: test build

# Initialize the environment: install and enable the PDK via ciel (idempotent via .envinitialized)
init-env:
	@if [ -f .envinitialized ]; then \
		echo "Environment already initialized (.envinitialized exists). Skipping."; \
	else \
		echo "Initializing environment: fetching PDK $(PDK_FAMILY) @ $(PDK_VERSION)..."; \
		ciel enable --pdk $(PDK_FAMILY) $(PDK_VERSION) && \
		touch .envinitialized && \
		echo "Environment initialized successfully."; \
	fi

# Run librelane and create a symlink to the latest run. (Note: -librelane => dont stop if error)
build:
	-librelane --flow classic librelane_config.json
	@ln -sfn $$(basename $$(ls -dt runs/RUN_* | head -1)) runs/LAST_RUN

# Run all discovered testmodules
test: $(TESTS)

# One target per testmodule — run with: make test_<name>
$(TESTS):
	$(TEST_RUNNER) run $@


# ============== OPEN TOOLS ==============
.PHONY: open-klayout-gds open-gds open-magic-sky130A
KLAYOUT_TECH := $(PDK_PATH)/sky130A/libs.tech/klayout/tech/sky130A.lyp
open-klayout-gds:
	klayout build/klayout_gds/*.gds -l $(KLAYOUT_TECH)

open-gds:
	klayout build/gds/*.gds -l $(KLAYOUT_TECH)

open-magic-sky130A:
	PDK_ROOT=$(PDK_PATH) magic -rcfile $(PDK_PATH)/sky130A/libs.tech/magic/sky130A.magicrc

.PHONY: clean
clean::
	@rm -rf test/sim_build
	@rm -rf runs/*