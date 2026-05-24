local ROOT = (...):match("^(.*)%.")

local Control = require(ROOT .. ".control") --- @type NodeUI.Control

--- @class NodeUI.Label: NodeUI.Control
--- @field private _settings NodeUI.Label.Settings
--- @field text string
local Label = Control:extend()

--#region Public Methods

--- Cria uma nova `Label`
--- @nodiscard
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param text string
--- @param settings? NodeUI.Label.SettingsParameter
--- @return NodeUI.Label Label
function Label:new(x, y, width, height, text, settings)
	local obj = Control.new(self, x, y, width, height, settings) --- @cast obj NodeUI.Label

	obj.text = text

	return obj
end

--- Atualiza a configuração atual sem sobrescrever valores não alterado.
--- @param settings NodeUI.Label.SettingsParameter
function Label:updateSettings(settings)
	Control.updateSettings(self, settings)
end

--#endregion

--#region Setters

--- Sobreescreve a configuração atual.
--- @param settings NodeUI.Label.SettingsParameter
function Label:setSettings(settings)
	settings.font = settings.font or love.graphics.getFont()
	settings.color = settings.color or { 1, 1, 1, 1 }
	settings.wrap_text = settings.wrap_text or false
	settings.h_align_mode = settings.h_align_mode or "left"
	settings.v_align_mode = settings.v_align_mode or "top"

	Control.setSettings(self, settings)
end

--#endregion

--#region Getters

--- Retorna uma cópia das configurações.
--- @return NodeUI.Label.Settings
function Label:getSettings()
	return Control.getSettings(self) --- @type NodeUI.Label.Settings
end

--#endregion

--#region Callbacks

--- @protected
function Label:_onDraw()
	local settings = self._settings
	local font = self._settings.font

	local limit
	local lines

	if settings.wrap_text then
		limit, lines = font:getWrap(self.text, self:getWidth())
	else
		limit = font:getWidth(self.text)
		lines = { self.text }
	end
	limit = math.max(limit, self:getWidth())

	local text_y = self:getY()
	local text_height = #lines * font:getHeight()

	if settings.v_align_mode == "bottom" then
		text_y = text_y + self:getHeight() - text_height
	elseif settings.v_align_mode == "center" then
		text_y = text_y + self:getHeight() / 2 - text_height / 2
	end

	love.graphics.push("all")
	love.graphics.setColor(settings.color)
	love.graphics.setFont(font)

	love.graphics.printf(self.text, self:getX(), text_y, limit, settings.h_align_mode)

	love.graphics.pop()
end

--#endregion

return Label
