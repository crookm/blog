---
title: "Sharing WiFi over Ethernet in Ubuntu 18"
date: 2018-05-10T23:46:00+12:00

categories: DevOps
tags:
  - linux
  - networking
---

I wanted to share my Ubuntu 18 desktop's WiFi connection over Ethernet to my Raspberry Pi - however, some of the software you need to do this is no longer readily available, as it is superseded by the new settings app in Ubuntu 18.

So now, you can only share your WiFi connection over Ethernet by directly opening the connection editor, which you can do through the terminal:

```sh
nm-connection-editor
```

When it opens, select the wired connection item, clicking the edit button (the cog). In that menu, switch to the IPv4 tab, and select the method: "shared to other computers".

{{< figure src="image/2018/nm-connection-editor-screenshot.png" caption="Screenshot of the connection editor with settings opened." >}}

After that, save everything and connect your cable if you haven't already, and DHCP should kick-in and set everything up for you!

You could even connect a switch or hub and share the connection further, if you wanted.

Note that if you need to get the IP address of the connection, you can use `ifconfig`. You'll only need this if DHCP doesn't automatically configure everything.