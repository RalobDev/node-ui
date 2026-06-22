local ROOT = (...):match("^(.*)%.")

local Container = require(ROOT .. ".container") --- @type NodeUI.Container

--- O **CenterContainer** centraliza seus filhos.
---
--- ## Descrição
---
--- A centralização dos filhos pode acontecer no centro do próprio **CenterContainer** ou no seu canto superior esquerdo.
--- Para alterar entre os dois modos use `NodeUI.CenterContainer:setUseTopLeft()`.
--- @class NodeUI.CenterContainer: NodeUI.Container
--- @field private _use_top_left boolean
local CenterContainer = Container:extend("CenterContainer")


--#region Public

--- Cria um novo **CenterContainer**.
--- @param x number 			                   Posição horizontal.
--- @param y number 			                   Posição vertical.
--- @param width number 		                   Comprimento em pixels.
--- @param height number 		                   Altura em pixels.
--- @return NodeUI.CenterContainer CenterContainer Novo **CenterContainer**.
function CenterContainer:new(x, y, width, height)
    local obj = Container.new(self, x, y, width, height) --- @cast obj NodeUI.CenterContainer
    return obj
end

--#endregion


--#region Override

--- Cria uma conexão em determinado **`NodeUI.CenterContainer.Signals`** do **CenterContainer**.
--- @param signal NodeUI.CenterContainer.Signals Nome do sinal.
--- @param method string|function                Nome do método ou método chamado ao sinal ser emitido.
--- @param owner? table                          Objeto dono do método.
function CenterContainer:connect(signal, method, owner)
    return Container.connect(self, signal, method, owner)
end

--- Remove a conexão de um **`NodeUI.CenterContainer.Signals`** do **CenterContainer**.
--- @param signal NodeUI.CenterContainer.Signals Nome do sinal.
--- @param method string|function                Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                          Objeto dono do método.
function CenterContainer:disconnect(signal, method, owner)
    Container.disconnect(self, signal, method, owner)
end

--#endregion


--#region Setter

--- Define se o **CenterContainer** deve centralizar os seus filhos no topo esquerdo ou não. Por padrão ativa a centralização
--- no topo esquerdo.
--- @param enabled? boolean Se é para ativar a centralização no topo esquerdo.
function CenterContainer:setUseTopLeft(enabled)
    if enabled == nil then
        enabled = true
    end

    self._use_top_left = enabled
    self:_queueUpdateChildrenLayout()
end

--#endregion


--#region Getter

--- Retorna se o **CenterContainer** centraliza os seus filhos no topo esquerdo ou não.
--- @return boolean use_top_left Se a centralização no topo esquerdo está ativada.
function CenterContainer:getUseTopLeft()
    return self._use_top_left
end

--#endregion


--#region Override Protected

--- Atualiza o layout dos filhos.
--- @protected
function CenterContainer:_updateChildrenLayout()
    local origin_x = self._layout_x
    local origin_y = self._layout_y

    -- Centraliza a origem caso não deva centralizar os filhos no topo esquerdo.
    if not self._use_top_left then
        origin_x = origin_x + self._layout_width / 2
        origin_y = origin_y + self._layout_height / 2
    end

    for _, child in ipairs(self:getChildren(true)) do
        child._layout_x = origin_x - child._layout_width / 2
        child._layout_y = origin_y - child._layout_height / 2
    end
end

--#endregion


return CenterContainer
