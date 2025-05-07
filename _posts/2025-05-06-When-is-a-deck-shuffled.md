---
layout: post
title: When is a deck shuffled?
tags:
  - technical
---

We all shuffle cards, but when is a deck truly shuffled? Firstly, what does 'truly shuffled' mean? Secondly, are some shuffles just better than others?

This is an explainer on mixing times for markov chains and how to think about "coupling" (a common technique for analysing markov chains), with our focus on card shuffling as the primary example.

Let's first dig into some terminology relating to markov chains:

- A deck of $n$ cards (in reality $n = 52$, but we will do a lot of our illustrations and visualizations with $n = 5$ too), has a state space of $n!$ (i.e. all the possible arrangements of the cards).

- A markov chain is a random process where the next state only depends on the current state. In our case, the current state is the arrangement of the cards in the deck.

- A transition matrix (denoted by $M$) corresponding to a markov chain is a matrix where the entry $M_{i,j}$ is the probability of going from state $i$ to state $j$. In our case, this matrix will be of size $n! \times n!$.

- A **stationary distribution** (commonly denoted by $\pi$) of a markov chain (i.e. a specific shuffling technique) is the distribution over the states such that if you start with this distribution, then after one step of the markov chain, you will still have the same distribution. One can show, that for our case, the stationary distribution would be the uniform distribution, where each arrangement of the cards is equally likely.

