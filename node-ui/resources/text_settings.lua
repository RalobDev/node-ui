local ROOT = (...):match("^(.*)%.[^.]+%.[^.]+$")        --- @type string

local Resource = require(ROOT .. ".resources.resource") --- @type NodeUI.Resource

--- Representa as configurações de texto de um **`NodeUI.TextBlock`**.
--- @class NodeUI.TextSettings: NodeUI.Resource
--- @field private _normal_font_data NodeUI.TextSettings.FontData
--- @field private _bold_font_data NodeUI.TextSettings.FontData
--- @field private _italic_font_data NodeUI.TextSettings.FontData
--- @field private _bold_italic_font_data NodeUI.TextSettings.FontData
--- @field private _mono_font_data NodeUI.TextSettings.FontData
--- @field private _font_color number[]
--- @field private _outline_color number[]
--- @field private _shadow_color number[]
--- @field private _outline_size number
--- @field private _shadow_outline_size number
--- @field private _shadow_offset_x number
--- @field private _shadow_offset_y number
--- @field private _line_separation number
local TextSettings = Resource:extend("TextSettings")


--#region Public

--- Cria uma nova **TextSettings**.
--- @nodiscard
--- @return NodeUI.TextSettings TextSettings Nova TextSettings.
function TextSettings:new()
    local obj = Resource.new(self) --- @cast obj NodeUI.TextSettings

    local _, default_font = pcall(love.graphics.newFont, 16)
    local dpi = default_font:getDPIScale()

    obj._normal_font_data = { font = default_font, path = "", size = 16, hinting = "normal", dpiscale = dpi }
    obj._bold_font_data = { font = default_font, path = "", size = 16, hinting = "normal", dpiscale = dpi }
    obj._italic_font_data = { font = default_font, path = "", size = 16, hinting = "normal", dpiscale = dpi }
    obj._bold_italic_font_data = { font = default_font, path = "", size = 16, hinting = "normal", dpiscale = dpi }
    obj._mono_font_data = { font = default_font, path = "", size = 16, hinting = "normal", dpiscale = dpi }
    obj._font_color = { 1, 1, 1, 1 }
    obj._outline_color = { 0, 0, 0, 1 }
    obj._shadow_color = { 0, 0, 0, 0 }
    obj._outline_size = 0
    obj._shadow_outline_size = 1
    obj._shadow_offset_x = 2
    obj._shadow_offset_y = 2
    obj._line_separation = 0

    return obj
end

--#endregion


--#region Setter

--- Define o caminho da fonte da **`NodeUI.TextSettings.FontVariant`**.
--- @param variant NodeUI.TextSettings.FontVariant # Variante da fonte.
--- @param font_path string                        # Caminho da fonte.
--- @param font_size? number                       # Tamanho da fonte.
--- @param hinting? love.HintingMode               # Modo da fonte.
--- @param dpiscale? number                        # Desensidade por pixel.
function TextSettings:setFont(variant, font_path, font_size, hinting, dpiscale)
    local variant_key = "_" .. variant:lower() .. "_font_data"
    local font_data = self[variant_key] --- @type NodeUI.TextSettings.FontData

    local old_path = font_data.path
    local old_size = font_data.size
    local old_hinting = font_data.hinting
    local old_dpiscale = font_data.dpiscale

    font_data.path = font_path
    font_data.size = font_size or 16
    font_data.hinting = hinting or "normal"
    font_data.dpiscale = dpiscale or -1 -- Usa o dpiscale da própria fonte.

    if (
            font_data.path ~= old_path
            or font_data.size ~= old_size
            or font_data.hinting ~= old_hinting
            or font_data.dpiscale ~= old_dpiscale
        ) then
        self:_rebuildFont(variant)
        self._signal:emit("CHANGED")
    end
end

--- Define o tamanho da fonte da **`NodeUI.TextSettings.FontVariant`**.
--- @param variant NodeUI.TextSettings.FontVariant # Variante da fonte.
--- @param size number                             # Tamanho da fonte.
function TextSettings:setFontSize(variant, size)
    local variant_key = "_" .. variant:lower() .. "_font_data"
    local old = self[variant_key].size

    self[variant_key].size = size

    if self[variant_key].size ~= old then
        self:_rebuildFont(variant)
        self._signal:emit("CHANGED")
    end
end

--- Define a cor da fonte.
--- @param color number[] Cor da fonte.
function TextSettings:setFontColor(color)
    local old = self._font_color

    self._font_color = {
        color[1] or 1,
        color[2] or 1,
        color[3] or 1,
        color[4] or 1,
    }

    if (
            self._font_color[1] ~= old[1]
            or self._font_color[2] ~= old[2]
            or self._font_color[3] ~= old[3]
            or self._font_color[4] ~= old[4]
        ) then
        self._signal:emit("CHANGED")
    end
end

--- Define a cor do outline.
--- @param color number[] Cor do outline.
function TextSettings:setOutlineColor(color)
    local old = self._outline_color

    self._outline_color = {
        color[1] or 1,
        color[2] or 1,
        color[3] or 1,
        color[4] or 1,
    }

    if (
            self._outline_color[1] ~= old[1]
            or self._outline_color[2] ~= old[2]
            or self._outline_color[3] ~= old[3]
            or self._outline_color[4] ~= old[4]
        ) then
        self._signal:emit("CHANGED")
    end
end

