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

-- [2] = "com.apple.iTunes",
appbindings.setup({"cmd", "ctrl"}, {
  [1] = "com.googlecode.iterm2",
  [2] = nil,
  [3] = "com.google.Chrome",
  [4] = "com.tinyspeck.slackmacgap",
  [5] = nil,
  [6] = "com.apple.iChat",
  [7] = nil,
  [8] = nil,
})

hs.hotkey.bind({"cmd", "ctrl"}, "2", function()
  local iTunesID = "com.apple.iTunes"
  local focus = hs.window.focusedWindow()

  local iTuneses = hs.application.applicationsForBundleID(iTunesID)
  if #iTuneses == 0 then
    return hs.application.launchOrFocusByBundleID(iTunesID)
  end

  local iTunes = iTuneses[1]
  local iTunesWindows = iTunes:allWindows()
  if #iTunesWindows ~= 0 and iTunesWindows[1]:title() == "MiniPlayer" then
    iTunes:activate()
    return iTunes:selectMenuItem({"Window", "Switch from MiniPlayer"})
  end

  if focus and focus:application():bundleID() == iTunesID then
    return focus:application():hide()
  end

  iTunes:activate()
end)

hs.hotkey.bind({"cmd", "ctrl"}, "m", function()
  local iTunesID = "com.apple.iTunes"
  local focus = hs.window.focusedWindow():application()

  local needReset = false

  local iTuneses = hs.application.applicationsForBundleID(iTunesID)
  if #iTuneses == 0 then
    print("launching iTunes")
    hs.application.launchOrFocusByBundleID(iTunesID)
    needReset = true
    iTuneses = hs.application.applicationsForBundleID(iTunesID)
  end

  local iTunes = iTuneses[1]
  local iTunesWindows = iTunes:allWindows()
  if #iTunesWindows == 0 or iTunesWindows[1]:title() ~= "MiniPlayer" then
    print("activating miniplayer")
    iTunes:activate()
    needReset = true
    iTunes:selectMenuItem({"Window", "Switch to MiniPlayer"})
    focus:activate()
  end

  if needReset then
    focus:activate()
  else
    if iTunes:isHidden() then
      iTunes:unhide()
    else
      iTunes:hide()
    end
  end
end)

-- Secondary screen watcher / autolayout {{{
local function setupSecondaryScreen()
  local s = "Color LCD"
  layout.apply({
    {"Slack",    nil, s, geometry.rect(0,    0,   0.65, 1),   nil, nil},
    {"Messages", nil, s, geometry.rect(0.65, 0,   0.35, 1), nil, nil},
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
  p = setupSecondaryScreen,

  r = reload,
  c = toggleConsole,

  s = setCurrentLeft,
  f = setCurrentRight,
  b = caffeine.clicked,
})
