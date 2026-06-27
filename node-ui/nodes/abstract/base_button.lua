local ROOT = (...):match("^(.*)%."):match("^(.*)%."):match("^(.*)%.")

local Control = require(ROOT .. ".nodes.control") --- @type NodeUI.Control

--- Classe base para todos os tipos de botões.
--- @class NodeUI.BaseButton: NodeUI.Control
--- @field private _is_pressed boolean
--- @field private _pressed_masks NodeUI.BaseButton.ButtonMask[]
--- @field private _active_mask NodeUI.BaseButton.ButtonMask?
--- @field private _action_mode NodeUI.BaseButton.ActionMode
--- @field private _button_mask table<NodeUI.BaseButton.ButtonMask, boolean>
--- @field private _toggled_mode boolean
--- @field private _disabled boolean
--- @field private _keep_pressed_outside boolean
local BaseButton = Control:extend("BaseButton")


--#region Local

--- Retorna a `NodeUI.BaseButton.ButtonMask` do button.
--- @nodiscard
--- @param button 1|2|3|4|5
--- @return NodeUI.BaseButton.ButtonMask button_mask
local function getButtonMask(button)
    local mask --- @type NodeUI.BaseButton.ButtonMask

    if button == 1 then
        mask = "MOUSE_LEFT"
    elseif button == 2 then
        mask = "MOUSE_RIGHT"
    elseif button == 3 then
        mask = "MOUSE_MIDDLE"
    elseif button == 4 then
        mask = "MOUSE_XBUTTON_1"
    elseif button == 5 then
        mask = "MOUSE_XBUTTON_2"
    end

    return mask
end

--#endregion


--#region Public

--- Cria um novo **BaseButton**.
--- @nodiscard
--- @param x number                      Posição horizontal.
--- @param y number                      Posição vertical.
--- @param width number                  Comprimento em pixels.
--- @param height number                 Altura em pixels.
--- @param is_minimum? boolean           Se a dimensão passada é a mínima.
--- @return NodeUI.BaseButton BaseButton Novo **BaseButton**.
function BaseButton:new(x, y, width, height, is_minimum)
    local obj = Control.new(self, x, y, width, height, is_minimum) --- @cast obj NodeUI.BaseButton

    obj._is_pressed = false
    obj._pressed_masks = {}
    obj._action_mode = "RELEASE"
    obj._button_mask = { MOUSE_LEFT = true }
    obj._toggled_mode = false

    return obj
end

--- Retorna se está pressionado.
--- @nodiscard
--- @return boolean is_pressed Se está pressionado.
function BaseButton:isPressed()
    return self._is_pressed
end

--- Retorna se está desativado.
--- @nodiscard
--- @return boolean disabled Se está desativado.
function BaseButton:isDisabled()
    return self._disabled
end

--#endregion


--#region Override

--- Cria uma conexão em determinado **`NodeUI.BaseButton.Signals`** do **BaseButton**.
--- @param signal NodeUI.BaseButton.Signals Nome do sinal.
--- @param method string|function           Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                     Objeto dono do método.
function BaseButton:connect(signal, method, owner)
    self._signal:connect(signal, method, owner)
end

--- Remove a conexão de um **`NodeUI.BaseButton.Signals`** do **BaseButton**.
--- @param signal NodeUI.BaseButton.Signals Nome do sinal.
--- @param method string|function           Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                     Objeto dono do método.
function BaseButton:disconnect(signal, method, owner)
    self._signal:disconnect(signal, method, owner)
end

--#endregion


--#region Setter

--- Define o modo de ação.
--- @param action_mode NodeUI.BaseButton.ActionMode Modo de ação.
function BaseButton:setActionMode(action_mode)
    local old = self._action_mode

    self._action_mode = action_mode

    if self._action_mode ~= old then
        self:_resetState()
    end
end

--- Define se a **`NodeUI.BaseButton.ButtonMask`** está ativada.
--- @param mask NodeUI.BaseButton.ButtonMask Máscara do botão.
--- @param enabled? boolean                  Se a máscara está ativada.
function BaseButton:setButtonMask(mask, enabled)
    if enabled == nil then enabled = true end

    local old = self._button_mask[mask]

    self._button_mask[mask] = enabled

    if self._button_mask[mask] ~= old then
        self:_resetState()
    end
end

--- Define se o modo de alterar está ativado.
--- @param enabled? boolean Se o modo de alterar está ativado.
function BaseButton:setToggledMode(enabled)
    if enabled == nil then enabled = true end

    local old = self._toggled_mode

    self._toggled_mode = enabled

    if self._toggled_mode ~= old then
        self:_resetState()
    end
end

--- Define se está desativado.
--- @param disabled? boolean Se está desativado.
function BaseButton:setDisabled(disabled)
    if disabled == nil then disabled = true end

    local old = self._disabled

    self._disabled = disabled

    if self._disabled ~= old then
        self:_resetState()
    end
end

--#endregion


--#region Getter

--- Retorna o modo de ação.
--- @nodiscard
--- @return NodeUI.BaseButton.ActionMode action_mode Modo de ação.
function BaseButton:getActionMode()
    return self._action_mode
