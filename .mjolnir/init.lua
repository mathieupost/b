local application = require "mjolnir.application"
local hotkey = require "mjolnir.hotkey"
local window = require "mjolnir.window"
local fnutils = require "mjolnir.fnutils"
local spotify = require "mjolnir.lb.spotify"

function hideshowhotkey(appname, bundleid)
  return function()
    local focusedapp = window.application(window.focusedwindow())
    if application.bundleid(focusedapp) == bundleid then
      application.hide(focusedapp)
    else
      application.launchorfocus(appname)
    end
  end
end

hotkey.bind({"cmd", "ctrl"}, "9", function()
  print(application.bundleid(window.application(window.focusedwindow())))
end)

hotkey.bind({"cmd", "ctrl"}, "1", hideshowhotkey("iTerm", "com.googlecode.iterm2"))
hotkey.bind({"cmd", "ctrl"}, "2", hideshowhotkey("Spotify", "com.spotify.client"))
hotkey.bind({"cmd", "ctrl"}, "3", hideshowhotkey("Google Chrome", "com.google.Chrome"))
hotkey.bind({"cmd", "ctrl"}, "4", hideshowhotkey("Slack", "com.tinyspeck.slackmacgap"))
hotkey.bind({"cmd", "ctrl"}, "5", hideshowhotkey("Dash", "com.kapeli.dash"))
hotkey.bind({"cmd", "ctrl"}, "6", hideshowhotkey("Messages", "com.apple.iChat"))


local tiling = require "mjolnir.tiling"
local mash = {"ctrl", "cmd"}



tiling.addlayout('2thirds', function(windows)
  local wincount = #windows

  if wincount == 1 then
    return layout.layouts['fullscreen'](windows)
  end

  for index, win in pairs(windows) do
    local frame = win:screen():frame()

    if index == 1 then
      frame.x, frame.y = 0, 0
      frame.w = frame.w * 0.67
    else
      frame.x = frame.w * 0.67
      frame.w = frame.w * 0.33
      frame.h = frame.h / (wincount - 1)
      frame.y = frame.h * (index - 2)
    end

    win:setframe(frame)
  end
end)


hotkey.bind(mash, "c", function() tiling.cyclelayout() end)
hotkey.bind(mash, "j", function() tiling.cycle(1) end)
hotkey.bind(mash, "k", function() tiling.cycle(-1) end)
hotkey.bind(mash, "space", function() tiling.promote() end)

tiling.set('layouts', {
  'fullscreen', 'main-vertical', '2thirds'
})
