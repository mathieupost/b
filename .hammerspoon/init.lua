-- vim: foldmethod=marker

local util = require("util")
local leader = require("leader")
local caffeine = require("caffeine")

-- don't animate windows during transitions
hs.window.animationDuration = 0

-- App hotkeys {{{

-- hs.hotkey.bind({"cmd", "ctrl"}, "9", function()
--   print(hs.window.focusedWindow():application():bundleID())
-- end)

local bindings = {
  [1] = "com.googlecode.iterm2",
  [2] = "com.spotify.client",
  [3] = "com.google.Chrome",
  [4] = "com.tinyspeck.slackmacgap",
  [5] = nil,
  [6] = "com.apple.iChat",
  [7] = nil,
  [8] = nil,
}

for i, bundleID in pairs(bindings) do
  if bundleID then
    hs.hotkey.bind({"cmd", "ctrl"}, tostring(i), util.hideShowHotkey(bundleID))
  end
end
-- }}}

-- Secondary screen watcher / autolayout {{{
local function setupSecondaryScreen()
  local s = "Color LCD"
  hs.layout.apply({
    {"Slack",    nil, s, hs.geometry.rect(0, 0, 0.65, 1),        nil, nil},
    {"Messages", nil, s, hs.geometry.rect(0.65, 0, 0.35, 0.5),   nil, nil},
    {"Adium",    nil, s, hs.geometry.rect(0.65, 0.5, 0.35, 0.5), nil, nil},
  })
end

local function screensChanged()
  local screens = hs.screen.allScreens()
  if #screens > 1 then
    setupSecondaryScreen()
  end
end

local screenWatcher = hs.screen.watcher.new(screensChanged)
screenWatcher:start()
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

local lmap = leader.new({"cmd"}, "`")
lmap:bindall({
  i = hs.spotify.displayCurrentTrack,
  h = hs.spotify.previous,
  l = hs.spotify.next,
  j = hs.spotify.play,

  p = setupSecondaryScreen,

  r = hs.reload,
  c = hs.toggleConsole,

  s = setCurrentLeft,
  f = setCurrentRight,
  b = caffeineClicked,
})
