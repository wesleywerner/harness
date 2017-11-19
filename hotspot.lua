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

--- Provides a hotspot with focus tracking.
--
-- @author Wesley Werner
-- @license GPL v3
-- @module hotspot

local module = {}
local hotspot = {}

--- A table of arguments for new hotspots.
-- In addition to the mentioned parameters, you can add any other keys
-- you want. All keys are copied to the hotspot instance, which allows
-- you to access them later through the instance.
--
-- @table args
--
-- @tfield number left
-- The left screen position.
--
-- @tfield number top
-- The top screen position.
--
-- @tfield number width
-- The width in pixels.
--
-- @tfield number height
-- The height in pixels.


--- Lists properties available on the instance.
-- @table instance
--
-- @tfield bool touched
-- true while the cursor is over the hotspot. This is determined automatically
-- while you call @{mousemoved}


--- Creates a new hotspot.
--
-- @tparam args args
-- A table of arguments.
--
-- @treturn instance
-- A new hotspot instance
function module:new(args)

  if not args.top or not args.left or not args.width or not args.height then
    error("Hotspot must have a top, left, width and height")
  end

  local instance = {}

  -- copy arguments to the instance
  for k, v in pairs(args) do
    instance[k] = v
  end

  -- apply instance functions
  setmetatable(instance, { __index = hotspot })

  return instance

end

--- Process mouse movement.
-- Call this from your game loop to let the aperture determine if
-- it is in focus via the "touched" property.
function hotspot:mousemoved(x, y, dx, dy, istouch)
  self.touched = x > self.left and x < self.left + self.width
    and y > self.top and y < self.top + self.height
end

return module
