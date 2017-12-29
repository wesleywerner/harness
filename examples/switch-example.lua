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

-- Demonstrates a two-state switch component built from a @{button} element.

function love.load()

    -- set button font
    love.graphics.setFont(love.graphics.newFont(24))

    local button = require("harness.button")

    -- button image is a cut-up of edges and fill
    local image = love.graphics.newImage("switch.png")
    local imw, imh = image:getDimensions()

    -- define the quads that make up the button parts
    local leftQuad = love.graphics.newQuad(0, 0, 15, 32, imw, imh)
    local rightQuad = love.graphics.newQuad(18, 0, 15, 32, imw, imh)
    local fillQuad = love.graphics.newQuad(16, 0, 1, 32, imw, imh)
    local switchQuad = love.graphics.newQuad(34, 0, 30, 32, imw, imh)

    -- a nice lerping function
    local function lerp(a, b, amt)
        return a + (b - a) * (amt < 0 and 0 or (amt > 1 and 1 or amt))
    end

    sexyswitch = button:new{
        left = 100,
        top = 100,

        -- text only used to measure element size, we make it large
        -- to pad the switch on both sides
        text = "-----------------",

        -- custom switch code
        value = 1,
        options = { "option a", "option b"},
        a = 0,
        b = 0,
        dt = 1,

        callback = function(btn)
            --btn.value = math.max(1, (btn.value + 1) % 3)
            print("clicked "..os.date("%c", os.time()))
            -- flip the switch value and "a"/"b" position values
            if btn.value == 1 then
                btn.value = 2
                btn.a = 0
                btn.b = 1
                btn.dt = 0
            else
                btn.value = 1
                btn.a = 1
                btn.b = 0
                btn.dt = 0
            end
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

            -- draw the switch position, lerped by "a" and "b" via "dt"
            local switchX = lerp(btn.a, btn.b, btn.dt) * (btn.width) - 15
            love.graphics.draw(image, switchQuad, switchX, 0)

            -- print text
            love.graphics.printf(btn.options[btn.value], 0, 0, btn.width, "center")

            -- restore graphics state
            love.graphics.pop()
            end,

        -- custom button update increases internal dt value
        update = function(btn, dt)
            btn.dt = btn.dt + dt * 4
            end
    }

end

function love.mousepressed(x, y, button, istouch)

    sexyswitch:mousepressed(x, y, button, istouch)

end

function love.mousereleased(x, y, button, istouch)

    sexyswitch:mousereleased(x, y, button, istouch)

end

function love.mousemoved(x, y, dx, dy, istouch)

    sexyswitch:mousemoved(x, y, dx, dy, istouch)

end

function love.update(dt)

    sexyswitch:update(dt)

end

function love.draw()

    sexyswitch:draw()

end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end
