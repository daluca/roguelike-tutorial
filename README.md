# Rougelike tutorial

Following along with this [tutorial](https://bfnightly.bracketproductions.com/)

## Prerequisites

### rustup

```shell
rustup target add wasm32-unknown-unknown
cargo install wasm-bindgen-cli
cargo install cargo-make
cargo install wasm-pack
cargo install simple-http-server
cargo install cargo-watch
```

### Arch Linux

```shell
pacman -Sy rust rust-analyzer rust-wasm rust-bindgen cargo-make wasm-pack simple-http-server cargo-watch
```

## Run in docker

```shell
make run
```
