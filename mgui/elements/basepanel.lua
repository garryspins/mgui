
--- The core, Base Panel of `mgui`, This contains all core functionality for operating on a panel
--- All panels derive from this, for LuaLS, you should declare your own classes and cast to them from `mgui.Create`
---@class mgui.BasePanel
---@field Controller mgui.Controller The controller that this is owned by hierarchically
---@field Parent mgui.BasePanel? The parent of this, or nil if its owned by the Controller
---@field Children mgui.LinkedTable The children of this panel
---@field Visible boolean Is this panel visible? This isnt a check, just a flag you can set if youd like to ignore the panel in rendering and updating
---@field LastTranslationData mgui.TranslationData? The translation data from this panels last render
---@field VisibleLastFrame boolean Was this panel visible last frame?
---@field Hovered boolean Is this panel hovered?
---@field ChildHovered boolean Is this panel hierarchically hovered?
---@field Width number Width of the panel
---@field Height number Height of the panel
---@field X number X coordinate of the panel, relative to its parent
---@field Y number Y coordinate of the panel, relative to its parent
---@field Cursor love.Cursor? The cursor of this panel, if we have one
local PANEL = mgui.Register("BasePanel", {}, false)
PANEL.__index = PANEL
mgui.Registry.BASEPANEL = PANEL

mgui.Accessor(PANEL, "Controller")
mgui.Accessor(PANEL, "Parent")
mgui.Accessor(PANEL, "Children")
mgui.Accessor(PANEL, "Visible", true)
mgui.Accessor(PANEL, "LastTranslationData", false)
mgui.Accessor(PANEL, "VisibleLastFrame", false)
mgui.Accessor(PANEL, "Hovered", false)
mgui.Accessor(PANEL, "ChildHovered", false)

mgui.Accessor(PANEL, "Width", 60)
mgui.Accessor(PANEL, "Height", 40)
mgui.Accessor(PANEL, "X", 0)
mgui.Accessor(PANEL, "Y", 0)
mgui.Accessor(PANEL, "Cursor", nil)

mgui.AccessorN(PANEL, "Size", "Width", "Height")
mgui.AccessorN(PANEL, "Pos", "X", "Y")

---Called when the Panel is initially created
function PANEL:Init()
    self:SetChildren(mgui.LinkedTable())
end

---Called when a child should be added
function PANEL:Add(child)
    self:GetChildren():Add(child)
end

function PANEL:OnSetParent(parent)
    self:InvalidateLayout()
    if mgui.Valid(self:GetParent()) then
        self:GetParent():GetChildren():RemoveByValue(self)
    end
    self:GetController():Remove(self)

    if not mgui.Valid(parent) then
        return self:GetController():Add(self)
    end
    parent:Add(self)
end

function PANEL:OnSetHovered(hov)
    if mgui.Valid(self:GetParent()) then
        self:GetParent():SetChildHovered(hov)
    end

    if self:GetHovered() == hov then return end
    if hov then
        return self:OnCursorEntered()
    end
    self:OnCursorExited()
end
function PANEL:OnSetChildHovered(hov)
    if mgui.Valid(self:GetParent()) then
        self:GetParent():SetChildHovered(hov)
    end
end

---Removes the panel and drops all held references to it in the library
function PANEL:Remove()
    if not mgui.Valid(self) then return end
    self:OnRemove()

    if mgui.Valid(self:GetParent()) then
        self:GetParent():GetChildren():RemoveByValue(self)
    end

    for k, v in pairs(self:GetChildren().IndexKeys) do
        if mgui.Valid(v) then v:Remove() end
    end

    self:GetController():Remove(self)
    self.IsNull = true
end

---Invalidates the layout of this panel, causing it to be layed out next frame (or this frame, if its called during a layout)
function PANEL:InvalidateLayout() self:GetController():InvalidateLayout(self) end
function PANEL:OnSetWidth(w)
    if self.Width == w then return end
    self:InvalidateLayout()
end

function PANEL:OnSetHeight(h)
    if self.Height == h then return end
    self:InvalidateLayout()
end

---Called whenever the panel is "thinking", when its on screen and valid
function PANEL:Think() end

---Called whenever the panel is requested to be rendered
---A transform and scissor are pushed to `love` when this is set, so `0, 0` in this is actually the coordinates of the panel itself
---@param w number Width of the panel
---@param h number Height of the panel
function PANEL:Paint(w, h) end

---Called whenever the panel is being laid out, position your children here
---@param w number Width of the panel
---@param h number Height of the panel
function PANEL:PerformLayout(w, h) end

---Called whenever this panel is being removed, called when the panel is still valid
function PANEL:OnRemove() end

---Called when the mouse enters this panel
function PANEL:OnCursorEntered() end

---Called whenever the mouse exits this panel
function PANEL:OnCursorExited() end

---Called when a mouse button has been pressed while this panel was hovered
---@param button number What button was pressed
function PANEL:OnMousePressed(button) end

---Called when a mouse button has been released while hovered
---@param button number What button was released
function PANEL:OnMouseReleased(button) end

---Called when the scroll wheel has been moved while hovered
---@param dy number Vertical wheel delta
---@param dx number Horizontal wheel delta
function PANEL:OnMouseWheeled(dy, dx) end

---Called when a key has been pressed
---Note that this is not called on all panels, only panels owned by the `mgui.Controller`!
---@param key love.KeyConstant
---@param scan love.Scancode
---@param repeating boolean
function PANEL:OnKeyPressed(key, scan, repeating) end

---Called when a key has been released
---Note that this is not called on all panels, only panels owned by the `mgui.Controller`!
---@param key love.KeyConstant
---@param scan love.Scancode
---@param repeating boolean
function PANEL:OnKeyReleased(key, scan) end