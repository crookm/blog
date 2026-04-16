---
title: Anvil
summary: |
    A Git Pages server for Forgejo and Gitea that serves static sites directly from repositories - intended for self-hosted Git platforms and self-hosters who want to publish static sites from their Forge installations.

repo_url: https://github.com/crookm/anvil

date: 2025-03-02
---

A custom implementation of a Pages server, which allows Git repositories to be used as the source for a static website.

## Why this project

I make use of Forgejo to host some random projects in a homelab environment, and I wanted to be able to host some websites out of it similar to Github and Gitlab Pages.

A pages server for Forgejo already exists, Codeberg's [pages-server](https://codeberg.org/Codeberg/pages-server), but I was having some trouble with its TLS management, and instead
wanted to build my own that simplified the implementation - no TLS support within the server itself, so it can be managed upstream with a system dedicated to the task, like Caddy.

Additionally, I was also interested in building a project like this myself. Please don't use this project in a high-scale production environment without performing a high-degree of
load testing, I have not done this myself.

## Features

* Stateless, self-contained system
* Serve static HTML, other media, directly from a repository
    * Including private repositories, depending on admin configuration
* Domains provided by the admin (`[repo.]user.pagesdomain`)
* Custom domain support
    * Defined with CNAME or TXT records, pointing to the provided domain
    * **NOTE**: TLS is not directly supported by this project, must be managed by the user with a reverse proxy, or by the admin with another project like Caddy