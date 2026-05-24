local ROOT = (...):match("^(.*)%.")

local Control = require(ROOT .. ".control") --- @type NodeUI.Control

--- @class NodeUI.ButtonBase: NodeUI.Control
--- @field private _settings NodeUI.ButtonBase.Settings
--- @field protected _pressed boolean
--- @field private _ignore_release boolean
--- @field private _mouse_buffer_x number
--- @field private _mouse_buffer_y number
--- @field private _mouse_buffer_istouch boolean
local ButtonBase = Control:extend()

--#region Public Methods

--- Cria uma nova `ButtonBase`
--- @nodiscard
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param settings? NodeUI.ButtonBase.SettingsParameter
--- @return NodeUI.ButtonBase ButtonBase
function ButtonBase:new(x, y, width, height, settings)
	local obj = Control.new(self, x, y, width, height, settings) --- @cast obj NodeUI.ButtonBase

	obj._pressed = false
	obj._ignore_release = false

	return obj
end

--- Atualiza a configuração atual sem sobrescrever valores não alterado.
--- @param settings NodeUI.ButtonBase.SettingsParameter
function ButtonBase:updateSettings(settings)
	Control.updateSettings(self, settings)
end

--#endregion

--#region Setters

--- Sobreescreve a configuração atual.
--- @param settings NodeUI.ButtonBase.SettingsParameter
function ButtonBase:setSettings(settings)
	settings.release_on_lost_focus = settings.release_on_lost_focus or false

	Control.setSettings(self, settings)
end

--#endregion

--#region Getters

--- Retorna uma cópia das configurações.
--- @return NodeUI.ButtonBase.Settings
function ButtonBase:getSettings()
	return Control.getSettings(self) --- @type NodeUI.ButtonBase.Settings
end

--#endregion

--#region Callbacks

--- @param dt number
--- @diagnostic disable-next-line: unused-local
function ButtonBase:_onUpdate(dt)
	if self._pressed and self:getSettings().release_on_lost_focus and not self:hasMouseFocus() then
		self:_onMousereleased(self._mouse_buffer_x, self._mouse_buffer_y, 2, self._mouse_buffer_istouch, 1)
		self._ignore_release = true
	end
end

--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
--- @diagnostic disable-next-line: unused-local
function ButtonBase:_onMousepressed(x, y, button, istouch, presses)
	self._pressed = true
	self._mouse_buffer_x = x
	self._mouse_buffer_y = y
	self._mouse_buffer_istouch = istouch
	print("pressed")
end

--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
--- @diagnostic disable-next-line: unused-local
function ButtonBase:_onMousereleased(x, y, button, istouch, presses)
	if self._ignore_release then
		self._ignore_release = false
		return
	end

	self._pressed = false
	print("released")
end

--#endregion

return ButtonBase
