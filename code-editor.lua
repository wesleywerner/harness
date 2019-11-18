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

--- Provides a code editor.
--
-- @author Wesley Werner
-- @license GPL v3
-- @module code-editor

local utf8 = require("utf8")
local dbg = require("debugger")
dbg.auto_where = 3
local editor = { }

--- Splits a block of text into lines by
-- either win32 or POSIX line ending.
-- @function split_lines
--
-- @param str string
-- @return table of lines
local function split_lines (str)
   local t = {}
   local function helper(line)
      table.insert(t, line)
      return ""
   end
   helper((str:gsub("(.-)\r?\n", helper)))
   -- TODO ensure each line ends with a space
   return t
end

--- A table of options.
-- @table options
-- @field columns number of visible characters horizontally.
-- @field rows number of visible characters vertically.
-- @field buffer string of default text buffer.

--- todo
function editor.load (self, options)
    -- store options
    self.options = options or { }
    -- init variables
    self.cursor_column = 1
    self.cursor_row = 1
    self.cursor_x = 0
    self.cursor_y = 0
    self.blink_dt = 0
    self.blink_on = true
    -- (the line number displayed in the top row)
    self.top_line_number = 1
    -- process the buffer
    self.buffer = split_lines (self.options.buffer or "")
    -- load font resource
    self:load_font()
    -- create the buffer canvas
    self:resize(self.options.columns, self.options.rows)
    -- calculate cursor position
    self:move(0, 0)
end

function editor.load_font (self, size, hinting)
    -- run a sanity check
    size = size or 18
    hinting = hinting or "mono"
    assert(type(size) == "number")
    assert(type(hinting) == "string")
    -- load a mono-spaced font
    self.font = love.graphics.newFont("FreeMono.ttf", size, hinting)
    -- measure the width of a character
    self.box_width = self.font:getWidth("=")
    self.box_height = self.font:getHeight("=")
end

function editor.draw (self)
    -- render the cursor
    if self.blink_on then
        love.graphics.setColor(1, 1, 0, .7)
        love.graphics.rectangle("fill", self.cursor_x, self.cursor_y, self.box_width, self.box_height)
    else
        love.graphics.setColor(1, 1, 0, .4)
        love.graphics.rectangle("fill", self.cursor_x, self.cursor_y, self.box_width, self.box_height)
    end
    -- render the canvas
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.canvas)
end

function editor.update (self, dt)
    self.blink_dt = self.blink_dt + dt
    if self.blink_dt > 1 then
        self.blink_on = not self.blink_on
        self.blink_dt = 0
    end
end

function editor.keypressed (self, key, scancode, isrepeat)
    local control_down = love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")
    local shift_down = love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")
    local alt_down = love.keyboard.isDown("lalt") or love.keyboard.isDown("ralt")
    -- print("pressed " .. key .. (control_down and " with control" or ""))

    -- cursor navigation
    if key == "left" and not control_down then
        self:move(-1, 0)
    elseif key == "right" and not control_down then
        self:move(1, 0)
    elseif key == "left" and control_down then
        -- word jump
        self:move(self:jumps_to_prev_space(), 0)
    elseif key == "right" and control_down then
        -- word jump
        self:move(self:jumps_to_next_space(), 0)
    elseif key == "up" then
        self:move(0, -1)
    elseif key == "down" then
        self:move(0, 1)
    elseif key == "home" then
        self:move(-self.options.columns, 0)
    elseif key == "end" then
        self:move(self.options.columns, 0)
    end

    if key == "backspace" then
        self:delete_character(true)
    elseif key == "delete" then
        self:delete_character(false)
    end

end

function editor.delete_character(self, advance_cursor)
    -- measure the line
    local buffer_line = self:get_line()
    local line_length = utf8.len(buffer_line)
    -- backspace if not on the first column
    local can_backspace = self.cursor_column > 1
    -- delete if not on the last column
    local can_delete = self.cursor_column < line_length
    -- test for operation
    if not can_backspace and not can_delete then
        return
    end
    -- get the cursor offset
    local cursor_offset = utf8.offset(buffer_line, self.cursor_column)
    if cursor_offset then
        -- cut the character at the cursor
        if advance_cursor then
            if can_backspace then
                buffer_line = string.sub(buffer_line, 1, cursor_offset-2) .. string.sub(buffer_line, cursor_offset, -1)
                self.cursor_column = self.cursor_column - 1
            end
        else
            if can_delete then
                buffer_line = string.sub(buffer_line, 1, cursor_offset-1) .. string.sub(buffer_line, cursor_offset+1, -1)
            end
        end
        -- update the buffer
        self:set_line(buffer_line)
        -- calculate cursor position
        self:move(0, 0)
        self:render_buffer()
    end
