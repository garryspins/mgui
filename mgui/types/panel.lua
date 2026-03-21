
---@meta

---@class mgui.Panel: mgui.BasePanel
local PANEL = {}

---Centers the panel in its parent
---@param xperc number? `0` to `1`, how far to center horizontally
---@param yperc number? `0` to `1`, how far to center vertically
function PANEL:Center(xperc, yperc)end

---Returns a coordinate relative of the panel to the screen
---@param x number? X coordinate relative to the panel
---@param y number? Y coordinate relative to the panel
---@return integer x
---@return integer y
function PANEL:LocalToScreen(x, y)end

---Identical to `mgui.Panel:GetHovered()`
---@return boolean hovered Is this panel hovered?
function PANEL:IsHovered()end

---Identical to `mgui.Panel:GetChildHovered()`
---@return boolean hovered Is a child of this panel hovered?
function PANEL:IsChildHovered()end

---Identical to `mgui.Panel:GetVisible()`
---@return boolean visible Is this panel visible?
function PANEL:IsVisible()end

