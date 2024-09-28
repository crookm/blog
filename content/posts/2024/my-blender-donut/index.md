---
title: My Blender Donut

series: Learning 3D Modeling
categories: Graphic Design
tags:
  - learning
  - blender
  - 3d

date: 2024-01-05T11:08:30+13:00
---

So I feel like I had a bit of a false start in terms of my [learning 3D modeling]({{< ref "/series/learning-3d-modeling" >}}). I started with [modeling a humanoid figure]({{< ref "/posts/2024/first-attempt-at-learning-3d-modeling-with-blender" >}}) - while the tutorial I was following was intended for absolute beginners who had never touched 3D modeling before, the subject was maybe a touch too complex to start with, and the teacher moved along too quickly. I ended up with something reminiscent of a lego character with weird hands.

I decided to take a step back and try something simpler, with a different tutorial. I found [this one](https://www.youtube.com/playlist?list=PLjEaoINr3zgEPv5y--4MKpciLaoQYZB1Z) by Blender Guru, which is an entire series on creating a donut with plenty of detail and explanation, as well as loads of opportunities to try different tools. This guy is a really good teacher!

{{< figure src="donut.png" caption="A still render of the donut I made following the tutorial." >}}

The tutorial covered many parts of blender, in greater detail the the previous tutorial I followed. I got a deeper look at the modifier system, geometry nodes, texturing, lighting, compositing, and even some basic camera animation.

{{< youtube 0B5oSKpgD-0 >}}

In particular, I was quite excited by the geometry nodes system. It feels a bit like programming, so I was right at home - I'm looking forward to learning more about it and seeing what I can do with it. I like the idea of being able to procedurally generate models, I'm very lazy and don't like doing things manually if I can avoid it.

The tutorial was quite full-on, teaching many different pieces of the 3D creator pipeline. This isn't necessarily a bad thing however, as I'll be able to refer to historical projects when I need to do similar things. This is how I learned to program; by building up a toolbox of techniques and then copying them into new projects.

{{< model src="donut.glb" caption="My donuts on a platter. Couldn't get the sprinkles working for the web export, so they look a bit bare!" >}}

I ended up working with lighting with the 'cycles' renderer as part of this tutorial, which made everything look really pretty, but my renders took a **long** time - a 300 frame animation took about six hours to render in 4K on my 'puter with an RTX 4080. I have found that this is normal, and I have no doubts that having a recent GPU is helping significantly, but yikes.

I wonder what the cost comparison is if I were to set up render farm with Azure Batch or DigitalOcean against the cost of electricity and my time. Could be an interesting project!

What I really liked about this tutorial series was that I had a really pretty result at the end of it. It's quite satisfying to have something at the end like this, so it's a good motivator to keep going. I still want to learn more about rigging for the purposes of game dev, but I think I'll keep practicing with modeling and texturing for now. Can't skip the basics!
