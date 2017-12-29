--[[
   Copyright 2017 wesley werner <wesley.werner@gmail.com>

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


local button = require("harness.button")


function love.mousepressed(x, y, button, istouch)



end

function love.mousemoved(x, y, dx, dy, istouch)


end

function love.update(dt)



end

function love.draw()


end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end
