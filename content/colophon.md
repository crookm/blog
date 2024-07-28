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
* [DigitalOcean App Platform](https://m.do.co/c/f8ffd8a5f356) (referral link)

This website is hosted on the DigitalOcean app platform as a static site in the SYD region (rejoice! an APAC region, finally!).

The build is managed and run in the app platform when the [respository](https://github.com/crookm/blog) is updated, defined using a [Dockerfile](https://github.com/crookm/blog/blob/main/Dockerfile) for simplicity - the automatic buildpack selection is super not helpful when you are using Go to manage Hugo dependencies.
