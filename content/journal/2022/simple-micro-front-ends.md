---
title: Simple Micro Front-Ends
slug: simple-micro-front-ends

description: |
    Like micro services, micro front-ends are a great way to separate domain knowledge away from your app, built
    and deployed separately to reduce complexity

date: 2022-09-02T08:35:03+12:00
---

I recently migrated my blog to [Hugo](https://gohugo.io) from a custom ASP .NET project, but I had some trouble thinking
of a way to bring my [projects](/projects) forward to this new way of doing things.

What I ultimately needed was a way to embed Blazor WASM inside Hugo generated pages, and I wanted to keep it free to
host through Cloudflare Pages or similar. There's no way to build, embed, and ship Blazor projects directly inside Hugo
(of course), so it has to be built separately and then stitched back into the site in some way.

This is where I started thinking about micro front-ends; re-usable components that are built and shipped separately from
main applications, which can be composed and designed in a similar way to micro services. Fit the domain knowledge into
the component, and expose it to the application using some interface.

All of this is a bit silly for my simple blog, but the way in which these micro front-ends are typically embedded into
pages are exactly perfect for the predicament I find myself in. So I went ahead and began evaluating the common options
for this against my requirements.

### Packaged component, built into main application

This idea doesn't really follow the "micro" ethos in my opinion, since you aren't building and shipping independently -
the main application must "know" about the component and its changes. But this option would involve building the
component externally, and then using those resources in the main application.

This might be something like shipping a nuget package, or maybe as a better idea for Hugo; an npm package.

### Reverse proxy pages

Maybe a better option would be to set up a reverse proxy, routing to different sources based on the path. For
example, `/projects/testing` might direct to a Blazor WASM project which hosts the entire page, as a self-contained
unit.
Every other path would direct to my generated Hugo blog as usual.

Nice and simple in concept, but I don't already use a reverse proxy like this, so hosting one would incur extra cost and
complexity for such a simple end result. I would also have to duplicate common page elements like navigation, which
would
be annoying to keep in-sync if I were to change anything.

### iFrames

The option I ended up using, a simple iFrame can be used to embed components on the page, and it can be styled to look
just like the parent. This way, you can use many lightweight components on a single page. For components which do things
considered sensitive, you will also need to make use of a reverse proxy, so you can configure
the [`X-FRAME-OPTIONS`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options) header to
be `SAMEORIGIN` to protect against attacks.

#### Dynamic sizing of frames

One drawback to this method is the size of the frame needed on the page - if the height is not static, it will need to
be updated dynamically. This means the component and the application need to communicate. I found a library which
handles this for you, called [iFrame Resizer](https://davidjbradshaw.github.io/iframe-resizer/).

So I went ahead with that last option; built and deployed the projects to Cloudflare Pages, stitched them into Hugo, and
it worked well! Feel free to have a look at my demo project, [Fridge Magnet](/projects/fridgemagnet), to give it a go.
The area with the form elements is an iFrame, which connects to a separate Cloudflare Pages project.  
