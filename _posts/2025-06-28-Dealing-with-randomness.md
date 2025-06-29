---
layout: post
title: Dealing with randomness
tags:
  - personal
---

This post is a reflection (can also be read as _rant_) on my master's experience - internship hunting, securing funding, and the in-betweens. It attempts to acknowledge the noise and randomness in feedback loops I encountered during this experience.

_Note: This post is a bit long and at places specific to Stanford, so feel free to skip to the sections that interest you._

_Disclaimer: The opinions expressed are my own and do not reflect the views of any current or past organizations, or educational institutions I am associated with._

## Table of Contents

The sections below are titled like “how-to” guides, but they’re really just my internal monologue, what worked (or didn’t) for me during the journey.

- [Background](#background)
- [Admission Process](#admission-process)
- [Which courses to take / area to specialize in?](#which-courses-to-take--area-to-specialize-in)
- [How to procure funding as a CA / RA?](#how-to-procure-funding-as-a-ca--ra)
- [Where to intern in the summer? How to prep?](#where-to-intern-in-the-summer-how-to-prep)
- [Conclusion](#conclusion)

## Background

I completed my undergrad in CS from the National University of Singapore (NUS) in 2021. I then worked for ~2 years at a trading firm (Citadel Securities) as a software engineer. After my 1st year on the job, I applied for a master's in the US. My motivations were:

- I still had a desire to learn more CS in classroom settings, especially theory courses, and gain some ML-related domain knowledge.
- Accepted the opportunity cost of two more years in academia to upskill, but more importantly expand my network in the US. I've found it easier to build friendships in school than at work. Only time will tell if this opportunity cost was worth it or not.
- Wanted to explore a more quant/math-based role compared to software engineering. I believed going back to school would give me time and opportunities to pivot and see if it matches my expectations.
- Lastly, while shallow in isolation, a recognizable university name builds credibility and might give me access to opportunities otherwise unavailable.

### Admission Process

I applied to 7 universities, with admits from Stanford[^1] and UMich. I expected rejections from some (CMU, Berkeley, Cornell) given their selectivity. Others (like Columbia, UT Austin) were more surprising. I believe my SOP (Statement of Purpose) might not have been as competitive as those of the top applicants, and my hunch is that Stanford has a positive bias towards high-GPA NUS undergrads (a category I fell under).

My SOP was about 80% the same across universities, but it became more refined over time. Stanford's early deadline (~early December) meant I submitted my least refined SOP to them. This highlights the inherent randomness in life, a recurring theme throughout this post.

## Master's Experience

Coming in, I thought (i) which courses to take would be the biggest decision to make. Turns out, (ii) how to procure funding and (iii) internship hunting were the more time-consuming aspects. This post is mostly about the latter two.

### Which courses to take / area to specialize in?

Initially, I focused on CS theory, taking courses like Cryptography, Quantum Computing, and Randomized Algorithms (you might ask why such a course again, well coin flips are <3).

As quarters went by, I mostly (~70%) stayed true to my initial focus but now also diversified into:

- ML courses: With the rise of LLMs and the market’s response at Stanford, I felt it was essential to gain exposure to some of the commonly used ML techniques. Stanford's deeply entrepreneurial culture is a double-edged sword. On one hand, the work being done here is impactful and applicable in startups/big-tech. On the other hand, it incentivizes students, profs, and research labs to have a locally greedy approach, focusing on the next hot thing (LLMs during this period) because it yields more job opportunities, publications, and funding.

- Blockchain/Cryptography courses: I was fortunate to be taught by Prof. Dan Boneh. His courses on cryptography and blockchain break down the fast-moving and context-heavy space into digestible chunks. His exams made one think about  why we make certain assumptions or why we do certain steps in specific protocols. Even small tweaks in smart contracts or cryptographic protocols often break their key properties, and I only appreciated these design subtleties after taking these courses. Lecture notes [here](https://cs251.stanford.edu/) and [here](https://crypto.stanford.edu/~dabo/cs255/).

- My narrow exposure to Systems courses: I took Parallel Computing in one of the quarters on the recommendation of my peers, which turned out to be a great experience. Prof Kavyon is a great teacher with an excellent pedagogy for explaining the nuances of multi-threading, memory-bandwidth boundedness, GPU layout, CUDA programming, and more. The course had high-quality assignments with high performance as its central theme. Lecture notes [here](https://gfxcourses.stanford.edu/cs149/fall24)

- I also took Discrete Probabilistic Methods in my last quarter. My post on it is [here](https://www.sidhantbansal.com/2025/When-Probability-Guarantees-Certainty/) which hopefully sells you on how amazing this topic is.

- As for the underwhelming aspect, took Convex Optimization and Quantum Computing courses too at some point but they were not as engaging as I had hoped. The Quantum Computing course's math felt a bit mechanical to me and I was unable to build a strong intuition about the computing model. Probably more of my limitations than the course's. As for Convex Optimization, the first couple of lectures covered what a convex constraint setting is and how to solve it. Later on, it was mainly applying the techniques learned to a bunch of word problems which felt less interesting.

Thanks to the quarter system, CS grad students typically take 10-12 technical courses (excluding research/startup-related courses). That's a plus for folks like me, who plan to return to the industry as it offers a wider breadth of knowledge. This also provides flexibility in the kind of courses a student takes, I know people with theory specialization (same as mine), who had < 40% overlap in courses with me, which shows how flexible the curriculum can be. This is a big positive about the program since you can take courses you are interested in, rather than being forced into taking a large set of mandatory courses.

Now going to (ii) and (iii) the crux of this post.

### How to procure funding as a CA / RA?

Discussions with seniors just at joining had suggested that it was rather common for a lot of international students (in CS and EE departments) to fund their entire program through CA (Course Assistant) or RA (Research Assistant) positions. The financial incentive is significant for CAs/RAs - they get tuition fee waived + make some money on top (~combined, say 20k per quarter), officially working for 20hrs/week, though actual effort is often less.

However, our year turned out to be special (not in a good way):

- In 1st year, only a few international CS students secured CA positions (~6 of the 12-15 I knew), likely due to a new rule barring first-quarter students from applying for these positions.

- During 2nd year, within the CS department, most of my international friends had figured out some way to sustain a CA/RA, so overall the situation got much better. Contributing reasons for the same: people had gotten time in the first year to build rapport with profs; had already taken (+ done well) in a couple of courses, which they could now CA; our seniors had graduated, so we were senior-most

My personal experiences with CA/RA positions:

- Intentionally took some courses with larger batch sizes earlier on and pushed the more niche courses to latter quarters, so I could potentially CA the larger ones that had more slots (and thus were easier to get). This trick paid off in my final quarter, where I CA'ed for an ML-related course with a large batch size, that I had previously done well in.

- Did not get to CA for the standard algorithms course, despite having prior TA experience at NUS with the same and a strong competitive programming background. This was disappointing. I speculate the decision makers apply certain filters (e.g., American undergrad university, guaranteed funding student, past CA experience at Stanford) which I might not have met. However, this is purely based on personal observation (and may not reflect an actual policy).

- Did research with a prof in my second quarter for credits and secured a CA position for their algorithms-related course in the subsequent quarter.

- Researched with two other profs in the algorithm mechanism design space (less of theory and more of implementation-related stuff) in the third quarter for credits and subsequently secured an RA position with them for my fourth quarter (Autumn 2024).

Some observations:

- Getting the first CA/RA position is a chicken-and-egg problem, where you need a prof to take a chance on you without prior experience with them. In my own experience + people around me, saw that once you built a good rapport with a prof, it was much easier to extend that relationship across multiple CA/RA positions. It often rewards persistent cold-emailing and approaching different profs and research labs, which rarely anyone would enjoy, but many resort to.

- The logistic overhead of applying for CA/RA positions, emailing professors, having meetings/interviews, and researching labs—repeats three times a year under the quarter system, amplifying the “admin” burden around the real work. I would have spent ~20% of my CA/RA time on admin tasks. Maybe I am bad at managing my time, or the system itself is not optimized for this.

- Pushes students to optimize for short-term goals: timing courses, CA/RAing in areas they don’t envision being in long-term, or sticking with profs/research labs even when the work isn’t compelling. Not proud of it, but I probably optimized for similar short-term wins more than I would have liked.

- Obviously, external factors like course enrollment, funding status of prof's PhD students, and course offerings for a specific quarter also affect the availability of CA/RA positions.

In conclusion, it is naive to believe that there is a direct correlation between being a CA and being the ideal fit (both in terms of knowing the content + teaching it) for a given course. The slightly subjective/opinionated selection process, combined with external factors, makes the process much more random than one would like it to be.

Criticism aside, these CA / RA positions are a significant selling point of the program, helping students be debt-free when graduating and offering opportunities to learn the content better and get to know profs. It's great that the CS department has strong funding sources, though a less gamified allocation process would be preferable.

_Note: This reflects my perspective and limited sample size; other students may have had entirely different experiences._

### Where to intern in the summer? How to prep?

My priority was to intern at a quant shop - same industry I'd worked in before, but this time in a research role instead of pure dev. Given the slightly rough job market, I had tempered my expectations. As far as preparation goes, I used typical (leetcode equivalent for quant) resources such as:
- A Practical Guide to Quant Interviews
- Heard On The Street
- Fifty Challenging Problems In Probability
- Quantguide.io (Has a good collection of prob/stats/riddle questions)
- Brainstellar.com

Sidenote: I don't have anything against being a dev. It's still my most marketable skill and aligns with things I enjoy (and am good at): high-performance code, algorithmic thinking, and firefighting live (like ACing a contest problem in the final minute), but at its core is more skewed towards engineering a service/feature and less towards math/algorithms. I wanted to explore domains with a more balanced mix, hence my focus on quant/research-oriented roles.

I applied widely, received a fair number of cold and mid-process rejections, and eventually found a good fit with Tower Research.  I also interviewed at some self-driving and web3 startups, since I had reasonable interest in these domains too and to hedge the risk of going all-in on quant. Overall, the intern hunt required more grit than expected and reminded me of my freshman internship hunt back in 2018. I would attribute this unusual difficulty to:
- Quant vs Dev differences: longer process (OA, ~2 phone rounds, maybe a data challenge and then onsite) and slightly more diverse pool (candidates range across: CS/math/econ/physics undergrads/masters/PhDs)
- Sluggish feedback cycles due to the tough job market, where firms were probably optimizing for headcount/trying to get interview outcomes for multiple candidates aligned in similar timelines, so they could get the most bang for their buck.

Overall in quant interviews, I got the gist that:

- Collecting historical question banks and figuring out questions asked in the recent hiring cycle is super helpful since questions/puzzles/riddles are always inspired by some other source and sometimes outrightly repeated across firms and candidates. Also, math questions are one thing you might have a strong chance of cracking even if you haven't seen the question but have strong fundamentals, but riddles -- not so much. Riddles tend to have a single approach that works and often, it's not natural to be able to derive the solution from first principles in a time-constrained setting, if you haven't seen the same/inspired riddle elsewhere. Also, riddles/puzzles are relatively limited and hard to invent, so they have well-defined question banks that one can work against.

- Other types of questions, can vary across a variety of domains: prob/stats, numerical analysis, algorithms/cp, linear algebra, to name a few. The scope of making errors is relatively less, say you get 4-5 questions in an interview (these are short questions if you know how to do them, so takes ~5-10mins per question, unlike dev interviews which typically can have only 1-2 leetcode style questions) it is quite likely to get a reject if you fumble on even a single question. Equivalently if a problem is being built up in parts throughout the interview, if you fumble on say the 3rd/4th extension of the question, even that can result in an exit (been there, done that). So overall the process felt less forgiving.

- Cold rejects are somewhat common. I suspect candidates with PhDs in math/cs/econs/physics background face this less. Another hunch, I have is, since the relative slowdown of big tech hiring post ~2021, the quant hiring process has tighter cold-reject filtration since these firms are receiving a larger number of applications.

- I saw a few folks who landed 1-2 offers from top-tier firms in the industry but the same people were also rejected and ghosted by a bunch of other reputable companies. Such variance seemed common.

## Conclusion

Like a broken tape recorder, I'll say it again: randomness showed up everywhere[^2] during this master's program. A lot of times things turned out in my favor (got into a good university, interned at a good place and CA/RAed some quarters), so not complaining per se.

My advice to folks working through other opportunities (be university/intern/job hunting) would be to actively try to disassociate themselves with individual outcomes (ex. a prof collaborates or not, a firm gets back to you or not, etc). Loosely inspired by Taleb and Wei Heng (one of my NUS seniors), a model to digest the uncertainty is to view these outcomes as a sample from an underlying probability distribution that you can influence by your actions, but never fully control.

Example: If you are aiming for a good grade in a course, you start with some probability distribution over {A+, A, B+, ...} at the start. Then, your preparation - attending lectures, doing problem sets, etc - helps shift this distribution in your favor. Ultimately, the grade you receive is going to be __sampled__ from this distribution, influenced by factors like - How sharp you are on exam day? How did others do? Did the topics you are good at get tested? Etc (i.e. the real-life "luck" explaining factors). In such a setting where the output can take plenty of values (is almost continuous from A+ to D), granular feedback gives you a sense of where you stand, making the variance easier to stomach. But in scenarios like - getting an offer from a firm, or a research opportunity with a prof - where the result is a simple yes/no, the cold rejects feel much harsher. Say you estimated an 80-20 chance of getting through, but now you see the reject. You're no longer sure whether it was really 80–20 and just a bad day, or 60–40, or even 30–70. The lack of granular feedback in such cases makes it harder to update your prior beliefs.

Poker makes this clearer as an analogy (I know it's cringe to use poker as an analogy but bear with me) where a decision is good or bad, not by how the play ends, but whether it had good expected value (EV) with the information available at the time. TL;DR sometimes you do make the correct positive EV decisions but still don't see the payoff and that is life. Poker is simpler since you have explicit odds, real-life scenarios not so much, at best you have a gut feel/intuition of your prior odds.

Experiencing multiple rejections whether from universities or firms helps update your prior beliefs, re-evaluate your strategy, and manage expectations. Mitigating this randomness often means increasing sample size applying to more universities, reaching out to multiple professors, or interviewing at many firms. In probability terms, you’re shifting from a one-shot Bernoulli trial to a geometric distribution, where persistence increases the likelihood of eventual success (for my readers rusty in probability: bernoulli here refers to one coin flip whereas geometric refers to the number of coin flips needed to get the first head). Since this meta-strategy is widely known, everyone optimizes accordingly, leading to a global suboptimal equilibrium that has more noise and more spam in the system as a whole, but individual rational play.

I am still far from embracing randomness in my day-to-day life, but a step closer to acknowledging and dealing with it.

A lot of ideas presented here on thinking about randomness can be read in "Fooled by Randomness" (by Taleb) (Short summaries can be found online too, like [this](https://www.safalniveshak.com/seven-big-ideas-from-fooled-by-randomness/) one)

Ending on a good note, the best parts of this experience have been:
- Made plenty of good friends
- Played a ton of table tennis
- Improved my fitness: biking to campus regularly and picking up tennis
- Took some great courses: Randomized Algorithms, Cryptography, Parallel Computing, Probabilistic Methods
- SF has great weather, it reminded me of Singapore. Also not having Delhi AQI is always a plus.
- Partied (on free alcohol) a bunch of times

[^1]: Fun fact: My first encounter with a stanford.edu address was in 2014, applying to a math camp for school students.
[^2]: Slightly tangential places where randomness also kicked in: (i) Our university requires us to play a lottery for second-year housing, and I ended up in the < 5% chance scenario of not getting anything assigned after the first round of assignments. Fortunately, I got a place on campus subsequently in the second round - but ended up having to move my stuff two more times. (ii) Failed my first DMV driving test because I hit the curb while reversing, despite having practiced the maneuver just fine before. Call it a skill issue or an aberration in the matrix, either way, this set me back by ~400-500$ in driving lessons and test fees. Just goes to show how randomness can play a role in even the most mundane things.
