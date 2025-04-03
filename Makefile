TAG := $(shell git describe --tags --abbrev=0)

help: ## Show this help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

docs: ## Build unified docs
	pulp-docs build

servedocs: ## Serves unified docs
	pulp-docs serve

pulp-minimal-custom: ## Build pulp-minimal-custom stable images
	docker build \
	    --no-cache \
		--file images/pulp-minimal-custom/stable/Containerfile.core \
		. \
		--tag pulp-minimal-custom:custom-stable \
		--tag pulp-minimal-custom:$(TAG)
	docker build \
	    --no-cache \
		--build-arg FROM_TAG="$(TAG)" \
		--file images/pulp-minimal-custom/stable/Containerfile.webserver \
		. \
		--tag pulp-web-custom:custom-stable \
		--tag pulp-web-custom:$(TAG)

pulp-custom-nightly: ## Build pulp-custom nightly images
	docker build \
	    --no-cache \
		--file images/pulp-custom/nightly/Containerfile \
		. \
		--tag pulp-custom:custom-latest

pulp-minimal-custom-nightly: ## Build pulp-minimal-custom nightly images
	docker build \
	    --no-cache \
		--file images/pulp-minimal-custom/nightly/Containerfile.core \
		. \
		--tag pulp-minimal-custom:custom-latest
	docker build \
	    --no-cache \
		--build-arg FROM_TAG="$(TAG)" \
		--file images/pulp-minimal-custom/nightly/Containerfile.webserver \
		. \
		--tag pulp-web-custom:custom-latest

.PHONY: docs servedocs help pulp-minimal-custom pulp-custom-nightly pulp-minimal-custom-nightly
