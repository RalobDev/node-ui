local ROOT = (...):match("^(.*)%.")

local ButtonBase = require(ROOT .. ".button_base") --- @type NodeUI.ButtonBase
local Panel = require(ROOT .. ".panel") --- @type NodeUI.Panel
local Label = require(ROOT .. ".label") --- @type NodeUI.Label

--- @class NodeUI.Button: NodeUI.ButtonBase
--- @field private _settings NodeUI.Button.Settings
--- @field private _panel NodeUI.Panel
--- @field private _label NodeUI.Label
local Button = ButtonBase:extend()

--#region Public Methods

--- Cria uma nova `Button`
--- @nodiscard
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param settings? NodeUI.Button.SettingsParameter
--- @return NodeUI.Button Button
function Button:new(x, y, width, height, settings)
	local obj = ButtonBase.new(self, x, y, width, height, settings) --- @cast obj NodeUI.Button

	obj._panel = obj:_addInternalChild(Panel:new(x, y, width, height))
	obj._label = obj:_addInternalChild(Label:new(x, y, width, height, "Button"))

	obj:_updatePanelSettings()
	obj:_updateLabelSettings()

	return obj
end

--#endregion

--#region Private Methods

--- @private
function Button:_updatePanelSettings()
	if not self._panel then
		return
	end

	local panel_settings = self._settings.panel_settings
	local current_settings = {}

	if self._pressed then
		current_settings = panel_settings.pressed
	elseif self._released then
		current_settings = panel_settings.released
	elseif self:hasMouseFocus() then
		current_settings = panel_settings.focused
	else
		current_settings = panel_settings.normal
	end

	-- Locked settings
	current_settings.layout_mode = "full_rect"
	current_settings.mouse_focus_mode = "ignore"

	self._panel:setSettings(current_settings)
end

--- @private
function Button:_updateLabelSettings()
	if not self._label then
		return
	end

	local label_settings = self._settings.label_settings
	local current_settings = {}

	if self._pressed then
		current_settings = label_settings.pressed
	elseif self._released then
		current_settings = label_settings.released
	elseif self:hasMouseFocus() then
		current_settings = label_settings.focused
	else
		current_settings = label_settings.normal
	end

	-- Locked settings
	current_settings.layout_mode = "full_rect"
	current_settings.mouse_focus_mode = "ignore"

	self._label:setSettings(current_settings)
end

--#endregion

--#region Setters

--- Sobreescreve a configuração atual.
--- @param settings NodeUI.Button.SettingsParameter
function Button:setSettings(settings)
	settings = settings or {}
	settings.panel_settings = settings.panel_settings or {}
	settings.label_settings = settings.label_settings or {}

	-- Panel settings
	settings.panel_settings.normal = settings.panel_settings.normal or {}
	settings.panel_settings.focused = settings.panel_settings.focused or {
		color = { 0.3, 0.3, 0.3, 1.0 },
	}
	settings.panel_settings.pressed = settings.panel_settings.pressed or {
		color = { 0.5, 0.5, 0.5, 1.0 },
	}
	settings.panel_settings.released = settings.panel_settings.released or {
		color = { 0.1, 0.1, 0.1, 1.0 },
	}

	-- Label settings
	settings.label_settings.normal = settings.label_settings.normal or {}
	settings.label_settings.focused = settings.label_settings.focused or {
		color = { 0.6, 0.6, 0.6, 1 },
	}
	settings.label_settings.pressed = settings.label_settings.pressed or {
		color = { 0.2, 0.2, 0.2, 1 },
	}
	settings.label_settings.released = settings.label_settings.released or {
		color = { 0.4, 0.4, 0.4, 1 },
	}

	-- Label defaults
	settings.label_settings.normal.h_align_mode = "center"
	settings.label_settings.normal.v_align_mode = "center"
	settings.label_settings.focused.h_align_mode = "center"
	settings.label_settings.focused.v_align_mode = "center"
	settings.label_settings.pressed.h_align_mode = "center"
	settings.label_settings.pressed.v_align_mode = "center"
	settings.label_settings.released.h_align_mode = "center"
	settings.label_settings.released.v_align_mode = "center"

	ButtonBase.setSettings(self, settings)
end

--#endregion

--#region Getters

--- Retorna as configurações.
--- @return NodeUI.Button.Settings
function Button:getSettings()
	return ButtonBase.getSettings(self) --- @type NodeUI.Button.Settings
end

--#endregion

--#region Callbacks

--- @protected
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
function Button:_onMousepressed(x, y, button, istouch, presses)
	ButtonBase._onMousepressed(self, x, y, button, istouch, presses)
	self:_updatePanelSettings()
	self:_updateLabelSettings()
end

--- @protected
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
function Button:_onMousereleased(x, y, button, istouch, presses)
	ButtonBase._onMousereleased(self, x, y, button, istouch, presses)
	self:_updatePanelSettings()
	self:_updateLabelSettings()
end

--- @protected
--- @param focused boolean
--- @diagnostic disable-next-line: unused-local
function Button:_onMouseFocusChanged(focused)
	self:_updatePanelSettings()
	self:_updateLabelSettings()
end

--- @protected
function Button:_onReleasedCooldownFinished()
	self:_updatePanelSettings()
	self:_updateLabelSettings()
end

--#endregion

return Button
