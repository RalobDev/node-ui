local ROOT = (...):match("^(.*)%.")         --- @type string

local Control = require(ROOT .. ".control") --- @type NodeUI.Control

--- Desenha um retângulo preenchido com uma cor sólida.
--- @class NodeUI.ColorRect: NodeUI.Control
--- @field private _color [number, number, number, number?]
local ColorRect = Control:extend("ColorRect")


--#region Public

--- Cria um novo **ColorRect**.
--- @param x number 			       Posição horizontal.
--- @param y number 			       Posição vertical.
--- @param width number 		       Comprimento em pixels.
--- @param height number 		       Altura em pixels.
--- @return NodeUI.ColorRect ColorRect Novo **ColorRect**.
function ColorRect:new(x, y, width, height)
    local obj = Control.new(self, x, y, width, height) --- @cast obj NodeUI.ColorRect
    return obj
end

--#endregion


--#region Override

--- Cria uma conexão em determinado **`NodeUI.ColorRect.Signals`** do **ColorRect**.
--- @param signal NodeUI.ColorRect.Signals Nome do sinal.
--- @param method string|function          Nome do método ou método chamado ao sinal ser emitido.
--- @param owner? table                    Objeto dono do método.
function ColorRect:connect(signal, method, owner)
    Control.connect(self, signal, method, owner)
end

--- Remove a conexão de um **`NodeUI.ColorRect.Signals`** do **ColorRect**.
--- @param signal NodeUI.ColorRect.Signals Nome do sinal.
--- @param method string|function          Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                    Objeto dono do método.
function ColorRect:disconnect(signal, method, owner)
    Control.disconnect(self, signal, method, owner)
end

--#endregion


--#region Setter

--- Define a cor de preenchimento do **ColorRect**.
--- @param color [number, number, number, number?] Cor de preenchimento.
function ColorRect:setColor(color)
    self._color = {
        color[1] or 1,
        color[2] or 1,
        color[3] or 1
    }
end

--#endregion


--#region Getter

--- Retorna a cor de preenchimento do **ColorRect**.
--- @nodiscard
--- @return [number, number, number, number?] color Cor de preenchimento.
function ColorRect:getColor()
    return self._color
end

--#endregion


--#region Protected Callback

--- Chamado durante o desenho do **Control**.
--- @protected
function ColorRect:_onDraw()
    local default_color = { love.graphics.getColor() }
    love.graphics.setColor(self._color)

    love.graphics.rectangle("fill", self._layout_x, self._layout_y, self._width, self._height)

    love.graphics.setColor(default_color)
end

--#endregion


return ColorRect
