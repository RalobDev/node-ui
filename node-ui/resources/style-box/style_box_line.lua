local ROOT = (...):match("^(.*)%."):match("^(.*)%."):match("^(.*)%.") --- @type string

local StyleBox = require(ROOT .. ".resources.abstract.style_box")     --- @type NodeUI.StyleBox
local Palette = require(ROOT .. ".palette")                           --- @type NodeUI.Palette

--- Uma **StyleBox** que exibe uma única linha.
--- @class NodeUI.StyleBoxLine: NodeUI.StyleBox
--- @field private _color number[]
--- @field private _grow_begin number
--- @field private _grow_end number
--- @field private _thickness number
--- @field private _side NodeUI.Control.Side
--- @field private _cap_begin NodeUI.StyleBoxLine.CapStyle
--- @field private _cap_end NodeUI.StyleBoxLine.CapStyle
local StyleBoxLine = StyleBox:extend("StyleBoxLine")


--#region Local

--- Desenha o limite de linha.
--- @param cap NodeUI.StyleBoxLine.CapStyle   Limite de linha.
--- @param thickness number                   Espessura da linha.
--- @param x number                           Posição x do limite.
--- @param y number                           Posição y do limite.
--- @param direction NodeUI.Control.Direction Direção do limite.
local function drawCap(cap, thickness, x, y, direction)
    local dx, dy = 0, 0
    if direction == "LEFT" then
        dx, dy = -1, 0
    elseif direction == "RIGHT" then
        dx, dy = 1, 0
    elseif direction == "UP" then
        dx, dy = 0, -1
    elseif direction == "DOWN" then
        dx, dy = 0, 1
    end

    if cap == "ROUNDED" then
        love.graphics.circle(
            "fill",
            x,
            y,
            thickness / 2
        )
    elseif cap == "SQUARE" or cap == "SQUARE_FILLED" then
        local mode = cap == "SQUARE_FILLED" and "fill" or "line"
        local size = thickness * (cap == "SQUARE_FILLED" and 3 or 2)

        love.graphics.rectangle(
            mode,
            x - size / 2 + (dx * size / 2),
            y - size / 2 + (dy * size / 2),
            size,
            size
        )
    elseif cap == "CIRCLE" or cap == "CIRCLE_FILLED" then
        local mode = cap == "CIRCLE_FILLED" and "fill" or "line"
        local size = thickness * (cap == "CIRCLE_FILLED" and 2.5 or 2)

        love.graphics.circle(
            mode,
            x + (dx * size / 2) + (dx * thickness),
            y + (dy * size / 2) + (dy * thickness),
            size
        )
    elseif cap == "DIAMOND" or cap == "DIAMOND_FILLED" then
        local mode = cap == "DIAMOND_FILLED" and "fill" or "line"
        local size = thickness * (cap == "DIAMOND_FILLED" and 2.5 or 2)
        local diagonal = size * math.sqrt(2)

        love.graphics.circle(
            mode,
            x + diagonal / 2 * dx,
            y + diagonal / 2 * dy,
            size,
            4
        )
    elseif cap == "ARROW" or cap == "ARROW_FILLED" then
        local lenght = thickness * (cap == "ARROW_FILLED" and 2.5 or 2)

        if cap == "ARROW_FILLED" then
            x = x + lenght * dx
            y = y + lenght * dy
        end

        local points = dx == 0
            and {
                x - lenght, y - lenght * dy,
                x, y,
                x + lenght, y - lenght * dy
            }
            or {
                x - lenght * dx, y - lenght,
                x, y,
                x - lenght * dx, y + lenght
            }

        if cap == "ARROW" then
            love.graphics.line(points)
        else
            love.graphics.polygon("fill", points)
        end
    end
end

--#endregion


--#region Public

--- Cria uma nova **StyleBoxLine**.
--- @nodiscard
--- @return NodeUI.StyleBoxLine StyleBoxLine Nova **StyleBoxLine**.
function StyleBoxLine:new()
    local obj = StyleBox.new(self) --- @cast obj NodeUI.StyleBoxLine

    obj._color = Palette:get("BORDER")
    obj._grow_begin = 0
    obj._grow_end = 0
    obj._thickness = 1
    obj._side = "TOP"
    obj._cap_begin = "BUTT"
    obj._cap_end = "BUTT"

    return obj
end

--#endregion


--#region Setter

--- Define a cor da linha.
--- @param color number[] Cor da linha.
function StyleBoxLine:setColor(color)
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
        self._signal:emit("CHANGED")
    end
end

--- Define o crescimento inicial da linha.
--- @param grow number Crescimento inicial.
function StyleBoxLine:setGrowBegin(grow)
    local old = self._grow_begin

    self._grow_begin = grow

    if self._grow_begin ~= old then
        self._signal:emit("CHANGED")
    end
end

--- Define o crescimento final da linha.
--- @param grow number Crescimento final.
function StyleBoxLine:setGrowEnd(grow)
    local old = self._grow_end

    self._grow_end = grow

    if self._grow_end ~= old then
        self._signal:emit("CHANGED")
    end
