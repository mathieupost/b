---
title: Carrot, Stick, and Battery
date:  2017-12-20
toc: false
...


Every change to a user's (developer's) behaviour is encouraged by [some amount of *carrot* and some
amount of *stick*](https://en.wikipedia.org/wiki/Carrot_and_stick).

There is always a switching cost for habits and workflows. In the case of *carrot*-motivated changes,
the developer perceives enough value in the change that they make the change themselves with no
additional encouragement.

When a user doesn't perceive enough benefit in a change that they willingly make it themselves, the
team has to implement a "stick" — extra incentive to make the change, typically through negative
reinforcement of the old behaviour.

The additional element here is the fusion of "Carrot and Stick" with Tobi's concept of [Trust
Batteries](https://www.nytimes.com/2016/04/24/business/tobi-lutke-of-shopify-powering-a-team-with-a-trust-battery.html).
Consider that each "Stick-based" change drains our team's Battery, and each *carrot*-based change
charges it. Resistance to stick-based changes increases as the battery drains, as does skepticism of
*carrot*-based change.

Thus, it's desirable to maintain a healthy weight toward *carrot*-based change and spend our battery
on stick-based change only when truly necessary.

<section>

To elaborate this idea even further, for a proposed adaptation $A$, take $B_A$ to be perceived
benefit of the adaptation and $C_A$ to be the perceived adaptation cost. Then $V_A$ is the perceived
value of an adaptation in:

$$
V_A = B_A - C_A
$$

A developer will only adopt $A$ if $V_A > 0$, in which case we can call $A$ a "*carrot*-based"
adaptation. If $V_A \le 0$, we have to apply an extra incentive, in the form of negative
reinforcement of the old behaviour ($S_A$) in order to make the effective value positive
— making this a "*stick*-based" adaptation:

$$
V_A + S_A \ge 0
$$

We define a developer's trust battery $T$ to be a sum of all historical value $V$ minus "*stick*"
$S$, subject to two different decay factors $\lambda$ and $\mu$, where $\lambda > \mu$ (slower
decay) to account for [Negativity Bias](https://en.wikipedia.org/wiki/Negativity_bias).

$$
T_m = \sum_{n=1}^m V_n e^{-\lambda(m-n)} - S_ne^{-\mu(m-n)}
$$

In observing that developers are likely to be skeptical of changes from a team that they have a
depleted trust battery with, we note that the perceived benefit $B_n$ can be decomposed. Let $U_n$
be the portion of perceived benefit $B_n$ *not* biased by the trust battery, and let $T_n$ be the
value of the trust battery, with $\alpha$ as some constant factor:

$$
B_A = U_{A} + \alpha T_{A-1}
$$

Putting this all together, we get:

$$
V_A = U_A + \alpha T_{A-1} - C_A
$$

$$
V_A + S_A \ge 0
$$

$$
T_0 = 0
$$

$$
T_m = \sum_{n=0}^m (U_n + \alpha T_{n-1} - C_n)e^{-\lambda(m-n)} - S_ne^{-\mu(m-n)}
$$

The most interesting thing to note here is that there's a feedback loop in subsequent values of $T$:
An initially high value of $T$ makes it easier to apply adaptations without using *stick* ($S$),
which makes it easier to continue to increase $T$. Conversely, a low trust battery tends to require
*stick*, causing continued erosion of trust. Additionally, because of the exponential decay factors,
old reputation can be quickly overcome by a series of more recent failures or successes, but
failures are harder to wipe away than successes.

</section>
