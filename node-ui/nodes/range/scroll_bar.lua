local ROOT = (...):match("^(.*)%."):match("^(.*)%."):match("^(.*)%.")

local Range = require(ROOT .. ".nodes.abstract.range")                      --- @type NodeUI.Range
local StyleBoxFlat = require(ROOT .. ".resources.style-box.style_box_flat") --- @type NodeUI.StyleBoxFlat
local Button = require(ROOT .. ".nodes.button.button")                      --- @type NodeUI.Button
local Palette = require(ROOT .. ".core.palette")                            --- @type NodeUI.Palette

--- Uma **ScrollBar** que varia de um valor mínimo à um valor máximo.
--- @class NodeUI.ScrollBar: NodeUI.Range
--- @field private _styleboxes table<NodeUI.ScrollBar.Styles, NodeUI.StyleBox>
--- @field private _grabber_button NodeUI.Button
--- @field private _page_size number
--- @field private _queued_for_update_grabber boolean
--- @field private _grabber_offset_x number
--- @field private _grabber_offset_y number
--- @field private _vertical boolean
local ScrollBar = Range:extend("ScrollBar")


--#region Public

--- Cria uma nova **ScrollBar**.
--- @nodiscard
--- @param x number                    Posição horizontal.
--- @param y number                    Posição vertical.
--- @param width number                Comprimento em pixels.
--- @param height number               Altura em pixels.
--- @param is_minimum? boolean         Se a dimensão passada é a mínima.
--- @return NodeUI.ScrollBar ScrollBar Novo **ScrollBar**.
function ScrollBar:new(x, y, width, height, is_minimum)
    local obj = Range.new(self, x, y, width, height, is_minimum) --- @cast obj NodeUI.ScrollBar

    obj._styleboxes = {}
    obj._grabber_button = obj:addChild(Button:new(0, 0, 0, 0), true)
    obj._page_size = 32
    obj._grabber_offset_x = 0
    obj._grabber_offset_y = 0
    obj._vertical = true

    obj:_setup()

    return obj
end

--- Retorna se a **ScrollBar** é vertical.
--- @nodiscard
--- @return boolean is_vertical Se é vertical.
function ScrollBar:isVertical()
    return self._vertical
end

--#endregion


--#region Override

--- Cria uma conexão em determinado **`NodeUI.ScrollBar.Signals`** do **ScrollBar**.
--- @param signal NodeUI.ScrollBar.Signals Nome do sinal.
--- @param method string|function          Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                    Objeto dono do método.
function ScrollBar:connect(signal, method, owner)
    self._signal:connect(signal, method, owner)
end

--- Remove a conexão de um **`NodeUI.ScrollBar.Signals`** do **ScrollBar**.
--- @param signal NodeUI.ScrollBar.Signals Nome do sinal.
--- @param method string|function          Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                    Objeto dono do método.
function ScrollBar:disconnect(signal, method, owner)
    self._signal:disconnect(signal, method, owner)
end

--#endregion


--#region Setter

--- Define a **`StyleBox`** do **`NodeUI.ScrollBar.Styles`**.
--- @param style NodeUI.ScrollBar.Styles Estilo da **StyleBox**.
--- @param stylebox NodeUI.StyleBox      **StyleBox** do estilo.
function ScrollBar:setStyleBox(style, stylebox)
    self._styleboxes[style] = stylebox
end

--- Define o tamanho de uma página da **ScrollBar**.
--- @param size number Tamanho da página.
function ScrollBar:setPageSize(size)
    local old = self._page_size

    self._page_size = size

    if self._page_size ~= old then
        self:_queueUpdateGrabber()
    end
end

--- Define se a ScrollBar é vertical.
--- @param enabled? boolean Se é vertical.
function ScrollBar:setVertical(enabled)
    enabled = enabled == nil and true or enabled
    --- @cast enabled boolean

    local old = self._vertical

    self._vertical = enabled

    if self._vertical ~= old then
        self:_queueUpdateGrabber()
    end
end

--#endregion


--#region Getter

--- Retorna a **`StyleBox`** do **`NodeUI.ScrollBar.Styles`**.
--- @nodiscard
--- @param style NodeUI.ScrollBar.Styles Estilo da **StyleBox**
--- @return NodeUI.StyleBox stylebox **StyleBox** do estilo.
function ScrollBar:getStyleBox(style)
    return self._styleboxes[style]
end

--- Retorna o tamanho de uma página da **ScrollBar**.
--- @nodiscard
--- @return number size Tamanho da página.
function ScrollBar:getPageSize()
    return self._page_size
end

--#endregion


--#region Protected Callback

--- Chamado durante a atualização do **Control**.
--- @protected
--- @param dt number Tempo decorrido desde a última atualização.
--- @diagnostic disable-next-line: unused-local
function ScrollBar:_onUpdate(dt)
    if self._queued_for_update_grabber then
        self._queued_for_update_grabber = false
        self:_updateGrabber()
    end

    local grabber_button = self._grabber_button
    if grabber_button:isPressed() then
        local size = self._layout_width
        local position = self._layout_x
        local mouse_position = NodeUI.getBaseMouseX()
        local offset = self._grabber_offset_x

        if self._vertical then
            size = self._layout_height
            position = self._layout_y
            mouse_position = NodeUI.getBaseMouseY()
            offset = self._grabber_offset_y
        end

        local available_size = size - self._page_size
        local grabber_position = mouse_position - offset

        local value = (grabber_position - position) * self:getMaxValue() / available_size
        value = math.max(0, math.min(value, self:getMaxValue()))

        self:setValue(value)
    end
