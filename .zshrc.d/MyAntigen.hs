{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
module MyAntigen where

import Antigen (AntigenConfiguration (..), bundle, antigen)
import Shelly (shelly)

bundles =
  [ bundle "hchbaw/opp.zsh"
  , bundle "tarruda/zsh-autosuggestions"
  , bundle "zsh-users/zsh-syntax-highlighting"
  ]

config = AntigenConfiguration bundles

main :: IO ()
main = shelly $ antigen config
