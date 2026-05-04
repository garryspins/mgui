
local registry = registry or {}

---Registry of `mgui.Register`ed panels
mgui.PanelRegistry = registry

---Creates a new controller, only call this if you arent using `mgui.inject`, or are trying to use multiple (which is inadvisable at best)
---@return mgui.Controller
function mgui.NewController()
    return setmetatable({}, mgui.MetaRegistry.CONTROLLER)
        :Init()
        :SetWidth(love.graphics.getWidth())
        :SetHeight(love.graphics.getHeight())
end

local function baseget(base, key)
    if not base then return end

    local meta = mgui.PanelRegistry[base]
    if meta.meta[key] then
        return meta.meta[key]
    end

    return baseget(meta.base, key)    
end

---Registers a new panel type for creation with `mgui.Create`
---@param name string Name of the panel type
---@param metatable table Metatable of the type 
---@param base string Name of the base of this type, defaults to `Panel`
---@return table metatable The input metatable
function mgui.Register(name, t, base)
    mgui.Assert(type(name) == "string", "The name parameter to mgui.Register must be a string!")

    local meta = {
        __index = function(s, k)
            if rawget(s, "IsNull") then
                return mgui.Error("Attempting to index a NULL Panel!")
            end

            if base == false then
                return rawget(s, k)
            end

            local meta = mgui.PanelRegistry[name]
            if meta and (meta.meta[k] ~= nil) then return meta.meta[k] end

            local bget = baseget(base or "Panel", k)
            if bget ~= nil then return bget end

            return rawget(s, k)
        end,
        __tostring = function(s)
            if rawget(s, "IsNull") then
                return "<Panel NULL (" .. (s.DebugName or name) .. ")>"
            end
            return "<Panel " .. (s.DebugName or name) .. ">"
        end,

        name = name,
        meta = t,
        base = base == nil and "Panel" or base,
    }
    t.__meta = meta
    
    function t:super(key)
        return baseget(base or "Panel", key)
    end

    mgui.PanelRegistry[name] = meta
    return t
end

local function callinitializers(meta, ...)
    local base = mgui.PanelRegistry[meta.base or false]
    if base then
        callinitializers(base, ...)
    end

    if meta.meta.Init then
        meta.meta.Init(...)
    end
end

---Creates a new panel object, and attaches it to the given parent
---@param name string Name of the type of panel to create
---@param parent mgui.Panel? Parent panel to attach this to, otherwise gets sent to the controller
---@param controller mgui.Controller? Controller to attach this to, defaults to `mgui.ActiveController`
---@return mgui.Panel
function mgui.Create(name, parent, controller)
    local kind = mgui.Assert(mgui.PanelRegistry[name], "Attempting to create a non-existent Panel type ("  .. name .. ")")
    controller = mgui.Assert(controller or mgui.ActiveController, "Attempting to call mgui.Create without a Controller")

    local panel = setmetatable({}, mgui.PanelRegistry[name])

    panel:SetController(controller)
    panel:SetParent(parent)

    callinitializers(kind, panel)

    return panel
end

---Draws the given controller, or `mgui.ActiveController`
---Dont call this unless you arent using `mgui.inject`
---@param controller mgui.Controller?
function mgui.Draw(controller)
    controller = controller or mgui.ActiveController
    mgui.Assert(controller, "Attempting to call mgui.Draw without a Controller")

    controller:Draw()
end

---Updates the given controller, or `mgui.ActiveController`
---Dont call this unless you arent using `mgui.inject`
---@param deltatime number The deltatime passed from `love.update`
---@param controller mgui.Controller
function mgui.Update(dt, controller)
    controller = controller or mgui.ActiveController
    mgui.Assert(controller, "Attempting to call mgui.Update without a Controller")

    controller:Update(dt)
end