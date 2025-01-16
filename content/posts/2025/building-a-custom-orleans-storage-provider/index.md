---
title: Building a Custom Orleans Storage Provider

categories: Engineering
tags:
  - learning
  - dotnet

date: 2025-01-16T12:31:51+13:00
---

When I'm trying to learn a new framework like [Orleans]({{< relref "getting-the-hang-of-dotnet-orleans" >}}), I find it useful to build something with it to really give it a good shake. This usually involves some project built on top of it (often incomplete, as per), but I wanted to really dig into Orleans in particular - a lot deeper than I would normally. To that end, I wanted to build a custom data persistence provider.

Oreans needs some kind of permanent backend storage system for a few reasons: acting as a check-in location to identify and co-ordinate with other servers to form a cluster, and permanently store grain and reminder state. There are a few built-in providers for various services like Azure Table Storage and ADO .NET (SQL) - with the former being the one with the least friction to get started with. I have issues with the ADO .NET provider, because it requires finding and running loose SQL scripts from all over the Orleans repo which doesn't really jive with me. The Azure Table provider, of course, requries me to host with Azure to some extent.

There are of course other user-contributed libraries for EF and Mongo among others, but really I just want to use the systems and tooling I'm already using - in this case [Marten](https://martendb.io/), which is a transactional document database abstraction over Postgres.

So that's the challenge then; I wanted to build a suite of provider libraries using Marten to support clustering, state persistence, and reminders in Orleans.

There's not a huge amount of documentation of how to do this (there was some light information about custom state persistence providers), I guess because it isn't super common - but I was able to make some inferences from the built-in providers.

Fortunately, the implementation for all the things I wanted to do was relatively simple - I just had to implement and register a bunch of interfaces, and the Orleans runtime would manage the rest.

## Implementations

### State persistence

I started with implementing state persistence, because I figured it would be the easiest. I wasn't wrong - just needed to implement [`IGrainStorage`](https://github.com/interflare/orleans-marten/blob/5a68a623f6d60239ca3ae024609e05d68c4307a7/src/Orleans.Providers.Marten.Persistence/MartenGrainStorage.cs) which had methods for reading, writing, and clearing individual state documents.

With most of these Orleans providers, optimistic concurrency is a must. I was able to make use of Marten's [`IVersioned`](https://martendb.io/documents/concurrency.html#using-iversioned) interface on the schema/doc definitions to allow the system to handle all of this for me, in combination with the `IDocumentSession.UpdateExpectedVersion(TDoc, Guid)` method when updating. What I didn't realise is that Marten doesn't offer a similar method for deleting an expected version. Maybe that isn't common? Easily solved by just loading the record and comparing the version manually, though.

Something I forgot initially when putting this provider together was the Orleans serializer. I started by using System.Text.Json, but then I remembered that Orleans likes to get a bit fancy with the serialization. That was a bit unusual - I had to register a class for `IOptions` which extends `IStorageProviderSerializerOptions`, with some strangeness to initialise it with the default if not provided:

```csharp {hl_lines=[5]}
public static IServiceCollection AddMartenGrainStorage(this IServiceCollection services, string name)
{
    services.ConfigureMarten(options => options.ConfigurePersistence());
    services.AddOptions<MartenGrainStorageOptions>(name);
    services.AddTransient<IPostConfigureOptions<MartenGrainStorageOptions>, DefaultStorageProviderSerializerOptionsConfigurator<MartenGrainStorageOptions>>();
    return services.AddGrainStorage(name, MartenGrainStorageFactory.Create);
}
```

### Clustering

Next up was clustering, also known as the Orleans "membership protocol".

Orleans uses a persistence provider to act as a common meeting point for other servers to register themselves as part of a cluster, as well as defining their ports and ip addresses for connection. A number of other servers will connect-up to the new server, as well as advertise the new connections to their other connected servers ('gossip'), so that the network is updated quicker than the configured period for checking with the clustering provider. Servers will also 'suspect' (vote) on their connected servers for liveness through the provider, marking it as dead if it meets the threshhold of votes.

Implementing this was a little more complicated because there were more methods, but also more concepts to get my head around. There were two interfaces to implement: [`IMembershipTable`](https://github.com/interflare/orleans-marten/blob/5a68a623f6d60239ca3ae024609e05d68c4307a7/src/Orleans.Providers.Marten.Clustering/MartenClusteringTable.cs) (used by the cluster itself) and [`IGatewayListProvider`](https://github.com/interflare/orleans-marten/blob/396516ef488f90e400c9931516ff46a25d627e71/src/Orleans.Providers.Marten.Clustering/MartenGatewayListProvider.cs) (used by external clients to find their way into the cluster - if used at all).

The concepts that got me tripped up were the way clusters were defined - there is a `ServiceId` and a `ClusterId` (previously known as a `DeploymentId`). The service is supposed to be constant, but the cluster id _may_ change. I figured that for a clustering provider library, this would mean there is some degree of 'tenanting' by these identifiers. But was it just for the service id or cluster id? It seemed that some of the existing providers I was looking at had different ideas about this as well - expecting the cluster id to be globally unique, and I think others were looking at just the service id.

I finally came to the conclusion that the clusters should be entirely separated given a composite identifier of `ServiceId+ClusterId`, when I read [the docs](https://learn.microsoft.com/en-us/dotnet/orleans/host/configuration-guide/server-configuration#orleans-clustering-information) for configuring a cluster in passing, that clusters with the same **cluster id** may connect directly to each other - implying that my implementation of `IMembershipTable` should not include entries from other clusters or services.

While implementing this provider, I figured that there could probably be an API-based client gateway provider that communicates with the cluster for gateways or something - so your external client services don't need to also be connected to the database if they aren't using it already.

### Reminders

Similar to the other two, the reminder functionality required an implementation of [`IReminderTable`](https://github.com/interflare/orleans-marten/blob/5a68a623f6d60239ca3ae024609e05d68c4307a7/src/Orleans.Providers.Marten.Reminders/MartenReminderTable.cs), which had methods for creating/reading/updating the reminder rows.

By this point, I understood a fair amount of how the data persistence functionality worked within Orleans, and had a good grasp on how to navigate the code of the built-in providers, so building the reminder implementation wasn't too bad. There was just the one part I wasn't sure about, which was if reminders should persist between deployments (by cluster identifier).

My gut feel was that they should be cross-cluster, as it wouldn't make sense to have to re-create all reminders when the cluster id changes (which is one of the methods of deployment: blue/green clusters). The other providers seem to do this as well, so at least it would be consistent. I still opted to store the cluster id which inserted/last updated the reminder for diagnostics, at least.

## Conclusion

I'm really proud of my little library! And I learned quite a bit about how Orleans works under the hood - which was the point after all.

Building this library also makes Orleans more attractive to me as an option when planning out projects, because I really don't want to use Azure or loose SQL scripts. Also, it makes me feel like I don't have to choose between using either system - I can use the best of both.

I've release this implementation as an open-source library, where you can find the [repository on Github](https://github.com/interflare/orleans-marten).
