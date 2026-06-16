local ROOT = (...):match("^(.*)%.")         --- @type string

local Control = require(ROOT .. ".control") --- @type NodeUI.Control

--- **Container** é um tipo de **`Control`** responsável por agrupar outros nós e gerenciar
--- o layout e atualização dos seus filhos dentro da hierarquia do **`NodeUI`**.
---
--- ## Descrição
---
--- O **Container** estende **Control** adicionando suporte a organização de filhos e
--- controle de layout.
---
--- Classes derivadas podem sobrescrever `_updateChildrenLayout()` para implementar
--- comportamentos específicos de posicionamento e organização dos elementos filhos.
--- @class NodeUI.Container: NodeUI.Control
--- @field private _queued_for_update_children_layout boolean
local Container = Control:extend("Container")


--#region Public

--- Cria um novo **Container**.
--- @param x number 			       Posição horizontal.
--- @param y number 			       Posição vertical.
--- @param width number 		       Comprimento em pixels.
--- @param height number 		       Altura em pixels.
--- @return NodeUI.Container Container Novo **Container**.
function Container:new(x, y, width, height)
    local obj = Control.new(self, x, y, width, height) --- @cast obj NodeUI.Container
    return obj
end

--#endregion


--#region Override

--- Cria uma conexão em determinado sinal do **`Control`**.
--- @param signal NodeUI.Control.Signals Nome do sinal.
--- @param owner table                   Objeto dono do método.
--- @param method string                 Nome do método chamado ao sinal ser emitido.
function Container:connect(signal, owner, method)
    Control.connect(self, signal, owner, method)
end

--- Desconecta o `method` do `signal`.
--- @param signal NodeUI.Control.Signals Nome do sinal.
--- @param method string             	 Nome do método chamado ao sinal ser emitido.
function Container:disconnect(signal, method)
    Control.disconnect(self, signal, method)
end

--#endregion


--#region Protected

--- Atualiza o layout dos filhos.
--- @protected
function Container:_updateChildrenLayout()
end

--- Marca o **Container** para atualizar o layout de seus filhos.
--- @protected
function Container:_queueUpdateChildrenLayout()
    if self._queued_for_update_children_layout then
        return
    end

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

--#endregion


return Container
