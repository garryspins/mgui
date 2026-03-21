
---@class mgui.Controller
---@field Panels mgui.LinkedTable Panels attached to this controller directly, as in, panels created without a parent
---@field PanelsToLayout { [mgui.Panel]: boolean } Panels to be layed out the next frame
---@field X number Origin X coordinate of this controller
---@field Y number Origin Y coordinate of this controller
---@field Width number Width of this controller 
---@field Height number Height of this controller
---@field HoveredPanel mgui.Panel? The panel currently being hovered by the mouse, if there is one
---@field KeyboardFocus mgui.Panel? todo 
local CON = {}
CON.__index = CON
mgui.Registry.CONTROLLER = CON

mgui.Accessor(CON, "Panels") -- todo accessors in docs
mgui.Accessor(CON, "PanelsToLayout")
mgui.Accessor(CON, "X", 0)
mgui.Accessor(CON, "Y", 0)
mgui.Accessor(CON, "Width", 0)
mgui.Accessor(CON, "Height", 0)
mgui.Accessor(CON, "HoveredPanel")

mgui.Accessor(CON, "QueuedKeyPress")
mgui.Accessor(CON, "QueuedKeyRelease")
mgui.Accessor(CON, "KeyboardFocus") -- todo

---@private
---@return mgui.Controller
function CON:Init()
    ---@type mgui.Controller The last created controller
    mgui.ActiveController = self
    self:SetPanels(mgui.LinkedTable())
    self:SetPanelsToLayout({})

    return self
end

---Adds a new `mgui.Panel` to be controlled by this controller directly
---Use `mgui.Create`
---@param panel mgui.Panel Panel to add
---@return mgui.Controller self
function CON:Add(panel)
    if not mgui.Valid(panel) then return end
    self.Panels:Add(panel)
    return self
end

---Removes a `mgui.Panel` from this controller
---Does not call `mgui.Panel:Remove()`, only interacts with the controller!
---@param panel mgui.Panel
function CON:Remove(panel)
    if not mgui.Valid(panel) then return end
    self.Panels:RemoveByValue(panel)
end

---Marks a `mgui.Panel` for layout
---Use `mgui.Panel:InvalidateLayout()`
---@param panel mgui.Panel
function CON:InvalidateLayout(panel)
    self.PanelsToLayout[panel] = true
end

---Draws this controller, use `mgui.Draw`
function CON:Draw()
    mgui.PushTranslate(self:GetX(), self:GetY(), self:GetWidth(), self:GetHeight())
    for k, v in ipairs(self.Panels.IndexKeys) do
        if mgui.Valid(v) then
            self:DrawPanel(v)
        end
    end
    mgui.PopTranslate()
end

---Renders a panel and its children recursively
---@private
---@param panel mgui.Panel
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

    panel:Paint(panel:GetSize())
    for k, v in pairs(panel:GetChildren().IndexKeys) do
        if mgui.Valid(v) then
            self:DrawPanel(v)
        end
    end

    mgui.PopTranslate()
end

---Updates the controller, use `mgui.Update`
---@param deltatime number The deltatime provided by `love.update`
function CON:Update(dt)
    local donelayout = {}
    for k, v in pairs(self.PanelsToLayout) do
        self:LayoutPanel(k, donelayout)
    end

    local hovered
    for k, v in ipairs(self.Panels.IndexKeys) do
        if mgui.Valid(v) and v:GetVisibleLastFrame() then
            if self:CheckHovered(v) then
                hovered = v
            end

            for _, press in pairs(self.QueuedKeyPress) do
                v:OnKeyPressed(key, scan, repeating)
            end
            for _, release in pairs(self.QueuedKeyRelease) do
                v:OnKeyReleased(key, scan)
            end

            v:Think()
        end
    end
    self.QueuedKeyPress = {}
    self.QueuedKeyRelease = {}

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

---Lays out a panel internally, use `mgui.Panel:InvalidateLayout()`!
---@param panel mgui.Panel
---@param donelayout {[mgui.Panel]: boolean}
function CON:LayoutPanel(panel, donelayout)
    if donelayout[panel] then return end

    self.PanelsToLayout[panel] = nil
    donelayout[panel] = true

    panel:PerformLayout(panel:GetSize())
end

---Checks if a panel is hovered internally, use `mgui.Panel:IsHovered()`!
---@private
---@param panel mgui.Panel
---@return boolean
function CON:CheckHovered(panel)
    local cx, cy = love.mouse.getPosition()
    local data = panel:GetLastTranslationData()

    if cx < data.left then return false end
    if cx > data.right then return false end
    if cy < data.top then return false end
    if cy > data.bottom then return false end

    return true
end

---Checks if a panels children is hovered internally, use `mgui.Panel:IsHovered()`!
---@private
---@param panel mgui.Panel
---@return mgui.Panel
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

---Tells the controller of an input, only call this if you arent using `mgui.inject`
---@param button number
function CON:MousePressed(button)
    if not self:GetHoveredPanel() then return end
    self:GetHoveredPanel():OnMousePressed(button)
end

---Tells the controller of an input, only call this if you arent using `mgui.inject`
---@param button number
function CON:MouseReleased(button)
    if not self:GetHoveredPanel() then return end
    self:GetHoveredPanel():OnMouseReleased(button)
end

---Tells the controller of an input, only call this if you arent using `mgui.inject`
---@param deltay number
---@param deltax number
function CON:MouseWheeled(deltay, deltax)
    if not self:GetHoveredPanel() then return end
    self:GetHoveredPanel():OnMouseWheeled(deltax, deltay)
end

---Tells the controller of an input, only call this if you arent using `mgui.inject`
---@param key love.KeyConstant
---@param scan love.Scancode
---@param repeating boolean
function CON:KeyPressed(key, scan, repeating)
    if not self:GetHoveredPanel() then return end
    table.insert(self.QueuedKeyPress, {key, scan, repeating})
end

---Tells the controller of an input, only call this if you arent using `mgui.inject`
---@param key love.KeyConstant
---@param scan love.Scancode
function CON:KeyReleased(key, scan)
    if not self:GetHoveredPanel() then return end
    table.insert(self.QueuedKeyRelease, {key, scan})
end