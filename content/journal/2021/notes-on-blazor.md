---
title: Notes on Blazor
slug: notes-on-blazor

description: |
  Blazor is a neat new client web application framework, allowing apps to be built using C# - these are some of the notes
  I have after using it for a bit

date: 2021-10-01T18:55:00+12:00
---

At work, I have started using Blazor as the base for a new web project - and I have compiled some notes that I would
like to share about my experience with it so far. There is no particular format or ordering here. Also note that I am
still only exploring Blazor, my notes are generally in comparison to some other similar web technologies.

Without further ado, begin brain-dump;

* Being able to re-use class libraries and components from existing .NET projects is huge
* Quite easy to pick up, particularly if you're at all familiar with ASP.NET
* Remember that the code that is published with WebAssembly is publicly decompile-able - much like how you wouldn't
  connect directly to a database, you shouldn't reference projects which contain sensitive code (like license key
  generators)
* WebAssembly Blazor is definitely the more attractive project type, server-based Blazor has the drawback of requiring
  an active connection for the entire lifetime of the application - I have seen Blazor apps that stopped working while I
  was reading some text, because it lost connection to the server. It was probably just a poorly implemented app, but it
  gave me a moment of pause
* The benefit of having a web application as a first-class csproj is clear, interacting with the project is simple
  inside of Visual Studio / Rider, and organisation is similar to ASP.NET and WPF projects (thinking like CSS files
  presented as WPF 'code behind' files if they are named similarly to a Blazor component file)
* You'll probably still want to use a server API, and you'll definitely be wanting to implement JWT-like authentication
  for that - the application I was developing uses single-tenant AAD auth,
  and [this guide](https://docs.microsoft.com/en-us/aspnet/core/blazor/security/webassembly/hosted-with-azure-active-directory?view=aspnetcore-5.0)
  was perfect for securing the client and server side together
* WebAssembly definitely shines with a CDN in front for speedy delivery of comparatively large assets that all need to
  be downloaded up-front, but:
* Deployment in tandem with a CDN seems precarious, because if any of the binaries don't match the manifest, the
  application breaks - this can be an issue where the new version's manifest is served, but some of the old version's
  binaries are cached
* Probably wouldn't use Blazor for a home page or news site just yet, plain HTML would still reign king for that - but
  complex applications in the browser seem like a perfect fit

End of brain-dump.

I might come back and add more things here as I go, but that is about where I'm at with the technology so far.

Generally I am pleased however, I think this might stick with me and find their way into my own personal projects.
