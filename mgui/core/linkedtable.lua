
--- A table that associatively stores all its data, allowing easy insertion and removal
---@class mgui.LinkedTable
---@field IndexKeys any[] Data stored by index key
---@field ValueKeys { [any]: any } Data stored by value key
local LT = {}
LT.__index = LT
mgui.MetaRegistry.LINKEDTABLE = LT

---@private
---@return mgui.LinkedTable self
function LT:Init()
    self.IndexKeys = {}
    self.ValueKeys = {}

    return self
end

---Adds any value to this table
---@param value any
---@return mgui.LinkedTable self
function LT:Add(value)
    table.insert(self.IndexKeys, value)
    self.ValueKeys[value] = #self.IndexKeys

    return self
end

---Removes a value from this table, by the value itself
function LT:RemoveByValue(value)
    local k = self.ValueKeys[value]
    if not k then return end

    self:RemoveByIndex(k)
end

---Removes a value from this table by its index
function LT:RemoveByIndex(index)
    local value = self.IndexKeys[index]
    local len = #self.IndexKeys
    for i = index + 1, len do
        self.ValueKeys[self.IndexKeys[i]] = i - 1
        self.IndexKeys[i - 1] = self.IndexKeys[i]
    end

    self.IndexKeys[len] = nil
    self.ValueKeys[value] = nil
end