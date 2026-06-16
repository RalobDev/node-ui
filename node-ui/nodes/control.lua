local ROOT = (...):match("^(.*)%.%w+%.%w+$") --- @type string

local Class = require(ROOT .. ".class")      --- @type Class

--- O **Control** é a classe base de todos os elementos da interface do **`NodeUI`**. Ela fornece funcionalidades fundamentais
--- como hierarquia de nós, sistema de layout, renderização, processamento de eventos de entrada e gerenciamento de sinais.
---
--- ## Descrição
---
--- O **Control** representa um elemento visual da interface e serve como base para todos os controles da biblioteca.
--- Cada controle pode possuir um pai e múltiplos filhos, formando uma árvore de UI organizada hierarquicamente.
---
--- A classe permite posicionar e dimensionar controles em relação ao seu pai ou à área base da interface. Além disso,
--- gerencia visibilidade, foco do mouse, renderização, atualização, clipping de conteúdo e propagação de eventos de entrada.
--- @class NodeUI.Control: Class
--- @field private _node_ui NodeUI
--- @field private _queued_for_deletion boolean
--- @field private _queued_for_update_layout boolean
--- @field private _parent? NodeUI.Control
--- @field private _children NodeUI.Control[]
--- @field private _minimum_width number
--- @field private _minimum_height number
--- @field private _x number
--- @field private _y number
--- @field private _width number
--- @field private _height number
--- @field protected _layout_x number
--- @field protected _layout_y number
--- @field protected _layout_width number
--- @field protected _layout_height number
--- @field private _layout NodeUI.Control.Layout
--- @field private _visible boolean
--- @field private _mouse_focused boolean
--- @field private _mouse_filter NodeUI.Control.MouseFilter
--- @field private _mouse_focused_control? NodeUI.Control
--- @field private _mouse_pressed_control? NodeUI.Control
--- @field private _signal_connections table<string, NodeUI.Control.SignalConnection[]>
--- @field private _is_internal_child boolean
--- @field protected _graphics_push_method function
--- @field clip_content boolean Se `true`, clipa o desenho dos filhos à área do **Control**.
local Control = Class:extend("Control")


--#region Public

--- Cria um novo **Control**.
--- @param x number 			   Posição horizontal.
--- @param y number 			   Posição vertical.
--- @param width number 		   Comprimento em pixels.
--- @param height number 		   Altura em pixels.
--- @return NodeUI.Control Control Novo Control.
function Control:new(x, y, width, height)
	local obj = Class.new(self) --- @cast obj NodeUI.Control

	obj._children = {}

	obj._minimum_width = 0
	obj._minimum_height = 0

	obj._x = x
	obj._y = y
	obj._width = width
	obj._height = height

	obj._layout_x = x
	obj._layout_y = y
	obj._layout_width = width
	obj._layout_height = height

	obj._layout = "TOP_LEFT"
	obj._visible = true

	obj._mouse_focused = false
	obj._mouse_filter = "PASS"

	obj._signal_connections = {}
	obj._is_internal_child = false
	obj.clip_content = false

	obj:connect("MOUSE_PRESSED", obj, "_onMousepressed")
	obj:connect("MOUSE_RELEASED", obj, "_onMousereleased")
	obj:connect("MOUSE_MOVED", obj, "_onMousemoved")
	obj:connect("WHEEL_MOVED", obj, "_onWheelMoved")

	obj:_queueUpdateLayout()

	-- Adiciona o Control à raiz da UI, mas caso tenha um parente seja definido
	-- posteriormente, será removido pelo módulo em NodeUI.process.
	--- @diagnostic disable-next-line: invisible
	Control._node_ui._addRootControl(obj)

	return obj
end

--- Marca para deletar o **Control** no próximo `love.update()`.
---
--- Os nós não são coletados pelo coletor de lixo do **Lua** ao ser definido com `nil`, pois
--- o próprio módulo **`NodeUI`** armazena uma referência deles. Assim é necessário chamar
--- `queueFree` quando quiser remover um nó da biblioteca.
---
--- Ao ser deletado o nó e seus filhos são removidos da raiz do **NodeUI**, mas quaisquer
--- referências fora do módulo continuarão existindo.
function Control:queueFree()
	self._queued_freed = true
