---
layout: notebook
title: When is randomness an asset vs a tax?
tags:
  - pop-phil
---

Click **Activate** above to run the code cells in this post.

This post is a companion to the [Sharpe post]({{ site.baseurl }}/2026/What-is-Sharpe-Is-it-useful-beyond-finance) and is meant to dig deeper into scenarios where randomness helps vs hurts.

Let's formulate a lot of real-world scenarios as:

You get a random variable X, which you might have some control over, say its mean or distribution. Life then passes it through some function f, and the outcome you observe is f(X).

A simplistic worldview, but one that captures a surprising number of situations.

## Take 3 different scenarios

### Case 1

$f$ is linear.

Say you flip a fair coin for \\$1, or choose not to play at all.

If your utility is just money itself, i.e. $f(X) = X$, then:

$$
E[X] = 0
$$

in both cases.

Nothing interesting happens.

## Case 2

Now, let's say you have a \\$10k a non-trivial amount, and two investment options: (i) gives guaranteed 10% return year-on-year, (ii) gives 50% return with 0.5 probability and -30% return with 0.5 probability. Which one would you prefer if you had to stay invested long-term.

If investing just for one year, then the expected returns match-up, since first option gets you to \\$11k with certainty, while the second option gets you to \\$15k with 0.5 probability and \\$7k with 0.5 probability, so the expected value is also \\$11k. But we already said, you are in it for the long-game.

Think through this exercise, before reading up. Open a calculator, do a simulation in your head if needed, and see which one you would prefer.

Suppose your wealth after $T$ years is:

$$
W_T = W_0 \prod_{t=1}^{T}(1+r_t)
$$

The important thing to notice is that returns don't add, they multiply.

So instead of looking at $E[r]$, let us take logs:

$$
\log W_T = \log W_0 + \sum_{t=1}^{T}\log(1+r_t)
$$

So the long-run growth rate is governed by:

$$
E[\log(1+r)]
$$

For option (i):

$$
\log(1.1) \approx 0.0953
$$

For option (ii):

$$
\frac{1}{2}\log(1.5) + \frac{1}{2}\log(0.7)
\approx 0.0244
$$

So even though both have the same arithmetic expected return of 10%, their long-term compound growth rates are very different.

More generally, for small returns:

$$
\log(1+r) \approx r - \frac{r^2}{2}
$$

Taking expectations:

$$
E[\log(1+r)] \approx E[r] - \frac{1}{2}E[r^2]
$$

If $\mu = E[r]$ and $\sigma^2 = Var(r)$, then:

$$
E[r^2] = \mu^2 + \sigma^2
$$

So:

$$
E[\log(1+r)] \approx \mu - \frac{1}{2}\mu^2 - \frac{1}{2}\sigma^2
$$

Ignoring the small $\mu^2$ term:

$$
E[\log(1+r)] \approx \mu - \frac{1}{2}\sigma^2
$$

This is the volatility drag. The variance quietly taxes you.

Here, the relevant function was $f(x) = \log{x}$ and the randomness turned out to be a tax.

### Case 3

Suppose there is a call option on a stock. Say that stock will end up at \\$80 with 0.5 probability or \\$120 with 0.5 probability tomorrow. Now what would be the payoff of a call option with strike price \\$100 (in effect at the "fair" price of the stock right now)? Crude intuition could be, that it is worthless, why will I pay to buy a option at a price equal to the expected price of the stock tomorrow?

But, compare the expected payoff if you bought the option: you make \\$20 with 0.5 probability and 0 with 0.5 probability, so the expected payoff is \\$10. So the option is worth \\$10. If you see it for cheaper in the market, then you should buy it. Now also notice that if the stock was even more volatile, say 70/130 or 60/140, then the expected payoff of the option would be even higher, so the more volatile the stock, the more valuable the option is. This is why being long options means you are long volatility.

Here, the relevant function was: $f(S) = \max(S-100,0)$, where $S$ is the stock price at expiry, and the randomness turned out to be an asset.

## The pattern

At this point we have seen randomness:
- does nothing
- hurts us
- helps us

What changed?

In Case 1, $f$ was linear. $f(x) = x$

There is no curvature. Randomness neither helps nor hurts. Only the mean matters.

In Case 2, $f$ was concave. $f(x) = \log x$

Bad outcomes hurt more than good outcomes help. Randomness becomes a tax.

In Case 3, $f$ was convex. $f(S) = \max(S-100,0)$

