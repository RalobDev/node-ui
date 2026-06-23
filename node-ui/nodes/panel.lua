local ROOT = (...):match("^(.*)%.")                                               --- @type string

local Control = require(ROOT .. ".control")                                       --- @type NodeUI.Control
local StyleBoxFlat = require(ROOT:match("(.+)%.") .. ".resources.style_box_flat") --- @type NodeUI.StyleBox

--- Um **`Control`** que exibe uma **`StyleBox`**.
--- @class NodeUI.Panel: NodeUI.Control
--- @field private _style_box NodeUI.StyleBox
local Panel = Control:extend("Panel")


--#region Public

--- Cria um novo **Panel**.
--- @param x number 		   Posição horizontal.
--- @param y number 		   Posição vertical.
--- @param width number 	   Comprimento em pixels.
--- @param height number 	   Altura em pixels.
--- @return NodeUI.Panel Panel Novo **Panel**.
function Panel:new(x, y, width, height)
    local obj = Control.new(self, x, y, width, height) --- @cast obj NodeUI.Panel

    obj._style_box = StyleBoxFlat:new()

    return obj
end

--#endregion


--#region Override

--- Cria uma conexão em determinado **`NodeUI.Panel.Signals`** do **Panel**.
--- @param signal NodeUI.Panel.Signals Nome do sinal.
--- @param method string|function      Nome do método ou método chamado ao sinal ser emitido.
--- @param owner? table                Objeto dono do método.
function Panel:connect(signal, method, owner)
    Control.connect(self, signal, method, owner)
end

--- Remove a conexão de um **`NodeUI.Panel.Signals`** do **Panel**.
--- @param signal NodeUI.Panel.Signals Nome do sinal.
--- @param method string|function      Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                Objeto dono do método.
function Panel:disconnect(signal, method, owner)
    Control.disconnect(self, signal, method, owner)
end

--#endregion


--#region Setter

--- Define a **`StyleBox`** do **Panel**.
--- @param style_box NodeUI.StyleBox **`StyleBox`**.
function Panel:setStyleBox(style_box)
    self._style_box = style_box
end

--#endregion


--#region Getter

--- Retorna a **`StyleBox`** do **Panel**.
--- @nodiscard
--- @return NodeUI.StyleBox style_box **`StyleBox`**.
function Panel:getStyleBox()
    return self._style_box
end

--#endregion


--#region Protected Callback

--- Chamado durante o desenho do **Control**.
--- @protected
function Panel:_onDraw()
    self._style_box:draw(self._layout_x, self._layout_y, self._layout_width, self._layout_height)
end

--#endregion


return Panel
