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

![figure 1](figures/figure1.png)
_figure 1 shows some text drawn to the screen. The top frame indicates the aperture position and size, content in this frame is visible._

### aperture methods

`aperture:new(args)`

Creates a new aperture instance using `args`, a table of initialisation values. Only position, size and number of pages are required, the rest are optional.

  local aperture = require("aperture")

  local instance = aperture:new {

    -- The position of the aperture on your screen
    top=10,
    left=220,

    -- The size of your aperture
    width=200,
    height=210,

    -- Pages is number of pages available.
    pages=2,

    -- Duration is the time in seconds the scroll animation lasts.
    -- The default is 1 second.
    duration=1,

    -- Easing is the function used for the scroll animation.
    -- The default is "outCubic".
    easing="linear",

    -- Landscape controls horizontal scrolling.
    -- The default is false (vertical scrolling).
    landscape=true,

    -- Factor is the size of each step per scroll.
    -- The default is 1 and scrolls a full page each time.
    -- A factor of 0.5 steps half a page at a time.
    factor=1
  }

`instance:update(dt)`

Updates the aperture every frame so it can process scroll animations.

`instance:mousemoved(x, y, dx, dy, istouch)`

Pass mouse moved events to the aperture so that it knows when it has focus, that is: the mouse pointer is over it.

`instance:scrollTo(page number)`

Scroll to the given page number. The page parameter is clamped for your safety.

`instance:scrollLeft()` and `aperture:scrollUp()`

Scroll one page left or up. These are synonymns and either can be used.

`instance:scrollRight()` and `aperture:scrollDown()`

Scroll one page right or down. These are synonymns and either can be used.

`instance:apply()`

You must call this before you start drawing anything inside the aperture. Your drawings will be clipped and transformed accordingly.

`aperture:release()`

You must call this after you finished drawing the contents of your aperture. It returns clipping and transforms to normal.

  function love.draw()
    aperture:apply()
    ... your drawing here
    aperture:release()
  end

`aperture:pointIn(x, y, rect)`

Tests if the given screen points `x` and `y` fall within the given `rect` bounds.

Points x and y are screen coordinates, that is: those received from the mouse pressed event.

Rect is a table with the `top`, `left`, `width` and `height` keys. The values must be relative to the aperture position, that is: point (0,0) is the top-left corner within the aperture, wherever it may be positioned on the screen.


### aperture properties

`instance.complete`

Truthy when the scroll animation is at it's end, falsy while still scrolling.

`instance.page`

The current page number.

`instance.active`

The aperture considers itself active while the mouse pointer is over it.


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
