
---Creates Set/Get/OnSet functions on the given metatable
---@param t table Metatable to put the functions on
---@param name string Name and Key of the functions create
---@param default any Any default
function mgui.Accessor(t, name, default, on)
    t["Set" .. name] = function(s, ...)
        if s["OnSet" .. name] then
            s["OnSet" .. name](s, ...)
        end

        s[name] = ...
        return s
    end

    t["Get" .. name] = function(s)
        if s[name] == nil then return default end
        return s[name]
    end
end

---Identical to mgui.Accessor, except that it sets a series of accessors
---@param t table Metatable to put the functions on
---@param name string Name of the function
---@param ... string Keynames of the accessors to set through this
function mgui.AccessorN(t, name, ...)
    local keys = {...}
    t["Set" .. name] = function(s, ...)
        for k, v in pairs({...}) do
            s["Set" .. keys[k]](s, v)
        end

        return s
    end

    t["Get" .. name] = function(s)
        local out = {}
        for k, v in pairs(keys) do
            out[k] = s["Get" .. v](s)
        end
        return unpack(out)
    end
end

---Identical to mgui.Accessor, except that this creates an alias of another accessor
---@param t table Metatable to put the functions on
---@param alias string Keyname of the new alias functions
---@param of string Keyname of the original source functions
function mgui.AccessorAlias(t, alias, of)
    t["Set" .. alias] = t["Set" .. of]
    t["Get" .. alias] = t["Get" .. of]
end

---Checks if any value is not a NULL panel
---@param any any Value to check
---@return boolean
function mgui.Valid(any)
    if not any then return false end
    if type(any) ~= "table" then return true end
    return not any.IsNull
end

---Internal debugging function to print a table
---@private
---@param t table
---@param indent string?
---@param done table?
function mgui.PrintTable(t, indent, done)
    indent = indent or ""
    done = done or {}

    if done[t] then
        print(indent .. "<done " .. tostring(t) .. ">")
        return
    end
    done[t] = true

    for k, v in pairs(t) do
        if type(v) == "table" then
            print(indent .. "[" .. tostring(k) .. "] = {")
            mgui.PrintTable(v, indent .. "  ", done)
            print(indent .. "}")
        else
            print(indent .. "[" .. tostring(k) .. "] = " .. tostring(v))
        end
    end
end

---Creates a new Linked Table
---@return mgui.LinkedTable
function mgui.LinkedTable()
    return setmetatable({}, mgui.MetaRegistry.LINKEDTABLE)
        :Init()
end

---Asserts that a condition is truey, for internal erroring
---@param cond any
---@param msg string
---@return any
function mgui.Assert(cond, msg)
    return assert(cond, "[mgui] " .. msg)
end

---Panics, for internal erroring
---@param msg string
function mgui.Error(msg)
    error(msg)
end

---Copys the input table to the output, not a deep copy
---@param t table
---@return table
function mgui.CopyTable(t)
    local new = {}
    for k, v in pairs(t) do
        new[k] = v
    end

    return new
end

---Clamps a number between two values
---@param val number
---@param min number
---@param max number
---@return number
function mgui.Clamp(val, min, max)
    return math.max(math.min(val, max), min)
end