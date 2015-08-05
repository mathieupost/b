function hideshowhotkey(appname, bundleID)
  return function()
    local fw = hs.window.focusedWindow()
    if fw == nil then
      hs.application.launchOrFocus(appname)
    else
      local focusedapp = hs.window.application(hs.window.focusedWindow())
      if hs.application.bundleID(focusedapp) == bundleID then
        hs.application.hide(focusedapp)
      else
        hs.application.launchOrFocus(appname)
      end
    end
  end
end

hs.hotkey.bind({"cmd", "ctrl"}, "9", function()
  print(hs.application.bundleID(hs.window.application(hs.window.focusedWindow())))
end)

hs.hotkey.bind({"cmd", "ctrl"}, "1", hideshowhotkey("iTerm", "com.googlecode.iterm2"))
hs.hotkey.bind({"cmd", "ctrl"}, "2", hideshowhotkey("Spotify", "com.spotify.client"))
hs.hotkey.bind({"cmd", "ctrl"}, "3", hideshowhotkey("Google Chrome", "com.google.Chrome"))
hs.hotkey.bind({"cmd", "ctrl"}, "4", hideshowhotkey("Slack", "com.tinyspeck.slackmacgap"))
hs.hotkey.bind({"cmd", "ctrl"}, "5", hideshowhotkey("Wunderlist", "com.wunderkinder.wunderlistdesktop"))
hs.hotkey.bind({"cmd", "ctrl"}, "6", hideshowhotkey("Messages", "com.apple.iChat"))
hs.hotkey.bind({"cmd", "ctrl"}, "7", hideshowhotkey("Evernote", "com.evernote.Evernote"))
