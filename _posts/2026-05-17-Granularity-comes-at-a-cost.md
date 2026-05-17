---
layout: post
title: Granularity comes at a cost
tags:
  - technical
---

I used to assume that more granularity in a system is usually a good thing. More price points, more time slots, more ways for users to express what they want, all of this sounds like efficiency.

But two recent examples, one from financial markets and one from booking a sports court, made me realize that granularity is not free. In strategic systems, finer choices can create new ways to game priority or reduce the incentive to participate honestly.

_Disclaimer: These are my personal thoughts and not the views of my employer._

## In financial markets - a relatively dull example

_Note: This section gets a little finance-lingo-specific. If you are not interested in markets, you can skip to the sports-court example, which is more real-life and completely unrelated to trading._

In the markets, we have an order book where people are quoting to buy and sell a stock at certain price points. Say one user is willing to buy AAPL at \\$100.00, another at \\$100.10 and similarly some are selling it at \\$101.00 and \\$101.50 respectively. The difference between the best ask and best bid is called the "spread" (in this case it's 101.00 - 100.10 = 90 cents).

Now obviously you can come in and quote at \\$100.20 and make the spread smaller. The "tick size" is the smallest increment in price that a stock can be quoted at. If the tick size is \\$0.10, then you can quote at \\$100.20 but not at \\$100.15. The smaller the tick size, the more granular the market is. One would think that this means more price points = more competition = tighter spreads = cheaper spread to pay for retail.

**Intuition: Think of the spread like an implicit fee retail investors pay when they trade.**

[This Nasdaq](https://www.nasdaq.com/articles/tick-sizes-are-trade) article makes a point I found counterintuitive: if a stock’s spread is “too many ticks wide,” then the market may actually be paying a cost for excessive granularity. Say the tick size is \\$0.01, but the average spread is \\$0.50. That means the spread is 50 ticks wide, so traders can jump ahead of each other in the queue by improving the price by just one cent. This makes life worse for liquidity providers. When you post a quote, you are taking adverse-selection risk: maybe the market moves against you before you get filled. In return, you hope to earn the spread. But if someone can cheaply step ahead of you by improving your quote by a tiny amount, then you still bear part of the risk while someone else can capture part of the reward. So liquidity providers may respond by quoting wider, i.e. less aggressively, or only when they have stronger conviction. In other words, smaller ticks do not automatically mean better markets. There is a sweet spot: ticks should be small enough to allow price competition, but not so small that queue priority becomes meaningless and liquidity providers stop quoting aggressively.

<figure style="text-align: center;">
  <img src="{{ site.baseurl }}/images/ticks.png" alt="Too many ticks graph" style="width: 600px;"/>
  <figcaption style="font-size: 0.9em; color: #666; margin-top: 6px;">
  Stocks in grey have a spread > 10 ticks, they could benefit from larger tick size.
  (Credits: Nasdaq article linked above)
  </figcaption>
</figure>

## In booking a sports court - a more fun example

For this example, I'll anonymize the sport and the NYC platform I was using.

Let us assume there is a booking system that has the following rules:

- You can book a court for a 1-hour session between 9am and 5pm. The possible time slots are: 9am-10am, 9:30am-10:30am, 10am-11am, 10:30am-11:30am, ..., 3:30pm-4:30pm, 4:00pm-5:00pm.
- Obviously, if the court is booked by user A for a 1hr slot, no other user can book it for any overlapping time slot.
- The platform does not object if users play before or after their booked session, as long as the court is not booked by someone else. It does not charge users for this extra time.
- The platform has captchas and rate limits to prevent bots from gaming the system.

Now, given these rules, think through:

- How you could still try to get an edge in booking the court to get the most value for your money?
- Is the platform's design optimal? Should they also allow 30-minute bookings at half the 1hr price or alternatively less granular/more granular time slots from a profitability perspective?

You can quantify profitability as being directly proportional to the total duration of the bookings, i.e. if the court was booked for 7 hours out of the 8 available hours, then their profitability is 7/8 = 87.5%.

**Think on this for a couple of minutes before reading on, it's a good thought experiment.**

Spoiler:

The immediate strategy is: suppose the court is booked from 9-10 and 12-1, then instead of booking 10-11 or 11-12 you book 10:30-11:30. Because the system only allows 1hr sessions, no one can book the remaining 30min slots at either side, so you effectively know the court is going to be free for those 30mins, i.e. from 10-10:30 and from 11:30-12. Of course, you are not guaranteed to get the full extra hour. The 9–10 players might overrun into 10–10:30, and the 12–1 players might arrive early for 11:30–12. But structurally, the platform has created two unbookable 30-minute pockets. If you are optimizing for value rather than etiquette, booking the middle slot gives you free optionality on both sides.

The platform has accidentally also created a new game. Because it allows 30-minute start times but only sells 1-hour sessions, certain gaps become unbookable. A strategic user is no longer incentivized to book the exact slot they want as early as possible. Instead, they may wait for nearby slots to fill, then book around them to create free slack on one or both sides. If you book too early, someone else can later book back-to-back with you and remove that slack. But if you wait until the schedule is partially filled, you can choose a slot that maximizes your chance of extra unpaid court time.

Now add two more rules:
- The platform allows one to cancel their booking up to 24hrs before the session starts with a full refund.
- The platform opens each slot for booking exactly 5 days in advance. So the 9am slot on day X opens at 9am on day X-5, the 9:30am slot on day X opens at 9:30am on day X-5, and so on.

Given these booking and cancellation rules, suppose I wanted to game the system to get the 2pm-3pm slot on a Saturday (assume it's a popular slot), what can I do?

Again, think like someone trying to game a system, and give it a shot before reading on.

Spoiler:

Assume that simply racing for the 2pm Saturday slot when it opens is noisy. Other people want it too, and you may lose the click-speed lottery. Well, since the platform allows unlimited cancels you could just keep a "lock" on the last available slot. So here is the strategy (disclaimer: this no longer works on the platform I saw it at, they have patched it since and rightfully so) - On Tuesday, suppose the 11-12 slot of Saturday is free when the current time is 11:05, just go ahead and book it. Now run the following:

```text
11:05  Book 11:00–12:00
11:30  11:30–12:30 should unlock, but it is blocked by your current booking
11:40  Cancel 11:00–12:00 and immediately book 11:30–12:30
12:10  Cancel 11:30–12:30 and immediately book 12:00–1:00
...
2:10   Roll into the desired 2:00–3:00 slot
```

Did you see how we slid our booked slot from 11-12 to 11:30-12:30 while taking minimal risk of losing the slot? I don't need to spell it out, but yeah, just keep maintaining this running lock on the last available slot till you hit 2pm-3pm, and you are golden. It is hilariously naive to execute, but it does require a bunch of free time and constant checking on your phone.

Again, the 30-minute granularity is what makes this rolling-lock strategy possible. If the platform only offered non-overlapping slots: 9–10, 10–11, 11–12, and so on, there would be no overlapping reservations to slide forward. The user would have to compete directly for the slot they actually wanted. The platform could also release all slots at once or limit repeated cancellations.

A simple product idea: "Let's allow users more granular time slots so they have more flexibility and we get higher utilization", ended up backfiring. It made the system more gameable and less profitable.

<center><img src="{{ site.baseurl }}/images/meme_drake.png" alt="Drake meme" style="width: 400px;"/></center>

## Conclusion

The lesson is not that granularity is bad. Granularity often does improve flexibility and competition. But it is not a free lunch. Once users are strategic, finer increments can lower the cost of strategic repositioning. 

More granularity gives users more moves. Sometimes those moves are exactly what you wanted. Sometimes you just built a more elegant game for the most annoying person in the room.

<iframe src="https://strawpoll.com/embed/polls/mpnb187Vvy5" width="800" height="420" frameborder="0"></iframe>
