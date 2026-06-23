local ROOT = (...):match("^(.*)%.[^.]+%.[^.]+$")        --- @type string

local StyleBox = require(ROOT .. ".abstract.style_box") --- @type NodeUI.StyleBox

--- Uma **StyleBox** que exibe uma textura.
--- @class NodeUI.StyleBoxTexture: NodeUI.StyleBox
--- @field private _texture love.Image?
--- @field private _texture_margin_left number
--- @field private _texture_margin_right number
--- @field private _texture_margin_top number
--- @field private _texture_margin_bottom number
--- @field private _expand_margin_left number
--- @field private _expand_margin_right number
--- @field private _expand_margin_top number
--- @field private _expand_margin_bottom number
--- @field private _axis_stretch_horizontal NodeUI.StyleBoxTexture.AxisStretchMode
--- @field private _axis_stretch_vertical NodeUI.StyleBoxTexture.AxisStretchMode
--- @field private _sub_region_x number
--- @field private _sub_region_y number
--- @field private _sub_region_width number
--- @field private _sub_region_height number
--- @field private _color [number, number, number, number?]
--- @field private _draw_center boolean
local StyleBoxTexture = StyleBox:extend("StyleBoxTexture")


--#region Local

--- Desenha um segmento (Quad) da textura lidando com STRETCH, TILE e TILE_FIT.
--- @param texture love.Image
--- @param qx number X do Quad (Origem)
--- @param qy number Y do Quad (Origem)
--- @param qw number Largura do Quad
--- @param qh number Altura do Quad
--- @param dx number X do Destino
--- @param dy number Y do Destino
--- @param dw number Largura do Destino
--- @param dh number Altura do Destino
--- @param h_mode NodeUI.StyleBoxTexture.AxisStretchMode
--- @param v_mode NodeUI.StyleBoxTexture.AxisStretchMode
local function draw_section(texture, qx, qy, qw, qh, dx, dy, dw, dh, h_mode, v_mode)
    if qw == 0 or qh == 0 or dw <= 0 or dh <= 0 then return end

    local tex_w, tex_h = texture:getDimensions()

    -- Lida com coordenadas de origem negativas (geradas quando a margem esmaga o centro)
    local real_qx, real_qy = qx, qy
    local real_qw, real_qh = qw, qh
    local flip_x, flip_y = 1, 1

    if real_qw < 0 then
        real_qx = real_qx + real_qw
        real_qw = math.abs(real_qw)
        flip_x = -1
    end

    if real_qh < 0 then
        real_qy = real_qy + real_qh
        real_qh = math.abs(real_qh)
        flip_y = -1
    end

    -- Cria o Quad sempre com dimensões positivas. Se a borda for maior que a textura,
    -- o real_qw será maior que tex_w, e o LÖVE repetirá a textura automaticamente.
    local quad = love.graphics.newQuad(real_qx, real_qy, real_qw, real_qh, tex_w, tex_h)

    local scale_x, scale_y = 1, 1

    if h_mode == "TILE_FIT" then
        local count = math.max(1, math.floor((dw / real_qw) + 0.5))
        scale_x = dw / (real_qw * count)
    elseif h_mode == "STRETCH" then
        scale_x = dw / real_qw
    end

    if v_mode == "TILE_FIT" then
        local count = math.max(1, math.floor((dh / real_qh) + 0.5))
        scale_y = dh / (real_qh * count)
    elseif v_mode == "STRETCH" then
        scale_y = dh / real_qh
    end

    -- STRETCH Puro
    if h_mode == "STRETCH" and v_mode == "STRETCH" then
        local draw_x = dx + (flip_x == -1 and dw or 0)
        local draw_y = dy + (flip_y == -1 and dh or 0)
        love.graphics.draw(texture, quad, draw_x, draw_y, 0, scale_x * flip_x, scale_y * flip_y)
        return
    end

    -- TILE e TILE_FIT
    local step_x = real_qw * scale_x
    local step_y = real_qh * scale_y

    local cx, cy, cw, ch = love.graphics.getScissor()
    love.graphics.intersectScissor(dx, dy, dw, dh)

    for cur_y = 0, dh - 0.001, step_y do
        for cur_x = 0, dw - 0.001, step_x do
            local t_dx = dx + cur_x
            local t_dy = dy + cur_y

            -- Se for invertido, compensamos a posição inicial de desenho
            if flip_x == -1 then t_dx = t_dx + step_x end
            if flip_y == -1 then t_dy = t_dy + step_y end

            love.graphics.draw(texture, quad, t_dx, t_dy, 0, scale_x * flip_x, scale_y * flip_y)
        end
    end

    if cx then
        love.graphics.setScissor(cx, cy, cw, ch)
    else
        love.graphics.setScissor()
    end
