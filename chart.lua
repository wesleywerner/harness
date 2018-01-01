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

--- Provides a chart display.
--
-- @author Wesley Werner
-- @license GPL v3
-- @module chart


--- A table of data points that represent the chart.
-- @table pointdefinition
--
-- @tfield number a
-- The value on the horizontal axiz.
--
-- @tfield number b
-- The value on the vertical axiz.


--- Defines a point in a line.
--
-- @table chartnode
--
-- @tfield number x
-- The x position of the point.
--
-- @tfield number y
-- The y position of the point.
--
-- @tfield number xvalue
-- The x value of the point.
--
-- @tfield number yvalue
-- The y value of the point.
--
-- @tfield bool focus
-- If the point is under the mouse cursor.


local chart = { }
local thispath = select('1', ...):match(".+%.") or ""
local tween = require(thispath.."tween")

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

--- Clears all data points from the chart.
function chart:clear()

    self.datapoints = { }

end

--- Add data points to the chart.
-- Calling this multiple times adds new datasets to the chart.
--
-- @tparam pointdefinition points
-- The list of points in the dataset.
--
-- @tparam string name
-- The dataset name.
function chart:data(points, name)

    local xmin, ymin, xmax, ymax = math.huge, math.huge, 0, 0

    -- get the min and max values
    for _, p in ipairs(points) do
        if p.a < xmin then xmin = p.a end
        if p.b < ymin then ymin = p.b end
        if p.a > xmax then xmax = p.a end
        if p.b > ymax then ymax = p.b end
    end

    print(string.format("min/max = %d/%d", ymin, ymax))

    -- scale of the chart
    self.scaleX = self.width / (xmax - xmin)
    self.scaleY = self.height / (ymax - ymin)

    -- normalize values to the chart size
    local processed = { }

    for _, p in ipairs(points) do

        local sx = self.scaleX * (p.a - xmin)
        local sy = self.height - (self.scaleY * (p.b - ymin))

        local newpoint = {
            a=p.a,
            b=p.b,
            x=sx,
            y=self.height,
            focus=false
        }
        table.insert(processed, newpoint)

        newpoint.tween = tween.new(1, newpoint, { y=sy }, "outCubic")

        print(string.format("point %d/%d == %d/%d", p.a, p.b, sx, sy))

    end

    table.insert(self.datapoints, { name=name, points=processed } )

    print(string.format("scales: %.2f/%.2f", self.scaleX, self.scaleY))

    -- create labels
    self.labels = { }

    -- y axiz
    local yrange = ymax < 20 and math.ceil(ymax * .1) or 10
    for n=ymin, ymax, yrange do
        local sx = 0
        local sy = self.height - (self.scaleY * (n - ymin))
        table.insert(self.labels, { x=sx, y=sy, text=n, axiz="y" })
    end

    -- x axiz
    local xrange = xmax < 20 and math.ceil(xmax * .1) or 10
    for n=xmin, xmax, xrange do
        local sx = self.scaleX * (n - xmin)
        local sy = self.height
        table.insert(self.labels, { x=sx, y=sy, text=n, axiz="x" })
    end

end

--- Process mouse movement to allow focus on data points.
function chart:mousemoved(x, y, dx, dy, istouch)

    local radius = 10

    for _, data in ipairs(self.datapoints) do

        for _, p in ipairs(data.points) do

            local inX = x > (p.x - radius) and x < (p.x + radius)
            local inY = y > (p.y - radius) and y < (p.y + radius)

            p.focus = inX and inY

        end

    end

end

--function chart:mousepressed(x, y, button, istouch)

--end

--function chart:mousereleased(x, y, button, istouch)

--end

--- Process chart animations.
--
-- @tparam number dt
-- delta time as given by Love
function chart:update(dt)

    for _, data in ipairs(self.datapoints) do
        for _, point in ipairs(data.points) do
            point.tween:update(dt)
        end
    end

end

