local ROOT = (...):match("^(.*)%.%w+%.%w+$") --- @type string

local Class = require(ROOT .. ".class")      --- @type Class

--- Representa a conexão de um sinal no **`Control`**.
--- @class NodeUI.Signal.Connection
--- @field method string|function Nome do método chamado quando o sinal é emitido.
--- @field owner? table           Objeto dono do método.

--- @class NodeUI.Signal: Class
--- @field private _signal_connections table<string, NodeUI.Signal.Connection>
local Signal = Class:extend("Signals")

--#region Public

--- Cria um no **Signal**.
--- @nodiscard
--- @return NodeUI.Signal Signal Novo **Signal**.
function Signal:new()
    local obj = Class.new(self) --- @cast obj NodeUI.Signal

    obj._signal_connections = {}

    return obj
end

--- Cria uma conexão em determinado sinal.
---
--- O `owner` é a tabela que possui o `method`, que deve ser uma `string`. Caso não seja passado um `owner`, o `method`
--- deve ser uma `function`.
---
--- Quando é passado um `owner` o método é chamado desta forma: `owner.method(owner, ...)` para respeitar o padrão `self`.
--- @param signal string                 Nome do sinal.
--- @param method string|function        Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                  Objeto dono do método.
function Signal:connect(signal, method, owner)
    if owner and type(method) ~= "string" then
        -- Quando um owner é passado o método deve ser obrigatoriamente uma string.
        return
    elseif not owner and type(method) ~= "function" then
        -- Quando um owner não é passado o método deve ser obrigatoriamente uma função.
        return
    end

    local connection = { --- @type NodeUI.Signal.Connection
        method = method,
        owner = owner,
    }

    local signal_connections = self._signal_connections
    if type(signal_connections) == "nil" then
        signal_connections = {}
        self._signal_connections = signal_connections
    end

    local connections = signal_connections[signal]
    if type(connections) == "nil" then
        connections = {} --- @type NodeUI.Signal.Connection[]
        signal_connections[signal] = connections
    end

    connections[#connections + 1] = connection
end

--- Remove a conexão de um sinal.
--- @param signal string                 Nome do sinal.
--- @param method string|function        Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                  Objeto dono do método.
function Signal:disconnect(signal, method, owner)
    local connections = self._signal_connections[signal]
    if type(connections) ~= "table" then
        return
    end

    if type(method) == "function" then
        owner = nil
    end

    for i, connection in ipairs(connections) do
        if connection.method == method and connection.owner == owner then
            table.remove(connections, i)
            return
        end
    end
end

--- Emite o `signal`, chamando todos os seus métodos.
--- @param signal string Nome do sinal.
--- @param ... any Retornos do sinal.
function Signal:emit(signal, ...)
    local connections = self._signal_connections[signal]
    if type(connections) == "nil" then
        return
    end

    for i = #connections, 1, -1 do
        local connection = connections[i]

        -- Garbage Collection Dinâmico: Limpa conexões de objetos que já foram deletados
        if connection.owner and type(connection.owner.isQueuedForDeletion) == "function" and connection.owner:isQueuedForDeletion() then
            table.remove(connections, i)
            goto continue
        end

        local method_function = connection.owner and connection.owner[connection.method] or connection.method

        if type(method_function) ~= "function" then
            goto continue
        end

        if connection.owner then
            method_function(connection.owner, ...)
        else
            method_function(...)
        end

        ::continue::
    end
end

--#endregion

return Signal
