local ROOT = (...):match("^(.*)%.%w+%.%w+$") --- @type string

local Class = require(ROOT .. ".class")      --- @type Class
local Signal = require(ROOT .. ".abstract.signal")

--- Classe base para todos os recursos dos nós.
---
--- ## Descrição
---
--- Os recursos funcionam unicamente como portadores de dados e não devem ter conhecimento a que
--- nó pertencem.
--- @class NodeUI.Resource: Class
--- @field _signal NodeUI.Signal
local Resource = Class:extend("Resource")


--#region Public

--- Cria um novo **Resource**.
--- @nodiscard
--- @return NodeUI.Resource Resource Novo **Resource**.
function Resource:new()
    local obj = Class.new(self) --- @cast obj NodeUI.Resource

    obj._signal = Signal:new()

    return obj
end

--- Cria uma conexão em determinado sinal do **Resource**.
---
--- O `owner` é a tabela que possui o `method`, que deve ser uma `string`. Caso não seja passado um `owner`, o `method`
--- deve ser uma `function`.
---
--- Quando é passado um `owner` o método é chamado desta forma: `owner.method(owner, ...)` para respeitar o padrão `self`.
--- @param signal NodeUI.Resource.Signals Nome do sinal.
--- @param method string|function        Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                  Objeto dono do método.
function Resource:connect(signal, method, owner)
    self._signal:connect(signal, method, owner)
end

--#endregion


--#region Protected

--- Emite o `signal`, chamando todos os seus métodos.
--- @protected
--- @param signal NodeUI.Resource.Signals Nome do sinal.
--- @param ... any Retornos do sinal.
function Resource:_emit(signal, ...)
    self._signal:emit(signal, ...)
end

--#endregion


return Resource
