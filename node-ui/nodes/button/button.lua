local ROOT = (...):match("^(.*)%."):match("^(.*)%."):match("^(.*)%.")       --- @type string

local BaseButton = require(ROOT .. ".nodes.abstract.base_button")           --- @type NodeUI.BaseButton
local StyleBoxFlat = require(ROOT .. ".resources.style-box.style_box_flat") --- @type NodeUI.StyleBoxFlat
local Panel = require(ROOT .. ".nodes.panel")                               --- @type NodeUI.Panel
local TextBlock = require(ROOT .. ".nodes.text_block")                      --- @type NodeUI.TextBlock

--- Um botão padrão que pode exibir um texto e uma **`StyleBox`**.
--- @class NodeUI.Button: NodeUI.BaseButton
--- @field private _styleboxes table<NodeUI.Button.State, NodeUI.StyleBox>
--- @field private _text_colors table<NodeUI.Button.State, number[]>
--- @field private _text_outline_colors table<NodeUI.Button.State, number[]>
--- @field private _panel NodeUI.Panel
--- @field private _text_block NodeUI.TextBlock
--- @field private _flat boolean
local Button = BaseButton:extend("Button")


--#region Public

--- Cria um novo **Button**.
--- @nodiscard
--- @param x number              Posição horizontal.
--- @param y number              Posição vertical.
--- @param width number          Comprimento em pixels.
--- @param height number         Altura em pixels.
--- @param is_minimum? boolean   Se a dimensão passada é a mínima.
--- @return NodeUI.Button Button Novo **Button**.
function Button:new(x, y, width, height, is_minimum)
    local obj = BaseButton.new(self, x, y, width, height, is_minimum) --- @cast obj NodeUI.Button

    do
        local normal_stylebox = StyleBoxFlat:new()
        local hover_stylebox = StyleBoxFlat:new()
        local pressed_stylebox = StyleBoxFlat:new()
        local disabled_stylebox = StyleBoxFlat:new()

        normal_stylebox:setFillColor({ 0.5, 0.5, 0.5 })
        hover_stylebox:setFillColor({ 0.7, 0.7, 0.7 })
        pressed_stylebox:setFillColor({ 0.3, 0.3, 0.3 })
        disabled_stylebox:setFillColor({ 0.1, 0.1, 0.1 })

        obj._styleboxes = {
            NORMAL = normal_stylebox,
            HOVER = hover_stylebox,
            HOVER_PRESSED = pressed_stylebox,
            PRESSED = pressed_stylebox,
            DISABLED = disabled_stylebox,
        }

        for _, stylebox in pairs(obj._styleboxes) do
            --- @cast stylebox NodeUI.StyleBoxFlat
            stylebox:setCornerRadius("TOP_LEFT", 12)
            stylebox:setCornerRadius("TOP_RIGHT", 12)
            stylebox:setCornerRadius("BOTTOM_LEFT", 12)
            stylebox:setCornerRadius("BOTTOM_RIGHT", 12)
        end
    end

    obj._text_colors = {
        NORMAL = { 1, 1, 1, 1 },
        HOVER = { 1, 1, 1, 1 },
        HOVER_PRESSED = { 1, 1, 1, 1 },
        PRESSED = { 1, 1, 1, 1 },
        DISABLED = { 0.5, 0.5, 0.5, 1 },
    }

    obj._text_outline_colors = {
        NORMAL = { 0, 0, 0, 1 },
        HOVER = { 0, 0, 0, 1 },
        HOVER_PRESSED = { 0, 0, 0, 1 },
        PRESSED = { 0, 0, 0, 1 },
        DISABLED = { 0, 0, 0, 1 },
    }

    do
        local panel = obj:addChild(Panel:new(0, 0, 0, 0), true)
        panel:setLayout("FULL_RECT")
        panel:setStyleBox(obj._styleboxes["NORMAL"])

        obj._panel = panel
    end

    do
        local text_block = obj:addChild(TextBlock:new(0, 0, 0, 0), true)
        text_block:setLayout("FULL_RECT")
        text_block:setAlignment("HORIZONTAL", "CENTER")
        text_block:setAlignment("VERTICAL", "CENTER")

        text_block:setText("Button")

        obj._text_block = text_block
    end

    obj:setMouseFilter("STOP")

    return obj
end

--- Retorna se o botão deve exibir suas **`StyleBox`**.
--- @nodiscard
--- @return boolean enabled Se é para exibir suas stylebox.
function Button:isFlat()
    return self._flat
end

--#endregion


--#region Override

