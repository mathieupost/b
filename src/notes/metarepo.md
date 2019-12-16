---
title: "Monorepo, Manyrepo, Metarepo"
date:  2017-10-10
...

The term "Monorepo" gets thrown around a lot, especially in reference to Google's (or Facebook's, or
Twitter's) internal development practices, where all source lives in a single repository.

The lesser-known term "Manyrepo" *(why this instead of "Polyrepo" is anyone's guess)* describes the
more common setup, encouraged by git and GitHub, where each project has its own completely separate
source repository.

This article discusses some of the relative merits of Monorepo and Manyrepo architectures, and then
attempts to define a hybrid approach preserving as much benefit as possible from both architectures
— a "Metarepo".

## Monorepo Architecture

What follows is an analysis of some major advantages and disadvantages of a Monorepo architecture
with a specific focus on comparison against the more common Manyrepo architecture.

### Advantages of Monorepos

#### Discovery

A Monorepo has all source organized in a single hierarchical tree. Related projects or components
can be grouped together, allowing users to more easily discover relationships between projects.

Imagine three logically-distinct codebases, implementing:

* A macOS app;
* A command-line interface to the same functionality provided by the app; and
* A packaging repo to bundle the app and the CLI into a single `.pkg` file for distribution.

These three projects would typically be modified separately from each other, and in some cases,
maybe even by completely different teams.

In a Manyrepo, these may be called `<project>-app`, `<project>-cli`, and `<project>`. The link
between them would have to be inferred from the shared prefix while browsing a list of projects, or
from documentation in the projects.

If the build project needs to refer to a specific revision of the other two, each project has to
define ad-hoc solutions (sometimes git submodules, sometimes by cloning to a build directory and
checking out a specified revision, sometimes something more creative).

Submodules may be used to implement a synchronous multi-project
commit.

```
<department/etc.>
└── <sub-team>
    └── <project>
        ├── app
        ├── build
        └── cli
```

The relationship could then be discovered just by browsing the hierarchy.

#### Simplified Dependencies

*(Incidentally, much of this is inspired by [Advantages of monolithic version control][danluu] by Dan Luu.)*

In a Monorepo, it's easy to depend on another project: just use code from a different path in the
hierarchy. At Google, it appears that this dependency is tracked via build dependencies encoded in
their Blaze (publicly, [Bazel]) `BUILD` files *(interestingly, [this
probably-accidentally-public-yet-Apache-licensed gist][wiseman] from a Googler gives some insight
into a lot of aspects of their workflow)*. When a subtree's dependencies are all extractable from
a `BUILD` file, and all of its dependents are also in-tree, it's possible to determine the full set
of callers and run their tests on each change.

This fact is important, so I'm going to restate it: with a Monorepo, library versioning is
de-emphasized. Instead, a library is expected to maintain a stable API and migrate its callers when
the API must change. This depends on being able to make atomic commits across the entire
world-state, which is simply not possible in a Manyrepo. This also implies a need for very
sophisticated dependency tracking or analysis, and excellent automated testing.

#### Dependency Rot *(or lack thereof)*

Note that at Google, the Monorepo includes *all* source used by projects, not just their own
first-party source. For example, if a Rails project `my-app` existed at Google and depended on
Nokogiri, one could assume that it would exist at a path in their Monorepo along the lines of
`//third_party/rb/nokogiri` as a single version, and the project would reference it via a `BUILD`
file dependency, maybe something like:

```
rails_app(name = 'my-app',
          ...
          deps = ['//third_party/rb/nokogiri', ...]
          ...
          )
```

Then, when a new version of Nokogiri were imported to `//third_party/rb/nokogiri`, the CI run would
include tests for `my-app` and any other callers (any subtree rooted with a `BUILD` file, presumably, whose [transitive dependencies] include this subtree).

This makes it much less likely for projects to "rot" via rarely-updated libraries.

#### Tooling

Knowing that all code available universally exists at a fixed path in a single shared hierarchy
makes it easier to build tools to perform operations on multiple projects.

In a Manyrepo architecture, any operation spanning multiple projects first has to know which
projects it's working on, and decide some hierarchical structure for them (typically, a flat
namespace for each GitHub account). It must hope that the revisions on the current master branches
are compatible if it's attempting to integrate the projects.

