--[[
   trig.lua

   Copyright 2017 wesley werner <wesley.werner@gmail.com>

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

--- Provides trigonometry functions.
--
-- @author Wesley Werner
-- @license GPL v3
-- @module trig

local module = {}


--- Returns the angle between two points.
function module:angle(x1, y1, x2, y2)
  return math.atan2(y2 - y1, x2 - x1)
end

--- Returns the distance between two points.
function module:distance(x1, y1, x2, y2)
  local dx = x1 - x2
  local dy = y1 - y2
  local s = dx * dx + dy * dy
  return math.sqrt(s)
end

--- Returns a point on a circle.
--
-- @tparam number cx
-- The origin of the circle
--
-- @tparam number cy
-- The origin of the circle
--
-- @tparam number r
-- The circle radius
--
-- @tparam number a
-- The angle of the point to the origin.
--
-- @treturn number
-- x, y
function module:pointOnCircle(cx, cy, r, a)

    x = cx + r * math.cos(a)
    y = cy + r * math.sin(a)
    return x, y

end

--- Clamp a point to a circular range.
--
-- @tparam number cx
-- The origin of the circle
--
-- @tparam number cy
-- The origin of the circle
--
-- @tparam number x
-- The goal point to reach
--
-- @tparam number y
-- The goal point to reach
--
-- @tparam number r
-- The circle radius
--
-- @treturn number
-- x, y
function module:limitPointToCircle(cx, cy, x, y, r)

    -- distance
    local dist = self:distance(cx, cy, x, y)

    -- if within the required range
    if dist <= r then
        return x, y
    end

    -- otherwise clamp the point to the radius limit
    r = math.min(r, dist)

    -- angle
    local a = self:angle(cx, cy, x, y)

    return self:pointOnCircle(cx, cy, r, a)

end

return module
