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
local aperture = {}

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

  -- keep a collection of embedded hotspots
  instance.hotspots = {}

  -- apply instance functions
  setmetatable(instance, { __index = aperture })

  -- apply first time tweening
  instance:applytween()

  return instance

end

--- Inserts another hotspot in the aperture.
-- This gives automatic clicking on inserted hotspots
-- via the @{aperture:mousepressed} function.
--
-- @tparam hotspot hotspot
function aperture:insert(hotspot)
  table.insert(self.hotspots, hotspot)
end

function aperture:update(dt)
  self.complete = self.tween:update(dt)
end

-- Convert screen points to local points.
function aperture:pointFromScreen(x, y)
  return x - self.left - self.xoffset, y - self.top - self.yoffset
end

function aperture:pointIn(x, y, rect)
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

function aperture:apply()

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

function aperture:release()
  love.graphics.pop()
  love.graphics.setStencilTest()
end

function aperture:scrollUp()
  if self.complete and self.active then
    self.complete = false
    self.page = math.max(1, self.page - self.factor)
    self:applytween()
  end
end

function aperture:scrollDown()
  if self.complete and self.active then
    self.complete = false
    self.page = math.min(self.pages, self.page + self.factor)
    self:applytween()
  end
end

function aperture:scrollLeft()
  self:scrollUp()
end

function aperture:scrollRight()
  self:scrollDown()
end

function aperture:scrollTo(page)

  -- clamp the desired page
  page = math.min(self.pages, math.max(1, page))

  if self.page ~= page then
    self.page = page
    self:applytween()
  end

end

function aperture:mousemoved(x, y, dx, dy, istouch)
  self.active = (x > self.left
    and x < self.left + self.width
    and y > self.top
    and y < self.top + self.height)
end

--- Process clicks on hotspots inside this aperture.
-- If the hotspot has a "action" key function it will be called.
--
-- @tparam number x
-- @tparam number y
-- @tparam number button
-- @tparam bool istouch
function aperture:mousepressed(x, y, button, istouch)

  -- ignore clicks if this aperture is not active
  if not self.active then return end

  -- convert to local points
  x, y = self:pointFromScreen(x, y)

  for _, hotspot in ipairs(self.hotspots) do
    if hotspot.touched and hotspot:touched(x, y) then
      if type(hotspot.action) == "function" then
        hotspot:action()
      end
    end
  end

end

function aperture:applytween()

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
