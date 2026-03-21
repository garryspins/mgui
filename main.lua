
print(); function love.quit() print() end

local pnl
require("mgui.init")
function love.load()
    local p = mgui.Create("Panel")
    p:SetSize(100, 300)
    p:SetPos(300, 300)
    p:Center()
    p:SetCursor(love.mouse.getSystemCursor("no"))
    pnl = p

    local top = p
    for i = 0, 10 do
        local c = mgui.Create("Panel", top)
        top = c

        c:SetWidth(p:GetWidth() - ((i * 5) * 2))
        c:SetHeight(p:GetWidth())
        c:Center()
        function c:Paint(w, h)
            love.graphics.setColor(0, i / 10, 1)
            if self:IsChildHovered() then
                love.graphics.setColor(0, 0, 1)
            elseif self:IsHovered() then
                love.graphics.setColor(1, 0, 0)
            end
            love.graphics.rectangle("fill", 0, 0, w, h)
        end

        function c:OnMousePressed()
            print("Removing")
            self:Remove()
        end
    end
end

function love.draw()
    local w, h = love.graphics.getDimensions()
    love.graphics.setColor(22 / 255, 22 / 255, 22 / 255)
    love.graphics.rectangle("fill", 0, 0, w, h)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(love.timer.getFPS() .. "fps", 10, h - 24)
end

function love.update(dt)
    -- pnl:SetWidth(
    --     math.max(love.mouse.getX() - pnl:GetX(), 100)
    -- )
end

mgui.inject()