end

function editor.textinput(self, text)
    local input = split_lines (text)
    local buffer_line = self:get_line()
    for no, input_line in ipairs(input) do
        if input_line then
            -- if the buffer is "hello*world" (* denotes cursor pos)
            -- get the cursor offset
            local cursor_offset = utf8.offset(buffer_line, self.cursor_column)
            if cursor_offset then
                -- insert input line into buffer line
                buffer_line = string.sub(buffer_line, 1, cursor_offset-1) .. input_line .. string.sub(buffer_line, cursor_offset, -1)
                -- update the buffer
                self:set_line(buffer_line)
                -- advance the cursor to the length of the input
                self.cursor_column = self.cursor_column + utf8.len(input_line)
                -- shift down a row (for multi-line input) - TODO
                --self.cursor_column = 1
                --self.cursor_row = self.cursor_row + 1
                --buffer_line = self:get_line()
            end
        end
    end
    -- calculate cursor position
    self:move(0, 0)
    self:render_buffer()
end

function editor.mousemoved (self, x, y, dx, dy, istouch)

end

function editor.mousepressed (self, x, y, button, istouch, presses)

end

function editor.mousereleased (self, x, y, button, istouch, presses)

end

--- Returns the number of characters to reach a " " to the right of the cursor.
function editor.jumps_to_next_space (self)
    local line = self:get_line()
    local line_length = line:len()
    local start = self.cursor_column
    local match = 0
    local is_spaced = 0
    if line then
        for n = start, line_length do
            match = n
            local letter = line:sub(n, n)
            if letter == " " then
                is_spaced = 1
                break
            end
        end
    end
    return match - self.cursor_column + is_spaced
end

function editor.jumps_to_prev_space (self)
    local line = self:get_line()
    local start = self.cursor_column-2
    local match = 0
    local is_spaced = 0
    if line then
        for n = start, 1, -1 do
            match = n
            local letter = line:sub(n, n)
            if letter == " " then
                is_spaced = 1
                break
            end
        end
    end
    return match - self.cursor_column + is_spaced
end

function editor.get_line(self)
    return self.buffer[self.cursor_row]
end

function editor.set_line(self, line)
    self.buffer[self.cursor_row] = line
    -- TODO Invalidate the canvas at self.cursor_row
end

function editor.move (self, column_delta, row_delta)

    local cc = self.cursor_column
    local cr = self.cursor_row
    local line = self.buffer[self.cursor_row]
    local line_length = line:len()

    -- stop moving at line's end
    local max_column = math.min(self.options.columns, line_length)
    local max_row = math.min(self.options.rows, #self.buffer)

    self.cursor_column = math.min(max_column, math.max(1, cc + column_delta))
    self.cursor_row = math.min(max_row, math.max(1, cr + row_delta))

    -- subtract to zero-based coordinates
    self.cursor_x = (self.cursor_column-1) * self.box_width
    self.cursor_y = (self.cursor_row-1) * self.box_height

    -- recalculate line max column if user changed rows
    if row_delta ~= 0 then
        self:move(0, 0)
    end

end

function editor.render_buffer (self)
    -- set the editor font and canvas
    local stored_font = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.setCanvas(self.canvas)
    -- clear fill
    love.graphics.setColor(0, 0, 1)
    --love.graphics.rectangle("fill", 0, 0)
    love.graphics.clear()
    -- set font color
    love.graphics.setColor(1, 1, 0)
    -- print buffer lines
    local print_y = 0
    local first_row = self.top_line_number
    local last_row = self.top_line_number + self.options.rows
    for current_row = first_row, last_row do
        local line = self.buffer[current_row]
        if line then
            love.graphics.print(line, 0, print_y)
            print_y = print_y + self.box_height
        end
    end
    -- restore font and canvas
    love.graphics.setFont(stored_font)
    love.graphics.setCanvas()
end

function editor.resize (self, columns, rows)
    self.options.columns = columns or 80
    self.options.rows = rows or 40
    self.canvas = love.graphics.newCanvas(width, height)
    self:render_buffer()
end

return editor