end

--#endregion


--#region Public

--- Cria uma nova **StyleBoxTexture**.
--- @nodiscard
--- @param texture? love.Image                     Textura da **StyleBoxTexture**.
--- @return NodeUI.StyleBoxTexture StyleBoxTexture Nova **StyleBoxTexture**.
function StyleBoxTexture:new(texture)
    local obj = StyleBox.new(self) --- @cast obj NodeUI.StyleBoxTexture

    obj._texture = texture
    obj._texture_margin_left = 0
    obj._texture_margin_right = 0
    obj._texture_margin_top = 0
    obj._texture_margin_bottom = 0
    obj._expand_margin_left = 0
    obj._expand_margin_right = 0
    obj._expand_margin_top = 0
    obj._expand_margin_bottom = 0
    obj._axis_stretch_horizontal = "STRETCH"
    obj._axis_stretch_vertical = "STRETCH"
    obj._sub_region_x = 0
    obj._sub_region_y = 0
    obj._sub_region_width = 0
    obj._sub_region_height = 0
    obj._color = { 1, 1, 1, 1 }
    obj._draw_center = true

    return obj
end

--#endregion


--#region Setter

--- Define a textura.
--- @param texture love.Image Textura da **StyleBoxTexture**.
function StyleBoxTexture:setTexture(texture)
    local old = self._texture

    self._texture = texture

    if self._texture ~= old then
        self:_emit("CHANGED")
    end
end

--- Define a margem de um lado da textura.
--- @param side NodeUI.Control.Side Lado da margem.
--- @param margin number            Margem do lado.
function StyleBoxTexture:setTextureMargin(side, margin)
    local margin_key = "_texture_margin_" .. side:lower()
    local old = self[margin_key]

    self[margin_key] = math.max(margin, 0)

    if self[margin_key] ~= old then
        self:_emit("CHANGED")
    end
end

--- Define a expanção de um lado.
--- @param side NodeUI.Control.Side Lado da expansão.
--- @param expand number            Expansão do lado.
function StyleBoxTexture:setExpandMargin(side, expand)
    local expand_key = "_expand_margin_" .. side:lower()
    local old = self[expand_key]

    self[expand_key] = math.max(expand, 0)

    if self[expand_key] ~= old then
        self:_emit("CHANGED")
    end
end

--- Define a **`NodeUI.StyleBoxTexture.AxisStretchMode`**, que afeta a maneira como
--- a textura será exibida horizontal ou verticalmente.
--- @param axis NodeUI.Control.Axis                       Eixo do stretch.
--- @param stretch NodeUI.StyleBoxTexture.AxisStretchMode Stretch do eixo.
function StyleBoxTexture:setStretch(axis, stretch)
    local stretch_key = "_axis_stretch_" .. axis:lower()
    local old = self[stretch_key]

    self[stretch_key] = stretch

    if self[stretch_key] ~= old then
        self:_emit("CHANGED")
    end
end

--- Define a posição x da sub região da textura.
--- @param x number Posição x.
function StyleBoxTexture:setSubRegionX(x)
    local old = self._sub_region_x

    self._sub_region_x = x

    if self._sub_region_x ~= old then
        self:_emit("CHANGED")
    end
end

--- Define a posição y da sub região da textura.
--- @param y number Posição y.
function StyleBoxTexture:setSubRegionY(y)
    local old = self._sub_region_y

    self._sub_region_y = y

    if self._sub_region_y ~= old then
        self:_emit("CHANGED")
    end
end

--- Define a posição da sub região da textura.
--- @param x number Posição x.
--- @param y number Posição y.
function StyleBoxTexture:setSubRegionPosition(x, y)
    local old_x, old_y = self._sub_region_x, self._sub_region_y

    self._sub_region_x, self._sub_region_y = x, y

    if self._sub_region_x ~= old_x or self._sub_region_y ~= old_y then
        self:_emit("CHANGED")
    end