In some cases, it may not even be possible within a Manyrepo to interact with both projects in
source form without modifying one or the other. Imagine a Rails app running a rubygem specified in
`Gemfile` with a git source. In order to perform integration testing using local copies of both the
Rails app and the gem, one first has to modify the `Gemfile` to refer to the gem by path. Monorepos
eliminate this case: The Rails app would indicate a dependency on the gem in the source tree. If the
gem source changed, it would be rebuilt as a step in the Rails application build, and the
application would refer to the new version.

Relatedly, certain problems like static analysis, global dependency analysis, code search, and so
forth are simpler in a Monorepo just because of not having to juggle multiple repositories and hope
that master branches represent a consistent state.

### Disadvantages of Monorepos

#### Nonstandard/Custom Tooling

First and foremost, this is not the way the open-source world works. Bundler, rubygems, yarn — the
list goes on — the common case for these tools is fetching a package from a server with a given
version, unpacking it in some managed directory, and running it from there. Many CI systems and CD
pipelines will assume they are testing or deploying a unit that maps onto the repository as a whole.

While building a Monorepo does provide an organization with the unique ability to build tooling
precisely in alignment with what they need, the burden of having to do so is substantial. This is
getting easier over time as Google releases more public versions of their own tools ([protobuf],
[Bazel], [GRPC], and [Go], to name a few).

#### Upgrade Complexity

The requirement that there be a single version of source and that all dependent source be upgraded
synchronously can make it more difficult to iterate on an API, and removes a common tool used to
build confidence in less-safe changes. Presumably there are many ways to work around this, but
developers coming from the open-source world will not be familiar with them.

#### High CI Burden

Automatically running tests for the full set of transitive dependencies on each change gets
expensive, especially because the most complex applications tend to be the ones with the most
dependencies.

#### Low quality tests more likely to produce failures

Care has to be taken to loop the right people in on every change, but at the same time, a downstream
consumer of a library won't always be interested in reviewing internal changes, even though they may
break their app through some unexpected means. In a Manyrepo, the application developer will usually
manually verify as they upgrade several libraries at once. In a Monorepo, it's almost completely
left up to automated testing to ensure that a library change is safe.

This can, of course, be viewed as a mixed blessing, in that it might encourage better test hygiene.

#### More difficult to change APIs

Again, a mixed blessing. While changing callsites becomes, at least to a degree, the domain of the
library author, which could slow down library development, it also encourages more thoughtful
interface design.

#### Challenging to manage Public/Private Split

It is difficult to export fragments of a Monorepo to the internet at large. Google does this using
[copybara], which literally copies code out of their Monorepo and into public repositories.

## Manyrepo Architecture

Largely recapping what we've covered above, a Manyrepo is a collection of smaller repositories: most
commonly git repositories all hosted under a single account on GitHub. All of the advantages
and disadvantages of Monorepos listed above are in contrast to Manyrepos, so there's no need to
rehash them here.

A few summary assertions based on analysis above:

#. Monorepos with sufficiently-good tooling and process probably encourage improved hygiene around:
     * testing;
     * dependency tracking;
     * code re-use;
     * code review;
#. Monorepos with bad or insufficient tooling/process probably perform worse in these areas than
   Manyrepos with bad or insufficient tooling/process; and
#. The relative utility of a Monorepo architecture appears to improve in correlation with an
   engineering organization's:
     * size; and
     * willingness to invest in tooling and process.

## In Search of an On-Ramp

Many of the advantages of Monorepos are tantalizing, but it's difficult to envision a way to migrate
a multi-thousand-project Manyrepo into a Monorepo wholesale. The number of components that would
have to change all at once would be overwhelming — just for starters:

