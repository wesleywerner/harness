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

local module = { }

local module_mt = { }

function module:new(args)

    if not args.top or not args.left or not args.text then
        error("Button must have text, top and left")
    end

    local instance = { }

    -- copy arguments to the instance
    for k, v in pairs(args) do
        -- ensure callback is always a function
        if k == "callback" then
            if type(v) == "function" then
                instance[k] = v
            end
        else
            instance[k] = v
        end
    end

    -- apply instance functions
    setmetatable(instance, { __index = module_mt })

    -- default size to the measured text
    instance.width, instance.height = love.graphics.newText(love.graphics.getFont(), args.text):getDimensions()

    --local edgeWidth = 15
    --local buttonHeight = 32
    --local image = love.graphics.newImage("button.png")
    --local w, h = image:getDimensions()
    --local tw, th = love.graphics.newText(love.graphics.getFont(), args.text):getDimensions()

    ---- text padding
    --local padding = math.ceil(edgeWidth / 2)

    --instance.width = edgeWidth + edgeWidth + tw - padding
    --instance.height = buttonHeight

    --if type(data) == "table" then
        --for k, v in pairs(data) do
            --instance[k] = v
        --end
    --elseif type(data) == "function" then
        --instance.callback = data
    --end

    --local renderButton = function(leftQuad, fillQuad, rightQuad)

        --local canvas = love.graphics.newCanvas(instance.width)
        --love.graphics.setCanvas(canvas)

        ---- left
        --love.graphics.draw(image, leftQuad, 0, 0)

        ---- fill
        --for n=0, tw - 1 - padding do
            --love.graphics.draw(image, fillQuad, edgeWidth + n, 0)
        --end

        ---- right
        --love.graphics.draw(image, rightQuad, edgeWidth + tw - padding)

        ---- text
        --love.graphics.printf(args.text, math.ceil(padding*1.5), math.ceil((h-th)/2), tw, "center")

        --love.graphics.setCanvas()
        --return canvas

    --end

    --love.graphics.setColor(255, 255, 255)

    --local normLeftQuad = love.graphics.newQuad(0, 0, edgeWidth, buttonHeight, w, h)
    --local normFillQuad = love.graphics.newQuad(16, 0, 1, buttonHeight, w, h)
    --local normRightQuad = love.graphics.newQuad(18, 0, edgeWidth, buttonHeight, w, h)
    --instance.image = renderButton(normLeftQuad, normFillQuad, normRightQuad)

    --local downLeftQuad = love.graphics.newQuad(35, 0, edgeWidth, buttonHeight, w, h)
    --local downFillQuad = love.graphics.newQuad(51, 0, 1, buttonHeight, w, h)
    --local downRightQuad = love.graphics.newQuad(53, 0, edgeWidth, buttonHeight, w, h)
    --instance.downimage = renderButton(downLeftQuad, downFillQuad, downRightQuad)

    return instance

end

function module_mt:testFocus(x, y)

  return x > self.left and x < self.left + self.width
    and y > self.top and y < self.top + self.height

end

function module_mt:draw()

    --love.graphics.push()

    --if self.down then
        --love.graphics.translate(0, 1)
        --love.graphics.draw(self.downimage, self.left, self.top)
    --elseif self.hover then
        --love.graphics.translate(0, -1)
        --love.graphics.draw(self.image, self.left, self.top)
    --else
        --love.graphics.draw(self.image, self.left, self.top)
    --end

    --love.graphics.pop()

end

function module_mt:update(dt)

end

function module_mt:mousemoved(x, y, dx, dy, istouch)

    self.focused = self:testFocus(x, y)

end

function module_mt:mousepressed(x, y, button, istouch)

    self.down = self.focused

end

function module_mt:mousereleased(x, y, button, istouch)

    self.down = false

    if self.focused and self.callback then
        self.callback(self)
    end

end

return module