end

--- Define o comprimento da sub região da textura.
--- @param width number Comprimento.
function StyleBoxTexture:setSubRegionWidth(width)
    local old = self._sub_region_width

    self._sub_region_width = width

    if self._sub_region_width ~= old then
        self:_emit("CHANGED")
    end
end

--- Define a altura da sub região da textura.
--- @param height number Altura.
function StyleBoxTexture:setSubRegionHeight(height)
    local old = self._sub_region_height

    self._sub_region_height = height

    if self._sub_region_height ~= old then
        self:_emit("CHANGED")
    end
end

--- Define a dimensão da sub região da textura.
--- @param width number Comprimento.
--- @param height number Altura.
function StyleBoxTexture:setSubRegionDimensions(width, height)
    local old_width, old_height = self._sub_region_width, self._sub_region_height

    self._sub_region_width, self._sub_region_height = width, height

    if self._sub_region_width ~= old_width or self._sub_region_height ~= old_height then
        self:_emit("CHANGED")
    end
end

--- Define a cor da textura.
--- @param color [number, number, number, number?] Cor da textura.
function StyleBoxTexture:setColor(color)
    local old = self._color

    self._color = {
        color[1] or 1,
        color[2] or 1,
        color[3] or 1,
        color[4] or 1
    }

    if (
            self._color[1] ~= old[1]
            or self._color[2] ~= old[2]
            or self._color[3] ~= old[3]
            or self._color[4] ~= old[4]
        ) then
        self:_emit("CHANGED")
    end
end

--- Define se o centro deve ser desenhado.
--- @param enabled boolean Se o centro da **StyleBoxTexture** deve ser desenhado.
function StyleBoxTexture:setDrawCenter(enabled)
    local old = self._draw_center

    self._draw_center = enabled

    if self._draw_center ~= old then
        self:_emit("CHANGED")
    end
end

--#endregion


--#region Getter

--- Retorna a textura.
--- @return love.Image texture  Textura da **StyleBoxTexture**.
function StyleBoxTexture:getTexture()
    return self._texture
end

--- Retorna a margem de um lado da textura.
--- @param side NodeUI.Control.Side Lado da margem.
--- @return number margin           Margem do lado.
function StyleBoxTexture:getTextureMargin(side)
    local margin_key = "_texture_margin_" .. side:lower()
    return self[margin_key]
end

--- Retorna a expanção de um lado.
--- @param side NodeUI.Control.Side Lado da expansão.
--- @return number expand           Expansão do lado.
function StyleBoxTexture:getExpandMargin(side)
    local expand_key = "_expand_margin_" .. side:lower()
    return self[expand_key]
end

--- Retorna a **`NodeUI.StyleBoxTexture.AxisStretchMode`**, que afeta a maneira como
--- a textura será exibida horizontal ou verticalmente.
--- @param axis NodeUI.Control.Axis                        Eixo do stretch.
--- @return NodeUI.StyleBoxTexture.AxisStretchMode stretch Stretch do eixo.
function StyleBoxTexture:getStretch(axis)
    local stretch_key = "_axis_stretch_" .. axis:lower()
    return self[stretch_key]
end

--- Retorna a posição x da sub região da textura.
--- @return number x Posição x.
function StyleBoxTexture:getSubRegionX()
    return self._sub_region_x
end

--- Retorna a posição y da sub região da textura.
--- @return number y Posição y.
function StyleBoxTexture:getSubRegionY()
    return self._sub_region_y
end

--- Retorna a posição da sub região da textura.
--- @return number x Posição x.
--- @return number y Posição y.
function StyleBoxTexture:getSubRegionPosition()
    return self._sub_region_x, self._sub_region_y
end

--- Retorna o comprimento da sub região da textura.
--- @return number width Comprimento.
function StyleBoxTexture:getSubRegionWidth()
    return self._sub_region_width
end

--- Retorna a altura da sub região da textura.
--- @return number height Altura.
function StyleBoxTexture:getSubRegionHeight()
    return self._sub_region_height
end

--- Retorna a dimensão da sub região da textura.
--- @return number width Comprimento.
--- @return number height Altura.
function StyleBoxTexture:getSubRegionDimensions()
    return self._sub_region_width, self._sub_region_height
end

