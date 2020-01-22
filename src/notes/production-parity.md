---
title: 'Production Parity'
date: 2020-01-22
toc: false
...

### TL;DR:

1. **Production Parity is a good thing, but:**
2. **Production Parity exists in an optimization space alongside other good things; and**
3. **People overestimate the cost of reduced Production Parity.**

---

The idea of production parity in development environments gets thrown around a lot. Making
development environments more like production has some objectively useful aspects:

* Developers spend less time thinking about whether their code has to behave differently in
  different contexts; and
* Fewer errors are introduced due to this divergence.

However, everything has a price. Production parity doesn't exist in a vacuum, and making development
behave more like production often means running heavier-weight tools on development machines than
would otherwise be necessary. Heavier tools inevitably slow the developer's core workflows, which
has less-apparent impacts on reliability and even overall product velocity.

In working on tooling for the better part of the last decade, I've observed that the number of
errors arising out of divergence between development and production is lower than most people
intuitively feel it should be: CI tends to catch most things that developers don't, and canary
deploys where available should catch the rest.

Conversely, it's hard to imagine how we might measure the consequences of improvements or
regressions in developer workflow delays, but I think everyone should be able to wrap their heads
around how this is, in fact, A Thing.

My core point is:

1. **Production Parity is a good thing, but:**
2. **Production Parity exists in an optimization space alongside other good things; and**
3. **People overestimate the cost of reduced Production Parity.**
