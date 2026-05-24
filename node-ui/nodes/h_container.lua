local ROOT = (...):match("^(.*)%.")

local Container = require(ROOT .. ".container") --- @type NodeUI.Container

--- @class NodeUI.HContainer: NodeUI.Container
local HContainer = Container:extend()

--#region Public Methods

--- Cria uma nova `HContainer`
--- @nodiscard
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param settings? NodeUI.HContainer.SettingsParameter
--- @return NodeUI.HContainer HContainer
function HContainer:new(x, y, width, height, settings)
	local obj = Container.new(self, x, y, width, height, settings) --- @cast obj NodeUI.HContainer

	return obj
end

--- Atualiza a configuração atual sem sobrescrever valores não alterado.
--- @param settings NodeUI.HContainer.SettingsParameter
function HContainer:updateSettings(settings)
	Container.updateSettings(self, settings)
end

--#endregion

--#region Protected Methods

function HContainer:_rearrangeChildren()
	self:_rearrangeChildrenAlongAxis("horizontal")
end

--#endregion

--#region Setters

--- Sobreescreve a configuração atual.
--- @param settings NodeUI.HContainer.SettingsParameter
function HContainer:setSettings(settings)
	Container.setSettings(self, settings)
end

--#endregion

--#region Getters

--- Retorna uma cópia das configurações.
--- @return NodeUI.HContainer.Settings
function HContainer:getSettings()
	return Container.getSettings(self) --- @type NodeUI.HContainer.Settings
end

--#endregion

return HContainer
