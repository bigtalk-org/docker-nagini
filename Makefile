.PHONY: help setup-hooks cz-commit cz-bump lint build build-carbon test

help:
	@echo "Available targets:"
	@echo "  setup-hooks   Install pre-commit hooks locally"
	@echo "  cz-commit     Commit changes using commitizen interactive prompt"
	@echo "  cz-bump       Bump version and update CHANGELOG.md"
	@echo "  lint          Validate pre-commit configuration and files"
	@echo "  build         Build local Silicon container image"
	@echo "  build-carbon  Build local Carbon container image"
	@echo "  test          Run contract verification tests on local container"

setup-hooks:
	pre-commit install --hook-type commit-msg
	pre-commit install

cz-commit:
	cz commit

cz-bump:
	cz bump

lint:
	pre-commit run --all-files

build:
	docker build -t docker-nagini:silicon -f Dockerfile .

build-carbon:
	docker build -t docker-nagini:carbon -f Dockerfile.carbon .

test: build
	docker run --rm -v $(PWD):/code docker-nagini:silicon tests/sample_test.py