end

--- Retorna se o **Control** está na fila de deleção.
--- @nodiscard
--- @return boolean deletion Se `true`, o **Control** está na fila de deleção.
function Control:isQueuedForDeletion()
	return self._queued_freed
end

--- Adiciona um filho ao **Control**. O filho adicionado é retornado, simplificando a criação e
--- referência de filhos.
--- @generic control: NodeUI.Control
--- @param child control 		**Control** filho.
--- @param is_internal? boolean Se `true`, o filho é marcado como interno do **Control**.
--- @return control child 		Filho que foi adicionado.
function Control:addChild(child, is_internal)
	--- @cast child NodeUI.Control

	child._parent = self
	child._is_internal_child = is_internal or false

	self._children[#self._children + 1] = child

	return child
end

--- Remove o `child` do **Control**.
--- @param child NodeUI.Control Filho a ser removido.
function Control:removeChild(child)
	for i = #self._children, 1, -1 do
		local other_child = self._children[i]

		if other_child == child then
			table.remove(self._children, i)
			break
		end
	end
end

--- Retorna se o **Control** está visível ou não.
--- @nodiscard
--- @return boolean visible Visibilidade do **Control**.
function Control:isVisible()
	return self._visible
end

--- Cria uma conexão em determinado sinal do **Control**.
---
--- O `owner` é a tabela que possui o `method`, que deve ser uma `string`. Caso não seja passado um `owner`, o `method`
--- deve ser uma `function`.
---
--- Quando é passado um `owner` o método é chamado desta forma: `owner.method(owner, ...)` para respeitar o padrão `self`.
--- @param signal NodeUI.Control.Signals Nome do sinal.
--- @param method string|function        Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                  Objeto dono do método.
function Control:connect(signal, method, owner)
	if owner and type(method) ~= "string" then
		-- Quando um owner é passado o método deve ser obrigatoriamente uma string.
		return
	elseif not owner and type(method) ~= "function" then
		-- Quando um owner não é passado o método deve ser obrigatoriamente uma função.
		return
	end

	local connection = { --- @type NodeUI.Control.SignalConnection
		method = method,
		owner = owner,
	}

	local _signal_connections = self._signal_connections
	if type(_signal_connections) == "nil" then
		_signal_connections = {}
		self._signal_connections = _signal_connections
	end

	local connections = _signal_connections[signal]
	if type(connections) == "nil" then
		connections = {}
		_signal_connections[signal] = connections
	end

	connections[#connections + 1] = connection
end

--- Remove a conexão de um sinal do **Control**.
--- @param signal NodeUI.Control.Signals Nome do sinal.
--- @param method string|function        Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                  Objeto dono do método.
function Control:disconnect(signal, method, owner)
	local connections = self._signal_connections[signal]
	if type(connections) ~= "table" then
		return
	end

	if type(method) == "function" then
		owner = nil
	end

	for i, connection in ipairs(connections) do
		if connection.method == method and connection.owner == owner then
			table.remove(connections, i)
			return
		end
	end
end

-- #endregion


--#region Engine Callback

--- Atualiza o **Control**.
--- @private
--- @param dt number Tempo decorrido desde a última atualização.
function Control:_update(dt)
	-- Atualiza o layout se estiver marcado para isto.
	if self._queued_for_update_layout then
		self._queued_for_update_layout = false
		self:_updateLayout()
	end

	self:_onUpdate(dt)

	-- Atualiza os filhos.
	for _, child in ipairs(self._children) do
		child:_update(dt)
	end
end

--- Desenha o **Control**.
--- @private
function Control:_draw()
	if not self._visible then
		return
	end

	love.graphics.push("all")

	if type(self._graphics_push_method) == "function" then
		self._graphics_push_method()
	end

	-- Desenha o Control.
	self:_onDraw()

	love.graphics.pop()

	-- Aplica o recorte de tela para área do Control.
	local previous_clip_x, previous_clip_y, previous_clip_w, previous_clip_h = love.graphics.getScissor()
	if self.clip_content then
		love.graphics.setScissor(self._layout_x, self._layout_y, self._layout_width, self._layout_height)
	end

	-- Chama o desenho dos filhos do Control.
	for _, child in ipairs(self._children) do
		child:_draw()
	end

	-- Volta ao recorte de tela anterior.
	if self.clip_content then
		love.graphics.setScissor(previous_clip_x, previous_clip_y, previous_clip_w, previous_clip_h)
	end
end

--- Lida com o pressionar de teclas.
--- @private
--- @param key love.KeyConstant   Caractere da tecla pressionada.
--- @param scancode love.Scancode O scancode que representa a tecla pressionada.
--- @param isrepeat boolean       Se este evento de pressionamento de tecla é uma repetição.
function Control:_keypressed(key, scancode, isrepeat)
	assert(key, scancode, isrepeat)
	-- !PASS
end

--- Lida com o soltar de teclas.
--- @private
--- @param key love.KeyConstant   Caractere da tecla pressionada.
--- @param scancode love.Scancode O scancode que representa a tecla pressionada.
function Control:_keyreleased(key, scancode)
	assert(key, scancode)
	-- !PASS
end

--- Lida com o pressionar de um botão do mouse.
--- @private
--- @param x number        Posição x do mouse, em pixels.
--- @param y number        Posição y do mouse, em pixels.
--- @param button number   O index do botão que foi pressionado.
--- @param istouch boolean `true` se o pressionar do botão do mouse é originado de uma touchscreen.
--- @param presses number  O número de pressionamentos.
function Control:_mousepressed(x, y, button, istouch, presses)
	local focused = self:_updateMouseFocus(x, y)

	if focused then
		focused:_emit("MOUSE_PRESSED", x, y, button, istouch, presses)
		self._mouse_pressed_control = focused
	end
end

--- Lida com o soltar de um botão do mouse.
--- @private
--- @param x number        Posição x do mouse, em pixels.
--- @param y number        Posição y do mouse, em pixels.
--- @param button number   O index do botão que foi solto.
--- @param istouch boolean `true` se o soltar do botão do mouse é originado de uma touchscreen.
--- @param presses number  O número de pressionamentos.
function Control:_mousereleased(x, y, button, istouch, presses)
	local pressed_control = self._mouse_pressed_control

	if pressed_control and pressed_control._visible then
		pressed_control:_emit("MOUSE_RELEASED", x, y, button, istouch, presses)
	end

	self._mouse_pressed_control = nil
	self:_updateMouseFocus(x, y)
end

--- Lida com o movimento do mouse.
--- @private
--- @param x number        Posição x do mouse, em pixels.
--- @param y number        Posição y do mouse, em pixels.
--- @param dx number       Quanto se moveu ao longo do eixo-x.
--- @param dy number       Quanto se moveu ao longo do eixo-y.
--- @param istouch boolean `true` se o movimento do mouse é originado de uma touchscreen.
function Control:_mousemoved(x, y, dx, dy, istouch)
	local focused = self:_updateMouseFocus(x, y)

	if focused then
		focused:_emit("MOUSE_MOVED", x, y, dx, dy, istouch)
	end
end

--- Lida com o movimento da roda do mouse.
--- @private
--- @param x number Quanto se moveu ao longo do eixo-x.
--- @param y number Quanto se moveu ao longo do eixo-y.
function Control:_wheelmoved(x, y)
	local focused = self:_updateMouseFocus(love.mouse.getPosition())

	if focused then
		focused:_emit("WHEEL_MOVED", x, y)
	end
end

--#endregion


--#region Setter

--- Define a posição horizontal do **Control**
--- @param value number Nova posição x.
function Control:setX(value)
	self._x = value
	self:_queueUpdateLayout()
end

--- Define a posição vertical do **Control**
--- @param value number Nova posição y.
function Control:setY(value)
	self._y = value
	self:_queueUpdateLayout()
end

--- Define a posição do **Control**
--- @param x number Nova posição x.
--- @param y number Nova posição y.
function Control:setPosition(x, y)
	self:setX(x)
	self:setY(y)
end

--- Define o comprimento mínimo do **Control**.
--- @param value number Novo comprimento mínimo.
function Control:setMinimumWidth(value)
	self._minimum_width = math.max(0, value)
	self:setWidth(self:getWidth())
	self:_queueUpdateLayout()
end

--- Define a altura mínima do **Control**.
--- @param value number Nova altura mínima.
function Control:setMinimumHeight(value)
	self._minimum_height = math.max(0, value)
	self:setHeight(self:getHeight())
	self:_queueUpdateLayout()
end

--- Define a dimensão mínima do **Control**.
--- @param width number  Novo comprimento mínimo.
--- @param height number Nova altura mínima.
function Control:setMinimumDimensions(width, height)
	self:setMinimumWidth(width)
	self:setMinimumHeight(height)
end

--- Define o comprimento do **Control**.
--- @param value number Novo comprimento.
function Control:setWidth(value)
	self._width = math.max(value, self._minimum_width)
	self:_queueUpdateLayout()
end

--- Define a altura do **Control**.
--- @param value number Novo comprimento.
function Control:setHeight(value)
	self._height = math.max(value, self._minimum_height)
	self:_queueUpdateLayout()
end

--- Define a dimensão do **Control**.
--- @param width number  Novo comprimento.
--- @param height number Nova altura.
function Control:setDimensions(width, height)
	self:setWidth(width)
	self:setHeight(height)
end

--- Define o layout do **Control**.
--- @param layout NodeUI.Control.Layout Novo layout.
function Control:setLayout(layout)
	self._layout = layout
	self:_queueUpdateLayout()
end

--- Define a visibilidade do **Control**. Por padrão ativa a visibilidade.
--- @param enabled? boolean Se `true`, ativa a visibilidade.
function Control:setVisible(enabled)
	enabled = type(enabled) == "nil" and true or enabled
	--- @cast enabled boolean

	if self._visible == enabled then
		return
	end

	self._visible = enabled
end

--- Define o filtro de mouse do **Control**.
--- @param filter NodeUI.Control.MouseFilter Filtro do mouse.
function Control:setMouseFilter(filter)
	self._mouse_filter = filter
	self:_updateMouseFocus(love.mouse.getPosition())
end

--#endregion


--#region Private Setter

--- Define o foco do mouse do **Control**.
--- @private
--- @param enabled boolean Se `true`, ativa o foco do mouse.
function Control:_setMouseFocus(enabled)
	local previous_focus = self._mouse_focused
	self._mouse_focused = enabled

	if enabled ~= previous_focus then
		self:_emit("MOUSE_FOCUS_CHANGED", enabled)
	end
end

--#endregion


--#region Getter

--- Retorna o parente do **Control** ou `nil` caso ela não tenha um.
--- @nodiscard
--- @return NodeUI.Control? parent Parente do **Control**.
function Control:getParent()
	return self._parent
end

--- Retorna uma tabela com todos os filhos do **Control**.
--- @nodiscard
--- @param include_internal? boolean Se `true`, retorna os filhos internos também.
--- @return NodeUI.Control[] children Filhos do **Control**.
function Control:getChildren(include_internal)
	local children = {} --- @type NodeUI.Control[]

	-- Cria uma cópia da tabela de filhos para protegé-la.
	for _, child in ipairs(self._children) do
		if child._is_internal_child then
			if include_internal then
				children[#children + 1] = child
			end
		else
			children[#children + 1] = child
		end
	end

	return children
end

--- Retorna a posição x do **Control**.
--- @nodiscard
--- @return number x Posição x.
function Control:getX()
	return self._layout_x
end

--- Retorna a posição y do **Control**.
--- @nodiscard
--- @return number y Posição y.
function Control:getY()
	return self._layout_y
end

--- Retorna a posição do **Control**.
--- @nodiscard
--- @return number x Posição x.
--- @return number y Posição y.
function Control:getPosition()
	return self:getX(), self:getY()
end

--- Retorna o comprimento mínimo do **Control**.
--- @nodiscard
--- @return number width Comprimento mínimo do **Control**.
function Control:getMinimumWidth()
	return self._minimum_width
end

--- Retorna a altura mínima do **Control**.
--- @nodiscard
--- @return number height Altura mínima do **Control**.
function Control:getMinimumHeight()
	return self._minimum_height
end

--- Retorna a dimensão mínima do **Control**.
--- @nodiscard
--- @return number width  Comprimento mínimo do **Control**.
--- @return number height Altura mínima do **Control**.
function Control:getMinimumDimensions()
	return self:getMinimumWidth(), self:getMinimumHeight()
end

--- Retorna o comprimento do **Control**.
--- @nodiscard
--- @return number width Comprimento do **Control**.
function Control:getWidth()
	return self._layout_width
end

--- Retorna a altura do **Control**.
--- @nodiscard
--- @return number height Altura do **Control**.
function Control:getHeight()
	return self._layout_height
end

--- Retorna a dimensão do **Control**.
--- @nodiscard
--- @return number width  Comprimento do **Control**.
--- @return number height Altura do **Control**.
function Control:getDimensions()
	return self:getWidth(), self:getHeight()
end

--- Retorna o layout do **Control**.
--- @nodiscard
--- @return NodeUI.Control.Layout layout Layout do **Control**.
function Control:getLayout()
	return self._layout
end

--- Retorna o filtro de mouse do **Control**.
--- @nodiscard
--- @return NodeUI.Control.MouseFilter mouse_filter Filtro do mouse.
function Control:getMouseFilter()
	return self._mouse_filter
end

--#endregion


--#region Protected

--- Marca para atualizar o layout do **Control** no próximo `love.update()`.
--- @protected
function Control:_queueUpdateLayout()
	if self._queued_for_update_layout then
		return
	end

	self._queued_for_update_layout = true
end

--- Emite o `signal`, chamando todos os seus métodos.
--- @protected
--- @param signal NodeUI.Control.Signals Nome do sinal.
function Control:_emit(signal, ...)
	local connections = self._signal_connections[signal]
	if type(connections) == "nil" then
		return
	end

	for _, connection in ipairs(connections) do
		local method_function = connection.owner and connection.owner[connection.method] or connection.method

		if type(method_function) ~= "function" then
			goto continue
		end

		if connection.owner then
			method_function(connection.owner, ...)
		else
			method_function(...)
		end

		::continue::
	end
end

--#endregion


--#region Private

--- Atualiza a posição e dimensões do **Control** de acordo com suas âncoras e offsets.
--- @private
function Control:_updateLayout()
	if not self._visible then
		return
	end

	if self:is("Container") then
		--- @diagnostic disable-next-line: undefined-field
		self:_queueUpdateChildrenLayout()
	end

	-- Quando o Control é filho de um Container ele não pode atualizar seu próprio layout.
	local parent = self._parent
	if parent and parent:is("Container") then
		--- @cast parent NodeUI.Container

		--- @diagnostic disable-next-line: invisible
		parent:_queueUpdateChildrenLayout()

		return
	end

	-- Atualiza o layout do Control.
	self:_onUpdateLayout()

	-- Marca os filhos para atualizarem seu layout.
	for _, child in ipairs(self._children) do
		child:_queueUpdateLayout()
	end
end

--- Desenha a depuração do **Control**.
--- @private
function Control:_drawDebug()
	if not self._visible then
		return
	end


	local default_color = { love.graphics.getColor() }
	love.graphics.setColor(self._mouse_focused and { 1, 1, 0 } or { 0, 1, 0 })

	love.graphics.push("all")

	if type(self._graphics_push_method) == "function" then
		self._graphics_push_method()
	end

	self:_onDrawDebug()

	love.graphics.pop()

	love.graphics.setColor(default_color)

	-- Aplica o recorte de tela para área do Control.
	local previous_clip_x, previous_clip_y, previous_clip_w, previous_clip_h = love.graphics.getScissor()
	if self.clip_content then
		love.graphics.setScissor(self._layout_x, self._layout_y, self._layout_width, self._layout_height)
	end

	for _, child in ipairs(self._children) do
		child:_drawDebug()
	end

	-- Volta ao recorte de tela anterior.
	if self.clip_content then
		love.graphics.setScissor(previous_clip_x, previous_clip_y, previous_clip_w, previous_clip_h)
	end
end

--- Encontra o foco do mouse na árvore de nós. Caso não exista retorna `nil`.
--- @private
--- @param x number        		    Posição x do mouse.
--- @param y number                 Posição y do mouse.
--- @return NodeUI.Control? focused **Control** com o foco do mouse.
function Control:_findMouseFocus(x, y)
	if not self:isVisible() then
		return nil
	end

	local filter = self._mouse_filter

	if filter == "IGNORE" then
		return nil
	end

	-- Verifica se o mouse está sobre o Control.
	if not (x >= self._layout_x
			and y >= self._layout_y
			and x <= self._layout_x + self._layout_width
			and y <= self._layout_y + self._layout_height) then
		return nil
	end

	if filter == "STOP" then
		return self
	end

	if filter == "PASS" then
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

--- Limpa o foco do mouse da árvore de nós.
--- @param exclude? NodeUI.Control **Control** que será excluido da limpeza.
--- @private
function Control:_clearMouseFocus(exclude)
	if self ~= exclude then
		self:_setMouseFocus(false)
	end

	for _, child in ipairs(self._children) do
		child:_clearMouseFocus()
	end
end

--- Atualiza o foco do mouse na árvore de nós. Se existir, retorna o **Control** com o foco do mouse.
--- @private
--- @param x number 				Posição horizontal do mouse.
--- @param y number                 Posição vertical do mouse.
--- @return NodeUI.Control? focused **Control** com o foco do mouse.
function Control:_updateMouseFocus(x, y)
	local focused = self:_findMouseFocus(x, y)

	self._mouse_focused_control = focused
	self:_clearMouseFocus(focused)

	if focused then
		focused:_setMouseFocus(true)
	end


	return focused
end

--#endregion


--#region Protected Callback

--- Chamado durante a atualização do **Control**.
--- @protected
--- @param dt number Tempo decorrido desde a última atualização.
function Control:_onUpdate(dt)
	assert(dt)
end

--- Chamado durante o desenho do **Control**.
--- @protected
function Control:_onDraw() end

--- Chamado durante a depuração do **Control**.
---
--- Este método deve ser sobreescrito em cada classe de **Control**, pois
--- é responsável por desenhar a depuração dela.
--- @protected
function Control:_onDrawDebug()
	love.graphics.rectangle("line", self._layout_x, self._layout_y, self._layout_width, self._layout_height)
end

--- Chamado quando um botão do mouse é pressionado.
--- @protected
--- @param x number        Posição x do mouse, em pixels.
--- @param y number        Posição y do mouse, em pixels.
--- @param button number   O index do botão que foi pressionado.
--- @param istouch boolean `true` se o pressionar do botão do mouse é originado de uma touchscreen.
--- @param presses number  O número de pressionamentos.
--- @diagnostic disable-next-line: unused-local
function Control:_onMousepressed(x, y, button, istouch, presses) end

--- Chamado quando um botão do mouse é solto.
--- @protected
--- @param x number        Posição x do mouse, em pixels.
--- @param y number        Posição y do mouse, em pixels.
--- @param button number   O index do botão que foi solto.
--- @param istouch boolean `true` se o soltar do botão do mouse é originado de uma touchscreen.
--- @param presses number  O número de pressionamentos.
--- @diagnostic disable-next-line: unused-local
function Control:_onMousereleased(x, y, button, istouch, presses) end

--- Chamado quando o mouse é movido.
--- @protected
--- @param x number        Posição x do mouse, em pixels.
--- @param y number        Posição y do mouse, em pixels.
--- @param dx number       Quanto se moveu ao longo do eixo-x.
--- @param dy number       Quanto se moveu ao longo do eixo-y.
--- @param istouch boolean `true` se o movimento do mouse é originado de uma touchscreen.
--- @diagnostic disable-next-line: unused-local
function Control:_onMousemoved(x, y, dx, dy, istouch) end

--- Chamado quando a roda do mouse é movida.
--- @private
--- @param x number Quanto se moveu ao longo do eixo-x.
--- @param y number Quanto se moveu ao longo do eixo-y.
--- @diagnostic disable-next-line: unused-local
function Control:_onWheelMoved(x, y) end

--- Chamado durante a atualização do layout do **Control**.
--- @protected
function Control:_onUpdateLayout()
	local base_width = self._parent and self._parent:getWidth() or self._node_ui:getBaseWidth()
	local base_height = self._parent and self._parent:getHeight() or self._node_ui:getBaseHeight()
	local begin_x = self._parent and self._parent:getX() or self._node_ui:getBaseX()
	local begin_y = self._parent and self._parent:getY() or self._node_ui:getBaseY()
	local end_x = begin_x + base_width
	local end_y = begin_y + base_height

	local x = self._x
	local y = self._y
	local width = self._width
	local height = self._height

	local layout = self._layout
	local layout_x, layout_y = x, y
	local layout_width, layout_height = width, height


	if layout == "TOP_LEFT" then
		layout_x = begin_x
		layout_y = begin_y

		layout_width = width
		layout_height = height
	elseif layout == "TOP_RIGHT" then
		layout_x = end_x - width
		layout_y = begin_y

		layout_width = width
		layout_height = height
	elseif layout == "BOTTOM_LEFT" then
		layout_x = begin_x
		layout_y = end_y - height

		layout_width = width
		layout_height = height
	elseif layout == "BOTTOM_RIGHT" then
		layout_x = end_x - width
		layout_y = end_y - height

		layout_width = width
		layout_height = height
	elseif layout == "CENTER_LEFT" then
		layout_x = begin_x
		layout_y = begin_y + base_height / 2 - height / 2

		layout_width = width
		layout_height = height
	elseif layout == "CENTER_RIGHT" then
		layout_x = end_x - width
		layout_y = begin_y + base_height / 2 - height / 2

		layout_width = width
		layout_height = height
	elseif layout == "CENTER_TOP" then
		layout_x = begin_x + base_width / 2 - width / 2
		layout_y = begin_y

		layout_width = width
		layout_height = height
	elseif layout == "CENTER_BOTTOM" then
		layout_x = begin_x + base_width / 2 - width / 2
		layout_y = end_y - height

		layout_width = width
		layout_height = height
	elseif layout == "CENTER" then
		layout_x = begin_x + base_width / 2 - width / 2
		layout_y = begin_y + base_height / 2 - height / 2

		layout_width = width
		layout_height = height
	elseif layout == "LEFT_WIDE" then
		layout_x = begin_x
		layout_y = begin_y

		layout_width = width
		layout_height = base_height
	elseif layout == "RIGHT_WIDE" then
		layout_x = end_x - width
		layout_y = begin_y

		layout_width = width
		layout_height = base_height
	elseif layout == "TOP_WIDE" then
		layout_x = begin_x
		layout_y = begin_y

		layout_width = base_width
		layout_height = height
	elseif layout == "BOTTOM_WIDE" then
		layout_x = begin_x
		layout_y = end_y - height

		layout_width = base_width
		layout_height = height
	elseif layout == "VCENTER_WIDE" then
		layout_x = begin_x + base_width / 2 - width / 2
		layout_y = begin_y

		layout_width = width
		layout_height = base_height
	elseif layout == "HCENTER_WIDE" then
		layout_x = begin_x
		layout_y = begin_y + base_height / 2 - height / 2

		layout_width = base_width
		layout_height = height
	elseif layout == "HEXPAND" then
		layout_x = x
		layout_y = y

		layout_width = end_x - x
		layout_height = height
	elseif layout == "VEXPAND" then
		layout_x = x
		layout_y = y

		layout_width = width
		layout_height = end_y - y
	elseif layout == "EXPAND" then
		layout_x = x
		layout_y = y

		layout_width = end_x - x
		layout_height = end_y - y
	elseif layout == "FULL_RECT" then
		layout_x = begin_x
		layout_y = begin_y

		layout_width = base_width
		layout_height = base_height
	elseif layout == "CUSTOM" then
		layout_x = x
		layout_y = y

		layout_width = width
		layout_height = height
	end

	-- Atualiza a posição e dimensão do layout.
	self._layout_x = layout_x
	self._layout_y = layout_y
	self._layout_width = layout_width
	self._layout_height = layout_height
end

--- Chamado quando o foco do mouse do **Control** muda.
--- @protected
--- @param focused boolean Se está focado pelo mouse.
--- @diagnostic disable-next-line: unused-local
function Control:_onMouseFocusChanged(focused) end

--#endregion


return Control
