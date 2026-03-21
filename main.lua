
print(); function love.quit() print() end

local pnl
require("mgui.init")
function love.load()
    local p = mgui.Create("Button")
    p:SetSize(100, 300)
    p:SetPos(300, 300)
    p:Center()
    pnl = p
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