
mgui.Translations = {
    Data = {
        x = false,
        y = false,
        left = false,
        top = false,
        right = false,
        bottom = false,
    },
    Stack = {},
    ActiveScissor = false,
    LastTranslation = false,
}
local data = mgui.Translations.Data
local stack = mgui.Translations.Stack

--- The stored translation data, all relative to the screens origin
---@alias mgui.TranslationData { x: number?, y: number?, left: number?, top: number?, right: number?, bottom: number? }

---Sets a rendering scissor from screen coords, instead of loves default of width and height
---@private
---@param left number 
---@param top number
---@param right number
---@param bottom number
function mgui.Scissor(left, top, right, bottom)
    if not left then return love.graphics.setScissor() end

    mgui.Translations.ActiveScissor = {
        left = left,
        top = top,
        right = right,
        bottom = bottom
    }

    love.graphics.setScissor(
        mgui.Round(math.max(left, 0)),
        mgui.Round(math.max(top, 0)),
        mgui.Round(math.max(right - left, 0)),
        mgui.Round(math.max(bottom - top, 0))
    )
end

function mgui.Translate(x, y)
    love.graphics.origin()
    
    if not x then return end
    love.graphics.translate(mgui.Round(x), mgui.Round(y))
end

---Pushes a translation to the internal stack
---@private
---@param x number
---@param y number
---@param w number
---@param h number
function mgui.PushTranslate(x, y, w, h)
    table.insert(stack, mgui.CopyTable(data))

    data.x = data.x or 0
    data.y = data.y or 0
    data.left = data.left or 0
    data.top = data.top or 0
    data.right = data.right or (data.left + w)
    data.bottom = data.bottom or (data.top + h)

    data.left = math.max(
        data.x + x,
        data.x,
        data.left
    )

    data.top = math.max(
        data.y + y,
        data.y,
        data.top
    )

    data.x = data.x + x
    data.y = data.y + y
    data.right = math.min(
        data.x + w,
        data.right
    )

    data.bottom = math.min(
        data.y + h,
        data.bottom
    )

    love.graphics.origin()

    mgui.Translate(data.x, data.y)
    mgui.Scissor(data.left, data.top, data.right, data.bottom)
end

---Pops a translation from the internal stack
---@private
function mgui.PopTranslate()
    local last = table.remove(stack, #stack)
    data = last

    love.graphics.origin()
    love.graphics.setScissor()

    if not data.left then return end
    mgui.Translate(data.x, data.y)
    mgui.Scissor(data.left, data.top, data.right, data.bottom)
end

---Gets the current translation data 
---@return mgui.TranslationData
function mgui.GetActiveTranslation()
    return data
end

---Gets if the given translation, or the currently active one is visible
---@param translation mgui.TranslationData? Defaults to the current translation
---@return boolean
function mgui.IsTranslationVisible(translation)
    translation = translation or data
    
    return translation.left < translation.right and
           translation.top < translation.bottom
end

---Toggles the active translation on/off entirely
---This resets the scissor and translation to 0
function mgui.ToggleTranslation()
    if not mgui.Translations.LastTranslation then
        mgui.Translations.LastTranslation = mgui.GetActiveTranslation()
        mgui.Translate()
        mgui.Scissor()

        return
    end
    
    local last = mgui.Translations.LastTranslation
    mgui.Translate(last.x, last.y)
    mgui.Scissor(last.left, last.left, last.right, last.bottom)
    mgui.Translations.LastTranslation = false
end

---Sets if clipping should be enabled on the upcoming render operations
---@param clip boolean
function mgui.SetClipping(clip)
    if not clip then
        return mgui.Scissor()
    end

    local last = mgui.GetActiveTranslation()
    mgui.Scissor(last.left, last.left, last.right, last.bottom)
end