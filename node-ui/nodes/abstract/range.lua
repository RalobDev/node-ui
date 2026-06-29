local ROOT = (...):match("^(.*)%."):match("^(.*)%."):match("^(.*)%.")

local Control = require(ROOT .. ".nodes.control") --- @type NodeUI.Control

--- Classe abstrata base para todos os **`Control`** que representam um número com um intervalo.
--- @class NodeUI.Range: NodeUI.Control
--- @field private _min_value number
--- @field private _max_value number
--- @field private _step number
--- @field private _value number
--- @field private _rounded boolean
local Range = Control:extend("Range")


--#region Public

--- Cria um novo **Range**.
--- @nodiscard
--- @param x number            Posição horizontal.
--- @param y number            Posição vertical.
--- @param width number        Comprimento em pixels.
--- @param height number       Altura em pixels.
--- @param is_minimum? boolean Se a dimensão passada é a mínima.
--- @return NodeUI.Range Range Novo **Range**.
function Range:new(x, y, width, height, is_minimum)
    local obj = Control.new(self, x, y, width, height, is_minimum) --- @cast obj NodeUI.Range

    obj._min_value = 0
    obj._max_value = 100
    obj._step = 0
    obj._value = 0
    obj._rounded = false

    return obj
end

--- Retorna se o arredondamento do valor atual está ativado ou desativado.
--- @nodiscard
--- @return boolean is_rounded Se o arredondamento está ativado.
function Range:isRounded()
    return self._rounded
end

--#endregion


--#region Override

--- Cria uma conexão em determinado **`NodeUI.Range.Signals`** do **Range**.
--- @param signal NodeUI.Range.Signals Nome do sinal.
--- @param method string|function      Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                Objeto dono do método.
function Range:connect(signal, method, owner)
    self._signal:connect(signal, method, owner)
end

--- Remove a conexão de um **`NodeUI.Range.Signals`** do **Range**.
--- @param signal NodeUI.Range.Signals Nome do sinal.
--- @param method string|function      Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                Objeto dono do método.
function Range:disconnect(signal, method, owner)
    self._signal:disconnect(signal, method, owner)
end

--#endregion


--#region Setter

--- Define o valor mínimo.
--- @param min number Valor mínimo.
function Range:setMinValue(min)
    local old = self._min_value

    self._min_value = min
    self:setMaxValue(self._max_value)

    if self._min_value ~= old then
        self._signal:emit("CHANGED")
    end
end

--- Define o valor máximo.
--- @param max number Valor máximo.
function Range:setMaxValue(max)
    local old = self._max_value

    self._max_value = math.max(max, self._min_value)
    self:setValue(self._value)

    if self._max_value ~= old then
        self._signal:emit("CHANGED")
    end
end

--- Define o valor de cada passo do valor.
--- @param step number Valor de um passo.
function Range:setStep(step)
    local old = self._step

    self._step = math.max(step, 0)
    self:setValue(self._value)

    if self._step ~= old then
        self._signal:emit("CHANGED")
    end
end

--- Define o valor atual.
--- @param value number Novo valor.
function Range:setValue(value)
    local old = self._value

    if self._step > 0 then
        -- Calcula a diferença em relação ao mínimo para que os steps sejam relativos a ele.
        local offset = value - self._min_value
        -- Encontra o múltiplo de 'step' mais próximo.
        local snapped = math.floor((offset / self._step) + 0.5) * self._step
        value = self._min_value + snapped
    end

    -- Aplica o arredondamento para números inteiros (se ativado).
    if self._rounded then
        value = math.floor(value + 0.5)
    end

    -- Limita o valor entre o mínimo e o máximo.
    self._value = math.max(math.min(self._max_value, value), self._min_value)

    if self._value ~= old then
        self._signal:emit("VALUE_CHANGED", self._value)
    end
end

--- Define o ratio do valor que varia de 0 a 1.
--- @param ratio number Ratio do valor.
function Range:setValueRatio(ratio)
    ratio = math.max(0, math.min(ratio, 1))
    self:setValue(ratio * self:getMaxValue())
end

--- Ativa ou desativa o arredondamento do valor atual.
--- @param enabled? boolean Se é para arredondar.
function Range:setRounded(enabled)
    enabled = enabled == nil and true or enabled
    --- @cast enabled boolean
    self._rounded = enabled
    self:setValue(self._value)
end

--#endregion


--#region Getter

--- Retorna o valor mínimo.
--- @nodiscard
--- @return number min Valor mínimo.
function Range:getMinValue()
    return self._min_value
end

--- Retorna o valor máximo.
--- @nodiscard
--- @return number max Valor máximo.
function Range:getMaxValue()
    return self._max_value
end

--- Retorna o valor de cada passo do valor.
--- @nodiscard
--- @return number step Valor de um passo.
function Range:getStep()
    return self._step
end

--- Retorna o valor atual.
--- @nodiscard
--- @return number value Novo valor.
function Range:getValue()
    return self._value
end

--- Retorna o ratio do valor que varia de 0 a 1.
--- @nodiscard
--- @return number ratio Ratio do valor.
function Range:getValueRatio()
    return self._value / self._max_value
end

--#endregion


return Range
