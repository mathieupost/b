local application = require "mjolnir.application"
local hotkey = require "mjolnir.hotkey"
local window = require "mjolnir.window"
local fnutils = require "mjolnir.fnutils"

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
-- hotkey.bind({"cmd", "ctrl"}, "5", hideshowhotkey("", ""))
hotkey.bind({"cmd", "ctrl"}, "6", hideshowhotkey("Messages", "com.apple.iChat"))
