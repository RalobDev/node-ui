local ROOT = (...):match("^(.*)%.")

local Control = require(ROOT .. ".control") --- @type NodeUI.Control

--- @class NodeUI.Container: NodeUI.Control
--- @field private _settings NodeUI.Container.Settings
local Container = Control:extend()

--#region Public Methods

--- Cria uma nova `Container`
--- @nodiscard
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param settings? NodeUI.Container.SettingsParameter
--- @return NodeUI.Container Container
function Container:new(x, y, width, height, settings)
	local obj = Control.new(self, x, y, width, height, settings) --- @cast obj NodeUI.Container

	return obj
end

--#endregion

--#region Protected Methods

--- @protected
function Container:_rearrangeChildren() end

--- @protected
--- @param axis "vertical"|"horizontal"
function Container:_rearrangeChildrenAlongAxis(axis)
	local axis_data = self:_getAxisData(axis)
	local children = self:getChildren()

	local separation = self._settings.separation
	local children_count = #children
	local total_separation = math.max(children_count - 1, 0) * separation

	local expand_child_count = 0
	local fixed_size = 0

	for _, child in ipairs(children) do
		local settings = child:getSettings()

		if settings.container_expand then
			expand_child_count = expand_child_count + 1
		else
			fixed_size = fixed_size + self:_getChildBaseSizeOnAxis(child, axis)
		end
	end

	local expanded_child_size = 0

	if expand_child_count > 0 then
		local available_size = self[axis_data.main_size] - fixed_size - total_separation

		expanded_child_size = available_size / expand_child_count
		expanded_child_size = math.max(expanded_child_size, 0)
	end

	local offset = 0

	for index, child in ipairs(children) do
		local settings = child:getSettings()

		local _, _, base_width, base_height = child:_getBaseTransform()

		local base_main_size

		if axis == "vertical" then
			base_main_size = base_height
		else
			base_main_size = base_width
		end

		local allocated_main_size = base_main_size

		if settings.container_expand then
			allocated_main_size = expanded_child_size
		end

		child._layout_width = base_width
		child._layout_height = base_height

		child[axis_data.main_pos] = self[axis_data.main_pos] + offset
		child[axis_data.cross_pos] = self[axis_data.cross_pos]

		if settings.container_expand and settings[axis_data.main_sizing] == "fill" then
			child[axis_data.main_size] = allocated_main_size
		end

		if settings[axis_data.cross_sizing] == "fill" then
			child[axis_data.cross_size] = self[axis_data.cross_size]
		elseif settings[axis_data.cross_sizing] == "shrink_begin" then
			child[axis_data.cross_pos] = self[axis_data.cross_pos]
		elseif settings[axis_data.cross_sizing] == "shrink_end" then
			child[axis_data.cross_pos] = self[axis_data.cross_pos]
				+ self[axis_data.cross_size]
				- child[axis_data.cross_size]
		elseif settings[axis_data.cross_sizing] == "shrink_center" then
			child[axis_data.cross_pos] = self[axis_data.cross_pos]
				+ self[axis_data.cross_size] / 2
				- child[axis_data.cross_size] / 2
		end

		if settings[axis_data.main_sizing] == "shrink_begin" then
			child[axis_data.main_pos] = self[axis_data.main_pos] + offset
		elseif settings[axis_data.main_sizing] == "shrink_end" then
			child[axis_data.main_pos] = self[axis_data.main_pos]
				+ offset
				+ allocated_main_size
				- child[axis_data.main_size]
		elseif settings[axis_data.main_sizing] == "shrink_center" then
			child[axis_data.main_pos] = self[axis_data.main_pos]
				+ offset
				+ allocated_main_size / 2
				- child[axis_data.main_size] / 2
		end

		offset = offset + allocated_main_size

		if index < children_count then
			offset = offset + separation
		end
	end
end

--- @private
--- @param axis "vertical"|"horizontal"
--- @return table
function Container:_getAxisData(axis)
	if axis == "vertical" then
		return {
			main_pos = "_layout_y",
			main_size = "_layout_height",
			main_sizing = "v_container_sizing",

			cross_pos = "_layout_x",
			cross_size = "_layout_width",
			cross_sizing = "h_container_sizing",
		}
	end

	return {
		main_pos = "_layout_x",
		main_size = "_layout_width",
		main_sizing = "h_container_sizing",

		cross_pos = "_layout_y",
		cross_size = "_layout_height",
		cross_sizing = "v_container_sizing",
	}
end

--- @private
--- @param child NodeUI.Control
--- @param axis "vertical"|"horizontal"
--- @return number
function Container:_getChildBaseSizeOnAxis(child, axis)
	local _, _, base_width, base_height = child:_getBaseTransform()

	if axis == "vertical" then
		return base_height
	end

	return base_width
end

--#endregion

--#region Setters

--- Sobreescreve a configuração atual.
--- @param settings NodeUI.Container.SettingsParameter
function Container:setSettings(settings)
	settings.separation = settings.separation or 0

	Control.setSettings(self, settings)
end

--#endregion

--#region Getters

--- Retorna as configurações.
--- @return NodeUI.Container.Settings
function Container:getSettings()
	return Control.getSettings(self) --- @type NodeUI.Container.Settings
end

--#endregion

--#region Callbacks

--- @protected
--- @param child NodeUI.Control
function Container:_onAddedChild(child)
	child._update_layout = false
	self:_rearrangeChildren()
end

--- @protected
--- @param child NodeUI.Control
function Container:_onRemovedChild(child)
	child._update_layout = true
end

--- @protected
function Container:_onLayoutUpdated()
	self:_rearrangeChildren()
end

--#endregion

return Container
