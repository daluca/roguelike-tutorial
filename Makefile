PROJECT_NAME = $(notdir $(CURDIR))

.PHONY: help
help:
	@printf "usage: make [argument]\n\n"
	@printf "arguments:\n"
	@printf "\thelp\t\tprint this help then exit\n"
	@printf "\trun\t\trun game on website with docker and WASM\n"
	@printf "\tbuild\t\tbuild WASM binary\n"
	@printf "\tupdate\t\tupdate crate versions\n"
	@printf "\tclean\t\tremove temporary files\n"

.PHONY: run
run: docker-run

.PHONY: build
build: target/wasm/$(PROJECT_NAME).js

.PHONY: update
update: cargo-update

.PHONY: cargo-build
cargo-build:
	@cargo build --release --target wasm32-unknown-unknown

.PHONY: cargo-update
cargo-update:
	@cargo update

.PHONY: docker-build
docker-build: wasm/index.html wasm/$(PROJECT_NAME).js
	@docker buildx build --tag daluca/$(PROJECT_NAME):latest --file docker/Dockerfile .

.PHONY: docker-stop
docker-stop:
	@docker stop $(PROJECT_NAME) >/dev/null 2>&1 || true

.PHONY: docker-run
docker-run: docker-stop build html
	@docker run -d --rm --name $(PROJECT_NAME) -p 8000:80 -v ${PWD}/target/wasm:/usr/share/nginx/html nginx:alpine >/dev/null
	@echo deployed on http://localhost:8000/

.PHONY: html
html: target/wasm/index.html

target/wasm/:
	@mkdir target/wasm/

target/wasm/index.html: target/wasm/
	@cp resources/index.html target/wasm/

target/wasm/$(PROJECT_NAME).js: cargo-build
	@wasm-bindgen target/wasm32-unknown-unknown/release/$(PROJECT_NAME).wasm --out-dir target/wasm/ --no-modules --no-typescript

.PHONY: clean
clean:
	@rm -rf target/
