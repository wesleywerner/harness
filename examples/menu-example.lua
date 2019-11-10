--[[
   Copyright 2018 wesley werner <wesley.werner@gmail.com>

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

local menu = require ("harness.menu")

local openAction = function ()
	print ("open file action clicked")
end

local zoomAction = function (item)
	print ("zoom " .. item .. " clicked")
end

function love.load ()

	local nop = function(title)
		print ("action " .. title)
	end

	mymenu = {
		{
			["title"] = "file",
			["items"] = {
				{
					["title"] = "options",
					["items"] = {
						{ ["title"] = "file A", ["callback"] = nop },
						{ ["title"] = "file B", ["callback"] = nop },
						{ ["title"] = "file C", ["callback"] = nop },
					}
				},
				{ ["title"] = "open", ["callback"] = nop },
				{ ["title"] = "close", ["callback"] = nop },
				{ ["title"] = "save", ["callback"] = nop },
				{ ["title"] = "exit", ["callback"] = nop },
			}
		},
		{
			["title"] = "view",
			["items"] = {
				{
					["title"] = "zoom",
					["items"] = {
						{ ["title"] = "50%", ["callback"] = nop },
						{ ["title"] = "100%", ["callback"] = nop },
						{ ["title"] = "200%", ["callback"] = nop },
					}
				},
			}
		}
	}

	love.graphics.setFont (love.graphics.newFont (20))

	menu:set (mymenu)

end

function love.update (dt)

end

function love.keypressed (key)

	love.event.quit ()

end

function love.draw ()

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Right click to open the menu.")
	menu:draw ()

end

function love.mousepressed (x, y, button, istouch, presses)

	-- left clicking is sent to the menu, and if the menu is
	-- visible and x,y is on a menu item, we get a truthy return result.
	-- right clicking shows the menu.
	if button == 1 then
		if menu:mousepressed (x, y, button, istouch, presses) then
			-- menu handled this event, exit this function
			return
		end
	elseif button == 2 then
		-- show the menu
		menu:show (x, y)
		return
	end

	-- your usual mouse code goes here

end

function love.mousereleased (x, y, button, istouch, presses)

end

function love.mousemoved (x, y, dx, dy, istouch)

end

function love.wheelmoved (x, y)

end
