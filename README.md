
# Melon's GUI
`mgui` is a developer focused retained-mode graphical user interface library for [Love2D](https://love2d.org/) heavily inspired (basically a reimplementation) of [vgui](https://wiki.facepunch.com/gmod/vgui) from Garry's Mod's Lua API.  

# Installation
To install the library
1. Clone the `mgui/` directory of this repository into your Love project
2. Require `mgui.init`
3. Call `mgui.inject()` *after* your `love.*` callbacks have been defined

If you'd like to avoid using `mgui.inject()`, please read its source to properly handle things.

# Usage
Registration of panels is the core of this library, all distinct logic should be in its own Panel, alongside generic derivative elements.  

### Registering a new Panel type
```lua
local PANEL = {}

function PANEL:Init()
    self.Counter = 0
end

function PANEL:OnMousePressed(m)
    if m == 1 then
        self.Counter = self.Counter + 1
    end
end

function PANEL:Paint(w, h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(tostring(self.Counter), 10, 10)
end

mgui.Register("MyPanel", PANEL)
```

### Using your Panel
```lua
local pnl = mgui.Create("MyPanel")
pnl:SetSize(100, 100)
pnl:SetPos(10, 10)
```

# Rationale
I personally am a firm believer in the supremacy of retain-mode UI, and theres very few implementations of RMUI I have interacted with that are easier to use than `vgui`, so this is a way to have that ease of use while being outside of Garry's Mod!