_Note: If you are first time reading above markov chains and stationary distributions. I strongly recommend reading these two 1-pagers: [introduction to markov chains](https://brilliant.org/wiki/markov-chains/) and [stationary distributions of markov chains](https://brilliant.org/wiki/stationary-distribution/)._

Let us also describe the two shuffling techniques we will be looking at:

- **Put-On-Top Shuffle**: 
    - Take a card uniformly at random from the deck and put it on the top of the deck.
    - Repeat this for $k_P$ times.

Example: Say we have a deck of cards "12345" (where "1" is the top card and "5" is the bottom card). If we pick "3" and put it on top, the deck becomes "31245".

- **Inverse-Riffle Shuffle**:
    - Assign each card a label "L" or "R", uniformly at random.
    - Put all the cards labelled "L" in the left pile (preserving their relative order) and all the cards labelled "R" in the right pile (preserving their relative order).
    - Put the left pile on top of the right pile.
    - Repeat this for $k_I$ times.

Example: If we start with "12345". In first shuffle, we might label the cards as "LRRLL", the left pile will be "145" and the right pile will be "23", so the deck becomes "14523".

<div class="quiz-box">
Now the natural question arises, what should be the values of $k_P$ and $k_I$ to get the deck to be truly shuffled? 
<br><br>
This is where the mixing time comes in. The mixing time of a markov chain is the time it takes for the distribution over the states to converge to the stationary distribution. In our case, we want to know how many shuffles we need to do before the distribution over the arrangements of the cards is close to uniform.
</div>

_Take a deck and arrange it say "A, 2, 3, \dots, Q, K" of spades, followed by clubs, diamonds and hearts. Now try out both the shuffles, you will quickly realize that the first shuffle is quite inefficient, where each step just moves around one card, so intuitively it will take a lot of steps to "mix" it well, whereas the second shuffle is kind of like a [riffle shuffle](https://www.wikihow.com/Riffle-and-Bridge-Shuffle) where you are mixing the cards a lot more. So intuitively, the second shuffle should "mix" faster._

Let us draw the markov chain for the two shuffles side by side, (for $n = 5$ cards, which is much easier to visualize). The state space is $5! = 120$, so we have $120$ nodes in the graph. In **Put-On-Top Shuffle**, each state has $5$ edges going out of it, one for each possible card being picked and being put on top. In **Inverse-Riffle Shuffle**, each state has $2^5 = 32$ edges going out of it, one for each possible combination of cards being labelled "L" or "R".

_Note: This graph is analogous to the transition matrix we described above. The edges in the graph represent the transitions between states. We don't draw the edge weights with the transition probability $$M_{i, j}$$ as $$1/5$$ and $$1/32$$ respectively, but they are there._

**Click on any of the nodes in the illustrations below to see the outgoing edges.**

<div style="display: flex; gap: 20px;">
  <div>
    <h4>Put-On-Top Shuffle</h4>
    <canvas id="put-on-top-canvas" width="400" height="400" style="border: 1px solid black; background: white;">
    </canvas>
  </div>

  <div>
    <h4>Inverse-Riffle Shuffle</h4>
    <canvas id="inverse-riffle-canvas" width="400" height="400" style="border: 1px solid black; background: white;">
    </canvas>
  </div>
</div>

<div id="tooltip" style="position:absolute; background:#eee; padding:4px 8px; border-radius:4px; border:1px solid #ccc; pointer-events:none; display:none;"></div>

> Quick poll to check your understanding: In both the shuffles we don't see all the 5 and 32 edges respectively. This is because this diagram dropped the self-edges. For a given state in each of the two shuffles, how many self-edges are there?

<details>
  <summary>Spoiler</summary>
  1 self-edge in Put-On-Top Shuffle and $n + 1$ (i.e. 6) self-edges in Inverse-Riffle Shuffle.
</details>
<br>

You can visually see that the **Inverse-Riffle Shuffle** has a lot more edges going out of each state and therefore can reach a lot more states in just a handful of steps. Intuitively this means it will mix faster, but how do we quantify this?

## Getting rigorous

To quantify how fast a markov chain mixed, we need to define a few more terms:

- **Total Variation Distance**: The total variation distance between two distributions $A$ and $B$ is defined as:
$$ ||A - B||_{TV} = \frac{1}{2} \sum_{i} |A(i) - B(i)| $$

So for $n = 5$, our $A$ and $B$ distributions are over the $120$ arrangements of the cards. The total variation distance is a measure of how different two distributions are. 

-  Let **$P_s^{t}$ be the distribution after $t$ steps of the markov chain starting from state $s$**. This markov chain is defined by $X_0, X_1, X_2, \dots$ where $X_0 = s$ and $X_t$ is the state after $t$ steps. Here $P_s^{t} = M^t \times P_s$, where $M$ is the transition matrix and $P_s$ is the initial distribution (which is a vector with a 1 at index $s$ and 0 everywhere else).

Say $s = "12345"$, then $P_s^{t}$ is the distribution over the arrangements of the cards after $t$ steps of the markov chain starting from state "12345".

- Let 
$$\Delta(t) = \max_{s}||\pi - P_s^{t}||_{TV}$$
. Here $\Delta(t)$ intuitively is the worst-case TV (total-variation) distance of a starting state $s$ from the stationary distribution $\pi$ after $t$ steps.

For example: 
$$\Delta(0) = \max_{s}||\pi - P_s^{0}|| = \max_{s}||\pi - P_s||$$

Where $P_{12345} = \[1, 0, 0, \dots, 0\]$ and $\pi = \[1/120, 1/120, \dots, 1/120\]$, 
$$\Rightarrow \Delta(0) = ||\pi - P_{12345}|| = \frac{1}{2}((1 - 1/120) + 119(1/120)) = \frac{119}{120}$$

_At the starting state all $s$'s result in this same value, so we can drop the $$\max_{s}()$$ thingy_

- We can now define the **mixing time (denoted by $\tau_{mix}$) as the first time-step when the TV distance between the worst-case $P_s^{t}$ and $\pi$ drops below $1/2e$**[^1] (i.e. the distribution is close to uniform). Formally, 
$$\tau_{mix} = \min\{t: \Delta(t) \leq 1/2e\} = \min\{t: \max_{s}||\pi - P_s^t||_{TV} \leq 1/2e\}$$

## Visualizing the mixing time

We can visualize the mixing time by picking an arbitrary starting state (say "12345") and plotting the TV distance between the stationary distribution $\pi$ and $P_s^{t}$ as a function of $t$. Since all states are symmetric in both shuffles, this 
$$||\pi - P_s^t||_{TV} = \Delta(t)$$

We do this by calculating 
$$||\pi - P_{12345}^t||_{TV} = ||\pi - M^t \times P_{12345}||_{TV}$$
for all $t$'s.

**Click on the "Simulate" button below to see how the probability distribution over all the states spreads out over time.**

<div style="display: flex; gap: 20px;">
  <div>
    <h4>Put-On-Top Shuffle</h4>
    <canvas id="put-on-top-heatmap" width="400" height="400" style="border: 1px solid black; background: white;">
    </canvas>
  </div>

  <div>
    <h4>Inverse-Riffle Shuffle</h4>
    <canvas id="inverse-riffle-heatmap" width="400" height="400" style="border: 1px solid black; background: white;">
    </canvas>
  </div>
</div>

<button id="simulate-btn">Simulate</button>

<div id="tv-chart"></div>

We can see that at roughly 6 shuffles, the Put-On-Top reaches mixing threshold and at roughly 3 shuffles, the Inverse-Riffle reaches mixing threshold. This is consistent with our intuition that the Inverse-Riffle mixes faster than the Put-On-Top. Obviously here $n = 5$ for illustration purposes so this difference between $3$ and $6$ is not stark.

In subsequent portion we will explain how to use coupling to determine the exact mixing time as a function of $n$, and then it will become apparent that for larger $n$'s, the difference between the two shuffles is much larger.

## Why do we need this "coupling" thing?

Let's first clarify a question that might have popped in your head. We know how $M$ looks like, can't get simply get a closed-form / tractable formula for:

$$||\pi - M^t \times P_s||_{TV}$$ 
as a function of $t$, and then figure out for which $t$ this value drops below $1/2e$?

Well, although $M$ has some structure (example: each node has a specific number of outgoing edges and same number of incoming edges, etc...), still the matrix doesn't have enough structure to get a closed-form solution for the above expression. So we need some other way...

## Coupling

Firstly, we use the fact[^2] that:
$$\Delta(t) = \max_{s}||\pi - P_s^t||_{TV} \leq \max_{s, s'}||P_s^t - P_{s'}^t||_{TV}$$
where $s$ and $s'$ are two states of the chains.

This step is still not useful enough, since $\Delta(t)$ is still bounded by 
$$||\dots||_{TV}$$ 
stuff where we don't know how to simplify this further.

Here we need one final math lemma as follows:

**Lemma**: For a joint distribution $(X, Y)$, where the marginal distributions of $X$ is $D_1$ and $Y$ is $D_2$, it holds that:
$$ ||D_1 - D_2||_{TV} \leq \Pr[X \neq Y]$$
[^3]

The idea of coupling is to create two copies of the markov chain with **shared randomness**. And we want these two chains to converge to the same state as quickly as possible.

This joint process can be denoted by $(X_0, Y_0), (X_1, Y_1), \dots, (X_t, Y_t)$, such that the following conditions hold:

- The marginal distribution of $\{X_t\}$ and $\{Y_t\}$ should look like the original markov random process. This means that the distribution of $X_t$ and $Y_t$ should be the same as the original markov chain, i.e. 
$$\Pr[X_t = a | X_{t - 1} = b] = \Pr[Y_t = a | Y_{t - 1} = b] = M_{b, a}$$

- Once $X_t = Y_t$, then $X_{t + 1} = Y_{t + 1}, X_{t + 2} = Y_{t + 2}, \dots$, i.e. the two chains are coupled and will stay together.

Which now boils down 
$$\Delta(t) = \dots \leq \dots \leq \max_{s, s'}\Pr[X_t \neq Y_t | X_0 = s, Y_0 = s']$$
. To show that this is small, we need to show that for the worst-case pair of initial states $(s, s')$ (intuitively far apart initial configurations), the probability that they are not in the same state even after $t$ steps is small.

## What if we don't have shared randomness in our coupling?

Let's concentrate on the **Put-On-Top Shuffle** and make a flawed coupling first, i.e. let $X_t$ and $Y_t$ be two independent copies with no shared randomness. Here you can see that if we start from two arbitrary decks, the chance that they will become the same deck after many steps is kind-of tiny. Each step you pick a random card from first deck, put it on the top. Pick another random card from the second deck and put it on its respective top. Accidentally getting the exact same configuration after some steps, sounds close to impossible. And you would be right, this is a bad coupling. Here $Pr[X_t \neq Y_t]$ would be close to 1 for even large values of $t > n$

## Shared randomness helps cheat and get the two walks to meet faster

Now let's see a good coupling. Let $X_t$ be the original markov chain with free randomness, i.e. you pick any card at random and put it at the top. But for $Y_t$, we will just pick the same card as $X_t$[^5] and put it on top. This is a coupling with shared randomness, where we are using the randomness of $X_t$ to determine the randomness of $Y_t$.

Do note, that if you looked at the second shuffle, i.e. $Y_t$ independent of $X_t$ (say I hide the first deck from you), you would see that this shuffle still follows the original markov chain distribution (because it is NOT doing some deterministic behaviour, instead just leeching off the randomness of $X_t$). So the marginal distribution of $Y_t$ is still the same as the original markov chain.

This **hack** helps you to ensure that the two decks quickly become the identical. Once a card is picked by $X_t$ and put on top, then the same card in the same time-step is also picked by $Y_t$ and put on top. Now this card will remain in the same relative position in both the decks forever. Once all the cards have been picked by $X_t$ at-least once and put on top, then both the decks will become identical. 

_Carefully re-read the paragraph above. And think why the event "all the cards have been picked by $X_t$ at-least once" is both, a necessary and sufficient condition for the two decks to become identical._

**Select two starting states $s$ (for $X_t$) and $s'$ (for $Y_t$) in the illustration below and click "Run Coupling" to see how the two decks would converge**

<div style="display: flex; gap: 20px;">
  <div>
    <canvas id="put-on-top-coupling" width="400" height="400" style="border: 1px solid black; background: white;">
    </canvas>
  </div>
</div>

<button id="run-coupling-btn">Run Coupling</button>
<button id="reset-coupling-btn">Reset</button>

Hitting time of the two walks: **<span id="hitsAt"></span>**

_Hover on how the blue walk mutates according to the red walk, since it leeches off the randomness of the red walk. Note: Sometimes one of the walk might not mutate because it travels on a self-edge._

Let $T$ denote the time-step when the two decks become identical for an arbitrary pair of initial states $(s, s')$. We can show that $E[T] = n\log{n}$, because it takes $nlogn$ steps to pick all the cards at least once. This is a well-known result in probability theory, and is called [Coupon Collector's Problem](https://brilliant.org/wiki/coupon-collector-problem/#general-case)

Given this, 
$$\Delta(t) \leq \max_{s, s'} \Pr[X_t \neq Y_t | X_0 = s, Y_0 = s'] = \Pr[T > t] \leq \frac{E[T]}{t}$$ 

(where the last inequality is [Markov's inequality](https://en.wikipedia.org/wiki/Markov%27s_inequality#Statement)

Plugging in $t = 2en\log{n}$, we get: $\Delta(t) \leq 1/2e \Rightarrow \tau_{mix} \leq 2en\log{n} \Rightarrow \tau_{mix} = O(n\log{n})$

<div class="quiz-box">
That's neat, we showed that after running the Put-On-Top Shuffle, $\sim 2enlogn$ steps, the deck would be more or less uniformly shuffled. Obviously this is SLOW (for a deck of 52 cards, we are talking about more than $> 400$ steps).
</div>

## Coupling in Inverse-Riffle Shuffle

TODO

## Key Takeaways

- We couple stuff, because analysing $\Pr[X_t \neq Y_t]$ is easier than analysing 
$$||\pi - P_s^t||_{TV}$$
. Intuitively, it's easier to tell when two random walks have converged to the same state than to tell when one walk has converged to a stationary distribution.

- We "try" to couple with a lot of shared randomness, so that this upper bound of $\Pr[X_t \neq Y_t]$ is tight.

- If you look at the problem only from the lens of linear algebra/probability, you might miss out on the **obvious** intuition of why Inverse-Riffle Shuffle should mix faster. Looking at the graph of the markov chain, we see how dense it is, having $2^n$ outgoing edges from each node, compared to the $n$ outgoing edges in the Put-On-Top Shuffle.

- Once mixed, there is no point in doing more shuffles. [7 riffle-shuffles](https://math.hmc.edu/funfacts/seven-shuffles) for a standard deck is the golden number.

## Follow-up Side-Quest

In both the shuffles, how many random bits did we use to ensure that we end up in a well-shuffled deck? 

In **Put-To-Top Shuffle** we generated a random number to decide the card to put at the top in each step (i.e. $\log_2{n}$ random bits) and we did this $O(n\log{n})$ times, so total we used: $O(n\log^2{n})$ random bits.

In **Inverse-Riffle Shuffle** we generated a random bit to decide the label of each card (total $n$ random bits) and we did this $O(\log{n})$ times, so total we used: $O(n\log{n})$ random bits.

> Question for you: Can you show if there is a shuffling strategy which takes $< O(n\log{n})$ random bits and still gives you a well-shuffled deck? If not, can you prove that $O(n\log{n})$ random bits is indeed the lower bound?

## References

TODO

[^1]: 1: This constant 1/2e is arbitrary, but a common choice in literature. You can see these lecture notes [here](https://web.stanford.edu/class/cs265/Lectures/Lecture15/l15.pdf) which explain how mixing time is generally referred to in asymptotic sense, so $\tau_{mix} = O(f(n))$, for some function $f(n)$ where we don’t worry about the constants.

[^2]: 2: Proof of why the last inequality holds is important but slightly irrelevant to our discussion. It is in lecture notes from [^1] as proof of Fact 7.

[^3]: 3: This is non-trivial, refer to proof of Fact 2 in the lecture notes from [^1]

[^4]: 4: Technically speaking, we want the $\Pr[X_t \neq Y_t]$ to fall below this $1/2e$ threshold for a small enough $t$ quickly, which is intuitively the same as saying that the 

[^5]: 5: The same card, not the same index, so if $X_t$ picked 5 of Hearts, then $Y_t$ also picks 5 of Hearts
