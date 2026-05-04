
---@meta

--- This is the main Controller class, essentially a virtual root panel that handles layouts, thinking and painting
---@class mgui.Controller
---@field Panels mgui.LinkedTable Panels attached to this controller directly, as in, panels created without a parent
---@field PanelsToLayout { [mgui.Panel]: boolean } Panels to be layed out the next frame
---@field X number Origin X coordinate of this controller
---@field Y number Origin Y coordinate of this controller
---@field Width number Width of this controller 
---@field Height number Height of this controller
---@field HoveredPanel mgui.Panel? The panel currently being hovered by the mouse, if there is one
local CON = {}

---@param panels mgui.LinkedTable Panels attached to this controller directly, as in, panels created without a parent
---@return mgui.Controller
function CON:SetPanels(panels)end
---@param panelstolayout { [mgui.Panel]: boolean } Panels to be layed out the next frame
---@return mgui.Controller
function CON:SetPanelsToLayout(panelstolayout)end
---@param x number Origin X coordinate of this controller
---@return mgui.Controller
function CON:SetX(x)end
---@param y number Origin Y coordinate of this controller
---@return mgui.Controller
function CON:SetY(y)end
---@param width number Width of this controller 
---@return mgui.Controller
function CON:SetWidth(width)end
---@param height number Height of this controller
---@return mgui.Controller
function CON:SetHeight(height)end
---@param hoveredpanel mgui.Panel? The panel currently being hovered by the mouse, if there is one
---@return mgui.Controller
function CON:SetHoveredPanel(hoveredpanel)end

---@return mgui.LinkedTable panels Panels attached to this controller directly, as in, panels created without a parent
function CON:GetPanels(panels)end
---@return { [mgui.Panel]: boolean } panelstolayout Panels to be layed out the next frame
function CON:GetPanelsToLayout(panelstolayout)end
---@return number x Origin X coordinate of this controller
function CON:GetX(x)end
---@return number y Origin Y coordinate of this controller
function CON:GetY(y)end
---@return number width Width of this controller 
function CON:GetWidth(width)end
---@return number height Height of this controller
function CON:GetHeight(height)end
---@return mgui.Panel? hoveredpanel The panel currently being hovered by the mouse, if there is one
function CON:GetHoveredPanel(hoveredpanel)end

---@type mgui.Controller? The last created controller, if we have one
mgui.ActiveController = {}

---@private
---@return mgui.Controller
function CON:Init()end

---Adds a new `mgui.Panel` to be controlled by this controller directly
---Use `mgui.Create`
---@param panel mgui.Panel Panel to add
---@return mgui.Controller self
function CON:Add(panel)end

---Removes a `mgui.Panel` from this controller
---Does not call `mgui.Panel:Remove()`, only interacts with the controller!
---@param panel mgui.Panel
function CON:Remove(panel)end

---Marks a `mgui.Panel` for layout
---Use `mgui.Panel:InvalidateLayout()`
---@param panel mgui.Panel Panel to layout
---@param now boolean Should we lay this panel out now?
function CON:InvalidateLayout(panel, now)end

---Draws this controller, use `mgui.Draw`
function CON:Draw()end

---Renders a panel and its children recursively
---@private
---@param panel mgui.Panel
function CON:DrawPanel(panel)end

---Updates the controller, use `mgui.Update`
---@param deltatime number The deltatime provided by `love.update`
function CON:Update(dt)end

---Thinks a panel and its children recursively
---@private
---@param panel mgui.Panel
---@param dt number
function CON:ThinkPanel(panel, dt)end

---Lays out a panel internally, use `mgui.Panel:InvalidateLayout()`!
---@param panel mgui.Panel
---@param donelayout {[mgui.Panel]: boolean}
function CON:LayoutPanel(panel, donelayout)end

---Checks if a panel is hovered internally, use `mgui.Panel:IsHovered()`!
---@private
---@param panel mgui.Panel
---@return boolean
function CON:CheckHovered(panel)end

---Checks if a panels children is hovered internally, use `mgui.Panel:IsHovered()`!
---@private
---@param panel mgui.Panel
---@return mgui.Panel
function CON:QualifyHoveredChild(panel)end

---Calls the given function on every panel owned by this controller, and their children recursively
---Returning false from the given closure will stop the function from being called on its children
---@param fn fun(panel: mgui.Panel): boolean Function to call on every panel 
function CON:CallDownTree(fn)end

---Calls the given function on the given panel and its children
---Returning false from the given closure will stop the function from being called on its children
---@param fn fun(panel: mgui.Panel): boolean Function to call on every panel
function CON:CallDownPanelsTree(panel, fn)end

---Tells the controller of an input, only call this if you arent using `mgui.inject`
---@param button number
function CON:MousePressed(button)end

---Tells the controller of an input, only call this if you arent using `mgui.inject`
---@param button number
function CON:MouseReleased(button)end

---Tells the controller of an input, only call this if you arent using `mgui.inject`
---@param deltay number
---@param deltax number
function CON:MouseWheeled(deltay, deltax)end

---Tells the controller of an input, only call this if you arent using `mgui.inject`
---@param key love.KeyConstant
---@param scan love.Scancode
---@param repeating boolean
function CON:KeyPressed(key, scan, repeating)end

---Tells the controller of an input, only call this if you arent using `mgui.inject`
---@param key love.KeyConstant
---@param scan love.Scancode
function CON:KeyReleased(key, scan)end