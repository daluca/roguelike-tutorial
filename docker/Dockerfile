FROM rust:1-buster AS build

COPY ./ ./

RUN cargo install cargo-make \
    && cargo make release

FROM nginx:1.23.2-alpine

RUN apk upgrade --update-cache

COPY --from=build static/ /usr/share/nginx/html/
