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

function love.load()

    -- set button font
    love.graphics.setFont(love.graphics.newFont(24))

    local button = require("harness.button")

    simplebutton = button:new{
        left = 100,
        top = 100,
        text = "hello, world!",

        callback = function(btn)
            print("clicked "..os.date("%c", os.time()))
            end,

        draw = function(btn)
            love.graphics.push()
            if btn.down then
                love.graphics.translate(0, 1)
            elseif btn.focused then
                love.graphics.translate(0, -1)
            end
            love.graphics.setColor(255, 255, 255)
            love.graphics.rectangle("fill", btn.left, btn.top, btn.width, btn.height)
            love.graphics.setColor(0, 0, 255)
            love.graphics.print(btn.text, btn.left, btn.top)
            love.graphics.pop()
            end
    }

end

function love.mousepressed(x, y, button, istouch)

    simplebutton:mousepressed(x, y, button, istouch)

end

function love.mousereleased(x, y, button, istouch)

    simplebutton:mousereleased(x, y, button, istouch)

end

function love.mousemoved(x, y, dx, dy, istouch)

    simplebutton:mousemoved(x, y, dx, dy, istouch)

end

function love.update(dt)

    simplebutton:update(dt)

end

function love.draw()

    simplebutton:draw()

end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end
