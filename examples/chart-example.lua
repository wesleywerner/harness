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

local color = { }
color.white     = { 255, 255, 255 }
color.base03    = {   0,  43,  54 }  -- darker background tones
color.base02    = {   7,  54,  66 }  -- dark background tones
color.base01    = {  88, 110, 117 }  -- darker content tones
color.base00    = { 101, 123, 131 }  -- dark content tones
color.base0     = { 131, 148, 150 }  -- light content tones
color.base1     = { 147, 161, 161 }  -- lighter content tones
color.base2     = { 238, 232, 213 }  -- light background tones
color.base3     = { 253, 246, 227 }  -- lighter background tones
color.yellow    = { 181, 137,   0 }
color.orange    = { 203,  75,  22 }
color.red       = { 220,  50,  47 }
color.magenta   = { 211,  54, 130 }
color.violet    = { 108, 113, 196 }
color.blue      = {  38, 139, 210 }
color.cyan      = {  42, 161, 152 }
color.green     = { 133, 153,   0 }

chart = require("harness.chart")

local function generateData()

    -- clear the chart
    sexychart:clear()
    plainchart:clear()

    -- create two sexy datasets
    for ds=1, 2 do

        local points = { }

        for n=1, 10 do
            table.insert(points, { a=n, b=math.random(20, 90) })
        end

        sexychart:data(points, string.format("dataset %d", ds))

    end

    -- create one plain dataset
    local points = { }
    for n=1, 10 do
        table.insert(points, { a=n, b=math.random(1, 100) + math.random() })
    end
    plainchart:data(points, "plain dataset")

end

local function drawGrid(chart, width, height)

    love.graphics.setColor(color.base3)

    -- vertical lines
    for x=0, width, 20 do
        love.graphics.line(x, 0, x, height)
    end

    -- horizontal lines
    for y=0, height, 20 do
        love.graphics.line(0, y, width, y)
    end

end

local function drawLabels(chart, labels)

    love.graphics.setColor(color.green)

    for _, label in ipairs(labels) do

        -- draw label point
        love.graphics.circle("line", label.x, label.y, 3)

        -- print label text
        if label.axiz == "x" then
            love.graphics.print(label.text, math.floor(label.x), math.floor(label.y + 12))
        else
            love.graphics.print(label.text, math.floor(label.x - 24), math.floor(label.y - 6))
        end

    end

end

local function drawBorder(chart, width, height)

    love.graphics.setColor(color.base1)
    love.graphics.rectangle("line", 0, 0, width, height)

end

local function drawLine(chart, dataset, node1, node2)

    -- switch color for each dataset
    if dataset == "dataset 1" then
        love.graphics.setColor(color.magenta)
    else
        love.graphics.setColor(color.blue)
    end

    love.graphics.setLineWidth(4)
    love.graphics.line(node1.x, node1.y, node2.x, node2.y)
    love.graphics.setLineWidth(1)

end

local function drawNode(chart, dataset, node)

    if dataset == "dataset 1" then
        love.graphics.setColor(color.magenta)
    else
        love.graphics.setColor(color.blue)
    end

    if node.focus then
        love.graphics.setColor(color.green)
        love.graphics.circle("fill", node.x, node.y, 6)
        -- tooltip
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", node.x + 20, node.y - 4, 90, 40)
        love.graphics.setColor(color.white)
        love.graphics.print(string.format("point: %d\nvalue: %d", node.a, node.b),
            math.floor(node.x + 24), math.floor(node.y))
    else
        love.graphics.circle("fill", node.x, node.y, 6)
    end

end

local function drawFill(chart, dataset, triangles)

    if dataset == "dataset 1" then
        love.graphics.setColor(211, 54, 130, 64)
    else
        love.graphics.setColor(38, 139, 210, 64)
    end

    for _, triangle in ipairs(triangles) do
        love.graphics.polygon("fill", triangle)
    end

end

function love.load()

    -- overwrite drawing functions
    sexychart = chart(400, 200)
    sexychart.drawGrid = drawGrid
    sexychart.drawLabels = drawLabels
    sexychart.drawBorder = drawBorder
    sexychart.drawLine = drawLine
    sexychart.drawNode = drawNode
    sexychart.drawFill = drawFill

    -- store the chart position.
    -- This is not used by the chart component, only by our example.
    sexychart.left = 100
    sexychart.top = 50

    -- use default drawing functions (black and white)
    plainchart = chart(600, 100)
    plainchart.left = 100
    plainchart.top = 400

    generateData()

end

function love.mousepressed(x, y, button, istouch)

    generateData()

end

function love.mousemoved(x, y, dx, dy, istouch)

    -- account for chart position on screen
    sexychart:mousemoved(x - sexychart.left, y - sexychart.top, dx, dy, istouch)
    plainchart:mousemoved(x - plainchart.left, y - plainchart.top, dx, dy, istouch)

end

function love.update(dt)

    sexychart:update(dt)
    plainchart:update(dt)

end

function love.draw()

    love.graphics.setColor(color.base2)
    love.graphics.rectangle("fill", 0, 0, 800, 300)

    love.graphics.push()
    love.graphics.translate(sexychart.left, sexychart.top)
    sexychart:draw()
    love.graphics.pop()

    love.graphics.push()
    love.graphics.translate(plainchart.left, plainchart.top)
    plainchart:draw()
    love.graphics.pop()

end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    else
        generateData()
    end
end
