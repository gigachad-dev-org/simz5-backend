# Change these variables as necessary.
MAIN_PACKAGE_PATH := ./main.go
BINARY_NAME := simz

# ==================================================================================== #
# HELPERS
# ==================================================================================== #

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'


.PHONY: no_dirty
no-dirty:
	git diff --exit-code


# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

## tidy: format code and tidy modfile
.PHONY: tidy
tidy:
	go fmt ./...
	go mod tidy -v

## audit: run quality control checks (static checks, vulnerability etc.)
.PHONY: audit
audit:
	go mod verify
	go vet ./...
	go run honnef.co/go/tools/cmd/staticcheck@latest -checks=all,-ST1000,-U1000 ./...
	go run golang.org/x/vuln/cmd/govulncheck@latest ./...
	go test -race -buildvcs -vet=off ./...


# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

## run_db: run a local DB in a docker container, and return after health check (linux and WSL only)
.PHONY: run_db
run_db:
	docker compose -f ./docker-compose.yml up -d --force-recreate
	until [ "`docker inspect -f '{{.State.Health.Status}}' simz5-dev`" = "healthy" ]; do sleep 1; done

## build: build the application
.PHONY: build
build:
	go build -o ./build/${BINARY_NAME} ${MAIN_PACKAGE_PATH}

## run: build and run the application, without a local DB
.PHONY: run
run: build
	./build/${BINARY_NAME}

## run_docker: build and run the application, along with a local DB in a docker container (linux and WSL only)
.PHONY: run_all
run_all: build run_db run

# ==================================================================================== #
# DEPLOYMENT
# ==================================================================================== #
