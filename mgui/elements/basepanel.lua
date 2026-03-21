
local PANEL = mgui.Register("BasePanel", {}, false) ---@type mgui.BasePanel
PANEL.__index = PANEL
mgui.MetaRegistry.BASEPANEL = PANEL

mgui.Accessor(PANEL, "Controller")
mgui.Accessor(PANEL, "Parent")
mgui.Accessor(PANEL, "Children")
mgui.Accessor(PANEL, "Visible", true)
mgui.Accessor(PANEL, "LastTranslationData", false)
mgui.Accessor(PANEL, "VisibleLastFrame", false)
mgui.Accessor(PANEL, "Hovered", false)
mgui.Accessor(PANEL, "ChildHovered", false)

mgui.Accessor(PANEL, "MouseInputEnabled", true)
mgui.Accessor(PANEL, "KeyboardInputEnabled", false)
mgui.Accessor(PANEL, "TakesTextInput", false)

mgui.Accessor(PANEL, "Width", 60)
mgui.Accessor(PANEL, "Height", 40)
mgui.Accessor(PANEL, "X", 0)
mgui.Accessor(PANEL, "Y", 0)
mgui.Accessor(PANEL, "Cursor", nil)

mgui.AccessorN(PANEL, "Size", "Width", "Height")
mgui.AccessorN(PANEL, "Pos", "X", "Y")
mgui.AccessorAlias(PANEL, "Wide", "Width")
mgui.AccessorAlias(PANEL, "Tall", "Height")

function PANEL:Init()
    self:SetChildren(mgui.LinkedTable())
end

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

function PANEL:InvalidateLayout() self:GetController():InvalidateLayout(self) end
function PANEL:OnSetWidth(w)
    if self.Width == w then return end
    self:InvalidateLayout()
end

function PANEL:OnSetHeight(h)
    if self.Height == h then return end
    self:InvalidateLayout()
end

function PANEL:Think(deltatime) end
function PANEL:Paint(w, h) end
function PANEL:PerformLayout(w, h) end
function PANEL:OnRemove() end
function PANEL:OnCursorEntered() end
function PANEL:OnCursorExited() end
function PANEL:OnMousePressed(button) end
function PANEL:OnMouseReleased(button) end
function PANEL:OnMouseWheeled(dy, dx) end
function PANEL:OnKeyPressed(key, scan, repeating) end
function PANEL:OnKeyReleased(key, scan) end
function PANEL:OnTextEntered(text) end