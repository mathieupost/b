local _M = {}

function _M.hideShowHotkey(bundleID)
  return function()
    local fw = hs.window.focusedWindow()
    if fw and fw:application():bundleID() == bundleID then
      fw:application():hide()
    else
      hs.application.launchOrFocusByBundleID(bundleID)
    end
  end
end

function _M.setFrameForCurrent(cb)
  local win = hs.window.focusedWindow()
  if win then
    local screenFrame = win:screen():frame()
    local x, y, w, h = cb(screenFrame.x, screenFrame.y, screenFrame.w, screenFrame.h)
    win:setFrame(hs.geometry.rect(x, y, w, h))
  end
end


return _M

