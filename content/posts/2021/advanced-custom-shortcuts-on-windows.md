---
title: Advanced Custom Shortcuts on Windows
date: 2021-10-07T21:02:00+12:00

categories: Development
tags:
  - powershell
  - windows
  - dotnet
---

Shortcuts on Windows are annoying. Inside those little binary `lnk` files is a large number of properties which are essential to doing some pretty cool stuff.

One of those things is the ability to enable toast notifications, without the need to use a UWP project. This was one of the things I wanted to do, and it ended up being surprisingly difficult. The thing I found most strange when implementing this, was that the key to the entire operation was the need to add special identifiers *inside a shortcut* on desktop or start menu.

I found it was incredibly difficult to create such a shortcut, unless I changed the installer technology I was using - which I was not super interested in doing. It turns out that there is no way to do this manually, either.

So instead, I created a new PowerShell Module named `PSAdvancedShortcut` which I could use inside my installer to create the shortcut for me.

This module is a C# binary module, using p/invoke to set the hidden properties inside a shortcut file.

You can check it out on [GitHub](https://github.com/crookm/ps-advanced-shortcut) and the [PSGallery](https://www.powershellgallery.com/packages/PSAdvancedShortcut).