--- Cria uma conexão em determinado **`NodeUI.Button.Signals** do **Button**.
--- @param signal NodeUI.Button.Signals Nome do sinal.
--- @param method string|function           Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                     Objeto dono do método.
function Button:connect(signal, method, owner)
    self._signal:connect(signal, method, owner)
end

--- Remove a conexão de um **`NodeUI.Button.Signals`** do **Button**.
--- @param signal NodeUI.Button.Signals Nome do sinal.
--- @param method string|function           Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                     Objeto dono do método.
function Button:disconnect(signal, method, owner)
    self._signal:disconnect(signal, method, owner)
end

--#endregion


--#region Setter

--- Define a **`StyleBox`** do **`NodeUI.Button.State`**.
--- @param state NodeUI.Button.State Estado da stylebox.
--- @param stylebox NodeUI.StyleBox  StyleBox do estado.
function Button:setStyleBox(state, stylebox)
    self._styleboxes[state] = stylebox
end

--- Define a **`TextSettings`** usada para exibir o texto do botão.
--- @param text_settings NodeUI.TextSettings
function Button:setTextSettings(text_settings)
    self._text_block:setTextSettings(text_settings)
end

--- Define se o botão deve exibir suas **`StyleBox`**.
--- @param enabled boolean Se é para exibir suas stylebox.
function Button:setFlat(enabled)
    enabled = enabled == nil and true or enabled
    self._flat = enabled
end

--- Define a cor do texto de determinado **`NodeUI.Button.State`**.
--- @param state NodeUI.Button.State Estado da cor.
--- @param color number[]            Cor do estado.
function Button:setTextColor(state, color)
    self._text_colors[state] = color
end

--- Define a cor do outline do texto de determinado **`NodeUI.Button.State`**.
--- @param state NodeUI.Button.State Estado da cor do outline.
--- @param color number[]            Cor do outline do estado.
function Button:setTextColor(state, color)
    self._text_outline_colors[state] = color
end

--#endregion


--#region Getter

--- Retorna a **`StyleBox`** do **`NodeUI.Button.State`**.
--- @nodiscard
--- @param state NodeUI.Button.State Estado da stylebox.
--- @return NodeUI.StyleBox stylebox StyleBox do estado.
function Button:getStyleBox(state)
    return self._styleboxes[state]
end

--- Retorna a **`TextSettings`** usada para exibir o texto do botão.
--- @nodiscard
--- @return NodeUI.TextSettings text_settings
function Button:getTextSettings()
    return self._text_block:getTextSettings()
end

--- Define a cor do texto de determinado **`NodeUI.Button.State`**.
--- @param state NodeUI.Button.State Estado da cor.
--- @param color number[]            Cor do estado.
function Button:setTextColor(state, color)
    self._text_colors[state] = color
end

--- Define a cor do outline do texto de determinado **`NodeUI.Button.State`**.
--- @param state NodeUI.Button.State Estado da cor do outline.
--- @param color number[]            Cor do outline do estado.
function Button:setTextColor(state, color)
    self._text_outline_colors[state] = color
end

--- Retorna a cor do texto de determinado **`NodeUI.Button.State`**.
--- @nodiscard
--- @param state NodeUI.Button.State Estado da cor.
--- @return number[] color           Cor do estado.
function Button:getTextColor(state)
    return self._text_colors[state]
end

--- Retorna a cor do outline do texto de determinado **`NodeUI.Button.State`**.
--- @nodiscard
--- @param state NodeUI.Button.State Estado da cor do outline.
--- @return number[] color           Cor do outline do estado.
function Button:getTextColor(state)
    return self._text_outline_colors[state]
end

--#endregion


--#region Protected Callback

--- Chamado durante a atualização do **Control**.
--- @protected
--- @param dt number Tempo decorrido desde a última atualização.
--- @diagnostic disable-next-line: unused-local
function Button:_onUpdate(dt)
    local state --- @type NodeUI.Button.State

    if self:isDisabled() then
        state = "DISABLED"
    elseif self:isPressed() and self:hasMouseFocus() then
        state = "HOVER_PRESSED"
    elseif self:isPressed() then
        state = "PRESSED"
    elseif self:hasMouseFocus() then
        state = "HOVER"
    else
        state = "NORMAL"
    end

    local text_settings = self._text_block:getTextSettings()

    self._panel:setStyleBox(self._styleboxes[state])
    text_settings:setFontColor(self._text_colors[state])
    text_settings:setOutlineColor(self._text_outline_colors[state])
end

--- Chamado durante o desenho de um filho do **Control**.
--- @protected
--- @param child NodeUI.Control
function Button:_onDrawChild(child)
    local can_draw = true

    if self._flat and child == self._panel then
        can_draw = false
    end

    if can_draw then
        BaseButton._onDrawChild(self, child)
    end
end

--#endregion


return Button
