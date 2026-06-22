local ROOT = (...):match("^(.*)%.[^.]+%.[^.]+$")        --- @type string

local StyleBox = require(ROOT .. ".abstract.style_box") --- @type NodeUI.StyleBox

--- Uma **StyleBox** que exibe um retângulo altamente customizável.
--- @class NodeUI.StyleBoxFlat: NodeUI.StyleBox
--- @field private _fill_color [number, number, number, number?]
--- @field private _draw_center boolean
--- @field private _skew_x number
--- @field private _skew_y number
--- @field private _border_size number
--- @field private _border_color [number, number, number, number?]
--- @field private _border_blend boolean
--- @field private _corner_radius_top_left number
--- @field private _corner_radius_top_right number
--- @field private _corner_radius_bottom_left number
--- @field private _corner_radius_bottom_right number
--- @field private _expand_margin_left number
--- @field private _expand_margin_right number
--- @field private _expand_margin_top number
--- @field private _expand_margin_bottom number
--- @field private _shadow_color [number, number, number, number?]
--- @field private _shadow_size number
--- @field private _shadow_blur number
--- @field private _shadow_offset_x number
--- @field private _shadow_offset_y number
local StyleBoxFlat = StyleBox:extend("StyleBoxFlat")

local rectangle_shader = love.graphics.newShader(ROOT .. "/shaders/rectangle_shader.glsl")


--#region Local

--- Calcula o quanto o skew "expalha" o retângulo na tela.
local function skewExpandedHalfSize(halfW, halfH, skewX, skewY)
    local det = 1 - skewX * skewY
    if math.abs(det) < 1e-3 then
        det = (det < 0) and -1e-3 or 1e-3 -- evita divisão por ~0 em skews extremos
    end
    local expandedW = (halfW + math.abs(skewX) * halfH) / math.abs(det)
    local expandedH = (math.abs(skewY) * halfW + halfH) / math.abs(det)
    return expandedW, expandedH
end

--#endregion


--#region Public

--- Cria uma nova **StyleBoxFlat**.
--- @nodiscard
--- @return NodeUI.StyleBoxFlat StyleBoxFlat Nova **StyleBoxFlat**.
function StyleBoxFlat:new()
    local obj = StyleBox.new(self) --- @cast obj NodeUI.StyleBoxFlat

    obj._fill_color = { 0.6, 0.6, 0.6, 1.0 }
    obj._draw_center = true
    obj._skew_x = 0
    obj._skew_y = 0
    obj._border_size = 0
    obj._border_color = { 0.8, 0.8, 0.8, 1.0 }
    obj._border_blend = false
    obj._corner_radius_top_left = 0
    obj._corner_radius_top_right = 0
    obj._corner_radius_bottom_left = 0
    obj._corner_radius_bottom_right = 0
    obj._expand_margin_left = 0
    obj._expand_margin_right = 0
    obj._expand_margin_top = 0
    obj._expand_margin_bottom = 0
    obj._shadow_color = { 0.0, 0.0, 0.0, 0.6 }
    obj._shadow_size = 0
    obj._shadow_blur = 5
    obj._shadow_offset_x = 0
    obj._shadow_offset_y = 0

    return obj
end

--#endregion


--#region Setter

--- Define a cor de preenchimento.
--- @param color [number, number, number, number?] Cor de preenchimento.
function StyleBoxFlat:setFillColor(color)
    local old = self._fill_color

    self._fill_color = color

    if (
            self._fill_color[1] ~= old[1]
            or self._fill_color[2] ~= old[2]
            or self._fill_color[3] ~= old[3]
            or self._fill_color[4] ~= old[4]
        ) then
        self:_emit("CHANGED")
    end
end

--- Define se é para desenhar o centro.
--- @param enabled boolean Se é para desenhar o centro.
function StyleBoxFlat:setDrawCenter(enabled)
    local old = self._draw_center

    self._draw_center = enabled

    if self._draw_center ~= old then
        self:_emit("CHANGED")
    end
end

--- Define o skew x.
--- @param x number Skew x.
function StyleBoxFlat:setSkewX(x)
    local old = self._skew_x

    self._skew_x = x

    if self._skew_x ~= old then
        self:_emit("CHANGED")
    end
end

--- Define o skew y.
--- @param y number Skew y.
function StyleBoxFlat:setSkewX(y)
    local old = self._skew_y

    self._skew_y = y

    if self._skew_y ~= old then
        self:_emit("CHANGED")
    end
end

--- Define o skew.
--- @param x number Skew x.
--- @param y number Skew y.
function StyleBoxFlat:setSkew(x, y)
    local old_x, old_y = self._skew_x, self._skew_y

    self._skew_x = x
    self._skew_y = y

    if old_x ~= self._skew_x or old_y ~= self._skew_y then
        self:_emit("CHANGED")
    end
end

--- Define o tamanho da borda.
--- @param size number Tamanho da borda.
function StyleBoxFlat:setBorderSize(size)
    local old = self._border_size

    self._border_size = math.max(size, 0)

    if self._border_size ~= old then
        self:_emit("CHANGED")
    end
