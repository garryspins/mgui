
---@meta

---@class mgui.Button: mgui.Panel
---@field CallOnRelease boolean Should we call our callbacks on mouse release?
---@field IsPressed boolean Is this button currently pressed?
local PANEL = {}

---@param callonrelease boolean Should we call our callbacks on mouse release?
---@return mgui.Button
function PANEL:SetCallOnRelease(callonrelease)end

---@return boolean callonrelease Should we call our callbacks on mouse release?
function PANEL:GetCallOnRelease()end

---@param pressed boolean Is this button currently pressed?
---@return mgui.Button
function PANEL:SetIsPressed(pressed)end

---@return boolean pressed Is this button currently pressed?
function PANEL:GetIsPressed()end


--- Called when this button was left clicked
function PANEL:LeftClick()end

--- Called when this button was right clicked
function PANEL:RightClick()end

--- Called when this button was middle clicked
function PANEL:MiddleClick()end

--- Handles the button press callbacks 
---@private
---@param button number Mouse button to press
function PANEL:CallButton(button)end