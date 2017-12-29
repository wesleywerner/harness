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
        -- ensure callback is always a function
        if k == "callback" then
            if type(v) == "function" then
                instance[k] = v
            end
        else
            instance[k] = v
        end
    end

    -- apply instance functions
    setmetatable(instance, { __index = hotspot })

    return instance

end

--- Placeholder function.
-- Hotspots do not process any updates.
--
-- @tparam number dt
-- Time delta as given by the Love callback
function hotspot:update(dt)

end

--- Process mouse movement.
function hotspot:mousemoved(x, y, dx, dy, istouch)

    self.focused = self:testFocus(x, y)

end

--- Process mouse presses.
function hotspot:mousepressed(x, y, button, istouch)

    self.down = self.focused

end

--- Process mouse releases.
-- This is the function that triggers the callback function on the control.
function hotspot:mousereleased(x, y, button, istouch)

    self.down = false

    if self.focused and self.callback then
        self.callback(self)
    end

end

--- Tests if a point is over the control.
-- Used internally by @{mousepressed}
--
-- @tparam number x
-- The x point
--
-- @tparam number y
-- The y point
--
-- @treturn bool
-- True if the point is over the control.
function hotspot:testFocus(x, y)

    return x > self.left and x < self.left + self.width
        and y > self.top and y < self.top + self.height

end

--- Placeholder function.
-- Hotspots do not draw anything, this is user controlled.
function hotspot:draw()

end

return module
