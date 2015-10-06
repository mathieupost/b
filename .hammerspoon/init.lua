function hideshowhotkey(bundleID)
  return function()
    local fw = hs.window.focusedWindow()
    local app = fw:application()
    if fw == nil or app:bundleID() ~= bundleID then
      hs.application.launchOrFocusByBundleID(bundleID)
    else
      app:hide()
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
