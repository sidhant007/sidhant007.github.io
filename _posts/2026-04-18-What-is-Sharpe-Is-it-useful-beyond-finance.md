---
layout: notebook
title: What is Sharpe? Is it useful beyond finance?
tags:
  - pop-phil
---

Click **Activate** above to run the code cells in this post.

This post covers the widely used, but often misunderstood Sharpe ratio.

You must have heard this term in some finance / quant lingo: "Our strategy has a Sharpe of 2" or something like: "We don't run anything with Sharpe < 1.5 on our books". Well, what does this actually mean?

The Sharpe ratio measures how much return you earn per unit of volatility. Formally,

\[
\text{Sharpe} = \frac{\mu - r_f}{\sigma}
\]

where $\mu$ is the mean return of the investment, $r_f$ is the risk-free rate, and $\sigma$ is the standard deviation of returns (volatility).

For simplicity, we will ignore the risk-free rate in this post, and just think of Sharpe as mean return divided by standard deviation (call it std for short) of returns.

Suppose the S&P 500 has an average annual return of 10% with a std of 15%, then its Sharpe would be 10/15 = 0.66. How should we interpret this std = 15%? If you think of the return of S&P over multiple years as a series of numbers, this std is just the standard deviation of those numbers.

If we were to assume (gross over-simplification) that S&P returns are normally distributed, then roughly 68% of the years, the returns would fall within one std of the mean (-5% to 25%), and 95% of the years within two std (-20% to 40%). Real returns have fatter tails, but this gives a feel for what ‘10% returns, 15% volatility’ means.

## How is Sharpe useful beyond finance?

Taleb once wrote that “The 100k\\$ a dentist earns is far more robust than the same 100k\\$ a gambler makes.” 
Run both lives ten times: the dentist almost always ends up fine.

We only ever observe one path of reality, not the counterfactuals that could’ve happened. Even if the expected value of being a dentist might be slightly lower than of being a gambler (unlikely to be the case, but lets assume for this example), you should probably choose the dentist path, because you don't get to replay your life multiple times to average out the bad outcomes.

{% codecell python Demo %}
import numpy as np
import matplotlib.pyplot as plt

rng = np.random.default_rng(0)

# n = number of simulated "lives" (independent paths)
# T = number of years per life
n, T = 1000, 10

# Dentist: stable
dent = rng.normal(100_000, 0, (n, T))

# Gambler: heavy-tailed mixture
u = rng.random((n, T))
gamb = np.zeros((n, T))

# Assumptions for the gambler:
# 80% of the times you make between -100k and 200k
# 15% of the times you lose between 300k and 1M
# and 5% of the times you make between 1.2M and 6M
gamb[u < 0.80] = rng.uniform(-100_000, 200_000, (u < 0.80).sum())
gamb[(u >= 0.80) & (u < 0.95)] = rng.uniform(-1_000_000, -300_000, ((u >= 0.80) & (u < 0.95)).sum())
gamb[u >= 0.95] = rng.uniform(1_200_000, 6_000_000, (u >= 0.95).sum())

# force expected mean to be empirically also at 122.5k
gamb = gamb - gamb.mean() + 122_500

# cumulative
dent_c = dent.cumsum(1)
gamb_c = gamb.cumsum(1)
t = np.arange(1, T+1)

fig, ax = plt.subplots(figsize=(6, 4))
for data, label in [(dent_c, "Dentist"), (gamb_c, "Gambler")]:
    p10, p25, p50, p75, p90 = np.percentile(data, [10, 25, 50, 75, 90], axis=0)
    ax.plot(t, p50, label=f"{label} median") # median
    ax.fill_between(t, p25, p75, alpha=0.6) # inner band (25–75)
    ax.fill_between(t, p10, p90, alpha=0.3) # outer band (10–90)
ax.set_title("Range of plausible futures")
ax.set_xlabel("Year")
ax.set_ylabel("Cumulative income")
ax.legend()

plt.tight_layout()
plt.show()
{% endcodecell %}

In the above visualization, you see for a span of 10 years, even though gambler has higher expected income of 122.5k vs 100k for the dentist, the range of plausible outcomes is much wider for the gambler. The median outcome for the gambler is actually worse than the dentist. Stretch it to T = 100 years (change $T$ to 100) and the median outcome becomes better, but you still need to stomach the bottom 10% outcomes. Extend it to T = 1000 years and one starts to see the upside of being a gambler.

# Knowing how many times you get to repeat a decision matters

