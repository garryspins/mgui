
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

---Swaps two values in the table by their values
---@param a any
---@param b any
---@return mgui.LinkedTable
function LT:Swap(a, b)
    return self:SwapByIndex(
        self.ValueKeys[a],
        self.ValueKeys[b]
    )
end

---Swaps two values in the table by their indices
---@param a number
---@param b number
---@return mgui.LinkedTable
function LT:SwapByIndex(a, b)
    if not self.IndexKeys[a] then return self end
    if not self.IndexKeys[b] then return self end

    local tmp = self.IndexKeys[b]

    self.IndexKeys[b] = self.IndexKeys[a]
    self.IndexKeys[a] = tmp

    self.ValueKeys[self.IndexKeys[a]] = a
    self.ValueKeys[self.IndexKeys[b]] = b

    return self
end

---Returns an iterator for the values of the linkedtable
---Identical to `ipairs(self.IndexKeys)`
---@param last number Initial value, should be left alone
---@return function
function LT:Iter(last)
    return next, self.IndexKeys, last
end

-- local lt = mgui.LinkedTable()
--     :Add("some1")
--     :Add("some2")
--     :Add("some3")
--     :Add("some4")
--     :Add("some5")

-- for k, v in lt:Iter() do
--     print(k, v) 
-- end

-- lt:SwapByIndex(1, 5)
-- lt:Swap("some1", "some5")

-- print("[IndexKeys]")
-- mgui.PrintTable(lt.IndexKeys)
-- print("[ValueKeys]")
-- mgui.PrintTable(lt.ValueKeys)
