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
local scoredata = { player1=0 }

-- demonstrates the digit roller
local roller = require("harness.digitroller")

-- tracks a sine value for effect
local sinecounter = 0

-- watch player scores for changes
local p1score = roller:new{
  subject=scoredata,
  target="player1",
  suffix="points",
  duration=2,
  easing="outCubic",
  left=30,
  top=300
}

-- demonstrates the aperture
local loremscroll = require("harness.aperture"):new{
  top=10,
  left=10,
  width=200,
  height=200,
  pages=4,
  duration=1,
  easing="inOutQuad",
  factor=0.5
}

local picturescroll = require("harness.aperture"):new{
  top=10,
  left=220,
  width=200,
  height=200,
  pages=3,
  duration=0.25,
  easing="linear",
  landscape=true    -- scrolls horizontally
}

local clickscroll = require("harness.aperture"):new{
  top=10,
  left=430,
  width=200,
  height=200,
  pages=2
}

-- defines the area for our test button.
-- The button will live inside one of our apertures, as such
-- these positions are relative to the aperture's position.
local hotspot = require("harness.hotspot")
local testbutton = hotspot:new {
  left=30,
  top=240,
  width=120,
  height=40,
  counter=0,
  -- action function called when aperture is clicked
  action = function(self)
    self.counter = self.counter + 1
    scoredata.player1 = scoredata.player1 + math.random(10, 100)
  end
  }

-- insert the button into the click aperture
clickscroll:insert(testbutton)

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    -- scroll the apertures programatically.
    -- the page parameter is clamped for us so we can
    -- set an out-of-bounds page without fretting.
    loremscroll:scrollTo(math.random(1, 4))
    picturescroll:scrollTo(math.random(1, 4))
    clickscroll:scrollTo(math.random(1, 4))
  end
end

function love.wheelmoved(x, y)
  if y > 0 then
    loremscroll:scrollUp()
    picturescroll:scrollLeft()  -- a synonymn for scrollUp
    clickscroll:scrollUp()
  else
    loremscroll:scrollDown()
    picturescroll:scrollRight() -- a synonymn for scrollDown
    clickscroll:scrollDown()
  end
end

-- Pass mouse movement to the apertures. This is how they know
-- when the focus is on them.
function love.mousemoved(x, y, dx, dy, istouch)
  loremscroll:mousemoved(x, y, dx, dy, istouch)
  picturescroll:mousemoved(x, y, dx, dy, istouch)
  clickscroll:mousemoved(x, y, dx, dy, istouch)
end

-- Tests clicking inside an aperture
function love.mousepressed(x, y, button, istouch)

  if button == 1 then
    clickscroll:mousepressed(x, y, button, istouch)
  end

end

function love.update(dt)
  sinecounter = sinecounter + dt
  loremscroll:update(dt)
  picturescroll:update(dt)
  clickscroll:update(dt)
  p1score:update(dt)
end

function love.draw()
  drawLorem()
  drawPictures()
  drawClicks()

  love.graphics.printf([[The aperture provides a constrained view of a larger drawing. Like the photographer who touches the tips of her thumbs together, framing a shot. The aperture scrolls what can be seen using transforms. There is no underlying canvas involved.

The digit roller simply watches a value on a table for changes. The roller then interpolates the displayed value via a tween, so it appears to count up or down.

You may press 'r' to programmatically randomize the pages to display.]], 100, 300, 400)

end

function drawLorem()

  -- white background
  love.graphics.setColor(white)
  love.graphics.rectangle("fill",
    loremscroll.left,
    loremscroll.top,
    loremscroll.width,
    loremscroll.height)

  -- apply the transform
  loremscroll:apply()

  -- print lorem text
  love.graphics.setColor(black)
  love.graphics.printf(
  [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam aliquet libero nec tortor malesuada malesuada. Quisque quis nisi non arcu finibus semper. Vivamus est turpis, tincidunt eu vestibulum a, viverra eleifend nunc. Nulla augue dolor, hendrerit dapibus suscipit a, faucibus nec ex. Proin in faucibus turpis, at venenatis nisl. Pellentesque pulvinar consectetur enim, non pharetra leo condimentum in. Curabitur tincidunt dolor dui, sit amet convallis nisl sodales pellentesque. Vivamus euismod, metus at dapibus elementum, risus odio pharetra massa, vitae dapibus nisi nibh non lorem. Aenean in mauris scelerisque, volutpat ante non, cursus quam.

  In sodales ullamcorper lorem vitae ornare. Integer et felis at est tincidunt consequat. Praesent tellus tellus, imperdiet sed nunc blandit, accumsan accumsan augue. Nullam id ante consequat, viverra tellus eu, efficitur nulla. Nulla ligula justo, commodo ut arcu sit amet, sollicitudin hendrerit magna. Duis porta pulvinar faucibus. Praesent accumsan semper purus ut interdum. Aenean commodo at magna nec tincidunt. Morbi tortor nisi, pulvinar scelerisque magna quis, bibendum hendrerit turpis. Vestibulum vel euismod libero, vel bibendum ipsum. Cras efficitur sapien id turpis ornare consectetur.]],
  10, 10, 180, "center" )

  -- release the transform
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
    string.format("page %.1f of %d", loremscroll.page, loremscroll.pages),
    loremscroll.left, loremscroll.top + loremscroll.height + 10)

end

function drawPictures()

  -- apply the transform
  picturescroll:apply()

  -- draw a hovering triangle
  love.graphics.setColor(red)
  love.graphics.polygon("fill",
    60+10*math.sin(sinecounter), 80+10*math.cos(sinecounter),
    160+10*math.sin(sinecounter), 80+10*math.sin(sinecounter),
    110+10*math.cos(sinecounter), 180+20*math.sin(sinecounter))

  -- draw a hydrogen atom
  love.graphics.setColor(green)
  love.graphics.print("Hydrogen", 270, 30)
  love.graphics.circle("fill", 300, 130, 20)
  love.graphics.circle("line", 300, 130, 60)
  love.graphics.setColor(yellow)
  love.graphics.circle("fill", 300+60*math.cos(sinecounter), 130+60*math.sin(sinecounter), 4)

  -- draw a bobbing ball
  love.graphics.setColor(blue)
  love.graphics.rectangle("fill", 400, 40, 200, 180)
  love.graphics.setColor(white)
  love.graphics.circle("fill", 500+(40*math.cos(sinecounter*.1)), 45+(8*math.sin(sinecounter)), 20)

  -- release the transform
  picturescroll:release()

  -- draw a nice box around our pictures
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

  -- apply the transform
  clickscroll:apply()

  -- print helpful text
  love.graphics.setColor(white)
  love.graphics.printf("scroll down to test clicking a point in a scrolled area", 10, 60, 150)

  -- draw a really ugly button
  love.graphics.setColor(white)
  love.graphics.rectangle("fill", testbutton.left, testbutton.top,
    testbutton.width, testbutton.height)

  love.graphics.setColor(yellow)
  love.graphics.rectangle("line", testbutton.left, testbutton.top,
    testbutton.width, testbutton.height)

  love.graphics.setColor(black)
  love.graphics.print(string.format("clicked %d times", testbutton.counter),
    testbutton.left+10, testbutton.top+14)

  -- draw the digit roller demo right inside this aperture.
  love.graphics.setColor(white)
  love.graphics.print(string.format("%d", p1score.value), p1score.left, p1score.top)

  -- release the transform
  clickscroll:release()

  -- draw a nice box around our clicks
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
