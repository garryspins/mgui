
local PANEL = mgui.Register("Button", {}) ---@type mgui.Button
PANEL.__index = PANEL
mgui.MetaRegistry.PANEL = PANEL

mgui.Accessor(PANEL, "CallOnRelease", true)
mgui.Accessor(PANEL, "IsPressed", false)

function PANEL:Init()
    self:SetMouseInputEnabled(true)
    self:SetCursor(love.mouse.getSystemCursor("hand"))

    self.pressed = {}
end

function PANEL:Paint(w, h)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 0, 0, w, h)
end

function PANEL:LeftClick() print("LeftClick") end
function PANEL:RightClick() print("RightClick") end
function PANEL:MiddleClick() print("MiddleClick") end

function PANEL:CallButton(button)
    self:SetIsPressed(next(self.pressed) ~= nil)

    local map = {
        [1] = "LeftClick",
        [2] = "RightClick",
        [3] = "MiddleClick"
    }

    if not map[button] then return end
    self[map[button]](self)
end

function PANEL:OnMousePressed(button)
    self:SetIsPressed(true)

    if not self:GetCallOnRelease() then
        return self:CallButton(button)
    end

    self.pressed[button] = true
end

function PANEL:OnMouseReleased(button)
    if self:GetCallOnRelease() then return end
    if not self.pressed[button] then return end
    self.pressed[button] = nil
    self:CallButton(button)
end

function PANEL:Think()
    if not self:GetCallOnRelease() then return end
    
    for button in pairs(self.pressed) do
        if not love.mouse.isDown(button) then 
            self.pressed[button] = nil
            self:CallButton(button)
        end
    end
end

function PANEL:Paint(w, h)
    love.graphics.setColor(self:GetIsPressed() and 1 or 0, 1, 1)
    love.graphics.rectangle("fill", 0, 0, w, h)
end