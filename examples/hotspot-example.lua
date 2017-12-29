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

local black = {0, 0, 0}
local white = {255, 255, 255}
local green = {64, 255, 128}
local pink = {255, 64, 255}
local heart = love.graphics.newImage("heart.png")
local heartflutter = 0

local hotspot = require("harness.hotspot")
local mysweetspot = hotspot:new{
    top=10,
    left=10,
    width=100,
    height=40,
    -- we can add any of our own values we find useful.
    ourText="click me quick",
    callback = function(hotspot)
        hotspot.ourText = "click me " .. ({"quick", "hard", "fast"})[math.random(1, 3)]
        heartflutter = 1.5
        print("hotspot clicked "..os.date("%c", os.time()))
        end
    }

function love.mousepressed(x, y, button, istouch)

    mysweetspot:mousepressed(x, y, button, istouch)

end

function love.mousereleased(x, y, button, istouch)

    mysweetspot:mousereleased(x, y, button, istouch)

end

function love.mousemoved(x, y, dx, dy, istouch)

    mysweetspot:mousemoved(x, y, dx, dy, istouch)

end

function love.update(dt)

    mysweetspot:update(dt)

    heartflutter = math.max(1, heartflutter - dt)

end

function love.draw()

    -- Draw the hotspot here, we could also have given mysweetspot
    -- a draw function and called mysweetspot:draw()

    if mysweetspot.down then
        love.graphics.setColor(green)
    elseif mysweetspot.focused then
        love.graphics.setColor(pink)
    else
        love.graphics.setColor(white)
    end

    love.graphics.rectangle("fill", mysweetspot.left, mysweetspot.top,
        mysweetspot.width, mysweetspot.height)

    love.graphics.setColor(black)

    love.graphics.printf(mysweetspot.ourText, mysweetspot.left, mysweetspot.top + mysweetspot.height/4, mysweetspot.width, "center")

    -- draw a fluttering heart
    love.graphics.setColor(white)
    love.graphics.draw(heart, 120, 120, 0, heartflutter, heartflutter, 34, 34)

end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
