include ./vendor/mk/*.mk

REPO := https://github.com/RedHatProductSecurity/oscal-automation-libs.git
BRANCH := main
SHELL := /bin/bash
SCRIPTS_DIR := "./vendor/scripts"
CONFIGS :=$(shell bash scripts/get_config_updates.sh)

############################################################################
## Environment setup
############################################################################

update-subtree:
	@git subtree pull --prefix vendor/ "$(REPO)" "$(BRANCH)" --squash
.PHONY: update-subtree

############################################################################
## Component Definition Custom tasks
############################################################################

# $1 - config path
define update-cd
echo $(1)
trestle task csv-to-oscal-cd -c $(1);
endef

update-cds:
	@source $(SCRIPTS_DIR)/trestle.sh && $(foreach f,$(CONFIGS),$(call update-cd,$(f)))
.PHONY: update-cd

check-csv:
	@bash scripts/csv_sanity_check.sh

trestlebot-install:
	@python3 -m pip install --upgrade pip setuptools && python3 -m pip install -r requirements.txt
.PHONY: trestlebot-install