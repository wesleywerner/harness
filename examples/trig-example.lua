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

local trig = require("harness.trig")

local cx, cy, r = 250, 250, 100
local focusX, focusY = 0, 0

function love.update(dt)

end

function love.draw()

    love.graphics.print("Demonstrates limiting a point to a circular radius")

    -- draw the limit
    love.graphics.setColor(255, 255, 255, 64)
    love.graphics.circle("fill", cx, cy, r)

    -- draw the focus
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", focusX, focusY, 10)

end

function love.mousemoved( x, y, dx, dy, istouch )

    focusX, focusY = trig:limitPointToCircle(cx, cy, x, y, r)

end

function love.keypressed(key)
    love.event.quit()
end
