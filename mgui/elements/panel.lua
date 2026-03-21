
---@class mgui.Panel: mgui.BasePanel
local PANEL = mgui.Register("Panel", {}, "BasePanel")
PANEL.__index = PANEL
mgui.Registry.PANEL = PANEL

function PANEL:Init()
end

function PANEL:Paint(w, h)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 0, 0, w, h)
end

---Centers the panel in its parent
---@param xperc number? `0` to `1`, how far to center horizontally
---@param yperc number? `0` to `1`, how far to center vertically
function PANEL:Center(xperc, yperc)
    local w, h = self:GetSize()
    local pw, ph

    if mgui.Valid(self:GetParent()) then
        pw, ph = self:GetParent():GetSize()
    else
        pw, ph = self:GetController():GetWidth(), self:GetController():GetHeight() 
    end

    self:SetX((pw - w) * (xperc or 0.5))
    self:SetY((ph - h) * (yperc or 0.5))
end

---Returns a coordinate relative of the panel to the screen
---@param x number? X coordinate relative to the panel
---@param y number? Y coordinate relative to the panel
---@return integer x
---@return integer y
function PANEL:LocalToScreen(x, y)
    local data = panel:GetLastTranslationData()
    if not data then return 0, 0 end
    if not data.x then return 0, 0 end

    return data.x + (x or 0), data.y + (y or 0)
end

---Identical to `mgui.Panel:GetHovered()`
---@return boolean hovered Is this panel hovered?
function PANEL:IsHovered() return self:GetHovered() end

---Identical to `mgui.Panel:GetChildHovered()`
---@return boolean hovered Is a child of this panel hovered?
function PANEL:IsChildHovered() return self:GetChildHovered() end

---Identical to `mgui.Panel:GetVisible()`
---@return boolean visible Is this panel visible?
function PANEL:IsVisible() return self:GetVisible() end

