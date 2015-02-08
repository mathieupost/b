function hideitermand(func)
  return function() 
    local apps = hs.application.applicationsForBundleID("com.googlecode.iterm2")
    func()
    if #apps > 0 then
      hs.application.hide(apps[1])
    end
  end
end

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
hs.hotkey.bind({"cmd", "ctrl"}, "5", hideshowhotkey("Dash", "com.kapeli.dash"))
hs.hotkey.bind({"cmd", "ctrl"}, "6", hideshowhotkey("Messages", "com.apple.iChat"))
hs.hotkey.bind({"cmd", "ctrl"}, "7", hideshowhotkey("Evernote", "com.evernote.Evernote"))


-- local mash = {"ctrl", "cmd"}
-- 
-- 
-- 
-- hs.tiling.addlayout('2thirds', function(windows)
--   local wincount = #windows
-- 
--   if wincount == 1 then
--     return layout.layouts['fullscreen'](windows)
--   end
-- 
--   for index, win in pairs(windows) do
--     local frame = win:screen():frame()
-- 
--     if index == 1 then
--       frame.x, frame.y = 0, 0
--       frame.w = frame.w * 0.67
--     else
--       frame.x = frame.w * 0.67
--       frame.w = frame.w * 0.33
--       frame.h = frame.h / (wincount - 1)
--       frame.y = frame.h * (index - 2)
--     end
-- 
--     win:setframe(frame)
--   end
-- end)
-- 
-- 
-- hs.hotkey.bind(mash, "c", function() hs.tiling.cyclelayout() end)
-- hs.hotkey.bind(mash, "j", function() hs.tiling.cycle(1) end)
-- hs.hotkey.bind(mash, "k", function() hs.tiling.cycle(-1) end)
-- hs.hotkey.bind(mash, "space", function() hs.tiling.promote() end)
-- 
-- hs.tiling.set('layouts', {
--   'fullscreen', '2thirds'
-- })
