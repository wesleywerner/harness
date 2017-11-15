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

-- build a collection of hot spots
local sensitiveAreas = {}

-- the hotspot must have the position and size arguments.
table.insert(sensitiveAreas, hotspot:new{
  top=10,
  left=10,
  width=100,
  height=40,
  -- we can add any of our own values we find useful.
  ourText="click me quick",
  ourFillTimeout=0
})

table.insert(sensitiveAreas, hotspot:new{
  top=10,
  left=120,
  width=100,
  height=40,
  -- we can add any of our own values we find useful.
  ourText="click me hard",
  ourFillTimeout=0
})

table.insert(sensitiveAreas, hotspot:new{
  top=10,
  left=230,
  width=200,
  height=80,
  -- we can add any of our own values we find useful.
  ourText="click me gently",
  ourFillTimeout=0
})

function love.mousepressed(x, y, button, istouch)

  -- test if any hot spot was touched
  for _, spot in ipairs(sensitiveAreas) do

    if spot:touched(x, y) then
      -- yep
      spot.ourFillTimeout = 1
    end

  end

end

function love.update(dt)

  heartflutter = math.max(1, heartflutter - dt)

  -- reduce the timeout for each hot spot
  for _, spot in ipairs(sensitiveAreas) do

    if spot.ourFillTimeout > 0 then
      spot.ourFillTimeout = spot.ourFillTimeout - dt * 5
      heartflutter = 1.5
    end

  end

end

function love.draw()

  -- draw our hot spots
  for _, spot in ipairs(sensitiveAreas) do

    if spot.ourFillTimeout > 0 then
      love.graphics.setColor(green)
    else
      love.graphics.setColor(white)
    end

    love.graphics.rectangle("fill", spot.left, spot.top, spot.width, spot.height)
    love.graphics.setColor(black)
    love.graphics.printf(spot.ourText, spot.left, spot.top+spot.height/4, spot.width, "center")

    love.graphics.setColor(white)
    love.graphics.draw(heart, 120, 120, 0, heartflutter, heartflutter, 34, 34)
  end

end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end
