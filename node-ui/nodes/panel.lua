local ROOT = (...):match("^(.*)%.")

local Control = require(ROOT .. ".control") --- @type NodeUI.Control

--- @class NodeUI.Panel: NodeUI.Control
--- @field private _settings NodeUI.Panel.Settings
local Panel = Control:extend()

--#region Local Methods

--- Desenha um retângulo com raio individual para cada canto.
--- @param mode "fill"|"line"
--- @param x number
--- @param y number
--- @param w number
--- @param h number
--- @param r NodeUI.Control.RectangleCorners
--- @param segments number?
local function roundedRectangle(mode, x, y, w, h, r, segments)
	segments = segments or 8

	local tl = r.top_left or 0 -- top-left
	local tr = r.top_right or 0 -- top-right
	local bl = r.bottom_left or 0 -- bottom-left
	local br = r.bottom_right or 0 -- bottom-right

	-- Evita raios maiores que metade do retângulo
	local max_radius = math.min(w, h) / 2
	tl = math.min(tl, max_radius)
	tr = math.min(tr, max_radius)
	br = math.min(br, max_radius)
	bl = math.min(bl, max_radius)

	local points = {}

	local function addPoint(px, py)
		points[#points + 1] = px
		points[#points + 1] = py
	end

	local function addArc(cx, cy, radius, start_angle, end_angle)
		if radius <= 0 then
			addPoint(cx, cy)
			return
		end

		for i = 0, segments do
			local t = i / segments
			local angle = start_angle + (end_angle - start_angle) * t

			local px = cx + math.cos(angle) * radius
			local py = cy + math.sin(angle) * radius

			addPoint(px, py)
		end
	end

	-- Os ângulos estão em radianos.
	-- Começamos no canto superior direito e seguimos no sentido horário.

	addArc(x + w - tr, y + tr, tr, -math.pi / 2, 0)
	addArc(x + w - br, y + h - br, br, 0, math.pi / 2)
	addArc(x + bl, y + h - bl, bl, math.pi / 2, math.pi)
	addArc(x + tl, y + tl, tl, math.pi, math.pi * 1.5)

	love.graphics.polygon(mode, points)
end

--#endregion

--#region Public Methods

--- Cria um novo `Panel`
--- @nodiscard
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param settings? NodeUI.Panel.SettingsParameter
--- @return NodeUI.Panel Panel
function Panel:new(x, y, width, height, settings)
	local obj = Control.new(self, x, y, width, height, settings) --- @cast obj NodeUI.Panel

	obj:setSettings(settings or {})

	return obj
end

--- Atualiza a configuração atual sem sobrescrever valores não alterado.
--- @param settings NodeUI.Panel.SettingsParameter
function Panel:updateSettings(settings)
	Control.updateSettings(self, settings)
end

--#endregion

--#region Private Methods

--- @private
function Panel:_fixCornerRadiusValues()
	local settings = self._settings
	settings.corner_radius = settings.corner_radius or {}

	settings.corner_radius.top_left = settings.corner_radius.top_left or 0
	settings.corner_radius.top_right = settings.corner_radius.top_right or 0
	settings.corner_radius.bottom_left = settings.corner_radius.bottom_left or 0
	settings.corner_radius.bottom_right = settings.corner_radius.bottom_right or 0
end

--- @private
function Panel:_fixExpandMarginValues()
	local settings = self._settings
	settings.expand_margin = settings.expand_margin or {}

	settings.expand_margin.left = settings.expand_margin.left or 0
	settings.expand_margin.right = settings.expand_margin.right or 0
	settings.expand_margin.top = settings.expand_margin.top or 0
	settings.expand_margin.bottom = settings.expand_margin.bottom or 0
end

--#endregion

--#region Setters

--- Sobreescreve a configuração atual.
--- @param settings NodeUI.Panel.SettingsParameter
function Panel:setSettings(settings)
	settings.color = settings.color or { 0.5, 0.5, 0.5, 1 }
	settings.edge_color = settings.edge_color or { 1, 1, 1, 0 }
	settings.edge_width = settings.edge_width or 1

	settings.corner_radius = settings.corner_radius or {}
	settings.corner_radius.top_left = settings.corner_radius.top_left or 0
	settings.corner_radius.top_right = settings.corner_radius.top_right or 0
	settings.corner_radius.bottom_left = settings.corner_radius.bottom_left or 0
	settings.corner_radius.bottom_right = settings.corner_radius.bottom_right or 0

	settings.corner_segments = settings.corner_segments or 8

	settings.expand_margin = settings.expand_margin or {}
	settings.expand_margin.left = settings.expand_margin.left or 0
	settings.expand_margin.right = settings.expand_margin.right or 0
	settings.expand_margin.top = settings.expand_margin.top or 0
	settings.expand_margin.bottom = settings.expand_margin.bottom or 0

	Control.setSettings(self, settings)
end

--#endregion

--#region Getters

--- Retorna uma cópia das configurações.
--- @return NodeUI.Panel.Settings
function Panel:getSettings()
	return Control.getSettings(self) --- @type NodeUI.Panel.Settings
end

--#endregion

--#region Callbacks

function Panel:_onDraw()
	local expand_margin = self._settings.expand_margin

	local rect_x = self:getX() - expand_margin.left
	local rect_y = self:getY() - expand_margin.top
	local rect_w = self:getWidth() + expand_margin.left + expand_margin.right
	local rect_h = self:getHeight() + expand_margin.top + expand_margin.bottom

	love.graphics.push("all")
	love.graphics.setColor(self._settings.color)

	roundedRectangle(
		"fill",
		rect_x,
		rect_y,
		rect_w,
		rect_h,
		self._settings.corner_radius,
		self._settings.corner_segments
	)

	love.graphics.setColor(self._settings.edge_color)
	love.graphics.setLineWidth(self._settings.edge_width)

	roundedRectangle(
		"line",
		rect_x,
		rect_y,
		rect_w,
		rect_h,
		self._settings.corner_radius,
		self._settings.corner_segments
	)

	love.graphics.pop()
end

--#endregion

--#region Debug Methods

--- @param settings? NodeUI.Control.DebugSettings
function Panel:debug(settings)
	Control.debug(self, settings)

	settings = settings or {}

	local expand_margin = self._settings.expand_margin

	if
		expand_margin.left == 0
		and expand_margin.right == 0
		and expand_margin.top == 0
		and expand_margin.bottom == 0
	then
		return
	end

	local rect_x = self:getX() - expand_margin.left
	local rect_y = self:getY() - expand_margin.top
	local rect_w = self:getWidth() + expand_margin.left + expand_margin.right
	local rect_h = self:getHeight() + expand_margin.top + expand_margin.bottom

	love.graphics.push("all")

	local width = settings.line_width or love.graphics.getLineWidth()
	love.graphics.setColor(1, 0.8, 0, 1)
	love.graphics.setLineWidth(width)

	love.graphics.rectangle("line", rect_x, rect_y, rect_w, rect_h)

	love.graphics.pop()
end

--#endregion

return Panel
