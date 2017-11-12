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
