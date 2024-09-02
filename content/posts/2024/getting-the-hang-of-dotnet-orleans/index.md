---
title: Getting the Hang of .NET Orleans
slug: getting-the-hang-of-dotnet-orleans

categories: Engineering
tags:
  - learning
  - dotnet

date: 2024-09-02T22:29:04+12:00
---

I like to challenge myself to learn new things, particularly around my profession, and one such thing I had been considering for a while
was [.NET Orleans](https://learn.microsoft.com/en-us/dotnet/orleans/overview). For me, it represents quite a significant shift in how I think about architecture - and that made me
a little nervous! Nevertheless, it was time I had given it a go, to see how it might fit in my toolbox.

## What it is

Orleans is a framework to implement the 'actor model' pattern in .NET - I haven't read the research papers around such a thing, so I can't really summarise the specific details of
what that is. However, my understanding of it implemented in practice by Orleans is that it is a method of structuring and partitioning your application around 'business domain
objects' - meaningful self-contained entities which contain their own logic to mutate their state and perform actions.

These 'grains', in Orleans parlance, are hosted within a cluster of 'silos' or servers. Grains 'always exist' and are always addressable via their identities, never created or
destroyed. The Orleans framework manages the persistence of their state against a backing store, and loading/unloading the actors into memory as resources permit.

Individual grains are executed single-threaded, which allows an engineer to be less concerned with common issues with distributed systems like concurrency.

The attraction with the Orleans framework is that it affords simplicity when building highly distributed systems, the mental overhead is consistent regardless of how many servers
you are running your application from, or how much traffic you are handling.

## Understanding the paradigm

In a nutshell, your grains are just like singleton classes which have state and logic methods. You reference these grains in your controllers or whatever by identifiers like guids,
strings, ints etc - the runtime will instantiate the grain if it isn't already active, but this isn't something your code would be aware of. The reference will either be
in-process (if you host your silo in the same project as your API etc), or transparently proxy to another server depending on placement. Only one instance exists of a single
identifiable grain at a time.

Here's a toy example of a blog system which allows adding 'likes' to posts via an API:

```cs
// Grains/BlogPostGrain.cs

public class BlogPostGrain(
    [PersistentState(stateName: "post", storageName: "posts")]
    IPersistentState<BlogPost> state)
    : Grain, IBlogPostGrain
{
    public async ValueTask AddLike()
    {
        state.State.Likes++;
        await state.WriteStateAsync();
    }

    [ReadOnly] // Optimisation for method which alters no state
    public ValueTask<int> GetLikes() => ValueTask.FromResult(state.State.Likes);

    [ReadOnly]
    public ValueTask<string> GetContent() => ValueTask.FromResult(state.State.Content ?? "Nothing here");

    // ...
}

[GenerateSerializer, Alias(nameof(BlogPost))]
public sealed record class BlogPost
{
    [Id(0)]
    public int Likes { get; set; }

    [Id(1)]
    public string? Content { get; set; }
}
```

```cs
// Controllers/BlogController.cs

public class BlogController(IGrainFactory grainFactory) : ControllerBase
{
    [HttpPost]
    public async Task<IActionResult> AddLike(Guid postId)
    {
        var post = grainFactory.GetGrain<BlogPostGrain>(postId);
        await post.AddLike();
        return Ok();
    }

    [HttpGet]
    public async Task<IActionResult> GetLikes(Guid postId)
    {
        var post = grainFactory.GetGrain<BlogPostGrain>(postId);
        var likes = await post.GetLikes(); // It'll be `0` if the post doesn't exist
        return Ok(likes)
    }
}
```

Because grains are single threaded, you don't need to be super concerned with concurrency - a concern in particular if what you were doing was not against a database, perhaps
orchestrating calls to several different APIs or something. All other method calls for the individual grain must wait until your non-`[ReadOnly]` method is completed, unless you
annotate your grain class with `[Reentrant]` to allow concurrent requests while `await`ing - [the docs](https://learn.microsoft.com/en-us/dotnet/orleans/grains/request-scheduling)
explain this really well.

## What I like

* The implementation of the framework is in the runtime
    * No need for an Azure PaaS integration like Fabric or Durable Functions, Dapr
* Works really nicely with Azure table storage
    * Real shame because I don't want to use Azure, but table storage is one of the few Azure services that I'd say are absolutely excellent no notes
* Really nice devex features like source generators and analysers
* Laser focus by the maintainers around improving performance, low-level features
* Allows for stateful services, if one feels the need to be like that

## What I don't like

* Built-in event sourcing persistence packages are lacking
* Lack of documentation (for things which matter)
* Database (ADO.NET) persistence setup is terrible
    * Ideally, I think it should work like EF, but you have to run raw SQL scripts yourself to set it up - and these are hard to find, and not very well organised
* Few recommendations of how to build things
    * You can do pretty much anything, and it's 'correct' - not helpful for people new to the framework, guidance would be great
* While the mental overhead of the architecture is consistent, it is consistently high from the beginning
    * The earlier point of there being 'few recommendations of how to build things' is relevant here
* Doesn't quite 'fit' with the clean architecture approach
    * All your models have to be annotated with Orleans-specific attributes, as an example (leaking implementation details)
* Stateful services feel wrong, and they absolutely should

## In summary

While it's exciting to learn and put into practice a framework which is highly regarded as 'S-tier', one very important aspect needs to be considered: are the benefits it brings
actually needed right now in your project?

As I was exploring Orleans, I couldn't help but feel like simpler frameworks are a better fit for most tasks - every very high scale ones; Entity Framework, Marten and the like.

Initially I went all-in with Orleans on a toy project to give it a good shake. The whole time I was uncomfy. It wasn't a skill issue or anything like that, but I found myself
refactoring more and more of the logic away from the grains - the richer, more common frameworks felt like a much better fit because I was able to move much faster with less code.
Eventually it got to the point where my grains were only storing the state in my project, and when I realised that I knew it was time to stop.

A bad framework? I don't think so - it certainly has a place in very high scale, low latency situations: there's a reason why everyone talks about how it was used for Halo
multiplayer. There's just too much 'groundwork' that has to be written for my comfort. I guess it would be worthwhile to be working at such low levels of a framework, if you were
part of a larger team with very specific requirements around performance and scalability.

For me, I believe complexity should always be in response to a real and measurable need - I personally don't believe I will ever have a need to use Orleans. It was still a
worthwhile exercise to try it out, I know more now than I did before.
