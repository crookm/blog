---
title: Anvil Pages Server
summary: |
    An open source git-ops GitHub-like Pages server for Forgejo and Gitea.

date: 2025-03-25T19:26:53+13:00
---

A custom implementation of a Pages server for Forgejo and Gitea, which allows Git repositories to be used as the source for a static website.

It is written in .NET, using AOT compilation for speed, code generation for minimal APIs and logging, and `IOptionsSnapshot` for live configuration updates.

[View the project on Github &rarr;](https://github.com/crookm/anvil)

## Why this project

I make use of Forgejo to host some random projects in a homelab environment, and I wanted to be able to host some websites out of it similar to Github and Gitlab Pages.

A pages server for Forgejo already exists, Codeberg's [pages-server](https://codeberg.org/Codeberg/pages-server), but I was having some trouble with its TLS management, and instead wanted to build my own that simplified the implementation - no TLS support within the server itself, so it can be managed upstream with a system dedicated to the task, like Caddy.

Additionally, I was also interested in building a project like this myself. Please don't use this project in a high-scale production environment without performing a high-degree of load testing, I have not done this myself.
