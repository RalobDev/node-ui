local ROOT = (...):match("^(.*)%."):match("^(.*)%."):match("^(.*)%.")       --- @type string

local BaseButton = require(ROOT .. ".nodes.abstract.base_button")           --- @type NodeUI.BaseButton
local StyleBoxFlat = require(ROOT .. ".resources.style-box.style_box_flat") --- @type NodeUI.StyleBoxFlat
local Panel = require(ROOT .. ".nodes.panel")                               --- @type NodeUI.Panel
local TextBlock = require(ROOT .. ".nodes.text_block")                      --- @type NodeUI.TextBlock
local Palette = require(ROOT .. ".palette")                                 --- @type NodeUI.Palette

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

    obj._styleboxes = {}
    obj._text_colors = {}
    obj._text_outline_colors = {}
    obj._panel = obj:addChild(Panel:new(0, 0, 0, 0), true)
    obj._text_block = obj:addChild(TextBlock:new(0, 0, 0, 0), true)

    obj:_setup()

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

--- Cria uma conexão em determinado **`NodeUI.Button.Signals`** do **Button**.
--- @param signal NodeUI.Button.Signals Nome do sinal.
--- @param method string|function       Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                 Objeto dono do método.
function Button:connect(signal, method, owner)
    self._signal:connect(signal, method, owner)
end

--- Remove a conexão de um **`NodeUI.Button.Signals`** do **Button**.
--- @param signal NodeUI.Button.Signals Nome do sinal.
--- @param method string|function       Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                 Objeto dono do método.
function Button:disconnect(signal, method, owner)
    self._signal:disconnect(signal, method, owner)
end

--#endregion


--#region Setter

--- Define a **`StyleBox`** do **`NodeUI.Button.State`**.
--- @param state NodeUI.Button.State|NodeUI.Button.State[] Estado da stylebox.
--- @param stylebox NodeUI.StyleBox                        StyleBox do estado.
function Button:setStyleBox(state, stylebox)
    if type(state) == "table" then
        for _, v in ipairs(state) do
            self:setStyleBox(v, stylebox)
        end
        return
    elseif state == "ALL" then
        self:setStyleBox(
            { "NORMAL", "PRESSED", "HOVER", "HOVER_PRESSED", "DISABLED" },
            stylebox
        )
        return
    end

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
--- @param state NodeUI.Button.State|NodeUI.Button.State[] Estado da cor.
--- @param color number[]                                  Cor do estado.
function Button:setTextColor(state, color)
    if type(state) == "table" then
        for _, v in ipairs(state) do
            self:setTextColor(v, color)
        end
        return
    elseif state == "ALL" then
        self:setTextColor(
            { "NORMAL", "PRESSED", "HOVER", "HOVER_PRESSED", "DISABLED" },
            color
        )
        return
    end

    self._text_colors[state] = color
end

--- Define a cor do outline do texto de determinado **`NodeUI.Button.State`**.
--- @param state NodeUI.Button.State|NodeUI.Button.State[] Estado da cor do outline.
--- @param color number[]                                  Cor do outline do estado.
function Button:setOutlineTextColor(state, color)
    if type(state) == "table" then
        for _, v in ipairs(state) do
            self:setOutlineTextColor(v, color)
        end
        return
    elseif state == "ALL" then
        self:setOutlineTextColor(
            { "NORMAL", "PRESSED", "HOVER", "HOVER_PRESSED", "DISABLED" },
            color
        )
        return
    end

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


--#region Private

--- Configura o **Button**.
--- @private
function Button:_setup()
    --- @type NodeUI.Button.State[]
    local states = { "NORMAL", "HOVER", "HOVER_PRESSED", "PRESSED", "DISABLED" }

    for _, state in ipairs(states) do
        -- StyleBox
        local stylebox = StyleBoxFlat:new()
        stylebox:setCornerRadius({ "TOP_LEFT", "TOP_RIGHT", "BOTTOM_LEFT", "BOTTOM_RIGHT" }, 12)
        self._styleboxes[state] = stylebox

        -- Text Color
        if state == "DISABLED" then
            self._text_colors[state] = Palette:get("DISABLED_TEXT")
        else
            self._text_colors[state] = Palette:get("TEXT")
        end

        -- Text Outline Color
        self._text_outline_colors[state] = Palette:get("TEXT_OUTLINE")
    end

    -- Define a cor de preenchimento das styleboxes.
    do
        local styleboxes = self._styleboxes
        --- @cast styleboxes table<NodeUI.Button.State, NodeUI.StyleBoxFlat>

        styleboxes["HOVER"]:setFillColor(Palette:get("HOVER"))
        styleboxes["PRESSED"]:setFillColor(Palette:get("PRESSED"))
        styleboxes["HOVER_PRESSED"]:setFillColor(Palette:get("HOVER_PRESSED"))
        styleboxes["DISABLED"]:setFillColor(Palette:get("DISABLED"))
    end

    -- Cria o Panel que vai exibir as styleboxes.
    do
        local panel = self._panel
        panel:setLayout("FULL_RECT")
        panel:setStyleBox(self._styleboxes["NORMAL"])
    end

    -- Cria o TextBlock que vai exibir o texto do botão.
    do
        local text_block = self._text_block
        text_block:setLayout("FULL_RECT")
        text_block:setAlignment("BOTH", "CENTER")
    end

    self:setMouseFilter("STOP")
end

--#endregion

return Button
