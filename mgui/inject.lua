
local function detour(og, with)
    return function(...)
        if og then og(...) end
        with(...)
    end
end

---Detours all needed functions for using mgui!
function mgui.inject()
    local ctrl = mgui.NewController()

    love.update = detour(love.update, mgui.Update)
    love.draw = detour(love.draw, mgui.Draw)

    love.mousepressed = detour(love.mousepressed, function(_, _, button)
        ctrl:MousePressed(button)
    end )

    love.mousereleased = detour(love.mousereleased, function(_, _, button)
        ctrl:MouseReleased(button)
    end )

    love.wheelmoved = detour(love.wheelmoved, function(x, y)
        ctrl:MouseWheeled(x, y)
    end )

    love.keypressed = detour(love.keypressed, function(key, scan, repeating)
        ctrl:KeyPressed(key, scan, repeating)
    end )

    love.keyreleased = detour(love.keyreleased, function(key, scan)
        ctrl:KeyReleased(key, scan)
    end )
end