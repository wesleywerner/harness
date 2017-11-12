--[[
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program. If not, see http://www.gnu.org/licenses/.
]]--

-- provides scroll functionality

local module = {}
local tween = require("tween")

-- provides the scroll panel instance functions
local scroll_mt = {}

function module:new(args)

  if not args.top or not args.left or not args.width or not args.height then
    error("A scroll panel must have a top, left, width and height")
  end

  local instance = {}

  -- copy arguments to the instance
  for k, v in pairs(args) do
    instance[k] = v
  end

  -- set defaults
  instance.pages = instance.pages or 1
  instance.offset = 0
  instance.page = 1

  -- apply instance functions
  setmetatable(instance, { __index = scroll_mt })

  -- apply first time tweening
  instance:applytween()

  return instance

end

function scroll_mt:update(dt)
  self.complete = self.tween:update(dt)
end

function scroll_mt:pointToScreen(x, y)
  return x - self.left, y - self.top - self.offset
end

function scroll_mt:pointIn(x, y, rect)
  -- convert to screen coords
  x, y = self:pointToScreen(x, y)
  -- allow if point is in the scroll range
  -- so you cannot click something that is scrolled out of view
  if not self.active then
    return false
  end
  -- test if point is inside the bounds
  return x > rect.left and x < rect.left + rect.width
    and y > rect.top and y < rect.top + rect.height
end

function scroll_mt:apply()

  -- clip anything drawn
  love.graphics.stencil(function()
    love.graphics.rectangle("fill",
      self.left, self.top,
      self.width, self.height)
  end, "replace", 1)

  -- Only allow rendering on pixels which have a stencil value greater than 0.
  love.graphics.setStencilTest("greater", 0)

  -- scroll all drawing
  love.graphics.push()
  --love.graphics.translate( 0, self.offset )
  love.graphics.translate( self.left, self.top + self.offset )

end

function scroll_mt:release()
  love.graphics.pop()
  love.graphics.setStencilTest()
end

function scroll_mt:scrollup()
  if self.complete and self.active then
    self.complete = false
    self.page = math.max(1, self.page - 1)
    self:applytween()
  end
end

function scroll_mt:scrolldown()
  if self.complete and self.active then
    self.complete = false
    self.page = math.min(self.pages, self.page + 1)
    self:applytween()
  end
end

function scroll_mt:mousemoved(x, y, dx, dy, istouch)
  self.active = (x > self.left
    and x < self.left + self.width
    and y > self.top
    and y < self.top + self.height)
end

function scroll_mt:applytween()
self.tween = tween.new(
  self.duration or .5,
  self,
  { offset=(self.page-1) * self.height * -1 },
  self.easing or "outCubic"
  )
end

return module
