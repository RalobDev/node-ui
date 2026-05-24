local ROOT = (...):match("^(.*)%.")

local Container = require(ROOT .. ".container") --- @type NodeUI.Container

--- @class NodeUI.VContainer: NodeUI.Container
local VContainer = Container:extend()

--#region Public Methods

--- Cria uma nova `VContainer`
--- @nodiscard
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param settings? NodeUI.VContainer.SettingsParameter
--- @return NodeUI.VContainer VContainer
function VContainer:new(x, y, width, height, settings)
	local obj = Container.new(self, x, y, width, height, settings) --- @cast obj NodeUI.VContainer

	return obj
end

--- Atualiza a configuração atual sem sobrescrever valores não alterado.
--- @param settings NodeUI.VContainer.SettingsParameter
function VContainer:updateSettings(settings)
	Container.updateSettings(self, settings)
end

--#endregion

--#region Protected Methods

function VContainer:_rearrangeChildren()
	self:_rearrangeChildrenAlongAxis("vertical")
end

--#endregion

--#region Setters

--- Sobreescreve a configuração atual.
--- @param settings NodeUI.VContainer.SettingsParameter
function VContainer:setSettings(settings)
	Container.setSettings(self, settings)
end

--#endregion

--#region Getters

--- Retorna uma cópia das configurações.
--- @return NodeUI.VContainer.Settings
function VContainer:getSettings()
	return Container.getSettings(self) --- @type NodeUI.VContainer.Settings
end

--#endregion

return VContainer
