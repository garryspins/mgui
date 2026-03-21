
---@meta

--- The core, Base Panel of `mgui`, This contains all core functionality for operating on a panel
--- All panels derive from this, for LuaLS, you should declare your own classes and cast to them from `mgui.Create`
---@class mgui.BasePanel
---@field Controller mgui.Controller The controller that this is owned by hierarchically
---@field Parent mgui.BasePanel? The parent of this, or nil if its owned by the Controller
---@field Children mgui.LinkedTable The children of this panel
---@field Visible boolean Is this panel visible? This isnt a check, just a flag you can set if youd like to ignore the panel in rendering and updating
---@field LastTranslationData mgui.TranslationData? The translation data from this panels last render
---@field VisibleLastFrame boolean Was this panel visible last frame?
---@field Hovered boolean Is this panel hovered?
---@field ChildHovered boolean Is this panel hierarchically hovered?
---@field MouseInputEnabled boolean Should this panel capture mouse input?
---@field KeyboardInputEnabled boolean Should this panel capture keyboard input?
---@field Width number Width of the panel
---@field Height number Height of the panel
---@field X number X coordinate of the panel, relative to its parent
---@field Y number Y coordinate of the panel, relative to its parent
---@field Cursor love.Cursor? The cursor to display when hovering this panel, if we have one
local PANEL = {}

---Gets the panels controller
---@return mgui.Controller
function PANEL:GetController() return self.Controllerend
---The parent of this, or nil if its owned by the Controller
---@return mgui.BasePanel?
function PANEL:GetParent()end
---The children of this panel
---@return mgui.LinkedTable
function PANEL:GetChildren()end
---Is this panel visible? This isnt a check, just a flag you can set if youd like to ignore the panel in rendering and updating
---@return boolean
function PANEL:GetVisible()end
---The translation data from this panels last render
---@return mgui.TranslationData?
function PANEL:GetLastTranslationData()end
---Was this panel visible last frame?
---@return boolean
function PANEL:GetVisibleLastFrame()end
---Is this panel hovered?
---@return boolean
function PANEL:GetHovered()end
---Is this panel hierarchically hovered?
---@return boolean
function PANEL:GetChildHovered()end
---Should this panel capture mouse input?
---@return boolean
function PANEL:GetMouseInputEnabled()end
---Should this panel capture keyboard input?
---@return boolean
function PANEL:GetKeyboardInputEnabled()end
---Width of the panel
---@return number
function PANEL:GetWidth()end
---Height of the panel
---@return number
function PANEL:GetHeight()end
---X coordinate of the panel, relative to its parent
---@return number
function PANEL:GetX()end
---Y coordinate of the panel, relative to its parent
---@return number
function PANEL:GetY()end
---The cursor to display when hovering this panel, if we have one
---@return love.Cursor?
function PANEL:GetCursor()end

---@param controller mgui.Controller The controller that this is owned by hierarchically
---@return mgui.Panel
function PANEL:SetController(controller)end 
---@param parent mgui.BasePanel The parent of this, or nil if its owned by the Controller
---@return mgui.Panel
function PANEL:SetParent(parent)end 
---@param children mgui.LinkedTable The children of this panel
---@return mgui.Panel
function PANEL:SetChildren(children)end 
---@param visible boolean Is this panel visible? This isnt a check, just a flag you can set if youd like to ignore the panel in rendering and updating
---@return mgui.Panel
function PANEL:SetVisible(visible)end 
---@param lasttranslationdata mgui.TranslationData? The translation data from this panels last render
---@return mgui.Panel
function PANEL:SetLastTranslationData(lasttranslationdata)end 
---@param visiblelastframe boolean Was this panel visible last frame?
---@return mgui.Panel
function PANEL:SetVisibleLastFrame(visiblelastframe)end 
---@param hovered boolean Is this panel hovered?
---@return mgui.Panel
function PANEL:SetHovered(hovered)end 
---@param childhovered boolean Is this panel hierarchically hovered?
---@return mgui.Panel
function PANEL:SetChildHovered(childhovered)end 
---@param enabled boolean Should this panel capture mouse input?
---@return mgui.Panel
function PANEL:SetMouseInputEnabled(enabled)end 
---@param enabled boolean Should this panel capture keyboard input?
---@return mgui.Panel
function PANEL:SetKeyboardInputEnabled(enabled)end 
---@param width number Width of the panel
---@return mgui.Panel
function PANEL:SetWidth(width)end 
---@param height number Height of the panel
---@return mgui.Panel
function PANEL:SetHeight(height)end 
---@param x number X coordinate of the panel, relative to its parent
---@return mgui.Panel
function PANEL:SetX(x)end 
---@param y number Y coordinate of the panel, relative to its parent
---@return mgui.Panel
function PANEL:SetY(y)end 
---@param cursor love.Cursor The cursor to display when hovering this panel, if we have one
---@return mgui.Panel
function PANEL:SetCursor(cursor)end 