Bad outcomes are capped at zero, while good outcomes keep going. Randomness becomes an asset.

This phenomenon is captured by Jensen's inequality.

For convex functions: $E[f(X)] \geq f(E[X])$

For concave functions: $E[f(X)] \leq f(E[X])$

{% codecell python Jensen-demo %}
import numpy as np
import matplotlib.pyplot as plt

# Same random variable throughout
# Think of X as tomorrow's stock price
x_vals = np.array([80, 120])
probs = np.array([0.5, 0.5])

EX = np.sum(probs * x_vals)

functions = [
    ("Linear: $f(x)=x$", lambda x: x),
    ("Convex: call option $f(x)=\\max(x-100,0)$", lambda x: np.maximum(x - 100, 0)),
    ("Concave: $f(x)=\\log(x)$", lambda x: np.log(x)),
]

x_grid = np.linspace(60, 140, 400)

fig, axes = plt.subplots(1, 3, figsize=(15, 4))

for ax, (title, f) in zip(axes, functions):
    y_grid = f(x_grid)
    y_vals = f(x_vals)

    EfX = np.sum(probs * y_vals)
    fEX = f(EX)
    gap = EfX - fEX

    ax.plot(x_grid, y_grid)
    ax.scatter(x_vals, y_vals, s=90, color="red", zorder=3, label="Possible values of $X$")
    ax.scatter([EX], [fEX], s=110, zorder=4, label="$f(E[X])$")

    ax.axvline(EX, linestyle="--", alpha=0.6)
    ax.axhline(EfX, linestyle=":", alpha=0.8, label="$E[f(X)]$")

    ax.set_title(title)
    ax.set_xlabel("$X$")
    ax.set_ylabel("$f(X)$")
    ax.legend(fontsize=8)

    ax.text(
        0.03, 0.95,
        f"$E[X]$ = {EX:.1f}\n"
        f"$f(E[X])$ = {fEX:.3f}\n"
        f"$E[f(X)]$ = {EfX:.3f}\n"
        f"Gap = {gap:.3f}",
        transform=ax.transAxes,
        verticalalignment="top",
        bbox=dict(boxstyle="round", alpha=0.15)
    )

plt.tight_layout()
plt.show()
{% endcodecell %}

The random variable is the same in all three plots: $X$ is either $80$ or $120$ with equal probability. Only the function changed. 

For the linear function, randomness does nothing. 

For the call option, randomness helps: $E[f(X)] \gt f(E[X])$. 

For the log function, randomness hurts: $E[f(X)] \lt f(E[X])$.

The inequality is just the math. The important part is how randomness interacts with the curvature.

## Other examples

- Insurance pricing: Insurance often looks like a bad deal in raw expected value terms, but when you are risk averse, i.e. your utlitity function is $\log{W}$ or $\sqrt{W}$, where $W$ is your wealth, then insurance effectively helps reduce the volatility of your wealth, and thus becomes useful. When wealth is passed through a concave utility function, reducing volatility can create value. This is one reason why insurances exist, despite having raw negative expected value.

- Leveraged ETFs: There is a reason why TQQQ gets screwed over long horizons in sideways markets (when $\sigma$ is high). $E[log(1+r)]$ becomes $E[log(1+3r)] \approx 3\mu - \frac{9}{2}\sigma^2$, notice how the volatility drag scaled up by 9x while the expected return only scaled up by 3x, so the volatility drag becomes more dominant.

> Food for thought:
> Many real-world systems are not linear. In winner-takes-all systems, the payoff function is often convex.
> Startups, research, content virality, sports, and some careers have this flavor: most attempts do little, but one unusually good outcome can dominate everything.
> In such systems, randomness may not just be noise. It may be the thing that gives you access to the upside.

## Conclusion 

Most of us encounter Jensen's Inequality in school, solve a few exercises, and move on thinking it is just another math thing. But many real-world decisions can be modelled as passing a random variable through some function and caring about the expected value of the output.

Whether it's choosing between investment opportunities, buying insurance, or deciding how much leverage to take, we are often implicitly deciding how much randomness to expose ourselves to. Jensen's Inequality tells us that the answer depends not just on the randomness itself, but also on the shape of the function it passes through.

Randomness is not inherently good or bad.

In linear systems, it washes out.

In concave systems, it becomes a tax.

In convex systems, it becomes an asset.

<iframe src="https://strawpoll.com/embed/polls/GPgVYlqLzna" width="800" height="420" frameborder="0"></iframe>
