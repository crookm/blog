---
title: Exploring Godot Game Development

categories: Game Development
tags:
  - learning
  - godot

date: 2024-02-25T09:22:07+13:00
---

For the last little while, I've been looking for ways to expand upon my creativity and learn new skills. That started with [learning 3D modeling]({{< ref "/series/learning-3d-modeling" >}}) in Blender, which I feel leads well into game development. Making bad games with no clue on the theory and design but with high confidence feels a little tired and cliché for software engineers - which will probably be me, but I just have this need to do something creative and fun.

## Finding the right engine

My belief is that selecting the first tool you learn with will be important, as it will probably be with you for a long time. For example, if you learn to code with Python, Rust might seem very different and difficult to learn. I don't want to have to re-learn everything if I decide to switch engines later on - so I'm evaluating the options with important criteria in mind:

- **.NET support**: I'm a .NET developer, and I want to be able to use my existing knowledge. I am aware that game development requires thinking differently when scripting as opposed to creating a web app, but I still want that familiarity. But to that end, I also want:
  - Proper `async`/`await` support
  - Familiar methods, frameworks, and libraries
  - Solution-based project structure allowing for customisation
  - Package management with NuGet
- **Pipeline support**: I need to be able to build and deploy using headless CI/CD pipelines. This is something of a rule with me - if I can't automate it, I don't want to do it.
- **Cross-platform support**: I want to be able to build for Windows, Linux, macOS, and even the web. As A lInUx UsEr, I always get a bit fierce about the Windows-first focus of games, so I want to do better and make my bad games natively cross-platform.
- **3D support**: I want to make 3D games, and I want to be able to use Blender assets in my games. I don't want to have to learn a new tool for 3D modeling and animation. I won't start with 3D games, but I want to have the option as I get more confident.
- **Linux-first development**: I don't use Windows at home, and I don't want to have to use it to develop games. I want to be able to use my Linux machine for everything, including testing and debugging.
  - Integration with JetBrains Rider is a bonus.

I've been looking at a few different game engines, and I've decided to start with [Godot](https://godotengine.org/). It's totally open source, hasn't had any 'enshittification' scandals, and I've heard good things about it. I've also been told that it's a good engine to start with, as it's quite user-friendly and has a lot of documentation and tutorials available.

For the evaluation, I followed the [2D tutorial on the official docs](https://docs.godotengine.org/en/stable/getting_started/first_2d_game/index.html) to get a feel for the engine.

## First impressions

Godot looks like it will be a great project for me to use as it meets most of my requirements, perhaps even for more than just games. I'll still need to give the 3D tutorial a go to see if it meets my 3D requirements, but I'm feeling pretty good about it.

I found that in the C# version (as opposed to the 'GDScript' version of Godot), there are many custom methods and classes that are similar-but-not the same as some of the ones built into .NET - but these didn't feel too alien to me, they were similar to what you would find in any other .NET library. It looked tricky, but I also think I may be able to do dependency injection, too.

One limitation I found that does not meet my requirements is that when using C# and Godot 4(.2), I am not able to publish to the web - version 3 does not have this limitation, however I don't want to begin as a new Godot user with the previous version. This appears to be a limitation of .NET at the moment, but is on the radar and intends to be supported as soon as possible by the team: [godotengine/godot#70796](https://github.com/godotengine/godot/issues/70796).

If you want to see the results of my following the tutorial, you can find the project on [GitHub](https://github.com/crookm/godot-tutorial-2d).

So far, I'm feeling pretty good about Godot. I'm going to continue with the 3D tutorial and see how I feel about it after that. I'll keep you posted!