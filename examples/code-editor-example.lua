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

local ce = require("harness.code-editor")

function love.load ()
    love.keyboard.setKeyRepeat(true)
    local options = { buffer="Hello, World! \nThe quick brown fox.....jumped \nover the lazy dog " }
    ce:load(options)
end

function love.update (dt)

end

function love.mousepressed (x, y, button, istouch, presses)

end

function love.mousereleased (x, y, button, istouch, presses)

end

function love.mousemoved (x, y, dx, dy, istouch)

end

function love.wheelmoved (x, y)

end

function love.update(dt)
    ce:update(dt)
end

function love.draw()

    love.graphics.print("harness code editor =)")

    love.graphics.push()
    love.graphics.translate(0, 20)
    ce:draw()
    love.graphics.pop()

end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    else
        ce:keypressed(key, scancode, isrepeat)
    end
end

function love.textinput(text)
    ce:textinput(text)
end
