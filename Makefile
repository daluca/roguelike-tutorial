PROJECT_NAME = $(notdir $(CURDIR))

.PHONY: help
help:
	@printf "usage: make [argument]\n\n"
	@printf "arguments:\n"
	@printf "\thelp\t\tprint this help then exit\n"
	@printf "\trun\t\trun game on website with docker and WASM\n"
	@printf "\tbuild\t\tbuild WASM binary\n"
	@printf "\tclean\t\tremove temporary files\n"

.PHONY: run
run: docker-run

.PHONY: build
build: wasm/$(PROJECT_NAME).js

.PHONY: cargo-build
cargo-build:
	@cargo build -q --release --target wasm32-unknown-unknown

.PHONY: docker-build
docker-build: wasm/index.html wasm/$(PROJECT_NAME).js
	@docker buildx build --tag daluca/$(PROJECT_NAME):latest --file docker/Dockerfile .

.PHONY: docker-stop
docker-stop:
	@docker stop $(PROJECT_NAME) >/dev/null 2>&1 || true

.PHONY: docker-run
docker-run: docker-stop build html
	@docker run -d --rm --name $(PROJECT_NAME) -p 8000:80 -v ${PWD}/wasm:/usr/share/nginx/html nginx:alpine >/dev/null
	@echo deployed on http://localhost:8000/

.PHONY: html
html: wasm/index.html

wasm/:
	@mkdir wasm

wasm/index.html: wasm/
	@cp resources/index.html wasm/

wasm/$(PROJECT_NAME).js: cargo-build
	@wasm-bindgen target/wasm32-unknown-unknown/release/$(PROJECT_NAME).wasm --out-dir wasm --no-modules --no-typescript

.PHONY: clean
clean:
	@rm -rf target/ wasm/