end

--- Define a cor da borda.
--- @param color [number, number, number, number?] Cor da borda.
function StyleBoxFlat:setBorderColor(color)
    local old = self._border_color

    self._border_color = color

    if (
            self._border_color[1] ~= old[1]
            or self._border_color[2] ~= old[2]
            or self._border_color[3] ~= old[3]
            or self._border_color[4] ~= old[4]
        ) then
        self:_emit("CHANGED")
    end
end

--- Define a mistura da borda. Se `true`, a cor da borda mescla com a cor de preenchimento.
--- @param enabled boolean Se a mistura está ativa.
function StyleBoxFlat:setBorderBlend(enabled)
    local old = self._border_blend

    self._border_blend = enabled

    if self._border_blend ~= old then
        self:_emit("CHANGED")
    end
end

--- Define o raio de um canto.
--- @param corner NodeUI.Control.Corner Canto do raio.
--- @param radius number                Raio do canto.
function StyleBoxFlat:setCornerRadius(corner, radius)
    local corner_key = "_corner_radius_" .. corner:lower()
    local old = self[corner_key]

    self[corner_key] = math.max(radius, 0)

    if self[corner_key] ~= old then
        self:_emit("CHANGED")
    end
end

--- Define a expansão da margem de determinado lado.
--- @param side NodeUI.Control.Side Lado da expansão de margem.
--- @param expand number            Valor da expansão de margem.
function StyleBoxFlat:setExpandMargin(side, expand)
    local margin_key = "_expand_margin_" .. side:lower()
    local old = self[margin_key]

    self[margin_key] = math.max(expand, 0)

    if self[margin_key] ~= old then
        self:_emit("CHANGED")
    end
end

--- Define a cor da sombra.
--- @param color [number, number, number, number?] Cor da sombra.
function StyleBoxFlat:setShadowColor(color)
    local old = self._shadow_color

    self._shadow_color = color

    if (
            self._shadow_color[1] ~= old[1]
            or self._shadow_color[2] ~= old[2]
            or self._shadow_color[3] ~= old[3]
            or self._shadow_color[4] ~= old[4]
        ) then
        self:_emit("CHANGED")
    end
end

--- Define o tamanho da sombra.
--- @param size number Tamanho da sombra.
function StyleBoxFlat:setShadowSize(size)
    local old = self._shadow_size

    self._shadow_size = math.max(size, 0)

    if self._shadow_size ~= old then
        self:_emit("CHANGED")
    end
end

--- Define o blur da sombra.
--- @param blur number Blur da sombra.
function StyleBoxFlat:setShadowBlur(blur)
    local old = self._shadow_blur

    self._shadow_blur = math.max(blur, 0)

    if self._shadow_blur ~= old then
        self:_emit("CHANGED")
    end
end

--- Define o offset x da sombra.
--- @param x number Offset x da sombra.
function StyleBoxFlat:setShadowOffsetX(x)
    local old = self._shadow_offset_x

    self._shadow_offset_x = x

    if self._shadow_offset_x ~= old then
        self:_emit("CHANGED")
    end
end

--- Define o offset y da sombra.
--- @param y number Offset y da sombra.
function StyleBoxFlat:setShadowOffsetY(y)
    local old = self._shadow_offset_y
    self._shadow_offset_y = y

    if self._shadow_offset_y ~= old then
        self:_emit("CHANGED")
    end
end

--- Define o offset da sombra.
--- @param x number Offset x da sombra.
--- @param y number Offset y da sombra.
function StyleBoxFlat:setShadowOffset(x, y)
    local old_x, old_y = self._shadow_offset_x, self._shadow_offset_y

    self._shadow_offset_x = x
    self._shadow_offset_y = y

    if self._shadow_offset_x ~= old_x or self._shadow_offset_y ~= old_y then
        self:_emit("CHANGED")
    end
end

--#endregion


--#region Getter

--- Retorna a cor de preenchimento.
--- @nodiscard
--- @return [number, number, number, number?] color Cor de preenchimento.
function StyleBoxFlat:getFillColor()
    return self._fill_color
end

--- Retorna se é para desenhar o centro.
--- @nodiscard
--- @return boolean enabled Se é para desenhar o centro.
function StyleBoxFlat:getDrawCenter()
    return self._draw_center
end

--- Retorna o skew x.
--- @nodiscard
--- @return number x Skew x.
function StyleBoxFlat:getSkewX()
    return self._skew_x
end

--- Retorna o skew y*.
--- @nodiscard
--- @return number y Skew y.
function StyleBoxFlat:getSkewX()
    return self._skew_y
end

--- Retorna o skew.
--- @nodiscard
--- @return number x Skew x.
--- @return number y Skew y.
function StyleBoxFlat:getSkew()
    return self._skew_x, self._skew_y
end

--- Retorna o tamanho da borda.
--- @nodiscard
--- @return number size Tamanho da borda.
function StyleBoxFlat:getBorderSize()
    return self._border_size
