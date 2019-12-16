---
title: Bumping Private Homebrew Dependencies
date: 2019-08-26
...

Shopify has a big-ish collection of semi-private [homebrew
packages](https://github.com/shopify/homebrew-shopify) and I frequently explain how to bump
versions, so here it is. In general:

1. `dev clone homebrew-shopify`
1. Find the Formula. For example,
   [`secret-sender`](https://github.com/Shopify/homebrew-shopify/blob/master/secret-sender.rb)
1. Edit the URL to point to the archive for a new tag that you've created and pushed to the source
   repo.
1. Fetch that URL using `curl $url | shasum -a 256` and replace the `sha256` in the file with that
   hash.
1. If you currently have this formula installed, remove it with `brew uninstall <formula>`.
1. Run `brew install --build-bottle ./<my-formula>.rb` (e.g. `./secret-sender.rb`)
1. Run `brew bottle <my-formula>` (e.g. `secret-sender`, *not* `./secret-sender.rb`)
1. Copy and paste the output of this command into the formula, replacing the previous `bottle do`
   paragraph, and add another line inside: `root_url "https://github.com/Shopify/<repo>/releases/download/<tag>`.
1. Rename the resulting file, changing the `--` into `-`. I have no idea why this part is necessary.
1. Attach the resulting file to the release for the tag on GitHub.
1. `brew uninstall <my-formula>` and `brew install ./<my-formula>.rb` to verify that it correctly
   downloads the bottle from github.
1. Branch, commit, push, PR, merge.
