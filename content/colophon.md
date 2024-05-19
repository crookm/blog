---
title: Colophon
date: 2022-07-23T09:15:10+12:00
---

[This site](https://github.com/crookm/blog) is built using [Hugo](https://gohugo.io), a static site generator. Below is
a list of the tools I use to create and host it.

### Runtimes and dependencies
* [Hugo](https://gohugo.io)
* [Bootstrap 5](https://getbootstrap.com)

### Developer tooling and monitoring
* [Cloudflare Insights](https://www.cloudflare.com/insights)
* [Visual Studio Code](https://code.visualstudio.com)

### Infrastructure
This website is self-hosted on a server which turns itself off at night (UTC+12) to save energy, with WOL to turn back on when a request is made - resulting in a short delay for cold startups.

[Cloudflare](https://www.cloudflare.com) caching is used to serve from the edge as much as possible.

It ain't much, but it's honest work.
