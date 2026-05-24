local ROOT = (...):match("^(.*)%.")

local Control = require(ROOT .. ".control") --- @type NodeUI.Control

--- @class NodeUI.ButtonBase: NodeUI.Control
--- @field private _settings NodeUI.ButtonBase.Settings
--- @field protected _pressed boolean
--- @field protected _released boolean
--- @field private _release_cooldown number
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
	obj._released = false
	obj._release_cooldown = 0
	obj._ignore_release = false

	return obj
end

--#endregion

--#region Setters

--- Sobreescreve a configuração atual.
--- @param settings NodeUI.ButtonBase.SettingsParameter
function ButtonBase:setSettings(settings)
	settings.release_on_lost_focus = settings.release_on_lost_focus or false
	settings.pressed_callback = settings.pressed_callback or function() end
	settings.released_callback = settings.released_callback or function() end

	Control.setSettings(self, settings)
end

--#endregion

--#region Getters

--- Retorna as configurações.
--- @return NodeUI.ButtonBase.Settings
function ButtonBase:getSettings()
	return Control.getSettings(self) --- @type NodeUI.ButtonBase.Settings
end

--#endregion

--#region Callbacks

--- @param dt number
--- @diagnostic disable-next-line: unused-local
function ButtonBase:_onUpdate(dt)
	if self._release_cooldown > 0 then
		self._release_cooldown = self._release_cooldown - dt
		if self._release_cooldown <= 0 then
			self._release_cooldown = 0
			self._released = false
			self:_onReleasedCooldownFinished()
		end
	end

	if self._pressed and self:getSettings().release_on_lost_focus and not self:hasMouseFocus() then
		self:_onMousereleased(self._mouse_buffer_x, self._mouse_buffer_y, 2, self._mouse_buffer_istouch, 1)
		self._ignore_release = true
	end
end

--- @protected
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
--- @diagnostic disable-next-line: unused-local
function ButtonBase:_onMousepressed(x, y, button, istouch, presses)
	self._pressed = true
	self._released = false
	self._release_cooldown = 0
	self._mouse_buffer_x = x
	self._mouse_buffer_y = y
	self._mouse_buffer_istouch = istouch
	self._settings.pressed_callback()
end

--- @protected
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
	self._released = true
	self._release_cooldown = 0.1
	self._settings.released_callback()
end

--- @protected
function ButtonBase:_onReleasedCooldownFinished() end

--#endregion

return ButtonBase
