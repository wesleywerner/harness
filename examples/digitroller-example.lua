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

local roller = require("harness.digitroller")

-- Creating a new instance gives you a digit roller collection, this helps rolling multiple digits with ease.
local scorecounters = roller:new()

-- our data model where our values are kept
local scoredata = { player1=0, player2=0 }

-- add a digit roller to watch player 1's score
local myRoller = scorecounters:add{
    subject=scoredata,
    target="player1",
    left=30,
    top=30,
    suffix="points to player 1",  -- optional
    duration=2,                   -- optional
    easing="outCubic",            -- optional
}

-- add another roller for player 2
scorecounters:add{
    subject=scoredata,
    target="player2",
    left=30,
    top=50,
    suffix="points to player 2"
}

-- update the collection to animate the rollers
function love.update(dt)
    scorecounters:update(dt)
end

function love.draw()

    -- let the digit roller draw itself
    scorecounters:draw()

    -- or you can control the drawing directly
    local printedValue = string.format("%d %s (custom print)", myRoller.value, myRoller.suffix)
    love.graphics.print(printedValue, myRoller.left, myRoller.top + 40)

end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  else
    scoredata.player1 = math.random(1, 100)
    scoredata.player2 = math.random(1, 100)
  end
end
