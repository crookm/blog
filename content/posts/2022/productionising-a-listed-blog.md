---
title: Productionising a Listed Blog
date: 2022-12-22T12:07:00+13:00

categories: DevOps
tags:
  - blogging
---

I recently [decided to streamline my personal projects](/posts/2022/scaling-back-side-projects/) and combine my personal and professional blogs into one platform: Listed. Listed is a cool feature of the Standard Notes app that I use - it lets you publish blog posts to a website from a note.

However, I noticed some drawbacks of using Listed: it is not very fast, it sometimes goes offline, and it does not give me any insights into my site traffic. According to Listed, the purpose of their platform is to [create a space for journaling](https://listed.to/@Listed/5063/what-will-you-write-about), not for hosting important websites.

I understand their point, but I still love the convenience of publishing from notes, and I don't want to maintain a separate site for my professional blog anymore. Luckily, there is a solution that can solve all these problems - if you are a paying Standard Notes subscriber (and have a Listed custom domain).

## Speed and Uptime

If you use Listed to host your personal tech blog, you might have noticed that it's not very fast or reliable. I've been monitoring the performance of my blog for a month, and I found out that it takes about two seconds to load the HTML page alone. That's too slow for a good reader experience. And the uptime was only 99.95%, which means there were some periods of downtime.

But don't worry, there is a simple solution: Cloudflare. You can use Cloudflare to proxy your Listed custom domain and cache your content. This will make your blog load much faster and more consistently. By default, Cloudflare will only cache static resources like CSS, JS, and images. But you can use custom page rules to set the cache level to 'cache everything'. This will cache the HTML pages as well.

> **Pro tip**: Don't forget to exclude your settings page from caching. You can create another page rule that matches your settings page URL, set the cache level to 'bypass', and put it at the top of the list. This is important to prevent unauthorized viewers from seeing a cached copy of your settings.

{{< figure src="image/2022/cloudflare-custom-page-rules-overview.png" caption="Screenshot of the Cloudflare custom page rules overview used on this site." >}}

{{< figure src="image/2022/cloudflare-custom-page-rules-cache-everything.png" caption="Screenshot of a custom Cloudflare page rule displaying the options necessary to cache all content explicitly." >}}

The graph below shows how much faster my website is now - it only takes 215 milliseconds to load a page, which is awesome!

{{< figure src="image/2022/listed-platform-response-time-measurements.png" caption="Screenshot of a graph showing the average page response time for the Listed blogging platform." >}}

## Analytics

I like to see how many people visit my blog, where they come from, and what they read. Unfortunately, Listed doesn't have this option yet. They are working on it, but they have some [privacy and security concerns](https://github.com/standardnotes/listed/issues/70) that they need to address first. I respect that, but I also want to have some insights into my blog performance.

Like with before, this is achievable through Cloudflare. Once your site is being proxied through Cloudflare, you can make use of page injection at-the-edge. The Cloudflare CDN allows you to alter the website served without modification to the origin, which is perfect for this situation.

Cloudflare has some apps that you can use to inject analytics scripts into your website, such as Google Analytics, Matomo Analytics, or Google Tag Manager. But I decided to use Cloudflare Insights, which is their own analytics tool. It's very easy to set up and it doesn't affect website speed or the privacy of your readers. All you need to do is enable it with one click and you're good to go.

{{< figure src="image/2022/cloudflare-insights-mattcrook-overview.png" caption="Screenshot of the Cloudflare insights statistics for this site over the last 24 hours." >}}

---

In conclusion, Listed is a great way to blog without hassle - you can publish your notes from the same app where you manage your daily tasks. It's not perfect, and some features might not suit a professional blog, but you can easily fix that with Cloudflare.

I recommend you to try [Standard Notes](https://standardnotes.com) and [Listed](https://listed.to) if you haven't yet. They are awesome tools for staying organized and creative.