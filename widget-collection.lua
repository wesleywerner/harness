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

--- Provides collective management of buttons.
-- The collection handles batch event updating and focus tracking.
--
-- @author Wesley Werner
-- @license GPL v3
-- @module widget-collection

local module = { controls={} }
local thispath = select('1', ...):match(".+%.") or ""
local buttonModule = require(thispath.."button")

--- Clears the collection.
function module:clear()

    self.controls = { }
    self.focusedKey = nil

end

--- Creates an ordered list of keys mapped to positions.
-- This function is used internally by the collection.
local function mapkeys()

    -- map control keys to position for sorting
    module.keymap = { }
    for key, v in pairs(module.controls) do
        table.insert(module.keymap, {key=key, left=v.left, top=v.top})
    end

    -- order top first, then left second
    table.sort(module.keymap, function(a, b)
        return (a.top == b.top) and (a.left < b.left) or (a.top < b.top)
        end)

end

--- Moves focus to the first element.
-- This function is used internally by the collection.
local function focusFirst()

    module.focusedKey = 1

end

--- Moves focus to the next element.
-- This function is used internally by the collection.
local function focusNext()

    module.focusedKey = module.focusedKey + 1
    if module.focusedKey > #module.keymap then
        module.focusedKey = 1
    end

    -- apply focus
    for key, control in pairs(module.controls) do
        control.focused = (key == module.keymap[module.focusedKey].key)
    end

end

--- Moves focus to the previous element.
-- This function is used internally by the collection.
local function focusPrev()

    module.focusedKey = module.focusedKey - 1
    if module.focusedKey < 1 then
        module.focusedKey = #module.keymap
    end

    -- apply focus
    for key, control in pairs(module.controls) do
        control.focused = (key == module.keymap[module.focusedKey].key)
    end

end

--- Moves focus to the element with a given key.
-- This function is used internally by the collection.
--
-- @tparam string key
local function focusByKey(key)

    for i, map in ipairs(module.keymap) do
        if map.key == key then
            module.focusedKey = i
        end
    end

end

--- Add a button to the collection.
--
-- @tparam string key
-- The key of the button to add to the collection.
--
-- @tparam table parameters
-- The button parameters to pass to the button constructor.
--
-- @treturn button.instance
-- The created button element.
--
-- @see get
function module:button(key, parameters)

    self.controls[key] = buttonModule:new(parameters)
    mapkeys()
    focusFirst()
    return self.controls[key]

end


--- Get the element in the collection that matches a key.
--
-- @tparam string key
-- The key of the element to find.
--
-- @treturn button.instance
-- The element instance.
function module:get(key)

    return self.controls[key]

end

--- Process key presses to allow navigation with the TAB key
-- and selection with the RETURN key.
function module:keypressed(key)

    if key == "tab" then
        local shift = love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")
        if shift then
            focusPrev()
        else
            focusNext()
        end
    elseif key == "return" or key == "kpenter" then
        local control = self.controls[self.keymap[self.focusedKey].key]
        if type(control.callback) == "function" then
            control.callback(control)
        end
    end

end

--- Process click/touch movement on all elements in the collection.
function module:mousemoved(x, y, dx, dy, istouch)

    for key, control in pairs(self.controls) do
        control:mousemoved(x, y, dx, dy, istouch)
    end

end

--- Process click/touch presses on all elements in the collection.
function module:mousepressed(x, y, button, istouch)

    for key, control in pairs(self.controls) do
        control:mousepressed(x, y, button, istouch)
    end

end

--- Process click/touch releases on all elements in the collection.
function module:mousereleased(x, y, button, istouch)

    for key, control in pairs(self.controls) do
        control:mousereleased(x, y, button, istouch)
        -- move focus to touched control
        if control.focused then
            focusByKey(key)
        end
    end

end

--- Process updates on all elements in the collection.
--
-- @tparam number dt
-- delta time as given by Love
function module:update(dt)

    for key, control in pairs(self.controls) do
        control:update(dt)
    end

end

--- Process drawing on all elements in the collection.
function module:draw()

    -- save state
    love.graphics.push()

    for key, control in pairs(self.controls) do
        control:draw()
    end

    -- restore state
    love.graphics.pop()

end

return module
