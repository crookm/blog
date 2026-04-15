---
title: WashZen

repo_url: https://github.com/crookm/washzen
embed_frame_url: https://matt-washzen.pages.dev

date: 2025-10-13
---


A simple project to calculate how long you should use the 'delay' function on your dishwasher or clothes washer, to finish at a specific time. Useful for setting up your washer to be done when you get home!

This is a toy project I am using to learn Rust in WASM.

## Building

This project uses Leptos, specifically the client-side rendering variant of it. To build and run, you will need to follow the instructions available in
the [Getting Started](https://book.leptos.dev/getting_started/index.html) section of the Leptos book.

As an overview:
1. Install Trunk: `cargo install trunk`
2. Install the WASM Rust target: `rustup target add wasm32-unknown-unknown`
3. Run with: `trunk serve --open` (in the root of the project)
4. Build with: `trunk build --release`