--- Define a cor da sombra.
--- @param color number[] Cor da sombra.
function TextSettings:setShadowColor(color)
    local old = self._shadow_color

    self._shadow_color = {
        color[1] or 1,
        color[2] or 1,
        color[3] or 1,
        color[4] or 1,
    }

    if (
            self._shadow_color[1] ~= old[1]
            or self._shadow_color[2] ~= old[2]
            or self._shadow_color[3] ~= old[3]
            or self._shadow_color[4] ~= old[4]
        ) then
        self._signal:emit("CHANGED")
    end
end

--- Define o tamanho do outline.
--- @param size number Tamanho do outline.
function TextSettings:setOutlineSize(size)
    local old = self._outline_size

    self._outline_size = size

    if self._outline_size ~= old then
        self._signal:emit("CHANGED")
    end
end

--- Define o tamanho do outline da sombra.
--- @param size number Tamanho do outline.
function TextSettings:setShadowOutlineSize(size)
    local old = self._shadow_outline_size

    self._shadow_outline_size = size

    if self._shadow_outline_size ~= old then
        self._signal:emit("CHANGED")
    end
end

--- Define o offset da posição x da sombra.
--- @param x number Offset x.
function TextSettings:setShadowOffsetX(x)
    local old = self._shadow_offset_x

    self._shadow_offset_x = x

    if self._shadow_offset_x ~= old then
        self._signal:emit("CHANGED")
    end
end

--- Define o offset da posição y da sombra.
--- @param y number Offset y.
function TextSettings:setShadowOffsetY(y)
    local old = self._shadow_offset_y

    self._shadow_offset_y = y

    if self._shadow_offset_y ~= old then
        self._signal:emit("CHANGED")
    end
end

--- Define o offset da posição da sombra.
--- @param x number Offset x.
--- @param y number Offset y.
function TextSettings:setShadowOffset(x, y)
    local old_x = self._shadow_offset_x
    local old_y = self._shadow_offset_y

    self._shadow_offset_x = x
    self._shadow_offset_y = y

    if self._shadow_offset_x ~= old_x or self._shadow_offset_y ~= old_y then
        self._signal:emit("CHANGED")
    end
end

--- Define a separação entre linhas.
--- @param separation number Separação entre linhas.
function TextSettings:setLineSeparation(separation)
    local old = self._line_separation

    self._line_separation = separation

    if self._line_separation ~= old then
        self:_emit("CHANGED")
    end
end

--#endregion


--#region Getter

--- Retorna a fonte da **`NodeUI.TextSettings.FontVariant`**.
--- @param variant NodeUI.TextSettings.FontVariant # Variante da fonte.
--- @return love.Font font                         # Fonte da variante.
function TextSettings:getFont(variant)
    local variant_key = "_" .. variant:lower() .. "_font_data"
    local font = self[variant_key].font --- @type love.Font

    -- Evita que a altura da linha seja alterada, pois a altura da linha deve ser definida
    -- Através de setLineSeparation().
    if font:getLineHeight() ~= 1 then
        font:setLineHeight(1)
    end

    return font
end

--- Retorna o tamanho da fonte da **`NodeUI.TextSettings.FontVariant`**.
--- @nodiscard
--- @param variant NodeUI.TextSettings.FontVariant # Variante da fonte.
--- @return number size                            # Tamanho da fonte.
function TextSettings:getFontSize(variant)
    local variant_key = "_" .. variant:lower() .. "_font_data"
    return self[variant_key].size
end

--- Retorna a cor da fonte.
--- @nodiscard
--- @return number[] color Cor da fonte.
function TextSettings:getFontColor()
    return self._font_color
end

--- Retorna a cor do outline.
--- @nodiscard
--- @return number[] color Cor do outline.
function TextSettings:getOutlineColor()
    return self._outline_color
end

--- Retorna a cor da sombra.
--- @nodiscard
--- @return number[] color Cor da sombra.
function TextSettings:getShadowColor()
    return self._shadow_color
end

--- Retorna o tamanho do outline.
--- @nodiscard
--- @return number size Tamanho do outline.
function TextSettings:getOutlineSize()
    return self._outline_size
end

--- Retorna o tamanho do outline da sombra.
--- @nodiscard
--- @return number size Tamanho do outline.
function TextSettings:getShadowOutlineSize()
    return self._shadow_outline_size
end

--- Retorna o offset da posição x da sombra.
--- @nodiscard
--- @return number x Offset x.
function TextSettings:getShadowOffsetX()
    return self._shadow_offset_x
end

--- Retorna o offset da posição y da sombra.
--- @nodiscard
--- @return number y Offset y.
function TextSettings:getShadowOffsetY()
    return self._shadow_offset_y
end

--- Retorna o offset da posição da sombra.
--- @nodiscard
--- @return number x Offset x.
--- @return  number y Offset y.
function TextSettings:getShadowOffset()
    return self._shadow_offset_x, self._shadow_offset_y
end

--- Retorna a separação entre linhas.
--- @nodiscard
--- @return number separation Separação entre linhas.
function TextSettings:getLineSeparation()
    return self._line_separation
end

--#endregion


--#region Private

--- Reconstroi uma fonte com novas propriedades.
--- @private
--- @param variant NodeUI.TextSettings.FontVariant
function TextSettings:_rebuildFont(variant)
    local font_data = self["_" .. variant:lower() .. "_font_data"] --- @type NodeUI.TextSettings.FontData

    if font_data.path == "" then
        local _, font = pcall(love.graphics.newFont, font_data.size, font_data.hinting, font_data.dpiscale)
        font_data.font = font
    else
        local dpiscale = font_data.dpiscale < 0 and font_data.font:getDPIScale() or font_data.dpiscale
        font_data.font = love.graphics.newFont(font_data.path, font_data.size, font_data.hinting, dpiscale)
    end
end

--#endregion


return TextSettings
