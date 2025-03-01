FROM ghcr.io/hugomods/hugo:ci-0.145.0 AS build
WORKDIR /src

COPY . ./
RUN hugo --environment production --cleanDestinationDir --minify --panicOnWarning -d /out
