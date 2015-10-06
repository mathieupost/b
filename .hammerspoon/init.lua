-- vim: foldmethod=marker

-- don't animate windows during transitions
hs.window.animationDuration = 0

-- App hotkeys {{{
local function hideshowhotkey(bundleID)
  return function()
    local fw = hs.window.focusedWindow()
    if fw and fw:application():bundleID() == bundleID then
      fw:application():hide()
    else
      hs.application.launchOrFocusByBundleID(bundleID)
    end
  end
end

hs.hotkey.bind({"cmd", "ctrl"}, "9", function()
  print(hs.window.focusedWindow():application():bundleID())
end)

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
    hs.hotkey.bind({"cmd", "ctrl"}, tostring(i), hideshowhotkey(bundleID))
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

function setFrameForCurrent(cb)
  local win = hs.window.focusedWindow()
  if win then
    local screenFrame = win:screen():frame()
    local x, y, w, h = cb(screenFrame.x, screenFrame.y, screenFrame.w, screenFrame.h)
    win:setFrame(hs.geometry.rect(x, y, w, h))
  end
end

function setCurrentLeft()
  setFrameForCurrent(function(x, y, w, h) return x, y, w/2, h end)
end

function setCurrentRight()
  setFrameForCurrent(function(x, y, w, h) return w/2, y, w/2, h end)
end

-- }}}

-- Caffeine {{{
-- borrowed from https://github.com/cmsj/hammerspoon-config/blob/master/init.lua
local caffeine = hs.menubar.new()

function setCaffeineDisplay(state)
  local result
  if state then
    result = caffeine:setIcon("caffeine-on.pdf")
  else
    result = caffeine:setIcon("caffeine-off.pdf")
  end
end

function caffeineClicked()
  setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
  caffeine:setClickCallback(caffeineClicked)
  setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end
-- }}}

-- Leader bindings {{{
local leader = hs.hotkey.modal.new({"cmd"}, "`")
function leader:bind1(k, f)
  self:bind({}, k, function() leader:exit(); f() end)
end
leader:bind({}, "escape", function() leader:exit() end)

leader:bind1("i", hs.spotify.displayCurrentTrack)
leader:bind1("h", hs.spotify.previous)
leader:bind1("l", hs.spotify.next)
leader:bind1("j", hs.spotify.play)
leader:bind1("1", setupSecondaryScreen)

leader:bind1("r", hs.reload)
leader:bind1("c", hs.toggleConsole)

leader:bind1("s", setCurrentLeft)
leader:bind1("f", setCurrentRight)
leader:bind1("b", caffeineClicked)
-- }}}
