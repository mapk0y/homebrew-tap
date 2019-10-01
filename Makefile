SHELL := /bin/bash
FORMULAS ?= $(shell find . -maxdepth 1 -type f -name '*.rb' -exec basename {} .rb \;)
TEST_CONTAINER_NAME := brew-test-docker

.PHONY: default
default: help

.PHONY: help help-common
help: help-common help-docker-test-fomulas help-test-fomulas

help-common:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m %-40s\033[0m %s\n", $$1, $$2}'

.PHONY: test
test: $(addprefix test-,$(FORMULAS))

.PHONY: setup-test-docker clean
setup-test-docker: ## linuxbrew/linuxbrew の docker コンテナを起動
	if [[ $$(docker ps -f name=$(TEST_CONTAINER_NAME) -q | wc -l) -eq 0 ]]; \
	then \
	  docker run -itd --name $(TEST_CONTAINER_NAME) -v ${PWD}:/work -w /work --rm linuxbrew/linuxbrew bash; \
	fi

clean: ## テスト用の docker を停止
	docker stop $(TEST_CONTAINER_NAME)

define test-formula
PHONY: docker-test-$(1) help-docker-test-$(1) test-$(1) help-test-$(1)
docker-test-$(1): setup-test-docker
	docker exec -it $(TEST_CONTAINER_NAME) make test-${1}

help-docker-test-$(1):
	@printf "\033[36m %-40s\033[0m %s\n" "docker-test-$1" "$1 のインストールとテストを docker 内で実施"

test-$(1):
	 brew install ./$(1).rb
	 brew test ./$(1).rb

help-test-$(1):
	@printf "\033[36m %-40s\033[0m %s\n" "test-$1" "$1 のインストールとテストを実施"
endef

$(foreach _formula,$(FORMULAS),$(eval $(call test-formula,$(_formula)))): # プロビジョニングで実行される task と各 tag の一覧を表示

help-docker-test-fomulas: $(addprefix help-docker-test-,$(FORMULAS))
help-test-fomulas: $(addprefix help-test-,$(FORMULAS))