* Code Review;
* Deployment;
* Container Image Builders;
* CI;
* Developer Muscle Memory;
* Version Control History;
* *(the list goes on...)*.

What if we could find some pathway to progressively enhance a Manyrepo architecture into a future
state that captured more of the advantages of a Monorepo *(and maybe even eased a plausible future
transition to a full Monorepo architecture?)* Can we find a way to accomplish this without requiring
a big-bang flip to a new set of processes, tools, and workflows?

The rest of this document describes one possible solution to this problem, styled a "Metarepo".

## Metarepo Architecture

The five-second pitch: **A Manyrepo woven into a Monorepo** by a suite of tools and a single
coordinating repository containing:

* A mapping from each repository to a position in a globally-unique hierarchy; and
* The latest master branch commit for each repository.

Consider again the example given previously of three sub-projects:

* `foo-app`, A macOS app;
* `foo-cli`, A command-line interface to the same functionality provided by the app; and
* `foo`, A packaging repo to bundle the app and the CLI into a single `.pkg` file for distribution.

In a Manyrepo architecture, these would be three separate repositories (`foo-app`, `foo-cli`, and
`foo`). In a Monorepo architecture, they might occupy subtrees at
`//prod-eng/dev-infra/foo/{app,cli,build}`).

To translate this into a Metarepo, we would have mappings in a special repo (say,
`github.com/<org>/_meta`), mapping:

* Repository origin URL to path (e.g. `github.com/<org>/foo-app` to `//prod-eng/dev-infra/foo/app`);
* Path back to repository origin URL; and
* Repository origin URL to latest master SHA (e.g. `github.com/<org>/foo-app` to
  `29239d776a58a9e3538de2746b47f84cc16280b7`).

The repository would be automatically updated by a job triggered on GitHub's [Organization
Webhooks], providing a consistent view of the world at a given moment.

Changes spanning multiple repositories would be handled by registering the change with
a higher-level coordination tool than GitHub. This tool could create stub PRs on GitHub, but when
the change was merged from the tool, it would merge the PRs on GitHub, but change the revision of
each repository in the Metarepo atomically.

Command-line tooling would have to be built to manage sparse-population of this tree and specifying
cross-repository dependencies with automatic backfill when a dependency is required, as well as some
interaction pathways to move around this tree, update all repositories to the latest head, revisit
some previous state, synchronize multi-project changes, and so on.

### Change is Scary

The most appealing aspect of this strategy from the perspective of a large established Manyrepo is
that the adaptation can be done progressively. While the Metarepo (`<org>/_meta`) is being
developed, developers can continue completely unaware of its existence. Their help can be enlisted
briefly to help develop a first-pass hierarchy for the existing repositories.

Once the hierarchical structure is ready to roll out, developers would have to adjust to new paths
to their existing codebases, but if done correctly by providing some related and compelling tooling
at the same time, the benefits of a browsable hierarchical structure alone should prevent major
complaints. Once in their project directory, developers would continue to interact with their
codebases precisely as they had before, and GitHub webhooks would passively update the Metarepo as
each change happened.

Once developers are all adjusted to the hierarchical structure, the next step is to ship tooling to
discourage developers from running `git pull` in a single repo, replacing that workflow with
a command to update the master branch of *all* checked-out repositories according to the current
state of the Metarepo. At this point, developers are all working from a consistent snapshot
world-view across projects. They would slowly adapt to the idea that all of the repositories under
the Metarepo-managed directory would typically be updated for them.

