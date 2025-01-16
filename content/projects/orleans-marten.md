---
title: Orleans Marten providers
description: |
    An open source library of a Marten implementation of Orleans providers for membership (clustering), state storage, and reminder storage. It seamlessly makes use of existing Marten project configuration and database management, and has a slim setup that's easy to get started with.

date: 2025-01-14T16:41:48+12:00
---

[![NuGet version of Interflare.Orleans.Marten.Clustering](https://img.shields.io/nuget/v/Interflare.Orleans.Marten.Clustering?label=clustering)](https://www.nuget.org/packages/Interflare.Orleans.Marten.Clustering/)
[![NuGet version of Interflare.Orleans.Marten.Persistence](https://img.shields.io/nuget/v/Interflare.Orleans.Marten.Persistence?label=persistence)](https://www.nuget.org/packages/Interflare.Orleans.Marten.Persistence/)
[![NuGet version of Interflare.Orleans.Marten.Reminders](https://img.shields.io/nuget/v/Interflare.Orleans.Marten.Reminders?label=reminders)](https://www.nuget.org/packages/Interflare.Orleans.Marten.Reminders/)

[![GitHub Actions status of CI workflow](https://img.shields.io/github/actions/workflow/status/interflare/orleans-marten/ci.yml?label=ci)](https://github.com/interflare/orleans-marten/actions/workflows/ci.yml)
[![GitHub Actions status of CI workflow](https://img.shields.io/github/actions/workflow/status/interflare/orleans-marten/release.yml?label=release)](https://github.com/interflare/orleans-marten/actions/workflows/release.yml)

An open source library of a [Marten](https://martendb.io/) implementation of [Orleans](https://docs.microsoft.com/dotnet/orleans) providers for **membership** (clustering), **state storage**, and **reminder storage**. It seamlessly makes use of existing Marten project configuration and database management, and has a slim setup that's easy to get started with.

[Read the blog post &rarr;]({{< relref "/posts/2025/building-a-custom-orleans-storage-provider" >}})  
[View the library on Github &rarr;](https://github.com/crookm/fridgemagnet)

## Why this library

Orleans requires configuration of a backend storage provider in production to manage clustering and persist state. With Azure services, this is relatively easy to get set started through Azure Table Storage - you can just point your cluster at the service, and you've got a production-ready system.

If you're not hosting in Azure, the storage options are not as easy to get started with. The ADO .NET (SQL) provider, for example, requires setting up the database tables manually using loose SQL scripts you have to download and execute from several different places in the Orleans git repo.

This library is for applications which already use Marten as a data store in some way, or intend to use it - meaning that there is no additional or separate tooling to configure just to run Orleans. The library automatically extends and uses your existing Marten config with tables for running Orleans.

### Nuget packages

- [Interflare.Orleans.Marten.Clustering](https://www.nuget.org/packages/Interflare.Orleans.Marten.Clustering/) (membership)
- [Interflare.Orleans.Marten.Persistence](https://www.nuget.org/packages/Interflare.Orleans.Marten.Persistence/) (state storage)
- [Interflare.Orleans.Marten.Reminders](https://www.nuget.org/packages/Interflare.Orleans.Marten.Reminders/) (reminder storage)
