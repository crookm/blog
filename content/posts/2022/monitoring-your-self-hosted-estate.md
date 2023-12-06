---
title: Monitoring Your Self-Hosted Estate
date: 2022-08-20T09:13:00+12:00

categories: Personal
tags:
  - devops
  - sre
---

If you build and develop a system with paying customers, you know that tracking and publishing service uptime is absolutely critical to build trust. If your customers don't trust that your system will be up and available when they need it, its unlikely that they will remain your customers for very long. Hosting a central web page where customers can view and track outage events over time builds that trust, and helps with communicating these events as they happen.

I believe that the same things are valuable in the self-hosting/homelab world - only, your "customers" are your friends and family.

Of course, you don't need to treat the end users of your self-hosted systems in quite the same way as a business would treat customers, but it is valuable to monitor the various services you may be hosting to allow yourself to be pro-active with issues. Personally, I get a little frustrated when anything I host goes down, and having several people tell me its down is unhelpful. I would rather share a link to a status page where they can see progress and status, and forget about it. If things go down in the future, they'll go direct to the status page instead of badgering me.

Keeping with the self-hosted nature of my homelab, I also self-host the monitoring tool - I use [Uptime Kuma](https://github.com/louislam/uptime-kuma). Just as an aside: try not to host your monitoring tools alongside the things they are monitoring - they might end up going down together, and it would ruin the entire point. I host my instance on a [DigitalOcean](https://m.do.co/c/f8ffd8a5f356) VM to keep it entirely separate from my home infrastructure, but using a Raspberry Pi in a different room or at a friends house would also do nicely.

I also find another benefit in monitoring your hosted services in a central location; you automatically get a tested inventory of everything you manage. It can be hard to track what you have hosted, since self-hosting can be quite low-friction (if you're doing it right). I can spin-up a Docker container, and completely forget about it. Maybe it goes into a crash-loop, using up resources, and I'm none the wiser until it starts affecting other services. If I always add a monitor to every service I spin-up, I can know when its misbehaving and make a decision of if it should still be there.

So yeah, monitoring your uptime can be a good idea for a homelabber, too. You can avoid getting snippy with your friends and family when things go down, and it can also help keep your digital estate under control. It might also serve as bragging rights, displaying all the services your host and their uptime.