---
title: Java Still Sucks
date: 2022-09-06T07:44:00+12:00

categories: Engineering
tags:
  - java
---

I love using Jenkins for my personal projects and some home automation tasks. It has a lot of features and plugins, and its UI reminds me of the good old days when I was making Minecraft server plugins.

Recently, I encountered a problem with one of the plugins that I used. It was a Java plugin that connected to a public API, but the API had changed without updating their version number. I wanted to fix it myself and contribute to the project, but I found out that someone had already submitted a pull request with the same fix months ago. The project seemed to be abandoned.

I decided to create my own plugin from scratch. I thought it would be easy, since I use OpenAPI a lot at work. I just needed to generate a Java client from the API's OpenAPI document, and then publish it as a plugin. I do this all the time in C#.

But I was wrong. Java was much more complex than I expected. I had trouble setting up a simple project, configuring Maven, and managing dependencies. I also realised that the API's OpenAPI document was poorly written, and it generated a Java project that wouldn't compile. It was frustrating.

Java is not as simple as it looks, and it has many different ways to do things. I have more respect for Java developers now, and I also feel a little sorry for them. I kid, the .NET ecosystem certainly has problems of its own, but its so much simpler and quicker to get up and running. Modern .NET has considered the development experience from the ground up, and it really shows.