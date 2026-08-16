---
layout: post
title: Entropy stops this algorithm
tags:
  - technical
---

Here is a weird way to prove that an algorithm terminates quickly.

Say the algorithm flips random coins and fixes things. Each fix might break something else, so it fixes that too and so on.

Also assume there is no easy way to quantify progress, i.e. a potential-function kind of analysis doesn't work or is cumbersome.

We will show that if the algorithm ran for too long, then its execution could be used to **compress random strings**. Here random strings come from the coin flips we did.

It is a well-known fact[^1] that most random strings cannot be compressed, so the algorithm cannot run for too long.

In this blog post, we'll explore this super unorthodox way of analysing an algorithm.

Formally, it's known as Moser's entropic proof of the algorithmic Lovász Local Lemma (LLL). For the exact details, see [Gregory Valiant's Stanford CS265 lecture notes](https://theory.stanford.edu/~valiant/teaching/CS265/lectureNotes/l12.pdf). Greg taught us this argument with an enthusiasm that made the idea stick with me; hopefully this post passes some of that enthusiasm on to you.

## An example

We'll use $k$-SAT.

A SAT formula is an AND of clauses, each an OR of variables or their negations. In $k$-SAT, every clause contains $k$ variables.

Consider three clauses from a 3-SAT:

[
C_1=(x_1\vee x_2\vee x_3)
]

[
C_2=(\neg x_1\vee x_4\vee x_5)
]

[
C_3=(\neg x_4\vee x_6\vee x_7)
]

Here our goal is to find an assignment of $x_1, x_2, \ldots, x_7$ such that 

[
C_1 \wedge C_2 \wedge C_3 = 1
]

Let's propose an algorithm that solves this: 

- Start with some arbitrary assignment of $x_1, x_2, \ldots, x_7$ 

- Whenever a clause $C$ is violated, resample all its variables. If this leaves an overlapping clause violated, recursively fix that one.

- Once all 3 clauses are satisfied, return the current assignment of $x_1, x_2, \ldots, x_7$

Crudely:

```text
FIX(C):
    resample all variables in C
    while some clause C' sharing variables with C is violated:
        FIX(C')
```

So a repair can trigger another repair, which can trigger another.

Why doesn't this recursion continue forever?

## Three repairs

Start with

[
(x_1,x_2\ldots,x_7)=0000000.
]

$C_1$ is violated. Resample its variables to $100$:

[
0000000 \rightarrow 1000000.
]

This fixes $C_1$ but breaks $C_2$.

Resample $(x_1,x_4,x_5)$ to $110$:

[
1000000 \rightarrow 1001000.
]

Now $C_2$ is fixed but $C_3$ is broken.

Resample $(x_4,x_6,x_7)$ to $110$:

[
1001000 \rightarrow 1001010.
]

Done.

We consumed nine random bits:

[
100\;110\;110.
]

Now throw them away.

## Proposing the compression algorithm

Suppose I only give you the **final assignment and the repair history $C_1\rightarrow C_2\rightarrow C_3$**

Can we recover the randomness?

Start at

[
1001010.
]

The last repair was $C_3$. Its variables $(x_4,x_6,x_7)$ are $110$, so those were the last three random bits.

Before the repair, $C_3$ was violated. The **only** assignment that violates

[
C_3=(\neg x_4\vee x_6\vee x_7)
]

is $(x_4,x_6,x_7)=100$.

So rewind:

[
1001010 \rightarrow 1001000.
]

We're now immediately after $C_2$ was repaired. Its variables $(x_1,x_4,x_5)$ are $110$, giving us the previous three random bits.

Rewind to the unique assignment that violates $C_2$, $(x_1,x_4,x_5)=100$:

[
1001000 \rightarrow 1000000.
]

Now $C_1$ reveals the first three random bits, $100$. Rewind once more to the only case where $C_1$ is violated:

[
1000000 \rightarrow 0000000.
]

So from the final assignment and repair history we recovered

[
100\;110\;110.
]

The randomness wasn't lost. **It got encoded in the execution.**

## The size of the history matters

Reversibility alone isn't enough. If we use $1000$ random bits and need $2000$ bits to describe the execution, congrats, we have invented decompression.

So the history must be cheap. **Suppose every clause overlaps with $\leq 2^{k-3}$ clauses**[^2]

Once we know the current clause, identifying an overlapping clause, now costs at most $\log_2(2^{k-3})=k-3$ bits.

Remember that `Fix` is recursive, so its execution forms a tree. We also need to say whether we descend to a child repair, move to another sibling, or return to the parent. Three possibilities fit in $2$ bookkeeping bits.

So a repair costs at most $(k-3)+2=k-1$ bits of history.

But the repair consumes $k$ fresh random bits.

That's our gap:

[
k\text{ random bits}
\quad > \quad
(k-1)\text{ history bits}.
]

## Let it run for too long

After $T$ repairs we've consumed $kT$ random bits.

Representing the history costs $(k - 1)T$ bits and the final assignment costs $n$ bits. 

So another way to look at execution of `FIX` is as a compression scheme: it encodes $kT$ random bits using only $(k-1)T+n$ bits.

Effectively, we save $kT-n-(k-1)T=T-n$ bits.

Once $T > n$ we enter the interesting territory of compression. Say $T = n + c$, we now have compressed a random string by $c$ bits. Only an exponentially small fraction of random strings can do that[^1]

So long executions are exponentially unlikely. That's the proof.

## Where did LLL enter?

In the sparse dependencies.

A repair can only recurse into one of relatively few overlapping clauses. That makes the execution tree cheap to describe.

The full Lovász Local Lemma is more general than the $2^{k-3}$ bound above, but the intuition here is:

[
\text{sparse dependencies}
\Rightarrow
\text{cheap history}
\Rightarrow
\text{long execution compresses randomness}.
]

## Can we be smarter?

The repair algorithm is intentionally dumb: it completely rerandomizes all $k$ variables.

Why not choose a smarter assignment that tries harder not to break neighboring clauses?

That might indeed be a better algorithm, at least in some greedy intuitive sense. But notice that full rerandomization is actually useful for this proof: every repair injects $k$ fresh random bits while producing at most $k-1$ bits of history.

A more targeted repair might use less randomness (say < $k - 1$ random bits), then this simple compression argument would no longer work.

**From the proof's perspective being dumb is a feature, not a bug**

[^1]: A simple counting argument: there are $2^m$ strings of length $m$, but only $2^{m-c}$ strings of length $m-c$. So only a $2^{-c}$ fraction of $m$-bit strings can have distinct $(m-c)$-bit encodings. There simply aren't enough short descriptions to go around.

[^2]: In this example $k = 3$, and clearly $C_2$ overlaps with both $C_1$ and $C_3$ so the $\leq 2^{3-3} = 1$ constraint of overlapping is not met. Treat this example as merely a toy for small $k$ to visualize the proof technique. 

<iframe src="https://strawpoll.com/embed/polls/mpnb1wVrYy5" width="800" height="420" frameborder="0"></iframe>
