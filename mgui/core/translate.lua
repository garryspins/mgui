
mgui.Translations = { Data = {
    x = false,
    y = false,
    left = false,
    top = false,
    right = false,
    bottom = false,
}, Stack = {} }
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

    love.graphics.setScissor(
        math.max(left, 0),
        math.max(top, 0),
        math.max(right - left, 0),
        math.max(bottom - top, 0)
    )
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

    love.graphics.translate(data.x, data.y)
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
    love.graphics.translate(data.x, data.y)
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