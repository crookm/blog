---
title: Enterprise Resource Planning, for the Home
date: 2022-08-29T21:18:00+12:00

categories: Personal
tags:
  - devops
  - self-hosted
  - automation
---

I live in a flat which I share with some really good friends; meals are planned and shared to lighten the load and costs between us all, same with household supplies. Because of the distributed nature of this setup, it can be time-consuming to organise the grocery shopping and meal plans each week.

As an avid homelabber, I spend plenty of time lurking in the r/homelab and r/selfhosted subreddits, and I came across a self-hosted application called [grocy](https://grocy.info) - which promised to help with this organisation. I was desperate to make it easier to plan things out for the week, so I launched a Docker instance and started exploring.

Now, my flat has a fair bit of organisation through the use of [Trello](https://trello.com), and I have some extensive automation set up using the built-in Butler, but none of this was particularly helpful for this task because there was no inventory tracking. It was more suited to things like chores, where a cards would come in and be randomly assigned on a schedule.

So by tracking inventory with grocy, I had hoped that automating groceries would be easier, and lessen the time that I had to personally invest in managing the household, distributing it amongst the rest of my flatmates. So I gave it a go, and everyone was on board to try it out.

I ended up cancelling the trial after a week. I found it didn't lighten the workload at all, quite the opposite. With grocy, you must scan groceries in and consume things out, or the automation I was hoping for - minimum stock amounts, adding recipes to a shopping list - just doesn't work. The flatmates would often forget to consume what they used, and of course we weren't too particular about stock-takes and inventory as it would just take too much time.

Another thing we all found way too difficult was manually adding all the products. You have to define the products before you can add them to the shopping list or recipes, which doubles the effort required to do what was previously a simpler task - throwing some free-form text on a checklist.

We ended up switching back to Trello for the grocery list, but with a few changes; we now have new columns/lists in the board for recipes and the meal plan. Recipes have an ingredients checklist, which gets copied to the grocery checklist when moved to the meal plan - all automated with Butler, of course. This makes planning for the next week much simpler and faster, which was one of the things I was hoping to achieve with grocy.

Grocy certainly has a purpose, but unfortunately it wasn't for us. We're a busy bunch with not much time to spare on household duties, so we were not able to put in the effort required to get the gains promised by the system.