Once developers are adjusted to this consistent worldview, we can ship tools to make cross-project
changes. For this particular workflow, we could employ [Gerrit] instead of GitHub Pull Requests.
A user would run some command on the command line (probably highly analogous to `start`, `diff`,
`upload`, from Android's [repo] tool) which would upload the cross-project diff to Gerrit, while
creating "stub" PRs on GitHub for each project, which would point at the diff on Gerrit. Gerrit
would somehow embed the CI statuses from GitHub and share reviewer assignments. When the Gerrit
issue was approved and "merged", the GitHub PRs would be automatically merged, and the Metarepo
would atomically update all component projects. In this way, no developer could update at the wrong
time and get an inconsistent state.

From here, it becomes a game of building more and better tooling around this multi-project workflow
until developers prefer it to the existing single-project workflow. Once a majority of developers
are using the multi-project workflow, we can start to consider the multi-project workflow primary
and begin to discourage the single-project workflow, eventually building tooling that *only* works
with the new workflows.

In parallel with this push away from single-project workflows, we can start bringing third-party
dependencies in-tree and keeping a single endorsed version of each. Dependencies on these
third-party modules would be made understandable by tooling (and probably indexed in the
`<org>/_meta` repo), and CI for changes to these projects would include all projects whose
transitive dependencies include it.

Once the organization is fully adapted to workflows that are indifferent to the underlying number of
unit repositories, it becomes tractable to grow the Metarepo into a true Monorepo (whether or not
it's even desirable at that point is hard to assess from this vantage point). Migrating all code
into the `<org>/_meta` repo using something like [GVFS] would be one way to pull this off.

### Translation of Monorepo Advantages

#### Discovery

A Metarepo can provide precisely the same discoverability as a Monorepo, since the hierarchical
structure appears exactly the same as if it were in fact a Monorepo. The underlying composition of
thousands of individual repositories actually provides a natural unit for sparse-checkout: the first
time a directory is entered, the backing repository can be fetched from the git server.

#### Simplified Dependencies

Since, like in a Monorepo, all unit repositories are held at a consistent snapshot world-view, we
can derive the same benefits as a Monorepo, though in a true Monorepo like at Google, all
third-party code is held in the same Monorepo. This is entirely possible with a Metarepo, and not
really a stretch of the technology, but it's a big cultural adjustment that would take some time and
finesse to implement.

#### Tooling

Monorepos make tooling very simple to write. Metarepos can make it a bit simpler, since you benefit
from the fixed path and consistent worldview, but the fact of having many underlying repositories
means we lose a bit of the benefit on this one. It's unclear how much exactly.

### Translation of Monorepo Disadvantages

Almost all of the Monorepo Disadvantages we discussed previously are nearly-identical in breadth and depth
in a Metarepo. Simulating the advantages of a Monorepo brings its disadvantages along for the ride,
namely:

* [Nonstandard/Custom Tooling](#nonstandardcustom-tooling)
* [Upgrade Complexity](#upgrade-complexity);
* [High CI Burden](#high-ci-burden);
* [Low quality tests more likely to produce failures](#low-quality-tests-more-likely-to-produce-failures); and
* [More difficult to change APIs](#more-difficult-to-change-apis).

One specific disadvantage though — Managing a Public/Private Split — preserves more of the
characteristics of a Manyrepo. Since the underlying storage of a public component would still be
a separate git repository, it could simply be backed by a public repository on GitHub.

## Summary

A Metarepo is probably the most reasonable way for a Manyrepo organization to progressively
transition toward a Monorepo architecture. Obviously this is a huge project, but this document has
outlined some broad steps that can accomplish the change progressively *(building the plane while
flying it)*.

[go]:                      <https://golang.org>
[copybara]:                <https://opensource.google.com/projects/copybara>
[grpc]:                    <https://grpc.io>
[bazel]:                   <https://bazel.build>
[protobuf]:                <https://github.com/google/protobuf>
[danluu]:                  <https://danluu.com/monorepo>
[wiseman]:                 <https://gist.github.com/wiseman/3834928>
[transitive dependencies]: <https://en.wikipedia.org/wiki/Transitive_dependency>
[organization webhooks]:   <https://developer.github.com/v3/orgs/hooks>
[gerrit]:                  <https://en.wikipedia.org/wiki/Gerrit_(software)>
[repo]:                    <https://source.android.com/source/using-repo>
[gvfs]:                    <https://blogs.msdn.microsoft.com/bharry/2017/05/24/the-largest-git-repo-on-the-planet/>
