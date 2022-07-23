---
title: Who Really Needs a Database, Anyway
slug: who-really-needs-a-database-anyway

description: |
    My blog tends to be my stomping ground for testing new ideas, and this time I wanted to try optimising my costs to make
    sense in a low traffic environment

date: 2021-09-11T16:07:00+12:00
---

As of today, my blog is serving requests from Azure Table Storage - and it is working far better than I had anticipated.
It has even reduced the complexity in my codebase by allowing me to rip out all of the Entity Framework pieces, like
migrations and setup.

I know most personal developer blogs prefer to use static content generators like Hugo et al, or even just off-the-shelf
blog software like Wordpress or Blogger, but I have mostly settled on building my own - I want to be able to fine tune
how everything works. This has allowed me to simply drop the need for the database I had been reluctantly paying for.

Previously, I was
using [DigitalOcean App Platform](https://mattcrook.io/journal/2020/first-impression-of-the-digitalocean-app-platform) -
I definitely did not want to be managing a virtual machine myself, but this came with the caveat of having to pay extra
for a database, rather than just installing Postgres or similar on the same machine. Fair enough, but my site is mostly
delivered from edge caching through CloudFlare. I really only needed something to persist a tiny amount of data should
the application need to be restarted.

This is where Azure Table Storage comes in. It has some limitations, namely; a maximum row size of 1MiB, a throughput of
around 2,000 entities per second, somewhat varying response latency, and of course very limited querying capability.
These are hardly issues for my tiny blog, as my posts tend to be very small, and of course as I said before, most
requests are delivered via an edge cache. Loading the entire table into memory to perform anything more complex than a
direct lookup is no big deal because of this.

## Table Structure

In Azure Table Storage, the most important 'schema' (there are no real schemas in table storage) decisions are really
only what you choose for the `PartitionKey` and `RowKey`. For the former I chose to use the published year, and for the
latter I chose to use the post 'slug'.

If you cast your gaze to the URL structure of this post, you can see that I have always had the year and the slug in the
route. This means that I can perform a very fast direct lookup, without having to scan the table for a matching slug -
had I used some random identifiers in the keys.

Given that I have so few posts, I definitely will have been able to get away with a single static `PartitionKey` and
continue using the slug for the `RowKey`, but the logical partitioning by year simply feels better to me.

## Performance Results

{{< figure src="/img/journal/2021/azure-table-storage-end-to-end-transaction-latency.png" caption="An example end-to-end request latency trace for my home page." alt="Screenshot of a graph showing an end-to-end transaction of dependencies when loading the home page of this site, with the entire duration of the request taking 28.9 milliseconds, and two requests to Azure Table Storage taking 12.5 and 5.9 milliseconds respectively" >}}

{{< figure src="/img/journal/2021/azure-storage-request-latency-distribution.png" caption="The average duration of the Azure Table Storage dependency when getting a list of blog posts." alt="Screenshot of a graph showing the distribution of latency for retrieving data from Azure Table Storage, with the 50th, 95th, and 99th percentile results being 8.5, 120, and 300 milliseconds respectively" >}}

As you can see from the images above, it looks quite good! The requests to table storage are still slightly slower: the
database had an average latency of around 4ms, where table storage has an average data retrieval latency of around 30ms,
but in the grander scheme of a web request it goes pretty much unnoticed - and again the edge caching makes this a no-op
for most visitors.

## Cost

For cost comparison, a database just cannot compete. I was paying US$7 for the smallest database provided by the
DigitalOcean App Platform, which is cheaper than their smallest managed database offering, but it was still costing more
than the application hosting itself. This was the original reason why I wanted to drop it.

Azure Table Storage has so far had an undetectable cost, though I'm expecting something along the lines of less than
US$1 by the end of the month. Paying only for what you use continues to be exactly the pricing model I look for,
especially for my personal projects like this blog, where traffic is low. No reason to pay hundreds of dollars to
support such things!
