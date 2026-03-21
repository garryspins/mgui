
local PANEL = mgui.Register("Panel", {}, "BasePanel") ---@type mgui.Panel
PANEL.__index = PANEL
mgui.MetaRegistry.PANEL = PANEL

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

function PANEL:LocalToScreen(x, y)
    local data = panel:GetLastTranslationData()
    if not data then return 0, 0 end
    if not data.x then return 0, 0 end

    return data.x + (x or 0), data.y + (y or 0)
end

function PANEL:IsHovered() return self:GetHovered() end
function PANEL:IsChildHovered() return self:GetChildHovered() end
function PANEL:IsVisible() return self:GetVisible() end

