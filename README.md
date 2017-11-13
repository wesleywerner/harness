# harness

Things to help scaffold your LÖVE user experience.

# digit roller

The digit roller simply watches a value on a table for changes, this value must be a number value. The roller then interpolates the displayed value via a tween, so it appears to count up or down.

Creating a new instance gives you a digit roller collection, this helps rolling multiple digits with ease.

  local roller = require("digitroller")

  -- our data model where our values are kept
  local scores = { player1=0, player2=0 }

  -- create a new digit roller collection
  local scorecounters = roller:new()

### adding digit rollers

  -- add a digit roller to watch player 1's score
  scorecounters:add{
    subject=scoredata,
    target="player1",
    duration=2,
    left=30,
    top=300
    suffix="points",
    easing="outCubic",
  }

*required parameters*

* `subject` is the table to watch
* `target` is the key of the table value to watch

*optional parameters*

* `duration` is the time the rolling will take.
* `left` and `top` are the drawing positions.
* `suffix` is a string to append to the printed value.
* `easing` is the name of interpolation function to use.

Here is a [list of easing functions](https://github.com/kikito/tween.lua#easing-functions) available.

### updating digit rollers

  function love.update(dt)
    scorecounters:update(dt)
  end

### drawing digit rollers

You can call the built-in `draw` function to print all digit rollers in your collection:

  function love.draw()
    scorecounters:draw()
  end

Or you can take charge and draw them yourself simply by reading out `value`:

  -- must capture the digit roller instance for later use
  local roller = scorecounters:add{
    subject=scoredata,
    target="player1",
    left=30,
    top=300
  }

  function love.draw()
    -- draw the roller's value
    love.graphics.print(string.format("%d", roller.value), roller.left, roller.top)
  end

# aperture

The aperture provides a constrained view of a larger drawing. Like the photographer who touches the tips of her thumbs together, framing a shot.

The aperture scrolls what can be seen, up and down, or left and right.

Call the `new` function with a table of parameters:

  local picturescroll = require("aperture"):new{
    top=10,           -- position on screen
    left=220,
    width=200,        -- size of the aperture
    height=210,
    pages=3,          -- number of pages available (the size of each equals the width/height)
    duration=0.25,    -- time in seconds to animate the scroll
    easing="linear",  -- scroll easing method
    landscape=true    -- true scrolls horizontally
  }

### aperture methods

Requires update calls to process scroll animations.

`aperture:update(dt)`

Pass mouse moved events to the aperture. This is how it knows when the focus is on them.

`aperture:mousemoved(x, y, dx, dy, istouch)`

Programatically scroll to a page. The parameter is clamped for your safety.

`aperture:scrollTo(page number)`

Programatically scroll an aperture left or up. These are synonymns and either can be used.

`aperture:scrollLeft()` and `aperture:scrollUp()`

Programatically scroll an aperture right or down. These are synonymns and either can be used.

`aperture:scrollright()` and `aperture:scrollDown()`

`aperture:apply()` begin transformation for drawing.

`aperture:release()` ends transformation.

  function love.draw()
    aperture:apply()
    ... your drawing here
    aperture:release()
  end

`aperture:pointIn(x, y, rect)` Tests if the given screen points `x` and `y` fall within the given `rect` bounds.

Points x and y are screen coordinates, that is: those received from the mouse pressed event.

Rect is a table with the `top`, `left`, `width` and `height` keys. The values must be relative to the aperture position, that is: point (0,0) is the top-left corner within the aperture, wherever it may be drawn on the screen.


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
