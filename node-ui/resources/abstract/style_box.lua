local ROOT = (...):match("^(.*)%.[^.]+%.[^.]+$")       --- @type string

local Resource = require(ROOT .. ".abstract.resource") --- @type NodeUI.Resource

--- Recurso base para todas as variantes da **StyleBox**.
--- @class NodeUI.StyleBox: NodeUI.Resource
local StyleBox = Resource:extend("StyleBox")


--#region Public

--- Cria uma nova **StyleBox**.
--- @nodiscard
--- @return NodeUI.StyleBox StyleBox Nova **StyleBox**.
function StyleBox:new()
    local obj = Resource.new(self) --- @cast obj NodeUI.StyleBox
    return obj
end

--- Desenha a **StyleBox** no retângulo dado.
--- @param x number Posição x da **StyleBox**.
--- @param y number Posição y da **StyleBox**.
--- @param width number Comprimento da **StyleBox**
--- @param height number Altura da **StyleBox**.
function StyleBox:draw(x, y, width, height)
    self:_onDraw(x, y, width, height)
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
function StyleBox:_onDraw(x, y, width, height) end

--#endregion


return StyleBox