--- Retorna a cor da textura.
--- @return [number, number, number, number?] color Cor da textura.
function StyleBoxTexture:getColor()
    return self._color
end

--- Retorna se o centro deve ser desenhado.
--- @return boolean enabled Se o centro da **StyleBoxTexture** deve ser desenhado.
function StyleBoxTexture:getDrawCenter()
    return self._draw_center
end

--#endregion


--#region Protected Callback

--- Chamado durante o desenho da **StyleBox**.
--- @protected
--- @param x number Posição x da **StyleBox**.
--- @param y number Posição y da **StyleBox**.
--- @param width number Comprimento da **StyleBox**
--- @param height number Altura da **StyleBox**.
function StyleBoxTexture:_onDraw(x, y, width, height)
    if not self._texture then return end

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self._color[1], self._color[2], self._color[3], self._color[4] or 1)

    -- Margens de Expansão.
    local dx = x - self._expand_margin_left
    local dy = y - self._expand_margin_top
    local dw = width + self._expand_margin_left + self._expand_margin_right
    local dh = height + self._expand_margin_top + self._expand_margin_bottom

    -- Sub-região / Dimensões Base.
    local sx, sy, sw, sh
    if self._sub_region_width > 0 and self._sub_region_height > 0 then
        sx, sy = self._sub_region_x, self._sub_region_y
        sw, sh = self._sub_region_width, self._sub_region_height
    else
        sx, sy = 0, 0
        sw, sh = self._texture:getDimensions()
    end

    local margin_left = math.min(self._texture_margin_left, self._texture:getWidth() - 1)
    local margin_right = math.min(self._texture_margin_right, self._texture:getWidth() - 1)
    local margin_top = math.min(self._texture_margin_top, self._texture:getHeight() - 1)
    local margin_bottom = math.min(self._texture_margin_bottom, self._texture:getHeight() - 1)

    do
        local half_width = self._texture:getWidth() / 2
        local half_height = self._texture:getHeight() / 2

        if margin_left == half_width and margin_right == half_width then
            margin_left = half_width - 1
            margin_right = half_width
        end
        if margin_top == half_height and margin_bottom == half_height then
            margin_top = half_height - 1
            margin_bottom = half_height
        end
    end

    local ml, mr = margin_left, margin_right
    local mt, mb = margin_top, margin_bottom

    -- Limites de DESTINO (Proteção da Tela).
    local d_ml, d_mr, d_mt, d_mb = ml, mr, mt, mb

    if d_ml + d_mr > dw then
        local factor = dw / (d_ml + d_mr)
        d_ml = d_ml * factor
        d_mr = d_mr * factor
    end

    if d_mt + d_mb > dh then
        local factor = dh / (d_mt + d_mb)
        d_mt = d_mt * factor
        d_mb = d_mb * factor
    end

    -- Math do Nine-Patch Grid.
    -- Origem (Sem limite de matemática, permitindo centros negativos / Wrap).
    local src_x = { sx, sx + ml, sx + sw - mr }
    local src_w = { ml, sw - ml - mr, mr }
    local src_y = { sy, sy + mt, sy + sh - mb }
    local src_h = { mt, sh - mt - mb, mb }

    -- Destino (Clampado para caber no tamanho final gerado em tela)
    local dst_x = { dx, dx + d_ml, dx + dw - d_mr }
    local dst_w = { d_ml, dw - d_ml - d_mr, d_mr }
    local dst_y = { dy, dy + d_mt, dy + dh - d_mb }
    local dst_h = { d_mt, dh - d_mt - d_mb, d_mb }

    local h_modes = { "STRETCH", self._axis_stretch_horizontal, "STRETCH" }
    local v_modes = { "STRETCH", self._axis_stretch_vertical, "STRETCH" }

    -- 5. Desenha as 9 partes.
    for row = 1, 3 do
        for col = 1, 3 do
            local is_center = (row == 2 and col == 2)
            if not (is_center and not self._draw_center) then
                draw_section(
                    self._texture,
                    src_x[col], src_y[row], src_w[col], src_h[row],
                    dst_x[col], dst_y[row], dst_w[col], dst_h[row],
                    h_modes[col], v_modes[row]
                )
            end
        end
    end

    love.graphics.setColor(r, g, b, a)
end

--#endregion


return StyleBoxTexture
