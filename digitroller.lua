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

local module = {}
local tween = require("harness.tween")

-- provides the digit roller instance functions
local digit_mt = {}

-- provides the digit roller collection functions
local manager_mt = {}

-- create a new instance of a digit roller collection.
function module:new()

  local manager = {}
  manager.collection = {}
  setmetatable(manager, { __index = manager_mt })
  return manager

end

function manager_mt:add(args)

  if not args.subject then
    error("A digit roller must have a subject, a table to watch")
  end

  if not args.target then
    error("A digit roller must have a target, the property on the subject to watch")
  end

  if type(args.subject[args.target]) ~= "number" then
    error("A digit roller target must be a number value")
  end

  local instance = {}

  -- copy arguments to the instance
  for k, v in pairs(args) do
    instance[k] = v
  end

  -- set defaults
  instance.top = instance.top or 0
  instance.left = instance.left or 0
  instance.limit = instance.limit or 200
  instance.duration = instance.duration or 3
  instance.suffix = instance.suffix or ""
  instance.align = instance.align or "left"
  instance.easing = instance.easing or "outCubic"
  instance.value = instance.subject[instance.target]

  -- apply instance functions
  setmetatable(instance, { __index = digit_mt })

  -- apply first time tweening
  instance:applytween()

  -- collect this label
  table.insert(self.collection, instance)

  return instance

end

function manager_mt:update(dt)
  for _, label in ipairs(self.collection) do
    label.tween:update(dt)
    if label.value ~= label.subject[label.target] then
      label:applytween()
    end
  end
end

function manager_mt:draw()
  for _, label in ipairs(self.collection) do
    love.graphics.printf(
      string.format("%d %s", label.value, label.suffix),
      label.left, label.top, label.limit, label.align)
  end
end

function manager_mt:get(target)

end

function digit_mt:applytween()
  self.tween = tween.new(self.duration, self,
    { value=self.subject[self.target] }, self.easing)
end

return module
