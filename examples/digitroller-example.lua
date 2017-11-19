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

-- our data model where our values are kept
local scoredata = { player1=0, player2=0 }

-- add a digit roller to watch player 1's score
local p1roller = roller:new{
    subject=scoredata,
    target="player1",
    duration=0.5,     -- optional
    easing="linear",  -- optional
    top=30,           -- our custom property
    left=30           -- our custom property
}

-- add another roller for player 2
local p2roller = roller:new{
    subject=scoredata,
    target="player2",
    top=50,           -- our custom property
    left=30           -- our custom property
}

-- update the collection to animate the rollers
function love.update(dt)
    p1roller:update(dt)
    p2roller:update(dt)
end

function love.draw()

    love.graphics.print("Press any key to change the scores to a random number")

    local printedValue = string.format("p1 score: %d", p1roller.value)
    love.graphics.print(printedValue, p1roller.left, p1roller.top)

    local printedValue = string.format("p2 score: %d", p2roller.value)
    love.graphics.print(printedValue, p2roller.left, p2roller.top)

end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    else
        scoredata.player1 = math.random(10, 1000)
        scoredata.player2 = math.random(10, 1000)
    end
end