Say you compare two activities:
- Preparing for an opportunity that comes once in a lifetime (e.g. a job interview, a critical exam)
- Preparing for a weekly / daily activity (e.g. playing a sport every weekend, doing an office presentation)

In which case, do you want to reduce your variance / std more?

The difference isn't simply about being risk-averse, but also about factoring in how many times you get to average over the outcomes (i.e. will the law of large numbers help you?).

Intuitively, it's case one, right. Similar to Dentist vs Gambler example, you would spend effort to minimize variance, sometimes even at the cost of reducing expected value. Think of why people do multiple mock interviews or practice exams before a big opportunity and avoid preparing altogether new, unfamiliar topics - they’re unknowingly optimizing Sharpe, not just EV.

What about case two? Here since you repeat the activity multiple times, vairance hurts you less.

Let's say your mean skill improvement is 0.1%[^1] with a std of 20% whenever you play tennis. Your Sharpe per session is 0.1/20 = 0.005, which sounds pretty bad, but you play a lot of sessions. If you repeat it N times, your mean improvement is N * 0.1%, but your std only goes up by sqrt(N) * 20%. So your Sharpe after N sessions is: sqrt(N) * 0.005.

The larger the $N$, the less one should care about reducing std and instead focus on increasing mean. 

## Is Sharpe arbitrary?

So we have the high-level intuition that as a metric, Sharpe quantifies quality of your return accounting for variance. But why not define it as say: $\mu - \sigma$ or $\mu / \sigma^2$? or use skew / kurtosis of the returns distribution as well?

- If you assume your utility function to optimize for is: $U(w) = E[wX] - \lambda Var(wX)$, where $w$ is the amount of money you invest and $X$ is the return of the investment (with mean $\mu$ and std $\sigma$), then the optimal $w* = \frac{\mu}{2\lambda\sigma^2}$, and the utility at the optimal $w^{\ast}$ is $U(w^{\ast}) = \frac{\mu^2}{4\lambda\sigma^2}$. So to compare two strategies $A$ and $B$ with $(\mu_A, \sigma_A)$ and $(\mu_B, \sigma_B)$, under this utility function you would prefer the one with higher $\frac{\mu^2}{\sigma^2}$, which is equivalent to higher Sharpe.

- Sharpe also cleanly links to maximizing t-stat (for a fixed $N$). Given $N$ observations, the t-stat of the mean return is $t = \frac{\mu}{\sigma / \sqrt{N}} = \sqrt{N} \times \text{Sharpe}$. Most typical usage of t-stat is to do hypothesis testing for whether the mean return is significantly different from zero. So maximizing Sharpe is also equivalent to maximzing the t-stat value and therefore being more confident that your mean return is truly positive and not just a result of noise.

## Where does Sharpe fail?

It probably fails in many cases, but the two I can immediately think of:

- Assumes additive returns and not compounding. In real world returns compound, which can be approximated to additive only when small[^1], but otherwise one needs Kelly criterion or other metrics that account for compounding.

- Breaks under correlated returns. For instance, it is an imperfect assumption to say tennis improvement today is independent of your improvement yesterday. If you had bad sleep two days back, maybe it impacts both your sessions making them correlated. In this case, the std of returns would increase[^2] and therefore the original metric is downplaying the risk.

## Conclusion

Tying this back to quant, Sharpe and its relationship with number of attempts is the reason why high-frequency strategies often have high annualized Sharpe compared to longer-term strategies. They get to repeat their bets more times in a year.

Sharpe isn’t entirely about money—it’s about robustness per attempt. The quality of a decision lies in how well it holds up across repeats, and in knowing how many times you’ll get to repeat it.

## References

- [Sharpe and its t-stat relationship](https://gregorygundersen.com/blog/2022/06/29/sharpe-ratio/)

- [Sqrt of time rule](https://gregorygundersen.com/blog/2022/05/24/square-root-of-time-rule/)

[^1]: We assume the mean improvement $r$ is so small, that $r \approx \log(1 + r)$, which implies $(1 + r)^{n} \approx n \times \log(1 + r)$ and therefore the additive argument works.

[^2]: $S_N = r_1 + r_2 + ... + r_N$, where $r_i$ is the return of session $i$. If $r_i$ are independent, then $Var(S_N) = N \sigma^2$. But if they are correlated with correlation $> 0$, then $Var(S_N) = N \sigma^2 + 2 \sum_{i \lt j}Cov(r_i, r_j)$, which is larger than $N \sigma^2$.
