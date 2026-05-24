local ROOT = (...):match("^(.*)%.%w+%.%w+$")

local Class = require(ROOT .. ".class") --- @type Class

--- @class NodeUI.Control: Class
--- @field private _settings NodeUI.Control.Settings
--- @field private _parent? NodeUI.Control
--- @field private _x number
--- @field private _y number
--- @field private _width number
--- @field private _height number
--- @field protected _layout_x number
--- @field protected _layout_y number
--- @field protected _layout_width number
--- @field protected _layout_height number
--- @field private _children NodeUI.Control[]
--- @field private _deferred_methods string[]
--- @field private _mouse_focus boolean
--- @field private _mouse_focus_mode boolean
--- @field private _mouse_focused_control? NodeUI.Control
--- @field private _mouse_pressed_control? NodeUI.Control
--- @field protected _update_layout boolean
local Control = Class:extend()

--#region Public Methods

--- Cria um novo `Control`.
--- @nodiscard
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param settings? NodeUI.Control.SettingsParameter
--- @return NodeUI.Control Control
function Control:new(x, y, width, height, settings)
	local obj = Class.new(self) --- @cast obj NodeUI.Control

	width = math.abs(width)
	height = math.abs(height)

	obj._x = x
	obj._y = y
	obj._width = width
	obj._height = height

	obj._layout_x = x
	obj._layout_y = y
	obj._layout_width = width
	obj._layout_height = height

	obj._children = {}
	obj._deferred_methods = {}
	obj._mouse_focus = false
	obj._update_layout = true

	obj:setSettings(settings or {})

	return obj
end

--- @param dt number
--- @diagnostic disable-next-line: unused-local
function Control:update(dt)
	if #self._deferred_methods > 0 then
		for _, method in ipairs(self._deferred_methods) do
			if type(self[method]) == "function" then
				self[method](self)
			end
		end
		self._deferred_methods = {}
	end

	self:_onUpdate(dt)

	for _, child in ipairs(self._children) do
		child:update(dt)
	end
end

function Control:draw()
	local clip_enabled = false
	if self._settings.clip_children then
		clip_enabled = true

		love.graphics.setScissor(self._layout_x, self._layout_y, self._layout_width, self._layout_height)
	end

	self:_onDraw()

	for _, child in ipairs(self._children) do
		child:draw()
	end

	if clip_enabled then
		love.graphics.setScissor()
	end
end

