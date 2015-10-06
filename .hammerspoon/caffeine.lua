local _M = {}

-- borrowed from https://github.com/cmsj/hammerspoon-config/blob/master/init.lua

local function set(caffeine, state)
  if state then
    caffeine:setIcon("caffeine-on.pdf")
  else
    caffeine:setIcon("caffeine-off.pdf")
  end
end

function _M.start()
  local c = hs.menubar.new()
  set(c, hs.caffeinate.get("displayIdle"))
  c:setClickCallback(function()
    set(c, hs.caffeinate.toggle("displayIdle"))
  end)
end

return _M
