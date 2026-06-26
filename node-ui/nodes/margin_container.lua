local ROOT = (...):match("^(.*)%.")

local Container = require(ROOT .. ".container") --- @type NodeUI.Container

--- O **MarginContainer** permite criar uma margem ao redor dos filhos.
--- @class NodeUI.MarginContainer: NodeUI.Container
--- @field private _margin_left number
--- @field private _margin_right number
--- @field private _margin_top number
--- @field private _margin_bottom number
local MarginContainer = Container:extend("MarginContainer")


--#region Public

--- Cria um novo **MarginContainer**.
--- @nodiscard
--- @param x number 			                   Posição horizontal.
--- @param y number 			                   Posição vertical.
--- @param width number 		                   Comprimento em pixels.
--- @param height number 		                   Altura em pixels.
--- @param is_minimum? boolean                     Se a dimensão passada é a mínima.
--- @return NodeUI.MarginContainer MarginContainer Novo **MarginContainer**.
function MarginContainer:new(x, y, width, height, is_minimum)
    local obj = Container.new(self, x, y, width, height, is_minimum) --- @cast obj NodeUI.MarginContainer

    obj._margin_left = 0
    obj._margin_right = 0
    obj._margin_top = 0
    obj._margin_bottom = 0

    return obj
end

--#endregion


--#region Override

--- Cria uma conexão em determinado **`NodeUI.MarginContainer.Signals`** do **MarginContainer**.
--- @param signal NodeUI.MarginContainer.Signals Nome do sinal.
--- @param method string|function                Nome do método ou método chamado ao sinal ser emitido.
--- @param owner? table                          Objeto dono do método.
function MarginContainer:connect(signal, method, owner)
    Container.connect(self, signal, method, owner)
end

--- Remove a conexão de um **`NodeUI.MarginContainer.Signals`** do **MarginContainer**.
--- @param signal NodeUI.MarginContainer.Signals Nome do sinal.
--- @param method string|function                Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                          Objeto dono do método.
function MarginContainer:disconnect(signal, method, owner)
    Container.disconnect(self, signal, method, owner)
end

--#endregion


--#region Setter

--- Define a margem de um lado do **MarginContainer**.
--- @param side NodeUI.Control.Side Lado da margem.
--- @param margin number Margem do lado.
function MarginContainer:setMargin(side, margin)
    local margin_key = "_margin_" .. side:lower()
    local old = self[margin_key]

    self[margin_key] = margin

    if self[margin_key] ~= old then
        self:_updateChildrenLayout()
    end
end

--#endregion


--#region Getter

--- Define a margem de um lado do **MarginContainer**.
--- @nodiscard
--- @param side NodeUI.Control.Side Lado da margem.
--- @return number margin Margem do lado.
function MarginContainer:getMargin(side)
    return self["_margin_" .. side:lower()]
end

--#endregion


--#region Protected

--- Retorna o retângulo formado pelas margens do **MarginContainer**.
--- @protected
--- @return number x
--- @return number y
--- @return number width
--- @return number height
function MarginContainer:_getMarginRect()
    local x = self._layout_x + self._margin_left
    local y = self._layout_y + self._margin_top

    local width = math.max(
        0,
        self._layout_width
        - self._margin_left
        - self._margin_right
    )

    local height = math.max(
        0,
        self._layout_height
        - self._margin_top
        - self._margin_bottom
    )

    return x, y, width, height
end

--#endregion


--#region Override Protected

--- Calcula o comprimento mínimo baseando-se nos filhos.
--- @protected
--- @return number width
function MarginContainer:_calculateMinimumWidth()
    local min_width = 0
    for _, child in ipairs(self:getChildren(true)) do
        min_width = math.max(min_width, child:getMinimumWidth())
    end

    -- O tamanho mínimo horizontal é o mínimo do filho MAIS as margens esquerda e direita
    return min_width + self._margin_left + self._margin_right
end

--- Calcula a altura mínima baseando-se nos filhos.
--- @protected
--- @return number height
function MarginContainer:_calculateMinimumHeight()
    local min_height = 0
    for _, child in ipairs(self:getChildren(true)) do
        min_height = math.max(min_height, child:getMinimumHeight())
    end

    -- O tamanho mínimo vertical é o mínimo do filho MAIS as margens topo e base
    return min_height + self._margin_top + self._margin_bottom
end

--- Atualiza o layout dos filhos.
--- @protected
function MarginContainer:_updateChildrenLayout()
    local x, y, width, height = self:_getMarginRect()

    for _, child in ipairs(self:getChildren(true)) do
        child._layout_width, child._layout_height = child:getMinimumDimensions()

        local size_flags_h = child:getSizeFlags("HORIZONTAL")
        local size_flags_v = child:getSizeFlags("VERTICAL")

        if size_flags_h == "FILL" or size_flags_h == "EXPAND" then
            child._layout_x = x
            child._layout_width = width
        elseif size_flags_h == "SHRINK_BEGIN" then
            child._layout_x = x
        elseif size_flags_h == "SHRINK_CENTER" then
            child._layout_x = x + width / 2 - child._layout_width / 2
        elseif size_flags_h == "SHRINK_END" then
            child._layout_x = x + width - child._layout_width
        end

        if size_flags_v == "FILL" or size_flags_v == "EXPAND" then
            child._layout_y = y
            child._layout_height = height
        elseif size_flags_v == "SHRINK_BEGIN" then
            child._layout_y = y
        elseif size_flags_v == "SHRINK_CENTER" then
            child._layout_y = y + height / 2 - child._layout_height / 2
        elseif size_flags_v == "SHRINK_END" then
            child._layout_y = y + height - child._layout_height
        end
    end
end

--#endregion


--#region Protected Callback

--- Chamado durante a depuração do **Control**.
---
--- Este método deve ser sobreescrito em cada classe de **Control**, pois
--- é responsável por desenhar a depuração dela.
--- @protected
function MarginContainer:_onDrawDebug()
    Container._onDrawDebug(self)

    love.graphics.setColor(0.8, 0.0, 0.8, 1.0)
    love.graphics.rectangle("line", self:_getMarginRect())
end

--#endregion


return MarginContainer
