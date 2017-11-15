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

local module = {}
local tween = require("harness.tween")

-- provides the scroll panel instance functions
local scroll_mt = {}

function module:new(args)

  if not args.top or not args.left or not args.width or not args.height then
    error("Aperture must have a top, left, width and height")
  end

  local instance = {}

  -- copy arguments to the instance
  for k, v in pairs(args) do
    instance[k] = v
  end

  -- set defaults
  instance.duration = instance.duration or 1
  instance.pages = instance.pages or 1
  instance.easing = instance.easing or "outCubic"
  instance.factor = instance.factor or 1
  instance.yoffset = 0
  instance.xoffset = 0
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

-- Convert screen points to local points.
function scroll_mt:pointFromScreen(x, y)
  return x - self.left - self.xoffset, y - self.top - self.yoffset
end

function scroll_mt:pointIn(x, y, rect)
  -- fail right away if we are not active
  if not self.active then
    return false
  end
  -- convert to screen coords
  x, y = self:pointFromScreen(x, y)
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

  love.graphics.translate( self.left + self.xoffset, self.top + self.yoffset )

end

function scroll_mt:release()
  love.graphics.pop()
  love.graphics.setStencilTest()
end

function scroll_mt:scrollUp()
  if self.complete and self.active then
    self.complete = false
    self.page = math.max(1, self.page - self.factor)
    self:applytween()
  end
end

function scroll_mt:scrollDown()
  if self.complete and self.active then
    self.complete = false
    self.page = math.min(self.pages, self.page + self.factor)
    self:applytween()
  end
end

function scroll_mt:scrollLeft()
  self:scrollUp()
end

function scroll_mt:scrollRight()
  self:scrollDown()
end

function scroll_mt:scrollTo(page)

  -- clamp the desired page
  page = math.min(self.pages, math.max(1, page))

  if self.page ~= page then
    self.page = page
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

  local xo = (self.page-1) * self.width * -1
  local yo = (self.page-1) * self.height * -1

  -- limit the tween direction depending on orientation
  if self.landscape then
    yo = 0
  else
    xo = 0
  end

  self.tween = tween.new(self.duration, self, { xoffset=xo, yoffset=yo }, self.easing)

end

return module
