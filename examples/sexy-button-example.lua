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

    -- button image is a cut-up of edges and fill
    local image = love.graphics.newImage("sexy-button.png")
    local imw, imh = image:getDimensions()

    -- define the quads that make up the button parts
    local leftQuad = love.graphics.newQuad(0, 0, 15, 32, imw, imh)
    local rightQuad = love.graphics.newQuad(18, 0, 15, 32, imw, imh)
    local fillQuad = love.graphics.newQuad(16, 0, 1, 32, imw, imh)

    sexybutton = button:new{
        left = 100,
        top = 100,
        text = "hello, sexy!",

        callback = function(btn)
            print("clicked "..os.date("%c", os.time()))
            end,

        draw = function(btn)

            -- this is a very unoptimized but functional demonstration.
            -- a better way is to pre-render this to canvas.
            -- it is worth noting the round corners are draw outside
            -- the button's bounds.

            -- save graphics state
            love.graphics.push()

            -- position the button
            love.graphics.translate(btn.left, btn.top)

            -- push up/down on focus/click
            if btn.down then
                love.graphics.translate(0, 1)
                love.graphics.setColor(255, 200, 255)
            elseif btn.focused then
                love.graphics.setColor(200, 255, 200)
            else
                love.graphics.setColor(255, 255, 255)
            end

            -- draw left corner (left of bounds)
            love.graphics.draw(image, leftQuad, -15, 0)

            -- draw fill
            for n=0, btn.width do
                love.graphics.draw(image, fillQuad, n, 0)
            end

            -- draw right corner (right of bounds)
            love.graphics.draw(image, rightQuad, btn.width, 0)

            -- print text
            love.graphics.print(btn.text)

            -- restore graphics state
            love.graphics.pop()
            end
    }

end

function love.mousepressed(x, y, button, istouch)

    sexybutton:mousepressed(x, y, button, istouch)

end

function love.mousereleased(x, y, button, istouch)

    sexybutton:mousereleased(x, y, button, istouch)

end

function love.mousemoved(x, y, dx, dy, istouch)

    sexybutton:mousemoved(x, y, dx, dy, istouch)

end

function love.update(dt)

    sexybutton:update(dt)

end

function love.draw()

    sexybutton:draw()

end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end