end

--- Retorna a cor da borda.
--- @nodiscard
--- @return [number, number, number, number?] color Cor da borda.
function StyleBoxFlat:getBorderColor()
    return self._border_color
end

--- Retorna a mistura da borda. Se `true`, a cor da borda mescla com a cor de preenchimento.
--- @nodiscard
--- @return boolean enabled Se a mistura está ativa.
function StyleBoxFlat:getBorderBlend()
    return self._border_blend
end

--- Retorna o raio de um canto.
--- @nodiscard
--- @param corner NodeUI.Control.Corner Canto do raio.
--- @return number radius               Raio do canto.
function StyleBoxFlat:getCornerRadius(corner)
    return self["_corner_radius_" .. corner:lower()]
end

--- Retorna a expansão da margem de determinado lado.
--- @nodiscard
--- @param side NodeUI.Control.Side Lado da expansão de margem.
--- @return number expand           Valor da expansão de margem.
function StyleBoxFlat:getExpandMargin(side)
    return self["_expand_margin_" .. side:lower()]
end

--- Retorna a cor da sombra.
--- @nodiscard
--- @return [number, number, number, number?] color Cor da sombra.
function StyleBoxFlat:getShadowColor()
    return self._shadow_color
end

--- Retorna o tamanho da sombra.
--- @nodiscard
--- @return number size Tamanho da sombra.
function StyleBoxFlat:getShadowSize()
    return self._shadow_size
end

--- Retorna o blur da sombra.
--- @nodiscard
--- @return number blur Blur da sombra.
function StyleBoxFlat:getShadowBlur()
    return self._shadow_blur
end

--- Retorna o offset x da sombra.
--- @nodiscard
--- @return number x Offset x da sombra.
function StyleBoxFlat:getShadowOffsetX()
    return self._shadow_offset_x
end

--- Retorna o offset y da sombra.
--- @nodiscard
--- @return number y Offset y da sombra.
function StyleBoxFlat:getShadowOffsetY()
    return self._shadow_offset_y
end

--- Retorna o offset da sombra.
--- @nodiscard
--- @return number x Offset x da sombra.
--- @return number y Offset y da sombra.
function StyleBoxFlat:getShadowOffset()
    return self._shadow_offset_x, self._shadow_offset_y
end

--#endregion


--#region Protected Callback

--- Chamado durante o desenho da **StyleBox**.
--- @protected
--- @param x number Poso
--- @param y number Posição y da **StyleBox**.
--- @param width number Comprimento da **StyleBox**
--- @param height number Altura da **StyleBox**.
--- @diagnostic disable-next-line: unused-local
function StyleBoxFlat:_onDraw(x, y, width, height)
    x = x - self._expand_margin_left
    y = y - self._expand_margin_top
    width = width + self._expand_margin_left + self._expand_margin_right
    height = height + self._expand_margin_top + self._expand_margin_bottom

    local default_shader = love.graphics.getShader()
    local shadow_blur = self._shadow_size == 0 and 0 or self._shadow_blur

    love.graphics.setShader(rectangle_shader)

    rectangle_shader:send("rectPos", { x, y })
    rectangle_shader:send("rectSize", { width, height })
    rectangle_shader:send("skew", { self._skew_x, self._skew_y })

    rectangle_shader:send("fillColor", self._fill_color)
    rectangle_shader:send("drawFill", self._draw_center)

    rectangle_shader:send("borderWidth", self._border_size)
    rectangle_shader:send("borderColor", self._border_color)
    rectangle_shader:send("smoothBorderTransition", self._border_blend)
    rectangle_shader:send("borderAlpha", 1)

    rectangle_shader:send("cornerRadius", {
        self._corner_radius_top_left,
        self._corner_radius_top_right,
        self._corner_radius_bottom_right,
        self._corner_radius_bottom_left
    })

    rectangle_shader:send("shadowColor", self._shadow_color)
    rectangle_shader:send("shadowWidth", self._shadow_size)
    rectangle_shader:send("shadowBlur", shadow_blur)
    rectangle_shader:send("shadowOffset", { self._shadow_offset_x, self._shadow_offset_y })

    local shadow_pad_x = self._shadow_size + shadow_blur + math.abs(self._shadow_offset_x)
    local shadow_pad_y = self._shadow_size + shadow_blur + math.abs(self._shadow_offset_y)

    local half_width = width / 2 + shadow_pad_x
    local half_height = height / 2 + shadow_pad_y

    local expanded_width, expanded_height = skewExpandedHalfSize(half_width, half_height, self._skew_x, self._skew_y)

    local pad_x = math.ceil(expanded_width - width / 2) + 4
    local pad_y = math.ceil(expanded_height - height / 2) + 4

    love.graphics.rectangle(
        "fill",
        x - pad_x,
        y - pad_y,
        width + pad_x * 2,
        height + pad_y * 2
    )

    love.graphics.setShader(default_shader)
end

--#endregion


return StyleBoxFlat
