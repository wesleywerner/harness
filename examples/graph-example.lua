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

graph = require("harness.graph")

local function setPoints()

    -- clear the graph
    sexygraph:clear()

    -- create two datasets
    for ds=1, 2 do

        local points = { }

        for n=1, 10 do
            table.insert(points, { x=n, y=math.random(20, 90) })
        end

        sexygraph:data(points, string.format("dataset %d", ds))

    end

end

local function drawGrid()

    love.graphics.setColor(color.base3)

    for x=0, sexygraph.width, 20 do
        love.graphics.line(x, 0, x, sexygraph.height)
    end
    for y=0, sexygraph.height, 20 do
        love.graphics.line(0, y, sexygraph.width, y)
    end

end

local function drawLabels(labels)

    love.graphics.setColor(color.green)

    for _, label in ipairs(labels) do

        -- draw label point
        love.graphics.circle("line", label.x, label.y, 3)

        -- print label text
        if label.axiz == "x" then
            love.graphics.print(label.text, label.x, label.y + 12)
        else
            love.graphics.print(label.text, label.x - 24, label.y - 6)
        end

    end

end

local function drawBorder()

    love.graphics.setColor(color.base1)
    love.graphics.rectangle("line", 0, 0, sexygraph.width, sexygraph.height)

end

local function drawLine(dataset, point1, point2)

    -- line
    if dataset == "dataset 1" then
        love.graphics.setColor(color.magenta)
    else
        love.graphics.setColor(color.blue)
    end

    love.graphics.setLineWidth(4)
    love.graphics.line(point1.x, point1.y, point2.x, point2.y)
    love.graphics.setLineWidth(1)

end

local function drawJoin(dataset, x, y, value1, value2, focused)

    if dataset == "dataset 1" then
        love.graphics.setColor(color.magenta)
    else
        love.graphics.setColor(color.blue)
    end

    if focused then
        love.graphics.setColor(color.white)
        love.graphics.circle("fill", x, y, 6)
        -- tooltip
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", x + 20, y - 4, 80, 40)
        love.graphics.setColor(color.white)
        love.graphics.print(string.format("point: %d\nvalue: %d", value1, value2), x + 24, y)
    else
        love.graphics.circle("fill", x, y, 6)
    end

end

local function drawFill(dataset, triangles)

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

    sexygraph = graph(400, 200)
    setPoints()
    sexygraph.drawGrid = drawGrid
    sexygraph.drawLabels = drawLabels
    sexygraph.drawBorder = drawBorder
    sexygraph.drawLine = drawLine
    sexygraph.drawJoin = drawJoin
    sexygraph.drawFill = drawFill

end

function love.mousepressed(x, y, button, istouch)

    setPoints()

end

function love.mousemoved(x, y, dx, dy, istouch)

    -- account for graph position on screen
    sexygraph:mousemoved(x - 100, y - 100, dx, dy, istouch)

end

function love.update(dt)

    sexygraph:update(dt)

end

function love.draw()

    love.graphics.push()
    love.graphics.translate(100, 100)
    love.graphics.clear(color.base2)
    sexygraph:draw()
    love.graphics.pop()

end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    else
        setPoints()
    end
end
