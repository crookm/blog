---
title: First impression of the DigitalOcean App Platform
slug: first-impression-of-the-digitalocean-app-platform

description: I've been tinkering with the DigitalOcean App Platform, so I thought I'd share my experience with it so far

date: 2020-11-29T20:24:48+12:00
---

DigitalOcean is one of my favourite cloud providers, but it had always bothered me that they didn't really do any
managed services. This was way back in 2013, and much has changed now.

As with most new tech I try, my blog is always the first victim. The post you are reading is currently being served from
a DigitalOcean App instance, but not without some early fighting.

In this post, I'll outline my experience with the platform and give some opinions - as well as a wishlist for where
DigitalOcean goes next with the platform.

## Getting started

At the time of writing, the stack I use to develop this blog is not supported out-of-the-box. However, DigitalOcean Apps
can be built and run from a simple Docker container. This is great, but is mostly expected these days - especially when
comparing with the likes of Azure's App Service or Google App Engine. I imagine the .NET stack is not super popular with
their users.

You connect your code to the App platform via GitHub, which is super convenient. I found it very easy to work with, and
very pleased that I didn't have to set up a pipeline or GitHub action, though I may end up doing so anyway to integrate
unit testing.

### Configuration

Configuring was a breeze - I actually didn't have to do anything, save for writing a Dockerfile to host from. I was
given a subdomain and HTTPS certificate and it was all go. Easy!

I did, however, run into an issue when setting up my custom domain, which left me reasonably salty given I had entirely
bought-in to the platform after playing around. I was not able to use my root domain - subdomain only. I ended up using
an Azure App Service instance for a little while as they supported root domains, this is a hard requirement for me.

After checking into
a [community thread answer](https://www.digitalocean.com/community/questions/when-will-root-domains-be-available-in-app-platform?answer=64441)
regularly, they did end up adding support for root/apex domains after a soft release. This got me back on-board.

### Performance

I haven't done benchmarking or anything like that, but if you run an app that does anything a little more heavy, you'll
want to be on the "Pro" tier; which allows you to have dedicated CPUs. Otherwise, the lowest tier will probably have you
set for a very long time.

From what I can tell, it seems that the resources available at the different price-points are mapped 1:1 to Droplet
pricing - this appears par for the course with all of DigitalOcean's managed services.

### Web integration

App platform integrates quite nicely with CloudFlare, which is perfect for me. I had previously relied upon
CloudFlare's "Page Rules" to perform HTML caching, which limit you to three free rules. It was simple enough to output
some cache headers on my endpoints, which CloudFlare started caching on the edge. This appears to be unique for the App
platform.

### Developer experience

After pushing quite a few changes over the weekend in relatively rapid succession, the build service picked up the
changes on GitHub nearly instantly. I had one build get stuck and simply timed out, but because I had another build
pending after it I don't know how it would have handled - maybe it would retry?

I also saw some standard common sense with their build pipeline; it switches out deployments seamlessly. This is great
for longer builds, and of course failed deployments. Great to see!

## Final notes

DigitalOcean's App Platform is quite a fabulous little service that makes it easy to deploy code without having to
manage a virtual machine.

My wishlist for its future is relatively small - I'm quite happy with the platform as it stands, and can't wait to use
it for some other projects.

What I do hope they will consider is integration of the app dashboard into the main dashboard - I don't like that its
separate from all my other resources.

I also wish that DigitalOcean considers a serverless option, specifically built into the App Platform itself. I imagine
this is the perfect platform for it.

So that's my first impression of the DigitalOcean App Platform! If you would like to give it a go, you can register for
an account with my [referral link](https://m.do.co/c/f8ffd8a5f356) to get us both some free credit.
