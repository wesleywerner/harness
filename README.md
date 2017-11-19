# harness

Harness is a Lua toolkit to help scaffold your LÖVE user experience.

Harness uses [Kikito's tween library](https://github.com/kikito/tween.lua).

### running the examples

Symlink (or copy) harness into the examples directory.

    ln -s $(pwd) examples/

Then symlink the example you want as `main.lua`

    ln -s full-example.lua main.lua

Now you can run it

    love .


# digit roller

The digit roller simply watches a value on a table for changes, this value must be a number value. The roller then interpolates the displayed value via a tween, so it appears to count up or down.

### commented example

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

*required parameters*

* `subject` is the table to watch
* `target` is the key of the table value to watch

*optional parameters*

* `duration` is the time the rolling will take.
* `left` and `top` are the drawing positions.
* `suffix` is a string to append to the printed value.
* `easing` is the name of interpolation function to use.

Here is a [list of easing functions](https://github.com/kikito/tween.lua#easing-functions) available.

# aperture

The aperture provides a constrained view of a larger drawing. Like the photographer who touches the tips of her thumbs together, framing a shot.

![figure 1](figures/figure1.png)

_figure 1 shows some text drawn to the screen. The top frame indicates the aperture position and size, anything drawn in this area is visible._

### commented example

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


### aperture methods

`aperture:new(args)`: Returns a new aperture passing a key-value table `args` as parameters.

`instance:update(dt)`: Updates the aperture every frame so it can process scroll animations.

`aperture:mousemoved(x, y, dx, dy, istouch)`: process mouse movement so that the "touched" property is set to `true` if the cursor is over the aperture.

`instance:scrollTo(page number)`: Scroll to the given page number. The parameter is clamped for your safety.

`instance:scrollLeft()` and `aperture:scrollUp()`: Scroll one page left or up. These are synonymns and either can be used.

`instance:scrollRight()` and `aperture:scrollDown()`: Scroll one page right or down. These are synonymns and either can be used.

`instance:apply()`: Call this to draw inside the aperture. Your drawings will be clipped and transformed accordingly.

`aperture:release()`: Call this when you are done drawing inside the aperture. It returns clipping and transforms to normal.

`aperture:pointIn(x, y, rect)`: Tests if the given screen points `x` and `y` fall within the given `rect` bounds. Points `x` and `y` are screen coordinates, that is: those received from the mouse pressed event.

`rect` is a table with the `top`, `left`, `width` and `height` keys. These values are relative to the aperture position, that is: point (0,0) is the top-left corner within the aperture.

`aperture:pointFromScreen(x, y)`: Convert screen points to aperture-local points. This only works well while `aperture.active` is truthy, otherwise you will get a result that is out of the aperture bounds.

`aperture:mousepressed(x, y, button, istouch)`

`aperture:insert(hotspot)`


### aperture properties

`instance.complete`: Truthy when the scroll animation is at it's end, falsy while still scrolling.

`instance.page`: The current page number.

`hotspot.touched`: true while the cursor is over the aperture.


# hotspot

The hotspot is a simple yet magical thing. Use it to track clicking on areas easier.

### commented example

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

        if spot.touched then
          -- yep
          spot.ourFillTimeout = 1
        end

      end

    end

    function love.mousemoved(x, y, dx, dy, istouch)

      -- test if any hot spot was touched
      for _, spot in ipairs(sensitiveAreas) do

        -- this sets "touched" to true on any hotspot under the cursor
        spot:mousemoved(x, y, dx, dy, istouch)

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


### hotspot methods

`hotspot:new(args)`: returns a new hotspot.

`hotspot:mousemoved(x, y, dx, dy, istouch)`: process mouse movement so that the "touched" property is set to `true` if the cursor is over the hotspot.

### hotspot properties

`hotspot.touched`: true while the cursor is over the hotspot.


# license

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
