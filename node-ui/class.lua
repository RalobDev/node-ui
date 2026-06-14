--
-- Class (based on classic)
--
-- Original library: classic
-- Author: rxi
-- Copyright (c) 2014 rxi
--
-- Modifications and extensions:
-- Copyright (c) 2026 Rafael Lopes
--
-- Licensed under the MIT License
-- See LICENSE for details
--

--- @class Class
--- @field private _id string Unique class id.
--- @field private _inheritances string[] Parent class IDs in the inheritance tree
local Class = {}
Class.__index = Class
Class._id = "Class"

--#region Public Methods

--- Creates a new instance of Class.
--- @nodiscard
--- @return table
function Class:new()
    local obj = setmetatable({}, self)
    return obj
end

--- Extends the class.
--- @nodiscard
--- @generic T : Class
--- @param self T
--- @param id string Unique class id.
--- @return T
function Class:extend(id)
    local cls = {}
    for k, v in pairs(self) do
        if k:find("__") == 1 then
            cls[k] = v
        end
    end

    cls.__index = cls
    cls._id = id

    local inheritances = {}
    --- @diagnostic disable-next-line: undefined-field
    local parent_inheritances = self._inheritances

    if parent_inheritances then
        for _, inheritance in ipairs(parent_inheritances) do
            inheritances[#inheritances + 1] = inheritance
        end
    end

    --- @diagnostic disable-next-line: undefined-field
    inheritances[#inheritances + 1] = self._id
    cls._inheritances = inheritances

    setmetatable(cls, self)
    return cls
end

--- Implements the methods of a mixin.
--- @param ... table
function Class:implement(...)
    for _, cls in pairs({ ... }) do
        for k, v in pairs(cls) do
            if self[k] == nil and type(v) == "function" then
                self[k] = v
            end
        end
    end
end

--- Returns whether the class id matches id.
--- @nodiscard
--- @param id string Unique class id.
--- @return boolean
function Class:is(id)
    if self._id == id then
        return true
    end

    for _, inheritance in ipairs(self._inheritances) do
        if inheritance == id then
            return true
        end
    end

    return false
end

--#endregion

return Class
