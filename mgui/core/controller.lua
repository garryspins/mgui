
local CON = {} ---@type mgui.Controller
CON.__index = CON
mgui.MetaRegistry.CONTROLLER = CON

mgui.Accessor(CON, "Panels")
mgui.Accessor(CON, "PanelsToLayout")
mgui.Accessor(CON, "LayoutAll", false) -- todo doc this
mgui.Accessor(CON, "InLayout", false) -- todo doc this
mgui.Accessor(CON, "X", 0)
mgui.Accessor(CON, "Y", 0)
mgui.Accessor(CON, "Width", 0)
mgui.Accessor(CON, "Height", 0)
mgui.Accessor(CON, "HoveredPanel")

mgui.Accessor(CON, "KeyboardFocus") -- todo

function CON:OnSetWidth(w)
    if self.Width == w then return end
    self:SetLayoutAll(true)
end
function CON:OnSetHeight(h)
    if self.Height == h then return end
    self:SetLayoutAll(true)
end

function CON:Init()
    mgui.ActiveController = self
    self:SetPanels(mgui.LinkedTable())
    self:SetPanelsToLayout({})

    return self
end

function CON:Add(panel)
    if not mgui.Valid(panel) then return end
    self.Panels:Add(panel)
    return self
end

function CON:Remove(panel)
    if not mgui.Valid(panel) then return end
    self.Panels:RemoveByValue(panel)
end

function CON:InvalidateLayout(panel, now)
    if (not now) and (not self:GetInLayout()) then
        self.PanelsToLayout[panel] = true
        return
    end

    self:SetInLayout(true)
    self.PanelsToLayout[panel] = nil
    self:LayoutPanel(panel, {})
    self:SetInLayout(false)
end

function CON:LayoutPanel(panel, donelayout)
    if (not self:GetLayoutAll()) and donelayout[panel] then return end

    self.PanelsToLayout[panel] = nil
    donelayout[panel] = true

    if not mgui.Valid(panel) then return end
    panel:PerformLayout(panel:GetSize())
end

function CON:Draw()
    mgui.PushTranslate(self:GetX(), self:GetY(), self:GetWidth(), self:GetHeight())
    for k, v in ipairs(self.Panels.IndexKeys) do
        if mgui.Valid(v) then
            self:DrawPanel(v)
        end
    end
    mgui.PopTranslate()
end

function CON:DrawPanel(panel)
    if not panel:GetVisible() then return end

    local x, y = panel:GetPos()
    local w, h = panel:GetSize()

    mgui.PushTranslate(x, y, w, h)

    local vis = mgui.IsTranslationVisible()
    panel:SetLastTranslationData(mgui.CopyTable(mgui.GetActiveTranslation()))
    panel:SetVisibleLastFrame(vis)

    if not vis then
        return mgui.PopTranslate()
    end

    panel:PrePaint(w, h, mgui.GetActiveTranslation())
    panel:Paint(w, h)
    panel:PostPaint(w, h, mgui.GetActiveTranslation())
    for k, v in pairs(panel:GetChildren().IndexKeys) do
        if mgui.Valid(v) then
            self:DrawPanel(v)
        end
    end
    panel:PaintOver(w, h)

    mgui.PopTranslate()
end

function CON:Update(dt)
    local donelayout = {}
    for k, v in pairs(self.PanelsToLayout) do
        self:LayoutPanel(k, donelayout)
    end
    self:SetLayoutAll(false)

    local hovered
    for k, v in ipairs(self.Panels.IndexKeys) do
        if mgui.Valid(v) and v:GetVisibleLastFrame() then
            if self:CheckHovered(v) then
                hovered = v
            end

            self:ThinkPanel(v, dt)
        end
    end

    local oldhov = self:GetHoveredPanel()
    if hovered then
        hovered = self:QualifyHoveredChild(hovered)

        if oldhov == hovered then
            return
        end

        if mgui.Valid(oldhov) then
            love.mouse.setCursor()
            oldhov:SetHovered(false)
            self:SetHoveredPanel(false)
        end

        if hovered:GetCursor() then
            love.mouse.setCursor(hovered:GetCursor())
        end

        self:SetHoveredPanel(hovered)
        hovered:SetHovered(true)
        return
    end

    if mgui.Valid(oldhov) then oldhov:SetHovered(false) end
    love.mouse.setCursor()
    self:SetHoveredPanel(false)
end

function CON:ThinkPanel(panel, dt)
    if not mgui.Valid(panel) then return end
    if not panel:GetVisibleLastFrame() then return end

    panel:Think(dt)

    if not mgui.Valid(panel) then return end
    for k, v in ipairs(panel:GetChildren().IndexKeys) do
        self:ThinkPanel(v, dt)
    end
end

function CON:CheckHovered(panel)
    if not mgui.Valid(panel) then return false end
    if not panel:GetMouseInputEnabled() then return false end

    local cx, cy = love.mouse.getPosition()
    local data = panel:GetLastTranslationData()

    if not data then return false end
    if cx < data.left then return false end
    if cx > data.right then return false end
    if cy < data.top then return false end
    if cy > data.bottom then return false end

    return true
end

function CON:QualifyHoveredChild(panel)
    local children = panel:GetChildren().IndexKeys
    local len = #children
    for i = 0, len - 1 do
        local child = children[len - i]

        if self:CheckHovered(child) then
            return self:QualifyHoveredChild(child)
        end
    end

    return panel
end

function CON:CallDownTree(fn)
    for k, v in ipairs(self:GetPanels().IndexKeys) do
        self:CallDownPanelsTree(v, fn)
    end
end

function CON:CallDownPanelsTree(panel, fn)
    if not mgui.Valid(panel) then return false end
    if fn(panel) == false then return end

    for _, child in ipairs(panel:GetChildren().IndexKeys) do
        self:CallDownPanelsTree(child, fn)
    end

    return panel
end

function CON:MousePressed(button)
    if not self:GetHoveredPanel() then return end
    self:GetHoveredPanel():OnMousePressed(button)
end

function CON:MouseReleased(button)
    if not self:GetHoveredPanel() then return end
    self:GetHoveredPanel():OnMouseReleased(button)
end

function CON:MouseWheeled(deltay, deltax)
    if not self:GetHoveredPanel() then return end
    self:GetHoveredPanel():OnMouseWheeled(deltax, deltay)
end

function CON:KeyPressed(key, scan, repeating)
    self:CallDownTree(function(p)
        if not p:GetKeyboardInputEnabled() then return false end
        p:OnKeyPressed(key, scan, repeating)
    end )
end

function CON:KeyReleased(key, scan)
    self:CallDownTree(function(p)
        if not p:GetKeyboardInputEnabled() then return false end
        p:OnKeyReleased(key, scan)
    end )
end

function CON:TextEntered(text)
    self:CallDownTree(function(p)
        if not p:GetKeyboardInputEnabled() then return false end
        if not p:GetTakesTextInput() then return end
        p:OnTextEntered(text)
    end )
end