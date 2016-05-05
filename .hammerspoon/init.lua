-- vim: foldmethod=marker

local util        = require("util")
local leader      = require("leader")
local caffeine    = require("caffeine")
local appbindings = require("appbindings")

local geometry      = hs.geometry
local hotkey        = hs.hotkey
local layout        = hs.layout
local reload        = hs.reload
local screen        = hs.screen
local spotify       = hs.spotify
local toggleConsole = hs.toggleConsole
local window        = hs.window

-- don't animate windows during transitions
window.animationDuration = 0

-- hotkey.bind({"cmd", "ctrl"}, "9", function()
--   print(window.focusedWindow():application():bundleID())
-- end)

appbindings.setup({"cmd", "ctrl"}, {
  [1] = "com.googlecode.iterm2",
  [2] = "com.apple.iTunes",
  [3] = "com.google.Chrome",
  [4] = "com.tinyspeck.slackmacgap",
  [5] = nil,
  [6] = "com.apple.iChat",
  [7] = nil,
  [8] = nil,
})

-- Secondary screen watcher / autolayout {{{
local function setupSecondaryScreen()
  local s = "Color LCD"
  layout.apply({
    {"Slack",    nil, s, geometry.rect(0,    0,   0.65, 1),   nil, nil},
    {"Messages", nil, s, geometry.rect(0.65, 0,   0.35, 0.5), nil, nil},
    {"Adium",    nil, s, geometry.rect(0.65, 0.5, 0.35, 0.5), nil, nil},
  })
end

if #screen.allScreens() > 1 then setupSecondaryScreen() end
screen.watcher.new(function()
  if #screen.allScreens() > 1 then setupSecondaryScreen() end
end):start()

-- }}}

-- Layout {{{

function setCurrentLeft()
  util.setFrameForCurrent(function(x, y, w, h) return x, y, w/2, h end)
end

function setCurrentRight()
  util.setFrameForCurrent(function(x, y, w, h) return w/2, y, w/2, h end)
end

-- }}}

caffeine.start()

leader.new({"cmd"}, "`"):bindall({
  i = spotify.displayCurrentTrack,
  h = spotify.previous,
  l = spotify.next,
  j = spotify.play,

  p = setupSecondaryScreen,

  r = reload,
  c = toggleConsole,

  s = setCurrentLeft,
  f = setCurrentRight,
  b = caffeine.clicked,
})