end

--- Define a espessura da linha.
--- @param thickness number Espessura da linha.
function StyleBoxLine:setThickness(thickness)
    local old = self._thickness

    self._thickness = math.max(thickness, 0)

    if self._thickness ~= old then
        self._signal:emit("CHANGED")
    end
end

--- Define o **`NodeUI.Control.Side`** que a linha é desenhada.
--- @param side NodeUI.Control.Side Lado que é desenhada.
function StyleBoxLine:setEdge(side)
    local old = self._side

    self._side = side

    if self._side ~= old then
        self._signal:emit("CHANGED")
    end
end

--- Define o **`NodeUI.StyleBoxLine.CapStyle`** do início da linha.
--- @param cap NodeUI.StyleBoxLine.CapStyle Limite do início da linha.
function StyleBoxLine:setCapBegin(cap)
    local old = self._cap_begin

    self._cap_begin = cap

    if self._cap_begin ~= old then
        self._signal:emit("CHANGED")
    end
end

--- Define o **`NodeUI.StyleBoxLine.CapStyle`** do final da linha.
--- @param cap NodeUI.StyleBoxLine.CapStyle Limite do final da linha.
function StyleBoxLine:setCapEnd(cap)
    local old = self._cap_end

    self._cap_end = cap

    if self._cap_end ~= old then
        self._signal:emit("CHANGED")
    end
end

--#endregion


--#region Getter

--- Retorna a cor da linha.
--- @nodiscard
--- @return number[] color Cor da linha.
function StyleBoxLine:getColor()
    return self._color
end

--- Retorna o crescimento inicial da linha.
--- @nodiscard
--- @return number grow Crescimento inicial.
function StyleBoxLine:getGrowBegin()
    return self._grow_begin
end

--- Retorna o crescimento final da linha.
--- @nodiscard
--- @return number grow Crescimento final.
function StyleBoxLine:getGrowEnd()
    return self._grow_end
end

--- Retorna a espessura da linha.
--- @nodiscard
--- @return number thickness Espessura da linha.
function StyleBoxLine:getThickness()
    return self._thickness
end

--- Retorna o **`NodeUI.Control.side`** que a linha é desenhada.
--- @nodiscard
--- @return NodeUI.Control.Side side Lado que é desenhada.
function StyleBoxLine:getEdge()
    return self._side
end

--- Retorna o **`NodeUI.StyleBoxLine.CapStyle`** do início da linha.
--- @nodiscard
--- @return NodeUI.StyleBoxLine.CapStyle cap Limite do início da linha.
function StyleBoxLine:getCapBegin()
    return self._cap_begin
end

--- Retorna o **`NodeUI.StyleBoxLine.CapStyle`** do final da linha.
--- @nodiscard
--- @return NodeUI.StyleBoxLine.CapStyle cap Limite do final da linha.
function StyleBoxLine:getCapEnd()
    return self._cap_end
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
function StyleBoxLine:_onDraw(x, y, width, height)
    love.graphics.setBackgroundColor(1, 1, 1)

    local grow_begin = self._grow_begin
    local grow_end = self._grow_end
    local begin_x, begin_y = 0, 0
    local end_x, end_y = 0, 0

    if self._side == "LEFT" then
        begin_x = x
        begin_y = y - grow_begin

        end_x = begin_x
        end_y = y + height + grow_end
    elseif self._side == "RIGHT" then
        begin_x = x + width
        begin_y = y - grow_begin

        end_x = begin_x
        end_y = y + height + grow_end
    elseif self._side == "TOP" then
        begin_x = x - grow_begin
        begin_y = y

        end_x = x + width + grow_end
        end_y = begin_y
    elseif self._side == "BOTTOM" then
        begin_x = x - grow_begin
        begin_y = y + height

        end_x = x + width + grow_end
        end_y = begin_y
    end

    local r, g, b, a = love.graphics.getColor()
    local prev_line_width = love.graphics.getLineWidth()

    love.graphics.setColor(self._color)
    love.graphics.setLineWidth(self._thickness)

    love.graphics.line(begin_x, begin_y, end_x, end_y)

    do
        local direction_begin, direction_end --- @type NodeUI.Control.Direction, NodeUI.Control.Direction

        if self._side == "LEFT" or self._side == "RIGHT" then
            if begin_y < end_y then
                direction_begin = "UP"
                direction_end = "DOWN"
            else
                direction_begin = "DOWN"
                direction_end = "UP"
            end
        elseif self._side == "TOP" or self._side == "BOTTOM" then
            if begin_x < end_x then
                direction_begin = "LEFT"
                direction_end = "RIGHT"
            else
                direction_begin = "RIGHT"
                direction_end = "LEFT"
            end
        end

        if direction_begin and direction_end then
            drawCap(self._cap_begin, self._thickness, begin_x, begin_y, direction_begin)
            drawCap(self._cap_end, self._thickness, end_x, end_y, direction_end)
        end
    end

    love.graphics.setLineWidth(prev_line_width)
    love.graphics.setColor(r, g, b, a)
end

--#endregion


return StyleBoxLine
