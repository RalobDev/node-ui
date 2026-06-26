local ROOT = (...):match("^(.*)%.")                         --- @type string

local Control = require(ROOT:match("(.+)%.") .. ".control") --- @type NodeUI.Control

--- **Container** é um tipo de **`Control`** responsável por agrupar outros nós e gerenciar
--- o layout e atualização dos seus filhos dentro da hierarquia do **`NodeUI`**.
---
--- ## Descrição
---
--- O **Container** estende **`Control`** adicionando suporte a organização de filhos e
--- controle de layout.
--- @class NodeUI.Container: NodeUI.Control
--- @field private _queued_for_update_children_layout boolean
local Container = Control:extend("Container")


--#region Public

--- Cria um novo **Container**.
--- @nodiscard
--- @param x number 			       Posição horizontal.
--- @param y number 			       Posição vertical.
--- @param width number 		       Comprimento em pixels.
--- @param height number 		       Altura em pixels.
--- @param is_minimum? boolean         Se a dimensão passada é a mínima.
--- @return NodeUI.Container Container Novo **Container**.
function Container:new(x, y, width, height, is_minimum)
    local obj = Control.new(self, x, y, width, height, is_minimum) --- @cast obj NodeUI.Container
    return obj
end

--#endregion


--#region Override

--- Cria uma conexão em determinado **`NodeUI.Container.Signals`** do **Container**.
--- @param signal NodeUI.Container.Signals Nome do sinal.
--- @param method string|function          Nome do método ou método chamado ao sinal ser emitido.
--- @param owner? table                    Objeto dono do método.
function Container:connect(signal, method, owner)
    Control.connect(self, signal, method, owner)
end

--- Remove a conexão de um **`NodeUI.Container.Signals`** do **Container**.
--- @param signal NodeUI.Container.Signals Nome do sinal.
--- @param method string|function          Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                    Objeto dono do método.
function Container:disconnect(signal, method, owner)
    Control.disconnect(self, signal, method, owner)
end

--#endregion


--#region Protected

--- Calcula o comprimento mínimo baseando-se nos filhos.
--- @protected
--- @return number width
function Container:_calculateMinimumWidth()
    local min_width = 0
    for _, child in ipairs(self:getChildren(true)) do
        min_width = math.max(min_width, child:getMinimumWidth())
    end
    return min_width
end

--- Calcula a altura mínima baseando-se nos filhos.
--- @protected
--- @return number height
function Container:_calculateMinimumHeight()
    local min_height = 0
    for _, child in ipairs(self:getChildren(true)) do
        min_height = math.max(min_height, child:getMinimumHeight())
    end
    return min_height
end

--- Atualiza o layout dos filhos.
--- @protected
function Container:_updateChildrenLayout() end

--- Marca o **Container** para atualizar o layout de seus filhos.
--- @protected
function Container:_queueUpdateChildrenLayout()
    self._queued_for_update_children_layout = true
end

--#endregion


--#region Protected Callback

--- Chamado durante a atualização do **Control**.
--- @protected
--- @param dt number Tempo decorrido desde a última atualização.
--- @diagnostic disable-next-line: unused-local
function Container:_onUpdate(dt)
    if self._queued_for_update_children_layout then
        self._queued_for_update_children_layout = false
        self:_updateChildrenLayout()
    end
end

--- Chamado durante a atualização do layout do **Control**.
--- @protected
function Container:_onUpdateLayout()
    Control._onUpdateLayout(self)
    self:_queueUpdateChildrenLayout()
end

--#endregion


return Container
