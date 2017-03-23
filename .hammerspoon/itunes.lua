-- suggested usage:
--   local itunes = require("itunes")
--   hs.hotkey.bind({"cmd", "ctrl"}, "2", itunes.toggleLibrary)
--   hs.hotkey.bind({"cmd", "ctrl"}, "m", itunes.toggleMiniPlayer)

local _M = {}

local iTunesID = "com.apple.iTunes"

function ensureRunning()
  local iTuneses = hs.application.applicationsForBundleID(iTunesID)
  if #iTuneses == 0 then
    return hs.application.launchOrFocusByBundleID(iTunesID)
  end
  iTuneses = hs.application.applicationsForBundleID(iTunesID)
  return iTuneses[1]
end

function setMiniPlayerState(iTunes, wantMiniPlayer)
  local didChangeState = false
  local wins = iTunes:allWindows()
  local haveMiniPlayer = #wins ~= 0 and wins[1]:title() == "MiniPlayer"

  if wantMiniPlayer and not haveMiniPlayer then
    iTunes:activate()
    iTunes:selectMenuItem({"Window", "Switch to MiniPlayer"})
    return true
  end

  if haveMiniPlayer and not wantMiniPlayer then
    iTunes:activate()
    iTunes:selectMenuItem({"Window", "Switch from MiniPlayer"})
    return true
  end

  return false
end

function toggleVisibility(app)
  if app:isHidden() then
    app:unhide()
  else
    app:hide()
  end
end

-- launch itunes if it isn't running
-- show and focus the iTunes main window (e.g. library)
-- toggle visibility if pressed again while library is active
-- toggle back to library if miniplayer is active
function _M.toggleLibrary()
  local prevFocus = hs.window.focusedWindow():application()
  local iTunes = ensureRunning()

  if setMiniPlayerState(iTunes, false) then
    return
  end

  if prevFocus and prevFocus:bundleID() == iTunesID then
    return prevFocus:hide()
  end

  iTunes:activate()
end

-- This is meant to be used with:
--    Preferences > Advanced > Keep MiniPlayer on top of other windows
--
-- launch itunes if it isn't running
-- switch to miniplayer if not currently active
-- toggle visibility of miniplayer if active without stealing focus from current app
function _M.toggleMiniPlayer()
  local prevFocus = hs.window.focusedWindow():application()
  local iTunes = ensureRunning()

  if setMiniPlayerState(iTunes, true) then
    return prevFocus:activate()
  end

  prevFocus:activate()
  toggleVisibility(iTunes)
end

return _M

