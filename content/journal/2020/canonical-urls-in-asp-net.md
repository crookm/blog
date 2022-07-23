---
title: Canonical URLs in ASP.NET
slug: canonical-urls-in-asp-net

description: |
    Setting a canonical URL in a web page is the way you tell search engines that between two URLs, the canonical one should
    be considered the 'real' one

date: 2020-11-29T20:08:00+12:00
---

I've recently changed the format of the URLs on my blog, so now websites link to mine using a different URL than what
I'm trying to settle on. But these are minor variations in the path - such as a trailing slash, or title-casing, etc -
which are still considered valid by the ASP.NET routing logic. There's no redirect because of this.

Thankfully, search engines are smart these days, and can figure out that all these URLs lead to the same content. The
problem is that they don't know which should be considered as the 'real' URL.

ASP.NET doesn't have a way to inject a canonicalised URL into the page's meta, so I thought I would go about creating
one for myself, and sharing it in the hopes that it will help others.

Below you will find some code for a service that can be injected into a partial page, which can in turn be rendered
inside your page's layout.

**Note**: This implementation is based on .NET Core 3 / .NET 5. You will have to adjust the query string handler, as
well as find another way to get the page's full Uri, to make this work with earlier versions of .NET Core.

## Interface

We'll start with an interface for the service, because I consider it best-practice when using dependency injection. Not
a big deal if you skip this, just remember to adjust the class we make later.

```cs
public interface ICanonicalService
{
    string HostName { get; set; }

    bool EnableHttps { get; set; }
    bool EnableTrailingSlash { get; set; }
    bool EnableLowerCase { get; set; }

    string CanonicaliseUrl(string url);
    string CanonicaliseUrl(Uri uri);
}
```

You can see that we've defined some basic options here, which are to force the canonical URL to have or not have various
properties. This would be set when we configure our dependency injection.

## Service

The service we will implement is mostly just string building, based on those options we set earlier.

```cs
public class CanonicalService : ICanonicalService
{
    public string HostName { get; set; }

    public bool EnableHttps { get; set; }
    public bool EnableTrailingSlash { get; set; }
    public bool EnableLowerCase { get; set; }

    public string CanonicaliseUrl(string url)
    {
        return CanonicaliseUrl(new Uri(url));
    }

    public string CanonicaliseUrl(Uri uri)
    {
        var builder = new StringBuilder();
        if (EnableHttps)
            builder.Append("https://");
        else
            builder.Append($"{uri.Scheme}://");

        builder.Append(HostName);

        if (!uri.IsDefaultPort)
            builder.Append($":{uri.Port}");

        // Path
        var newPath = uri.AbsolutePath.TrimEnd('/');
        if (EnableLowerCase)
            newPath = newPath.ToLowerInvariant();

        if (EnableTrailingSlash)
            newPath += '/';

        builder.Append(newPath);

        // Query parameters
        if (!string.IsNullOrEmpty(uri.Query))
        {
            var query = QueryHelpers.ParseQuery(uri.Query);
            var newQuery = new List<string>();
            foreach (var item in query)
            {
                var key = item.Key;
                if (EnableLowerCase) key = key.ToLowerInvariant();

                newQuery.Add($"{key}={item.Value}");
            }

            builder.Append($"?{string.Join("&", newQuery)}");
        }

        builder.Append(uri.Fragment);
        return builder.ToString();
    }
}
```

## Configuration

This is the part where we configure the dependency injection, as well as the service itself. Inside your `Startup.cs`
file, find and add the following:

```cs
public void ConfigureServices(IServiceCollection services)
{
    // ...

    services
        .AddSingleton<ICanonicalService>(new CanonicalService
        {
            HostName = "example.com",
            EnableTrailingSlash = false,
            EnableLowerCase = true,
            EnableHttps = true,
        });

    // ...
}
```

You may be wondering why I set a hostname explicitly. This is because the hostname is actually user-generated content.
The user can set it, and we should not consider it as safe content. Besides, in this instance I would have liked it to
be constant, to deal with the issue of www and non-www domains.

## Implementation

Now we must insert the canonical URL into our web page, specifically in the `<head>` of the HTML. I decided to create a
partial page to keep the logic separate from my layout.

```html
@using Microsoft.AspNetCore.Http.Extensions
@inject ICanonicalService canonicalService
@{
    var canonical = canonicalService.CanonicaliseUrl(
    Context.Request.GetDisplayUrl());
}
<link rel="canonical" href="@canonical"/>
```

And rendered into my layout like so:

```html
<!doctype html>
<html lang="en" dir="ltr">

<head>
    <meta charset="utf-8">
    <title>my web sight :-)</title>

    @await Html.PartialAsync("Canonical")

    <!-- ... -->
</head>
```

And that should be all! A simple and portable way to get a canonical URL into your page meta. If there's anything
unusual with how you use URLs in your application that isn't supported by this code, all you need do is alter the
service string builder.

You can check out how I use this code in my blog on [GitHub](https://github.com/crookm/aoraki).
