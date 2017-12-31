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

-- stores the widget collection
local coll = nil

function love.load()

    -- set button font
    love.graphics.setFont(love.graphics.newFont(24))

    -- load the widget collection
    local collectionModule = require("harness.widgetcollection")

    -- get a new collection instance
    coll = collectionModule:new()

    -- define a reusable draw function
    local drawfunc = function(btn)
        love.graphics.push()
        if btn.down then
            love.graphics.translate(0, 1)
        elseif btn.focused then
            love.graphics.translate(0, -1)
            love.graphics.setColor(255, 0, 0)
            love.graphics.setLineWidth(4)
            love.graphics.rectangle("line", btn.left, btn.top, btn.width, btn.height)
        end
        love.graphics.setColor(255, 255, 255)
        love.graphics.rectangle("fill", btn.left, btn.top, btn.width, btn.height)
        love.graphics.setColor(0, 0, 255)
        love.graphics.print(btn.text, btn.left, btn.top)
        love.graphics.pop()
        end

    -- define a reusable click function
    local clickfunc = function(btn)
        print("clicked "..btn.text)
        end

    -- create a bunch of buttons
    for n=1, 5 do

        coll:button("button"..n, {
            left = 100,
            top = 10 + (n * 40),
            text = string.format("#%.2d", n),
            callback = clickfunc,
            draw = drawfunc
        })

    end

    for n=6, 10 do

        coll:button("button"..n, {
            left = 0 + (n * 60),
            top = 100,
            text = string.format("#%.2d", n),
            callback = clickfunc,
            draw = drawfunc
        })

    end

end

function love.mousepressed(x, y, button, istouch)

    coll:mousepressed(x, y, button, istouch)

end

function love.mousereleased(x, y, button, istouch)

    coll:mousereleased(x, y, button, istouch)

end

function love.mousemoved(x, y, dx, dy, istouch)

    coll:mousemoved(x, y, dx, dy, istouch)

end

function love.update(dt)

    coll:update(dt)

end

function love.draw()

    love.graphics.clear(32, 128, 192)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("use TAB and shift-TAB to cycle focus, ENTER selects")
    coll:draw()

end

function love.keypressed(key)

    if key == "escape" then
        love.event.quit()
    else
        coll:keypressed(key)
    end

end
