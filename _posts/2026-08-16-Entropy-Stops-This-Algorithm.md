---
layout: post
title: Entropy stops this algorithm
tags:
  - technical
---

Here is a weird way to prove that an algorithm terminates quickly.

Say an algorithm repeatedly uses fresh random bits to repair violated constraints. A repair might violate another constraint, which the algorithm then repairs using more fresh randomness, and so on.

Think of the randomness as a tape of independent random bits (each equally like to be $0$ or $1$) that the algorithm consumes as it runs.

Also assume there is no easy way to quantify progress, i.e. a potential-function kind of analysis doesn't work or is cumbersome.

We will show that if the algorithm ran for too long, its execution would give us a shorter description of the random bits it consumed. In other words, we could reconstruct the original random tape using fewer bits than the algorithm actually read.

It is a well-known fact that most random strings cannot be losslessly described using substantially fewer bits. So if a long execution gives us such a shorter description, long executions must be rare.

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

- Whenever a clause $C$ is violated, resample all its variables: independently assign each variable in $C$ a fresh uniformly random value (True or False). If this leaves an overlapping clause violated, recursively fix that one.

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

## Example dry run of three repairs

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

Suppose I give you only:
1. the final assignment, $1001010$, and
2. enough information to reconstruct the repair history, here $C_1\rightarrow C_2\rightarrow C_3$

Can we recover all nine random bits?

Start from the final assignment:

[
1001010.
]

The last repair was $C_3$. Its variables $(x_4,x_6,x_7)$ are $110$. Those values are exactly the three random bits sampled when $C_3$ was last repaired.

So we have recovered the final three random bits: $110$

To rewind further, we will need to identify what the variables looked like before this repair. 

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

More generally, the final assignment and repair history are enough to rewind the entire execution and recover the random bits used by the algorithm.

## The size of the history matters

Reversibility alone isn't enough. If we use $1000$ random bits and need $2000$ bits to describe the execution, congrats, we have invented decompression.

So the repair history must be cheap to encode. 

Build a graph whose vertices are the clauses, with an edge between clauses whenever they share a variable. **Suppose every clause overlaps with $\leq 2^{k-3}$ clauses**[^1]

Suppose we are repairing clause $C$, and it triggers a repair of some overlapping clause $C'$. Since $C$ has at most $2^{k - 3}$ neighbours, we can number them: $0, 1, \dots, 2^{k - 3} - 1$. 

We don't need to store the full id of $C'$ among all clauses in the $k$-SAT. Once the decoder knows $C$, it only needs to know which numbered neighbour of $C$ came next. This local index takes at most $\log_2(2^{k - 3}) = k - 3$ bits.

Remember that `Fix` is recursive, so its execution forms a tree. Think of walking this tree depth-first, we also need to record how the traversal moves: descending into a child repair, moving to a sibling, or returning to the parent. These three possibilities fit in $2$ bookkeeping bits.

So each repair costs $(k-3)+2=k-1$ bits of history.

But repairing a $k$-variable clause consumes exactly $k$ fresh random bits.

That's our gap:

[
k\text{ random bits}
\quad > \quad
(k-1)\text{ history bits}.
]

## Let it run for too long

After $T$ repairs we've consumed $kT$ random bits.

And we know from the previous sections, those bits can be reconstructed from:
- the repair history, costing $(k - 1)T$ bits, and
- the final assignment, costing $n$ bits (where $n$ is the \#variables in $k$-SAT)

So another way to look at execution of `FIX` is as a compression scheme: it encodes $kT$ random bits using $(k-1)T+n$ bits.

Effectively, we save $kT-n-(k-1)T=T-n$ bits.

If $T = n + c$, then a $kT$-bit random string has been described using only $kT - c$ bits.

Now use the counting fact. There are $2^{kT}$ possible $kT$-bit strings, but only $2^{kT-c}$ descriptions of length $kT - c$, therefore at most a $2^{-c}$ fraction of all $kT$-bit strings can have a $c$-bit shorter lossless description.

$$\Rightarrow \Pr[T \geq n + c] \leq 2^{-c}$$

So long executions are exponentially unlikely. That's the proof.

## Why sparse dependencies matter

A repair can recurse only into one of relatively few overlapping clauses. That makes the execution tree cheap to describe.

This sparsity condition is exactly the kind of condition captured by the Lovász Local Lemma (LLL): roughly, bad events can be individually unlikely as long as they don't depend on too many other bad events. The full LLL is more general than the $2^{k - 3}$ bound above, but the intuition here is:

[
\text{sparse dependencies}
\Rightarrow
\text{cheap history}
\Rightarrow
\text{long execution compresses randomness}.
]

Without the sparse-dependency assumption, the next repair could be any of the $m$ clauses, identifying it would cost roughly $\log_2{m}$ bits per repair. There would be no reason for $\log_2{m}$ to be smaller than the $k$ fresh random bits consumed by a repair. We would lose the gap between *randomness consumed* and *history needed to describe the execution*, and the proof would no longer work. 

## Can we be smarter?

The repair algorithm is intentionally dumb: it completely rerandomizes all $k$ variables.

Why not choose a smarter assignment that tries harder not to break neighboring clauses?

That might indeed be a better algorithm, at least in some greedy intuitive sense. But notice that full rerandomization is actually useful for this proof: every repair injects $k$ fresh random bits while producing at most $k-1$ bits of history.

A more targeted repair might use less randomness (say < $k - 1$ random bits), then this simple compression argument would no longer work.

**From the proof's perspective, being dumb is a feature, not a bug**

[^1]: In this example $k = 3$, and clearly $C_2$ overlaps with both $C_1$ and $C_3$ so the $\leq 2^{3-3} = 1$ constraint of overlapping is not met. Treat this example as merely a toy for small $k$ to visualize the proof technique. 

<iframe src="https://strawpoll.com/embed/polls/mpnb1wVrYy5" width="800" height="420" frameborder="0"></iframe>
