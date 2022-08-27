-- -- -- -- -- -- -- -- --
-- common/text_4px.lua  --
-- -- -- -- -- -- -- -- --

function new_text_4px(text)
    local sprites = {}
    for i = 1, #text do
        -- TODO: is a new PICO-8 with text[i] syntax available yet?
        local char = sub(text, i, i)
        local sprite = _font_4px_sprites[char]
        add(sprites, { x = sprite[1], y = sprite[2], w = sprite[3] or 3 })
    end

    local text_4px = {
        w = 0
    }

    for sprite in all(sprites) do
        text_4px.w = text_4px.w + sprite.w + 1
    end
    text_4px.w = max(0, text_4px.w - 1)

    function text_4px.draw(x, y, color)
        pal(11, color, 0)
        for index, sprite in pairs(sprites) do
            sspr(sprite.x, sprite.y, sprite.w, 4, x, y)
            x = x + sprite.w + 1
        end
        pal()
    end

    return text_4px
end