---Sets the position of the panel
---@param x number X coordinate of the panel, relative to its parent
---@param y number Y coordinate of the panel, relative to its parent
function PANEL:SetPos(x, y)end

---Gets the position of the panel
---@return number x X coordinate of the panel, relative to its parent
---@return number y Y coordinate of the panel, relative to its parent
function PANEL:GetPos()end

---Sets the size of the panel
---@param width number Width of the panel
---@param height number Height of the panel
function PANEL:SetSize(width, height)end

---Gets the size of the panel
---@return number width Width of the panel
---@return number height Height of the panel
function PANEL:GetSize()end

---Alias of `SetWidth`
---@param width number Width of the panel
function PANEL:SetWide(width)end

---Alias of `SetHeight`
---@param height number Height of the panel
function PANEL:SetTall(height)end

---Alias of `GetWidth`
---@return number width Width of the panel
function PANEL:GetWide()end

---Alias of `GetHeight`
---@return number height Height of the panel
function PANEL:GetTall()end


---Called when the Panel is initially created
function PANEL:Init()end

---Adds a child to this panel
---@param child mgui.Panel
function PANEL:Add(child)end

---Removes the panel and drops all held references to it in the library
function PANEL:Remove()end

---Invalidates the layout of this panel, causing it to be layed out next frame (or this frame, if its called during a layout)
function PANEL:InvalidateLayout()end

---Called whenever the panel is "thinking", when its on screen and valid
---@param deltatime number Deltatime from the `love.update` this was called from
function PANEL:Think(deltatime)end

---Called whenever the panel is requested to be rendered
---A transform and scissor are pushed to `love` when this is set, so `0, 0` in this is actually the coordinates of the panel itself
---@param w number Width of the panel
---@param h number Height of the panel
function PANEL:Paint(w, h)end

---Called whenever the panel is being laid out, position your children here
---@param w number Width of the panel
---@param h number Height of the panel
function PANEL:PerformLayout(w, h)end

---Called whenever this panel is being removed, called when the panel is still valid
function PANEL:OnRemove()end

---Called when the mouse enters this panel
function PANEL:OnCursorEntered()end

---Called whenever the mouse exits this panel
function PANEL:OnCursorExited()end

---Called when a mouse button has been pressed while this panel was hovered
---@param button number What button was pressed
function PANEL:OnMousePressed(button)end

---Called when a mouse button has been released while hovered
---@param button number What button was released
function PANEL:OnMouseReleased(button)end

---Called when the scroll wheel has been moved while hovered
---@param dy number Vertical wheel delta
---@param dx number Horizontal wheel delta
function PANEL:OnMouseWheeled(dy, dx)end

---Called when a key has been pressed
---Note that this is not called on all panels, only panels owned by the `mgui.Controller`!
---@param key love.KeyConstant
---@param scan love.Scancode
---@param repeating boolean
function PANEL:OnKeyPressed(key, scan, repeating)end

---Called when a key has been released
---Note that this is not called on all panels, only panels owned by the `mgui.Controller`!
---@param key love.KeyConstant
---@param scan love.Scancode
---@param repeating boolean
function PANEL:OnKeyReleased(key, scan)end