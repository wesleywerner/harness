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

-- the text we will be using
local loremipsum = [[Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed doeiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enimad minim veniam, quis nostrud exercitation ullamco laboris nisi utaliquip ex ea commodo consequat. Duis aute irure dolor inreprehenderit in voluptate velit esse cillum dolore eu fugiat nullapariatur. Excepteur sint occaecat cupidatat non proident, sunt inculpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed doeiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enimad minim veniam, quis nostrud exercitation ullamco laboris nisi utaliquip ex ea commodo consequat. Duis aute irure dolor inreprehenderit in voluptate velit esse cillum dolore eu fugiat nullapariatur. Excepteur sint occaecat cupidatat non proident, sunt inculpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed doeiusmod tempor incididunt ut labore et dolore magna aliq]]

local aperture = require("harness.aperture")

local textaperture = aperture:new {

  -- The position of the aperture on your screen
  top=0,
  left=300,

  -- The size of your aperture
  width=200,
  height=200,

  -- Pages is number of pages available.
  pages=3,

  -- Duration is the time in seconds the scroll animation lasts.
  -- The default is 1 second.
  duration=1,

  -- Easing is the function used for the scroll animation.
  -- The default is "outCubic".
  easing="inOutCubic",

  -- Landscape controls horizontal scrolling.
  -- The default is false (vertical scrolling).
  landscape=false,

  -- Factor is the size of each step per scroll.
  -- The default is 1 and scrolls a full page each time.
  -- A factor of 0.5 steps half a page at a time.
  factor=1
}


function love.mousemoved(x, y, dx, dy, istouch)

  textaperture:mousemoved(x, y, dx, dy, istouch)

end

function love.update(dt)

  textaperture:update(dt)

end

function love.wheelmoved(x, y)
  if y > 0 then
    textaperture:scrollUp()
  else
    textaperture:scrollDown()
  end
end

function love.draw()

  -- print the text without any aperture
  love.graphics.printf(loremipsum, 10, 10, 200)

  -- now apply the aperture and print the same text.
  -- note how x and y are draws relative to the aperture.
  textaperture:apply()
  love.graphics.printf(loremipsum, 10, 10, 200)
  textaperture:release()

end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end
