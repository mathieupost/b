---
title: An Ontology of Developer Productivity
date: 2018-01-15
preamble: |
  Work on developer productity can be sorted into five factors:

  1. **Clarity**: Helping developers understand what to do;
  2. **Efficiency**: Helping developers do things faster;
  3. **Leverage**: Increasing the value of the things developers do;
  4. **Continuity**: Reducing the amount of idle time while waiting on computers or other humans;
  5. **Focus**: Increasing the proportion of attentional cycles spent on the task at hand (promoting
     [flow](https://en.wikipedia.org/wiki/Flow_(psychology))).

  ---
...

## Modelling a Developer

For our purposes here, we'll imagine a developer a system that performs this sequence of tasks, *ad
infinitum*:

1. Choose a task to work on;
2. Perform the next step of the action;
3. Wait for feedback on the step;
4. If the task is not done, go to step 2.

In step 1, developers choose a task to work on, based on their own internalized (inherently lossy)
copy of the organization's and team's goals and values, and the imperfect tools available to them to
help them understand both what tasks are valuable, and how to interact with the codebases and
systems available to them.

In step 2, developers choose the some part of the task to work on, until they are blocked on
feedback from a computer or another human (for example, running a test).

In step 3, developers wait on feedback from the other system, typically accomplishing very little in
the meantime.

Additionally, we need to recognize the inputs and outputs of this system:

* The **Input** is a series of [*Attentional
  Cycles*](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3081809/) that the developer applies to the
  problem, over a certain amount of time.
* The **Output** is a certain amount of value created for the organization.

## Modes of Improvement

Based on the model above, we can identify five dimensions for improvement, where the goal is to
maximize the value created by the developer:

1. Improving the efficiency of step 1 (**Clarity**: helping developers make good decisions about
   tasks to work on, which maximize value);
2. Improving the efficiency of step 2 (**Efficiency**: helping developers work faster);
3. Increasing the amount of value delivered by a task (**Leverage**);
4. Reducing or eliminating instances of step 3;
5. Increasing the proportion of *Attentional Cycles* applied to the task.

### Clarity

*Clarity* is the factor that encourages developer to choose tasks that align correctly with creating
value. There are three main sub-dimensions here:

1. Building mental models that allow developers to correctly choose high-value tasks;
2. Building understandable systems that allow developers to quickly build context in new projects
   and domains;
3. Building discoverable systems that allow developers to find out how to solve problems at a high
   level.

### Efficiency

*Efficiency* defines how quickly developers are able to solve problems given the tools they have.
For example, a developer using `nano` is going to be much less efficient than one using — and
skilled with — `vim` any IDE, etc.

### Leverage

*Leverage* is the amount of impact that a given task has. For example, an extremely
configuration-heavy specification that a developer must write each time they want to deploy a new
service might *feel* productive to that developer, but if tooling could be written that would infer
95% of that configuration, the developer would have more *Leverage*.

### Continuity

*Continuity* is reflective of the amount of time that a developer spends waiting for feedback from
other systems, computer or human. It is simply the proportion of time that a developer is not
actively blocked. For example, waiting for tests, code review, server boot-up, and slow API requests
are all examples of degraded *Continuity*.

### Focus

This part might seem a little abstract at first. When trying to pay attention to something, we're
incessantly pulled in a bunch of different directions at once. There's [some
research](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3081809/) to suggest that our mental activity
can be analyzed as individual *Attentional Cycles*.

When a developer is attempting to multi-task, their attention bounces back and forth between the
task at hand and the other task (with some additional penalty due to context switching).

There are myriad ways *Focus* can be improved. For example:

* Encouraging developer happiness (unhappiness drives distraction, burning attentional cycles on the
  unhappiness);
* Building tools that don't require multi-tasking, reducing context-switching overhead;
* Discouraging open-concept workspaces to minimize time spent filtering overheard conversations
  (corresponding negative impact to *Clarity*, due to less free context sharing);
* and so on.