--- Draw the chart.
-- This calls the chart drawing functions that you should overwrite.
--
-- @see drawBorder
-- @see drawFill
-- @see drawGrid
-- @see drawJoin
-- @see drawLabels
-- @see drawLine
function chart:draw()

    -- save state
    love.graphics.push()

    self.drawGrid()
    self.drawBorder()
    self.drawLabels(self.labels)

    -- process data points
    for _, data in ipairs(self.datapoints) do

        -- fill area
        local fillpoints = { 0, self.height }
        for _, p in ipairs(data.points) do
            table.insert(fillpoints, p.x)
            table.insert(fillpoints, p.y)
        end
        table.insert(fillpoints, self.width)
        table.insert(fillpoints, self.height)
        -- triangulate the points to avoid concave polygons
        local triangles = love.math.triangulate(fillpoints)
        self.drawFill(data.name, triangles)

        -- draw points
        for n, point in ipairs(data.points) do

            -- skip first point as they come in pairs
            if n > 1 then
                self.drawLine(data.name,
                    {
                        xvalue=data.points[n-1].a,
                        yvalue=data.points[n-1].b,
                        x=data.points[n-1].x,
                        y=data.points[n-1].y,
                        focus=data.points[n-1].focus
                    },
                    {
                        xvalue=data.points[n].a,
                        yvalue=data.points[n].b,
                        x=data.points[n].x,
                        y=data.points[n].y,
                        focus=data.points[n].focus
                    }
                )
            end

        end

    end

    -- draw joins (track focused item and draw it last)
    local focused = nil
    for _, data in ipairs(self.datapoints) do

        for n, point in ipairs(data.points) do

            if (focused) or (not point.focus) then
                self.drawJoin(data.name,
                    math.floor(point.x),
                    math.floor(point.y),
                    point.a,
                    point.b,
                    false
                )
            else
                focused = { name=data.name, point=point }
            end

        end

    end
    if focused then
        self.drawJoin(focused.name,
            math.floor(focused.point.x),
            math.floor(focused.point.y),
            focused.point.a,
            focused.point.b,
            focused.point.focus
        )
    end

    -- restore state
    love.graphics.pop()

end

--- Callback to draw the grid.
-- You must overwrite this function to draw your own.
function chart.drawGrid()

    love.graphics.setColor(color.base3)

    for x=0, self.width, 20 do
        love.graphics.line(x, 0, x, self.height)
    end
    for y=0, self.height, 20 do
        love.graphics.line(0, y, self.width, y)
    end

end

--- Callback to draw the axiz label.s
-- You must overwrite this function to draw your own.
--
-- @tparam labeldefinition labels
-- A table of @{labeldefinition} items that you must draw.
function chart.drawLabels(labels)

    --- Defines label data for you to draw.
    -- @table labeldefinition
    --
    -- @tfield string text
    -- The label text.
    --
    -- @tfield number x
    -- The x position of the label.
    --
    -- @tfield number y
    -- The y position of the label.

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

--- Callback to draw the border.
-- You must overwrite this function to draw your own.
function chart.drawBorder()

    love.graphics.setColor(color.base1)
    love.graphics.rectangle("line", 0, 0, self.width, self.height)

end

--- Callback to draw the lines.
-- You must overwrite this function to draw your own.
--
-- @tparam string dataset
-- The name of the dataset currently drawn.
--
-- @tparam chartnode point1
-- The first point in the line segment to draw.
--
-- @tparam chartnode point2
-- The second point in the line segment to draw.
function chart.drawLine(dataset, point1, point2)

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

--- Callback to draw the joins between lines.
-- You must overwrite this function to draw your own.
-- TODO: change to use chartnode parameters.
function chart.drawJoin(dataset, x, y, value1, value2, focused)

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

--- Callback to fill the area under the lines.
-- You must overwrite this function to draw your own.
--
-- @tparam string dataset
-- The name of the dataset currently drawn.
--
-- @tparam table triangles
-- The collection of points to fill.
-- To avoid concave polygons, the chart points are triangulated into
-- this set of points that must be iterated over.
function chart.drawFill(dataset, triangles)

    if dataset == "dataset 1" then
        love.graphics.setColor(211, 54, 130, 64)
    else
        love.graphics.setColor(38, 139, 210, 64)
    end

    for _, triangle in ipairs(triangles) do
        love.graphics.polygon("fill", triangle)
    end

end

return function (width, height)

    local instance = { }
    setmetatable(instance, {__index = chart } )
    instance.datapoints = { }
    instance.width = width
    instance.height = height
    return instance

end
