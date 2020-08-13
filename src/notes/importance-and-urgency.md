---
title: Importance and Urgency
date: 2020-08-13
toc: false
...

_This is a mental model that I've been mulling for a number of years. I realized while writing this
article that I probably cribbed it from [Eisenhower's
Principle](https://www.mindtools.com/pages/article/newHTE_91.htm) early on, but it's different now._

Every communication sits somewhere on a two-axis system. The axes are:

* **Importance**: How important is it that the receiver receives and understands this message?
* **Urgency**: How time-sensitive is this message?

I'm going to call these **IU** for "Importance and Urgency".

Every communication medium has a **Natural IU**, based on the way the system fundamentally works and
the user interaction paradigms that it encourages. Some examples of **Natural IU**:

* **Phone calls** are high-importance, high-urgency
* **Tweets** are low-importance, low-urgency
* **Postal mail** is high-importance, medium-low-urgency

This value doesn't tell the whole story, though.

## Adjusted IU

Most communication tools have different features that can be used to nudge the **Natural IU** up or
down. For example, `@channel` in Slack adjusts the importance and urgency of a message up
substantially, and putting "ACTION REQUIRED" in the subject line of an email adjusts the importance
up substantially (and perhaps the urgency somewhat).

We'll call this **Adjusted IU**, but it still doesn't tell the whole story.

## Sender IU and Receiver IU

When a Sender wants to send a message to one or more Receivers, they have some idea in their heads of how
Important and Urgent that message is. They choose a medium with a **Natural IU** and possibly a set
of adjustments for an **Adjusted IU** that will cause the receiver to interpret the message with the
same Importance and Urgency values.

Importance and Urgency are not really properties of the tools we use; they're entirely in our heads,
and no one will ever completely agree on values. These senses of **Natural IU** and **Adjusted IU**
are almost entirely cultural, apart from some specific limitations (phone calls require synchronous
voice communication, making them inherently urgent).

This leaves us with each message being interpreted with a **Sender IU** and a **Receiver IU**.

Communications work best when:

1. A culture settles on a consensus for the **Natural IU** values of their communications tools and
  **Adjusted IU** values of the various adjustment knobs available. (i.e. how important and urgent
  is it, really, when a particular channel is `@here`'d?); and
1. **Sender IU** and **Receiver IU** are broadly similar.

But let's dig into that a little more—what does it mean for **Sender IU** and **Receiver IU** to
disagree?

## Disagreement

If **Sender IU** is high Importance, high Urgency, the Sender will often choose methods of
communication that, within the culture, have high and **Adjusted IU**. The Receiver decodes the
medium and adjustments on their end into a mental model of the **Sender IU**. I guess if we want to
introduce yet another term, we could call this **Inferred Sender IU**.

If the **Inferred Sender IU** and the **Receiver IU** mismatch often enough, the Receiver's internal
modelling of the **Natural IU** and **Adjusted IU** will start to diverge from the cultural design
for these values.

When an agent's modelling of **Natural IU** and **Adjusted IU** diverge from the cultural design,
they may apply their own adjustments to bring the entire medium more into line with their
expectations (e.g. muting a channel, turning off notifications).

These attenuation effects for Importance and Urgency don't only affect one agent in the system
though. Typically, the entire cultural consensus of **Natural IU** and **Adjusted IU** shifts over
time.

## Tragedy of the Commons

It's common for Senders to over-estimate the importance of their messages, especially when they're
broadcasting to a wide audience. It's also common for Senders to not consider the level of Urgency
implied by their choice of medium. This seems to lead to an effect where the cultural assessment of
**Natural IU** is slowly calibrated downward over time. This is really easy to see in Email. How
many emails do you get that seem really important to the person who wrote them, but have no real
bearing on your job or life? I know I've attenuated my **Natural IU** for the entire medium of email
quite a bit.

I feel like there are more thoughts to flesh out on this train of thought but I'm tired of writing
for now.

## Conclusion

I don't have any particular message here, but I think this is a really useful mental model, and if
everyone in a culture understood it, that culture would probably trend towards healthier
communication systems. In short:

* Senders and Receivers of messages always have Importance and Urgency assessments of the messages
they're sending.
* Senders choose media (slack, email, ...) and adjustments (`@here`, etc.) to encode their
assessments.
* Cultures have distributions of assessments for the Importance and Urgency implied by the various
media and adjustments.
* Communications stay healthy and focus is disrupted least when a Sender's encoding and a Receiver's
interpretation of Importance and Urgency both agree with the cultural average; that is:
  * Everyone agrees on what the media and adjustments imply; and
  * Senders encode messages in a way that Receivers agree with.
