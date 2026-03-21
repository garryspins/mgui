
local PANEL = mgui.Register("Button", {}) ---@type mgui.Button
PANEL.__index = PANEL
mgui.MetaRegistry.PANEL = PANEL

function PANEL:Init()
    self:SetMouseInputEnabled(true)
    self:SetCursor(love.mouse.getSystemCursor("hand"))
end

function PANEL:Paint(w, h)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 0, 0, w, h)
end