end

--- Retorna se a **`NodeUI.BaseButton.ButtonMask`** está ativada.
--- @nodiscard
--- @param mask NodeUI.BaseButton.ButtonMask Máscara do botão.
--- @return boolean enabled                  Se a máscara está ativada.
function BaseButton:getButtonMask(mask)
    return self._button_mask[mask]
end

--- Retorna se o modo de alterar está ativado.
--- @nodiscard
--- @return boolean enabled Se o modo de alterar está ativado.
function BaseButton:getToggledMode()
    return self._toggled_mode
end

--#endregion


--#region Protected Callback

--- Chamado quando um botão do mouse é pressionado.
--- @protected
--- @param x number        Posição x do mouse, em pixels.
--- @param y number        Posição y do mouse, em pixels.
--- @param button number   O index do botão que foi pressionado.
--- @param istouch boolean `true` se o pressionar do botão do mouse é originado de uma touchscreen.
--- @param presses number  O número de pressionamentos.
--- @diagnostic disable-next-line: unused-local
function BaseButton:_onMousepressed(x, y, button, istouch, presses)
    if self._disabled then return end

    local pressed_successfully, is_primary = self:_press(button)

    -- Adicionada verificação do is_primary
    if pressed_successfully and is_primary and self._action_mode == "PRESS" then
        if self._toggled_mode then
            self:_forcePressed(not self._is_pressed)
        end
        self._signal:emit("PRESSED")
    end
end

--- Chamado quando um botão do mouse é solto.
--- @protected
--- @param x number        Posição x do mouse, em pixels.
--- @param y number        Posição y do mouse, em pixels.
--- @param button number   O index do botão que foi solto.
--- @param istouch boolean `true` se o soltar do botão do mouse é originado de uma touchscreen.
--- @param presses number  O número de pressionamentos.
--- @diagnostic disable-next-line: unused-local
function BaseButton:_onMousereleased(x, y, button, istouch, presses)
    if self._disabled then return end

    local unpressed_successfully, is_primary = self:_unpress(button)

    -- Adicionada verificação do is_primary
    if unpressed_successfully and is_primary and self._action_mode == "RELEASE" then
        if self._toggled_mode then
            self:_forcePressed(not self._is_pressed)
        end
        self._signal:emit("PRESSED")
    end
end

--- Chamado quando o foco do mouse do **Control** muda.
--- @protected
--- @param focused boolean Se está focado pelo mouse.
function BaseButton:_onMouseFocusChanged(focused)
    if not focused and not self._keep_pressed_outside and not self._toggled_mode then
        self:_forcePressed(false)
    end
end

--#endregion


--#region Private

--- Força o estado pressionado do botão. Se o modo toggle estiver ativo, emite o sinal "TOGGLED".
--- @private
--- @param pressed boolean
function BaseButton:_forcePressed(pressed)
    if self._is_pressed == pressed then return end

    self._is_pressed = pressed

    if self._toggled_mode then
        self._signal:emit("TOGGLED", self._is_pressed)
    end
end

--- Pressiona o botão fisicamente.
--- @param button 1|2|3|4|5
--- @return boolean success
--- @return boolean is_primary Se o botão foi o que iniciou a interação.
--- @private
function BaseButton:_press(button)
    local mask = getButtonMask(button)

    if mask and self._button_mask[mask] then
        self._pressed_masks[#self._pressed_masks + 1] = mask

        local is_primary = false
        if not self._active_mask then
            self._active_mask = mask
            is_primary = true
        end

        if #self._pressed_masks == 1 then
            self._signal:emit("BUTTON_DOWN")

            if not self._toggled_mode then
                self._is_pressed = true
            end
        end
        return true, is_primary
    end
    return false, false
end

--- Solta o botão fisicamente.
--- @param button 1|2|3|4|5
--- @return boolean success
--- @return boolean is_primary Se o botão solto era o dono da interação.
--- @private
function BaseButton:_unpress(button)
    local mask = getButtonMask(button)
    local mask_is_pressed = false

    for i = 1, #self._pressed_masks do
        if self._pressed_masks[i] == mask then
            table.remove(self._pressed_masks, i)
            mask_is_pressed = true
            break
        end
    end

    if mask_is_pressed then
        local is_primary = false
        if self._active_mask == mask then
            self._active_mask = nil -- O botão principal foi solto
            is_primary = true
        end

        if #self._pressed_masks == 0 then
            self._signal:emit("BUTTON_UP")

            if not self._toggled_mode then
                self._is_pressed = false
            end
        end
        return true, is_primary
    end
    return false, false
end

--- Reseta o estado do botão para evitar comportamentos inconsistentes.
--- @private
function BaseButton:_resetState()
    -- Se havia botões pressionados, limpamos a fila
    if #self._pressed_masks > 0 then
        self._pressed_masks = {}
        self._active_mask = nil

        -- Se o botão estava visualmente/logicamente "pressionado", liberamos
        if self._is_pressed then
            self._is_pressed = false
            self._signal:emit("BUTTON_UP")
        end
    end
end

--#endregion


return BaseButton
