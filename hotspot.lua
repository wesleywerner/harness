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
local hotspot = {}

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

--- Process mouse movement to determine if a hotspot is touched
function hotspot:mousemoved(x, y, dx, dy, istouch)
  self.touched = x > self.left and x < self.left + self.width
    and y > self.top and y < self.top + self.height
end

return module
