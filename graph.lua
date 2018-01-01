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

--local module = { }
local graph = { }
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

function graph:clear()

    self.datapoints = { }

end

function graph:data(points, name)

    local xmin, ymin, xmax, ymax = math.huge, math.huge, 0, 0

    -- get the min and max values
    for _, p in ipairs(points) do
        if p.x < xmin then xmin = p.x end
        if p.y < ymin then ymin = p.y end
        if p.x > xmax then xmax = p.x end
        if p.y > ymax then ymax = p.y end
    end

    print(string.format("min/max = %d/%d", ymin, ymax))

    -- scale of the chart
    self.scaleX = self.width / (xmax - xmin)
    self.scaleY = self.height / (ymax - ymin)

    -- normalize values to the graph size
    local processed = { }

    for _, p in ipairs(points) do

        local sx = self.scaleX * (p.x - xmin)
        local sy = self.height - (self.scaleY * (p.y - ymin))

        local newpoint = {
            x=p.x,
            y=p.y,
            screenx=sx,
            screeny=sy,
            tweeny=self.height,
            focus=false
        }
        table.insert(processed, newpoint)

        newpoint.tween = tween.new(1, newpoint, { tweeny=sy }, "outCubic")

        print(string.format("point %d/%d == %d/%d", p.x, p.y, sx, sy))

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

function graph:mousemoved(x, y, dx, dy, istouch)

    local radius = 10

    for _, data in ipairs(self.datapoints) do

        for _, p in ipairs(data.points) do

            local inX = x > (p.screenx - radius) and x < (p.screenx + radius)
            local inY = y > (p.screeny - radius) and y < (p.screeny + radius)

            p.focus = inX and inY

        end

    end

end

function graph:mousepressed(x, y, button, istouch)

end

function graph:mousereleased(x, y, button, istouch)

end

function graph:update(dt)

    for _, data in ipairs(self.datapoints) do
        for _, point in ipairs(data.points) do
            point.tween:update(dt)
        end
    end

end

function graph:draw()

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
            table.insert(fillpoints, p.screenx)
            table.insert(fillpoints, p.tweeny)
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
                        xvalue=data.points[n-1].x,
                        yvalue=data.points[n-1].y,
                        x=data.points[n-1].screenx,
                        y=data.points[n-1].tweeny,
                        focus=data.points[n-1].focus
                    },
                    {
                        xvalue=data.points[n].x,
                        yvalue=data.points[n].y,
                        x=data.points[n].screenx,
                        y=data.points[n].tweeny,
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
                    math.floor(point.screenx),
                    math.floor(point.tweeny),
                    point.x,
                    point.y,
                    false
                )
            else
                focused = { name=data.name, point=point }
            end

        end

    end
    if focused then
        self.drawJoin(focused.name,
            math.floor(focused.point.screenx),
            math.floor(focused.point.tweeny),
            focused.point.x,
            focused.point.y,
            focused.point.focus
        )
    end

    -- restore state
    love.graphics.pop()

end

function graph.drawGrid()

    --love.graphics.setColor(color.base3)

    --for x=0, self.width, 20 do
        --love.graphics.line(x, 0, x, self.height)
    --end
    --for y=0, self.height, 20 do
        --love.graphics.line(0, y, self.width, y)
    --end

end

function graph.drawLabels(labels)

    --love.graphics.setColor(color.green)

    --for _, label in ipairs(labels) do

        ---- draw label point
        --love.graphics.circle("line", label.x, label.y, 3)

        ---- print label text
        --if label.axiz == "x" then
            --love.graphics.print(label.text, label.x, label.y + 12)
        --else
            --love.graphics.print(label.text, label.x - 24, label.y - 6)
        --end

    --end

end

function graph.drawBorder()

    --love.graphics.setColor(color.base1)
    --love.graphics.rectangle("line", 0, 0, self.width, self.height)

end

function graph.drawLine(dataset, point1, point2)

    ---- line
    --if dataset == "dataset 1" then
        --love.graphics.setColor(color.magenta)
    --else
        --love.graphics.setColor(color.blue)
    --end

    --love.graphics.setLineWidth(4)
    --love.graphics.line(point1.x, point1.y, point2.x, point2.y)
    --love.graphics.setLineWidth(1)

end

function graph.drawJoin(dataset, x, y, value1, value2, focused)

    --if dataset == "dataset 1" then
        --love.graphics.setColor(color.magenta)
    --else
        --love.graphics.setColor(color.blue)
    --end

    --if focused then
        --love.graphics.setColor(color.white)
        --love.graphics.circle("fill", x, y, 6)
        ---- tooltip
        --love.graphics.setColor(0, 0, 0)
        --love.graphics.rectangle("fill", x + 20, y - 4, 80, 40)
        --love.graphics.setColor(color.white)
        --love.graphics.print(string.format("point: %d\nvalue: %d", value1, value2), x + 24, y)
    --else
        --love.graphics.circle("fill", x, y, 6)
    --end

end

function graph.drawFill(dataset, triangles)

    --if dataset == "dataset 1" then
        --love.graphics.setColor(211, 54, 130, 64)
    --else
        --love.graphics.setColor(38, 139, 210, 64)
    --end

    --for _, triangle in ipairs(triangles) do
        --love.graphics.polygon("fill", triangle)
    --end

end

return function (width, height)

    local instance = { }
    setmetatable(instance, {__index = graph} )
    instance.datapoints = { }
    instance.width = width
    instance.height = height
    return instance

end