--- Adiciona um nó filho.
--- @generic T : NodeUI.Control
--- @param child T
--- @return T child
function Control:addChild(child)
	--- @cast child NodeUI.Control

	child._parent = self
	self._children[#self._children + 1] = child

	child:_deferreMethod("_updateLayout")

	self:_onAddedChild(child)

	return child
end

--- Remove determinado nó filho.
--- @param child NodeUI.Control
function Control:removeChild(child)
	for i, other_child in ipairs(self._children) do
		if other_child == child then
			table.remove(self._children, i)
			child._parent = nil
		end
	end

	return child
end

--- Remove o child em determinado index. Caso não exista, retorna `nil`.
--- @param index number
--- @return NodeUI.Control? child
function Control:removeChildAt(index)
	local child

	if index > 0 and index <= #self._children then
		child = self._children[index]
		table.remove(self._children, index)
		child._parent = nil
	end

	return child
end

--- Atualiza a configuração atual sem sobrescrever valores não alterado.
--- @param settings NodeUI.Control.SettingsParameter
function Control:updateSettings(settings)
	local updated_settings = {}

	for k, v in pairs(self._settings) do
		if type(settings[k]) ~= "nil" then
			updated_settings[k] = settings[k]
		else
			updated_settings[k] = v
		end
	end

	self:setSettings(updated_settings)
end

--#endregion

--#region Input Methods

--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
function Control:mousepressed(x, y, button, istouch, presses)
	local focused = self:_findMouseFocus(x, y)
	self._mouse_focused_control = focused
	self._mouse_pressed_control = focused

	self:_clearMouseFocus()

	if focused then
		focused._mouse_focus = true
		focused:_onMousepressed(x, y, button, istouch, presses)
	end
end

--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
function Control:mousereleased(x, y, button, istouch, presses)
	local pressed = self._mouse_pressed_control

	if pressed then
		pressed:_onMousereleased(x, y, button, istouch, presses)
	end

	self._mouse_pressed_control = nil

	local focused = self:_findMouseFocus(x, y)
	self._mouse_focused_control = focused

	self:_clearMouseFocus()

	if focused then
		focused._mouse_focus = true
	end
end

--- @param x number
--- @param y number
--- @param dx number
--- @param dy number
--- @param istouch boolean
function Control:mousemoved(x, y, dx, dy, istouch)
	self:_clearMouseFocus()

	local focused = self:_findMouseFocus(x, y)
	self._mouse_focused_control = focused

	if focused then
		focused._mouse_focus = true
		focused:_onMousemoved(x, y, dx, dy, istouch)
	end
end

--#endregion

--#region Private Methods

--- Adia um método para ser chamado no próximo update.
--- @private
--- @param method string
function Control:_deferreMethod(method)
	local has_method = false
	for _, other_method in ipairs(self._deferred_methods) do
		if method == other_method then
			has_method = true
			break
		end
	end

	if not has_method then
		self._deferred_methods[#self._deferred_methods + 1] = method
	end
end

--- Retorna se o mouse está dentro ou não.
--- @private
--- @return boolean
function Control:_isPointInside(x, y)
	return x >= self._layout_x
		and y >= self._layout_y
		and x <= self._layout_x + self._layout_width
		and y <= self._layout_y + self._layout_height
end

--- Encontra o foco do mouse na árvore de nós.
--- @private
--- @param x number
--- @param y number
--- @return NodeUI.Control?
function Control:_findMouseFocus(x, y)
	local mode = self._settings.mouse_focus_mode

	if mode == "ignore" then
		return nil
	end

	if not self:_isPointInside(x, y) then
		return nil
	end

	if mode == "stop" then
		return self
	end

	if mode == "pass" then
		for i = #self._children, 1, -1 do
			local child = self._children[i]
			local focused = child:_findMouseFocus(x, y)

			if focused then
				return focused
			end
		end

		return self
	end

	return nil
end

--- Limpa o mouse_focus da árvore de nós.
--- @private
function Control:_clearMouseFocus()
	self._mouse_focus = false

	for _, child in ipairs(self._children) do
		child:_clearMouseFocus()
	end
end

--- Atualiza a layout position e layout dimensions.
--- @private
function Control:_updateLayout()
	local parent = self._parent

	if self._update_layout then
		self._layout_x = self._x
		self._layout_y = self._y
		self._layout_width = self._width
		self._layout_height = self._height
	end

	if parent and self._update_layout then
		local mode = self._settings.layout_mode

		if mode == "top_left" then
			self._layout_x = parent._layout_x
			self._layout_y = parent._layout_y
		elseif mode == "top_right" then
			self._layout_x = parent._layout_x + parent._layout_width - self._width
			self._layout_y = parent._layout_y
		elseif mode == "bottom_left" then
			self._layout_x = parent._layout_x
			self._layout_y = parent._layout_y + parent._layout_height - self._height
		elseif mode == "bottom_right" then
			self._layout_x = parent._layout_x + parent._layout_width - self._width
			self._layout_y = parent._layout_y + parent._layout_height - self._height
		elseif mode == "center" then
			self._layout_x = parent._layout_x + parent._layout_width / 2 - self._width / 2
			self._layout_y = parent._layout_y + parent._layout_height / 2 - self._height / 2
		elseif mode == "center_left" then
			self._layout_x = parent._layout_x
			self._layout_y = parent._layout_y + parent._layout_height / 2 - self._height / 2
		elseif mode == "center_right" then
			self._layout_x = parent._layout_x + parent._layout_width - self._width
			self._layout_y = parent._layout_y + parent._layout_height / 2 - self._height / 2
		elseif mode == "center_top" then
			self._layout_x = parent._layout_x + parent._layout_width / 2 - self._width / 2
			self._layout_y = parent._layout_y
		elseif mode == "center_bottom" then
			self._layout_x = parent._layout_x + parent._layout_width / 2 - self._width / 2
			self._layout_y = parent._layout_y + parent._layout_height - self._height
		elseif mode == "full_rect" then
			self._layout_x = parent._layout_x
			self._layout_y = parent._layout_y
			self._layout_width = parent._layout_width
			self._layout_height = parent._layout_height
		elseif mode == "left_wide" then
			self._layout_x = parent._layout_x
			self._layout_y = parent._layout_y
			self._layout_height = parent._layout_height
		elseif mode == "right_wide" then
			self._layout_x = parent._layout_x + parent._layout_width - self._width
			self._layout_y = parent._layout_y
			self._layout_height = parent._layout_height
		elseif mode == "top_wide" then
			self._layout_x = parent._layout_x
			self._layout_y = parent._layout_y
			self._layout_width = parent._layout_width
		elseif mode == "bottom_wide" then
			self._layout_x = parent._layout_x
			self._layout_y = parent._layout_y + parent._layout_height - self._height
			self._layout_width = parent._layout_width
		elseif mode == "h_center_wide" then
			self._layout_x = parent._layout_x
			self._layout_y = parent._layout_y + parent._layout_height / 2 - self._height / 2
			self._layout_width = parent._layout_width
		elseif mode == "v_center_wide" then
			self._layout_x = parent._layout_x + parent._layout_width / 2 - self._width / 2
			self._layout_y = parent._layout_y
			self._layout_height = parent._layout_height
		end
	end

	self:_onLayoutUpdated()

	for _, child in ipairs(self._children) do
		child:_deferreMethod("_updateLayout")
	end
end

--#endregion

--#region Protected Methods

--- @protected
--- @nodiscard
--- @return number x, number y, number width, number height
function Control:_getBaseTransform()
	return self._x, self._y, self._width, self._height
end

--#endregion

--#region Setters

--- Define a posição horizontal.
--- @param x number
function Control:setX(x)
	self._x = x
	self:_deferreMethod("_updateLayout")
end

--- Define a posição vertical.
--- @param y number
function Control:setY(y)
	self._y = y
	self:_deferreMethod("_updateLayout")
end

--- Define a posição.
--- @param x number
--- @param y number
function Control:setPosition(x, y)
	self:setX(x)
	self:setY(y)
end

--- Define o comprimento.
--- @param width number
function Control:setWidth(width)
	self._width = width >= 0 and width or 0
	self:_deferreMethod("_updateLayout")
end

--- Define a altura.
--- @param height number
function Control:setHeight(height)
	self._height = height >= 0 and height or 0
	self:_deferreMethod("_updateLayout")
end

--- Define as dimensões.
--- @param width number
--- @param height number
function Control:setDimensions(width, height)
	self:setWidth(width)
	self:setHeight(height)
end

--- Sobreescreve a configuração atual.
--- @param settings NodeUI.Control.SettingsParameter
function Control:setSettings(settings)
	settings.layout_mode = settings.layout_mode or "top_left"
	settings.mouse_focus_mode = settings.mouse_focus_mode or "pass"
	settings.clip_children = settings.clip_children or false
	settings.h_container_sizing = settings.h_container_sizing or "fill"
	settings.v_container_sizing = settings.v_container_sizing or "fill"
	settings.container_expand = settings.container_expand or false

	--- @diagnostic disable-next-line: assign-type-mismatch
	self._settings = settings

	if settings.layout_mode then
		self:_deferreMethod("_updateLayout")
	end
end

--#endregion

--#region Getters

--- Retorna a posição horizontal.
--- @nodiscard
--- @return number x
function Control:getX()
	return self._layout_x
end

--- Retorna a posição vertical.
--- @nodiscard
--- @return number y
function Control:getY()
	return self._layout_y
end

--- Retorna a posição.
--- @nodiscard
--- @return number x, number y
function Control:getPosition()
	return self:getX(), self:getY()
end

--- Retorna o comprimento.
--- @nodiscard
--- @return number width
function Control:getWidth()
	return self._layout_width
end

--- Retorna a altura.
--- @nodiscard
--- @return number height
function Control:getHeight()
	return self._layout_height
end

--- Retorna as dimensões.
--- @nodiscard
--- @return number width, number height
function Control:getDimensions()
	return self:getWidth(), self:getHeight()
end

--- Retorna uma cópia das configurações.
--- @nodiscard
--- @return NodeUI.Control.Settings
function Control:getSettings()
	local settings = {}

	for k, v in pairs(self._settings) do
		settings[k] = v
	end

	return settings
end

--- Retorna uma cópia da tabela de filhos.
--- @nodiscard
--- @return NodeUI.Control[]
function Control:getChildren()
	local children = {}

	for _, child in ipairs(self._children) do
		children[#children + 1] = child
	end

	return children
end

--- Retorna se possui ou não o foco do mouse.
--- @nodiscard
--- @return boolean
function Control:hasMouseFocus()
	return self._mouse_focus
end

--#endregion

--#region Callbacks

--- @protected
--- @diagnostic disable-next-line: unused-local
function Control:_onUpdate(dt) end

--- @protected
function Control:_onDraw() end

--- @protected
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
--- @diagnostic disable-next-line: unused-local
function Control:_onMousepressed(x, y, button, istouch, presses) end

--- @protected
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
--- @diagnostic disable-next-line: unused-local
function Control:_onMousereleased(x, y, button, istouch, presses) end

--- @protected
--- @param x number
--- @param y number
--- @param dx number
--- @param dy number
--- @param istouch boolean
--- @diagnostic disable-next-line: unused-local
function Control:_onMousemoved(x, y, dx, dy, istouch) end

--- @protected
--- @param child NodeUI.Control
--- @diagnostic disable-next-line: unused-local
function Control:_onAddedChild(child) end

--- @protected
--- @param child NodeUI.Control
--- @diagnostic disable-next-line: unused-local
function Control:_onRemovedChild(child) end

function Control:_onLayoutUpdated() end

--#endregion

--#region Debug Methods

--- Desenha a depuração.
--- @param settings? NodeUI.Control.DebugSettings
function Control:debug(settings)
	settings = settings or {}

	love.graphics.push("all")

	local color = self._mouse_focus and { 1, 1, 0, 1 } or { 0, 1, 0, 1 }
	local width = settings.line_width or love.graphics.getLineWidth()
	love.graphics.setColor(color)
	love.graphics.setLineWidth(width)

	love.graphics.rectangle("line", self._layout_x, self._layout_y, self._layout_width, self._layout_height)

	love.graphics.pop()
end

--- Desenha recursivamente a depuração dos filhos.
--- @param settings? NodeUI.Control.DebugSettings
function Control:recursiveDebug(settings)
	self:debug(settings)

	for _, child in ipairs(self._children) do
		child:recursiveDebug(settings)
	end
end

--#endregion

return Control
