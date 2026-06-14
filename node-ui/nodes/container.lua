local ROOT = (...):match("^(.*)%.")

local Control = require(ROOT .. ".control") --- @type NodeUI.Control

--- @class NodeUI.Container: NodeUI.Control
--- @field private _queued_for_update_children_layout boolean Marca se é para atualizar o layout de seus filhos.
local Container = Control:extend("Container")


--#region Public

--- Cria um novo **`Container`**.
--- @param x number Posição horizontal
--- @param y number Posição vertical
--- @param width number Comprimento em pixels
--- @param height number Altura em pixels
--- @return NodeUI.Control Control
function Container:new(x, y, width, height)
    local obj = Control.new(self, x, y, width, height) --- @cast obj NodeUI.Container

    return obj
end

--#endregion


--#region Override

--- Cria uma conexão em determinado sinal do **`Control`**.
--- @param signal NodeUI.Container.Signals
--- @param owner table Objeto dono do método da conexão que será passado como primeiro parâmetro do método.
--- @param method string Método chamado ao sinal ser emitido.
function Container:connect(signal, owner, method)
    Control.connect(self, signal, owner, method)
end

--- Desconecta o `method` do `signal`.
--- @param signal NodeUI.Container.Signals
--- @param method string Método chamado ao sinal ser emitido.
function Container:disconnect(signal, method)
    Control.disconnect(self, signal, method)
end

--#endregion


--#region Protected

--- Atualiza o layout dos filhos.
--- @protected
function Container:_updateChildrenLayout()
end

--- Marca o **`Container`** para atualizar o layout de seus filhos.
--- @protected
function Container:_queueUpdateChildrenLayout()
    if self._queued_for_update_children_layout then
        return
    end

    self._queued_for_update_children_layout = true
end

--#endregion


--#region Protected Callback

--- Chamado durante a atualização do **`Control`**.
--- @protected
--- @param dt number
--- @diagnostic disable-next-line: unused-local
function Container:_onUpdate(dt)
    if self._queued_for_update_children_layout then
        self._queued_for_update_children_layout = false
        self:_updateChildrenLayout()
    end
end

--#endregion


return Container