end

--- Chamado durante o desenho do **Control**.
--- @protected
function ScrollBar:_onDraw()
    local styleboxes = self._styleboxes
    local x, y = self._layout_x, self._layout_y
    local width, heigth = self._layout_width, self._layout_height

    styleboxes.BACKGROUND:draw(x, y, width, heigth)
end

--- Lida com um **InputEvent**.
--- @protected
--- @param event NodeUI.InputEvent
function ScrollBar:_onInput(event)
    local grabber_button = self._grabber_button

    if grabber_button:isPressed() then return end

    if self:_eventIs(event, "INPUT_EVENT_MOUSE_BUTTON") then
        --- @cast event NodeUI.InputEventMouseButton

        if not event.pressed then return end
        self:_acceptEvent(event)

        local position = event.x
        local grabber_position = grabber_button._layout_x

        if self._vertical then
            position = event.y
            grabber_position = grabber_button._layout_y
        end

        local step_direction = position < grabber_position and -1 or 1
        self:_stepValue(step_direction, 5)
    elseif self:_acceptEvent(event, "INPUT_EVENT_WHEEL_MOVED") then
        --- @cast event NodeUI.InputEventWheelMoved

        self:_stepValue(-event.y, 10)
    end
end

--- Chamado durante a atualização do layout do **Control**.
--- @protected
function ScrollBar:_onUpdateLayout()
    Range._onUpdateLayout(self)

    self:_queueUpdateGrabber()
end

--#endregion


--#region Private

--- Configura a **ScrollBar**.
--- @private
function ScrollBar:_setup()
    -- Configura as StyleBox.
    do
        --- @type NodeUI.ScrollBar.Styles[]
        local styles = { "BACKGROUND", "GRABBER", "GRABBER_HIGHLIGHT", "GRABBER_PRESSED" }

        for _, style in ipairs(styles) do
            local stylebox = StyleBoxFlat:new()

            stylebox:setCornerRadius("ALL", 16)

            if style == "BACKGROUND" then
                stylebox:setFillColor(Palette:get("BACKGROUND"))
            elseif style == "GRABBER_HIGHLIGHT" then
                stylebox:setFillColor(Palette:get("HOVER"))
            elseif style == "GRABBER_PRESSED" then
                stylebox:setFillColor(Palette:get("PRESSED"))
                stylebox:setBorderColor(Palette:get("PRESSED"))
            end

            -- !DEBUG
            if style ~= "BACKGROUND" then
                stylebox:setBorderSize(4)
                stylebox:setFillColor({ 1, 1, 1, 0.0 })
            end

            self._styleboxes[style] = stylebox
        end
    end

    do
        local grabber_button = self._grabber_button

        grabber_button:setLayout("CUSTOM")
        grabber_button:setKeepPressedOutside()

        grabber_button:setStyleBox("NORMAL", self._styleboxes["GRABBER"])
        grabber_button:setStyleBox("HOVER", self._styleboxes["GRABBER_HIGHLIGHT"])
        grabber_button:setStyleBox({ "HOVER_PRESSED", "PRESSED" }, self._styleboxes["GRABBER_PRESSED"])

        grabber_button:connect("BUTTON_DOWN", "_onGrabberButtonDown", self)
    end

    self:_queueUpdateGrabber()

    -- Connections
    self:connect("CHANGED", "_onChanged", self)
    self:connect("VALUE_CHANGED", "_onValueChanged", self)
end

--- Marca o ScrollBar para atualizar o `_grabber_button`.
--- @private
function ScrollBar:_queueUpdateGrabber()
    self._queued_for_update_grabber = true
end

--- Atualiza o `_grabber_button` button para que sua posição corresponda ao valor da **ScrollBar** e
--- para que seu tamanho também corresponda ao da **ScrollBar**.
--- @private
function ScrollBar:_updateGrabber()
    local grabber_button = self._grabber_button

    local size = self._layout_width
    if self._vertical then
        size = self._layout_height
    end

    local x, y = self._layout_x, self._layout_y

    local available_size = size - self._page_size
    local used_size = available_size / self:getMaxValue() * self:getValue()

    if self._vertical then
        y = y + used_size
    else
        x = x + used_size
    end

    grabber_button:setPosition(x, y)

    if self._vertical then
        grabber_button:setDimensions(self._layout_width, self._page_size)
    else
        grabber_button:setDimensions(self._page_size, self._layout_height)
    end
end

--- Anda um passo dada uma direção e o número de divisões dos passos.
--- @private
--- @param direction -1|1
--- @param step_divisions number
function ScrollBar:_stepValue(direction, step_divisions)
    local page_step = math.max(self:getStep(), self:getMaxValue() / step_divisions)
    self:setValue(self:getValue() + page_step * direction)
end

--#endregion


--#region Signal Callback

--- Chamado quando o valor mínimo, valor máximo e step são alterados.
--- @private
function ScrollBar:_onChanged()
    self:_queueUpdateGrabber()
end

--- Chamado quando o valor é alterado.
--- @private
--- @param value number
--- @diagnostic disable-next-line: unused-local
function ScrollBar:_onValueChanged(value)
    self:_queueUpdateLayout()
end

--- Chamado quando o `_grabber_button` é pressionado.
--- @private
function ScrollBar:_onGrabberButtonDown()
    local grabber_button = self._grabber_button

    self._grabber_offset_x = self._node_ui:getBaseMouseX() - grabber_button._layout_x
    self._grabber_offset_y = self._node_ui:getBaseMouseY() - grabber_button._layout_y
end

--#endregion


return ScrollBar
