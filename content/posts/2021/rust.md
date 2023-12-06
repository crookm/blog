---
title: Rust
date: 2021-12-07T22:00:00+12:00

categories: Development
tags:
  - rust
---

The Rust programming language has been one of those things that I want to get into, but have just been struggling to get my head around. I've seen the light, but how the hell do I use it? From the outside, it looks so different to anything I've used before.

For example; I had learned to program originally in PHP, but when I realised that it was certainly not the language for me long-term, I was able to step into C# with very little resistance. I've found myself having to read documentation very frequently with Rust, it's not as intuitive in comparison.

That being said, the effort that has gone into education with Rust is phenomenal. The compiler errors are quite clear and visual, and there are help commands that give you examples on errors, and how to get around them. This is primarily how I had been learning: find a thread from the web and the Rust docs to give me examples on what I'm trying to do, coding it, and then using the help commands when it inevitably goes wrong.

Additionally, the build system through Cargo work exactly as I had hoped it would. The projects I work on tend to be quite complicated, with many external dependencies in different languages - and I'm of the opinion that each individual application/library/crate/etc should be responsible for wrangling its own dependencies at build time, so I was pretty thrilled when I found out about [Cargo build scripts](https://doc.rust-lang.org/cargo/reference/build-scripts.html). The build script for one of my Rust projects builds a .NET project, and consumes its output. It works pretty well!

So yeah, I keep getting these little tastes of Rust, and I'm liking what I'm seeing so far.