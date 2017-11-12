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
local red = {255, 64, 128}
local green = {64, 255, 128}
local blue = {64, 128, 255}
local yellow = {255, 255, 64}

-- the data model where player scores live
local scoredata = { player1=0, player2=0 }

-- demonstrates the labelcollection
local scorecounters = require("digitroller"):new()

-- watch player scores for changes
scorecounters:add{
  subject=scoredata,
  target="player1",
  suffix="points",
  duration=2,
  easing="outCubic",
  left=30,
  top=300
}

scorecounters:add{
  subject=scoredata,
  target="player2",
  suffix="points",
  left=30,
  top=320
}

-- demonstrates the scroll manager
local loremscroll = require("scrollmanager"):new{
  top=10, left=10, width=200, height=210,
  pages=4,
  duration=1,
  easing="inOutQuad"
}

local picturescroll = require("scrollmanager"):new{
  top=10, left=220, width=200, height=210,
  pages=3,
  duration=0.25,
  easing="linear"
}

local clickscroll = require("scrollmanager"):new{
  top=10, left=430, width=200, height=210,
  pages=2
}

local testbutton = {left=30, top=240, width=120, height=40, counter=1}

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.wheelmoved(x, y)
  if y > 0 then
    loremscroll:scrollup()
    picturescroll:scrollup()
    clickscroll:scrollup()
  else
    loremscroll:scrolldown()
    picturescroll:scrolldown()
    clickscroll:scrolldown()
  end
end

function love.mousemoved(x, y, dx, dy, istouch)
  loremscroll:mousemoved(x, y, dx, dy, istouch)
  picturescroll:mousemoved(x, y, dx, dy, istouch)
  clickscroll:mousemoved(x, y, dx, dy, istouch)
end

function love.mousepressed(x, y)
  if clickscroll:pointIn(x, y, testbutton) then
    testbutton.counter = testbutton.counter + 1
    local increase = math.random(10, 100)
    scoredata.player1 = scoredata.player1 + increase
    scoredata.player2 = scoredata.player2 + increase
    print("button clicked")
  end
  -- you can also call this to get the point in screen coordinates
  -- x, y = clickscroll:pointToScreen(x, y)
end

function love.update(dt)
  loremscroll:update(dt)
  picturescroll:update(dt)
  clickscroll:update(dt)
  scorecounters:update(dt)
end

function love.draw()
  drawLorem()
  drawPictures()
  drawClicks()
end

function drawLorem()

  -- white background
  love.graphics.setColor(white)
  love.graphics.rectangle("fill",
    loremscroll.left,
    loremscroll.top,
    loremscroll.width,
    loremscroll.height)

  -- apply the scroll transform
  loremscroll:apply()

  -- print lorem text
  love.graphics.setColor(black)
  love.graphics.printf(
  [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam aliquet libero nec tortor malesuada malesuada. Quisque quis nisi non arcu finibus semper. Vivamus est turpis, tincidunt eu vestibulum a, viverra eleifend nunc. Nulla augue dolor, hendrerit dapibus suscipit a, faucibus nec ex. Proin in faucibus turpis, at venenatis nisl. Pellentesque pulvinar consectetur enim, non pharetra leo condimentum in. Curabitur tincidunt dolor dui, sit amet convallis nisl sodales pellentesque. Vivamus euismod, metus at dapibus elementum, risus odio pharetra massa, vitae dapibus nisi nibh non lorem. Aenean in mauris scelerisque, volutpat ante non, cursus quam.

  In sodales ullamcorper lorem vitae ornare. Integer et felis at est tincidunt consequat. Praesent tellus tellus, imperdiet sed nunc blandit, accumsan accumsan augue. Nullam id ante consequat, viverra tellus eu, efficitur nulla. Nulla ligula justo, commodo ut arcu sit amet, sollicitudin hendrerit magna. Duis porta pulvinar faucibus. Praesent accumsan semper purus ut interdum. Aenean commodo at magna nec tincidunt. Morbi tortor nisi, pulvinar scelerisque magna quis, bibendum hendrerit turpis. Vestibulum vel euismod libero, vel bibendum ipsum. Cras efficitur sapien id turpis ornare consectetur.]],
  10, 10, 180, "center" )

  -- release the scroll transform
  loremscroll:release()

  -- draw a nice box around our text
  love.graphics.setColor(white)
  love.graphics.rectangle("line",
    loremscroll.left,
    loremscroll.top,
    loremscroll.width,
    loremscroll.height
    )

  -- print page info
  love.graphics.print(
    string.format("page %d of %d", loremscroll.page, loremscroll.pages),
    loremscroll.left, loremscroll.top + loremscroll.height + 10)

end

function drawPictures()

  -- apply the scroll transform
  picturescroll:apply()

  -- draw some pictures
  love.graphics.setColor(red)
  love.graphics.polygon("fill", 60, 80, 160, 80, 110, 180)
  love.graphics.setColor(green)
  love.graphics.circle("fill", 100, 330, 40)
  love.graphics.circle("line", 100, 330, 60)
  love.graphics.setColor(blue)
  love.graphics.rectangle("fill", 20, 440, 160, 160)
  love.graphics.setColor(white)
  love.graphics.circle("fill", 100, 520, 20)

  -- release the scroll transform
  picturescroll:release()

  -- draw a nice box around our text
  love.graphics.setColor(white)
  love.graphics.rectangle("line",
    picturescroll.left,
    picturescroll.top,
    picturescroll.width,
    picturescroll.height
    )

  -- print page info
  love.graphics.print(
    string.format("page %d of %d", picturescroll.page, picturescroll.pages),
    picturescroll.left, picturescroll.top + picturescroll.height + 10)

end

function drawClicks()

  -- apply the scroll transform
  clickscroll:apply()

  love.graphics.setColor(yellow)
  love.graphics.printf("scroll down to test clicking a point in a scrolled area", 10, 60, 150)
  love.graphics.print(string.format("click me (%d)", testbutton.counter),
    testbutton.left+10, testbutton.top+10)
  love.graphics.rectangle("line", testbutton.left, testbutton.top, testbutton.width, testbutton.height)

  -- draw the labelcounter demo right inside this scroll demo
  scorecounters:draw()

  -- release the scroll transform
  clickscroll:release()

  -- draw a nice box around our text
  love.graphics.setColor(white)
  love.graphics.rectangle("line",
    clickscroll.left,
    clickscroll.top,
    clickscroll.width,
    clickscroll.height
    )

  -- print page info
  love.graphics.print(
    string.format("page %d of %d", clickscroll.page, clickscroll.pages),
    clickscroll.left, clickscroll.top + clickscroll.height + 10)

end
