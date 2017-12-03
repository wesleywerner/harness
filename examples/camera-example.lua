--[[
   camera-example.lua

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

local camera = require("harness.camera")
local scale = 5
local mousePositionInFrame = nil

function love.load()

    love.graphics.setDefaultFilter( "nearest", "nearest", 1 )

    background = love.graphics.newImage( "swamp-300px.png" )

    -- camera world size is our image size
    camera:worldSize(background:getWidth() * scale, background:getHeight() * scale)

    -- frame is what we see at any one time
    camera:frame(20, 60, 400, 400)

    love.graphics.setFont( love.graphics.newFont( 10 ) )

end

function love.update(dt)

    camera:update(dt)

end

function love.draw()

    -- pose the camera. everything drawn now is clipped and framed.
    camera:pose()

    -- scale up
    love.graphics.scale(scale, scale)

    -- draw the image
    love.graphics.draw(background)

    -- print image credits
    love.graphics.printf("Frog On Bluish Pond by schugschug (openclipart.org/detail/117031/frog-on-bluish-pond)", 0, 0, 400, "center")

    -- relax the camera. drawing returns to normal
    camera:relax()

    -- draw a box around the camera frame
    love.graphics.rectangle("line", camera.frameLeft, camera.frameTop,
    camera.frameWidth, camera.frameHeight)

    -- print some help text
    love.graphics.print("use arrow keys to scroll, a/d to switch the frame position")

    if mousePositionInFrame then
        love.graphics.print(string.format("point in frame: %d, %d", mousePositionInFrame.x, mousePositionInFrame.y), 0, 10)
    end

end

function love.keypressed(key)

    if key == "escape" then
        love.event.quit()
    elseif key == "left" then
        camera:moveBy(100, 0)
    elseif key == "right" then
        camera:moveBy(-100, 0)
    elseif key == "up" then
        camera:moveBy(0, 100)
    elseif key == "down" then
        camera:moveBy(0, -100)
    elseif key == "a" then
        camera:frame(20, camera.frameTop, camera.frameWidth, camera.frameHeight)
    elseif key == "d" then
        camera:frame(300, camera.frameTop, camera.frameWidth, camera.frameHeight)
    end

end

function love.mousemoved( x, y, dx, dy, istouch )

    x, y = camera:pointToFrame( x, y )
    if x and y then
        mousePositionInFrame = { x = x, y = y }
    else
        mousePositionInFrame = nil
    end

end
