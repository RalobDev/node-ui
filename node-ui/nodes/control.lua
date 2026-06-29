local ROOT = (...):match("^(.*)%.%w+%.%w+$")                 --- @type string

local Class = require(ROOT .. ".class")                      --- @type Class
local Signal = require(ROOT .. ".resources.abstract.signal") --- @type NodeUI.Signal

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
--- @field protected _node_ui NodeUI
--- @field private _queued_for_deletion boolean
--- @field private _queued_for_update_layout boolean
--- @field private _parent? NodeUI.Control
--- @field private _children NodeUI.Control[]
--- @field private _minimum_width number
--- @field private _minimum_height number
--- @field protected _x number
--- @field protected _y number
--- @field protected _width number
--- @field protected _height number
--- @field protected _layout_x number
--- @field protected _layout_y number
--- @field protected _layout_width number
--- @field protected _layout_height number
--- @field private _size_flags_horizontal NodeUI.Control.SizeFlags
--- @field private _size_flags_vertical NodeUI.Control.SizeFlags
--- @field private _layout NodeUI.Control.Layout
--- @field private _visible boolean
--- @field private _mouse_filter NodeUI.Control.MouseFilter
--- @field private _focus_mode NodeUI.Control.FocusMode
--- @field private _focus_behavior_recursive NodeUI.Control.FocusBehavior
--- @field private _focus_next? NodeUI.Control
--- @field private _focus_previous? NodeUI.Control
--- @field private _neighbor_left? NodeUI.Control
--- @field private _neighbor_right? NodeUI.Control
--- @field private _neighbor_top? NodeUI.Control
--- @field private _neighbor_bottom? NodeUI.Control
--- @field protected _signal NodeUI.Signal
--- @field private _is_internal_child boolean
--- @field private _clip_content boolean
local Control = Class:extend("Control")


--#region Public

--- Cria um novo **Control**.
--- @nodiscard
--- @param x number 			   Posição horizontal.
--- @param y number 			   Posição vertical.
--- @param width number 		   Comprimento em pixels.
--- @param height number 		   Altura em pixels.
--- @param is_minimum? boolean      Se a dimensão passada é a mínima.
--- @return NodeUI.Control Control Novo Control.
function Control:new(x, y, width, height, is_minimum)
	local obj = Class.new(self) --- @cast obj NodeUI.Control

	obj._children = {}

	obj._minimum_width = 0
	obj._minimum_height = 0

	obj._x = x
	obj._y = y
	obj._width = 0
	obj._height = 0

	obj._layout_x = x
	obj._layout_y = y
	obj._layout_width = 0
	obj._layout_height = 0

	obj._size_flags_horizontal = "FILL"
	obj._size_flags_vertical = "FILL"

	obj._layout = "TOP_LEFT"
	obj._visible = true

	obj._mouse_filter = "PASS"

	obj._focus_mode = "NONE"
	obj._focus_behavior_recursive = "INHERITED"

	obj._signal = Signal:new()
	obj._is_internal_child = false
	obj._clip_content = false

	obj:setMinimumDimensions(
		is_minimum and width or 0,
		is_minimum and height or 0
	)
	obj:setDimensions(width, height)

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
--- Ao ser deletado o nó e seus filhos são removidos da raiz do **`NodeUI`**, mas quaisquer
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

--- Cria uma conexão em determinado **`NodeUI.Control.Signals** do **Control**.
---
--- O `owner` é a tabela que possui o `method`, que deve ser uma `string`. Caso não seja passado um `owner`, o `method`
--- deve ser uma `function`.
---
--- Quando é passado um `owner` o método é chamado desta forma: `owner.method(owner, ...)` para respeitar o padrão `self`.
--- @param signal NodeUI.Control.Signals Nome do sinal.
--- @param method string|function        Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                  Objeto dono do método.
function Control:connect(signal, method, owner)
	self._signal:connect(signal, method, owner)
end

--- Remove a conexão de um **`NodeUI.Control.Signals`** do **Control**.
--- @param signal NodeUI.Control.Signals Nome do sinal.
--- @param method string|function        Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                  Objeto dono do método.
function Control:disconnect(signal, method, owner)
	self._signal:disconnect(signal, method, owner)
end

--- Retorna se o cursor do mouse está sobre o **Control**.
--- @nodiscard
--- @return boolean focused Se o cursor está sobre.
function Control:isHovered()
	return self._node_ui.getControlMouseFocus() == self
end

--- Solicita que este nó receba o foco do teclado/input.
function Control:grabFocus()
	self._node_ui._setFocus(self) --- @diagnostic disable-line: invisible
end

--- Retorna se este controle é o que detém o foco atualmente.
--- @nodiscard
--- @return boolean has_focus Se o nó está focado.
function Control:hasFocus()
	return self._node_ui._getFocusedControl() == self --- @diagnostic disable-line: invisible
end

-- #endregion


--#region Engine Callback

--- Atualiza o **Control**.
--- @private
--- @param dt number Tempo decorrido desde a última atualização.
function Control:_update(dt)
	if self._queued_for_update_layout then
		self._queued_for_update_layout = false
		self:_updateLayout()
	end

	self:_onUpdate(dt)

	for i = #self._children, 1, -1 do
		local child = self._children[i]

		if child:isQueuedForDeletion() then
			-- Deleta o filho se estiver marcado para deleção.
			table.remove(self._children, i)
		else
			-- Atualiza o filho.
			child:_update(dt)
		end
	end
end

--- Desenha o **Control**.
--- @private
function Control:_draw()
	-- Controls invisíveis não são desenhados.
	if not self._visible then
		return
	end

	local prev_scissor_x, prev_scissor_y, prev_scissor_w, prev_scissor_h = love.graphics.getScissor()

	-- Aplica o recorte de tela para área do Control.
	if self._clip_content then
		love.graphics.setScissor(self._layout_x, self._layout_y, self._layout_width, self._layout_height)
	end

	-- Desenha o Control.
	self:_onDraw()

	-- Chama o desenho dos filhos do Control.
	for _, child in ipairs(self._children) do
		self:_onDrawChild(child)
	end

	love.graphics.setScissor(prev_scissor_x, prev_scissor_y, prev_scissor_w, prev_scissor_h)
end

--#endregion


--#region Setter

--- Define a posição horizontal do **Control**
--- @param value number Nova posição x.
function Control:setX(value)
	local old = self._x

	self._x = value

	if self._x ~= old then
		self:_queueUpdateLayout()
	end
end

--- Define a posição vertical do **Control**
--- @param value number Nova posição y.
function Control:setY(value)
	local old = self._y

	self._y = value

	if self._y ~= old then
		self:_queueUpdateLayout()
	end
end

--- Define a posição do **Control**
--- @param x number Nova posição x.
--- @param y number Nova posição y.
function Control:setPosition(x, y)
	self:setX(x)
	self:setY(y)
end

--- Define o comprimento mínimo do **Control**.
--- @param width number Novo comprimento mínimo.
function Control:setMinimumWidth(width)
	local old = self._minimum_width

	self._minimum_width = math.max(0, width)

	if self._minimum_width ~= old then
		self:setWidth(self._width)
		self:_queueUpdateLayout()
	end
end

--- Define a altura mínima do **Control**.
--- @param height number Nova altura mínima.
function Control:setMinimumHeight(height)
	local old = self._minimum_height

	self._minimum_height = math.max(0, height)

	if self._minimum_height ~= old then
		self:setHeight(self._height)
		self:_queueUpdateLayout()
	end
end

--- Define a dimensão mínima do **Control**.
--- @param width number  Novo comprimento mínimo.
--- @param height number Nova altura mínima.
function Control:setMinimumDimensions(width, height)
	self:setMinimumWidth(width)
	self:setMinimumHeight(height)
end

--- Define o comprimento do **Control**.
--- @param width number Novo comprimento.
function Control:setWidth(width)
	local old = self._width

	self._width = math.max(width, self:getMinimumWidth())

	if self._width ~= old then
		self:_queueUpdateLayout()
	end
end

--- Define a altura do **Control**.
--- @param height number Nova altura.
function Control:setHeight(height)
	local old = self._height

	self._height = math.max(height, self:getMinimumHeight())

	if self._height ~= old then
		self:_queueUpdateLayout()
	end
end

--- Define a dimensão do **Control**.
--- @param width number  Novo comprimento.
--- @param height number Nova altura.
function Control:setDimensions(width, height)
	self:setWidth(width)
	self:setHeight(height)
end

--- Define o **`NodeUI.Control.Layout`** do **Control**.
--- @param layout NodeUI.Control.Layout Novo layout.
function Control:setLayout(layout)
	local old = self._layout

	self._layout = layout

	if self._layout ~= old then
		self:_queueUpdateLayout()
	end
end

--- Define a visibilidade do **Control**. Por padrão ativa a visibilidade.
--- @param enabled? boolean Se `true`, ativa a visibilidade.
function Control:setVisible(enabled)
	enabled = enabled == nil and true or enabled
	--- @cast enabled boolean

	local old = self._visible

	self._visible = enabled

	if old == false and self._visible then
		self:_queueUpdateLayout()
	end
end

--- Define o recorte de conteúdo do **Control**. Se `true`, clipa o desenho dos filhos à área do **Control**.
--- Por padrão ativa o recorte de conteúdo.
--- @param enabled? boolean
function Control:setClipContent(enabled)
	enabled = enabled == nil and true or enabled
	--- @cast enabled boolean

	self._clip_content = enabled
end

--- Define o **`NodeUI.Control.MouseFilter`** do **Control**.
--- @param filter NodeUI.Control.MouseFilter Filtro do mouse.
function Control:setMouseFilter(filter)
	self._mouse_filter = filter
end

--- Define a **`NodeUI.Control.SizeFlags`** do `axis`. Ela afeta a maneira como o **Control**
--- se comporta em um **`Container`**.
--- @param axis NodeUI.Control.Axis Eixo da size flags.
--- @param size_flags NodeUI.Control.SizeFlags Size flags aplicada ao `axis`.
function Control:setSizeFlags(axis, size_flags)
	if axis == "BOTH" then
		self:setSizeFlags("HORIZONTAL", size_flags)
		self:setSizeFlags("VERTICAL", size_flags)
		return
	end

	local size_flags_key = "_size_flags_" .. axis:lower()
	local old = self[size_flags_key]

	self[size_flags_key] = size_flags

	if self[size_flags_key] ~= old then
		self:_queueUpdateLayout()
	end
end

--- Define o **`NodeUI.Control.FocusMode`**.
--- @param focus_mode NodeUI.Control.FocusMode Modo do foco.
function Control:setFocusMode(focus_mode)
	local old = self._focus_mode

	self._focus_mode = focus_mode

	if self._focus_mode ~= old then
		-- Se mudou em tempo de execução e este controle está focado, verifica se ainda pode manter o foco.
		if self:hasFocus() and self:getFocusModeWithOverride() == "NONE" then
			self._node_ui._setFocus(nil) --- @diagnostic disable-line: invisible
		end
	end
end

--- Define o **`NodeUI.Control.FocusBehavior`**.
--- @param focus_behavior NodeUI.Control.FocusBehavior Comportamento do foco.
function Control:setFocusBehaviorRecursive(focus_behavior)
	local old = self._focus_behavior_recursive

	self._focus_behavior_recursive = focus_behavior

	if self._focus_behavior_recursive ~= old then
		-- Quando a recursividade muda, o controle atual ou seus filhos podem perder o foco.
		local current_focus = self._node_ui._getFocusedControl() --- @diagnostic disable-line: invisible

		if current_focus then
			-- Verifica se o controle focado é 'self' ou algum de seus descendentes.
			local parent = current_focus --- @type NodeUI.Control?
			while parent do
				if parent == self then
					-- Se o 'self' ou um filho dele tem o foco, reavaliamos o modo.
					-- Se agora for NONE, soltamos o foco.
					if current_focus:getFocusModeWithOverride() == "NONE" then
						self._node_ui._setFocus(nil) --- @diagnostic disable-line: invisible
					end
					break
				end
				parent = parent:getParent()
			end
		end
	end
end

--- Define o próximo **Control** a receber foco.
--- @param focus_next NodeUI.Control|nil Próximo nó a receber foco.
function Control:setFocusNext(focus_next)
	self._focus_next = focus_next
end

--- Define **Control** anterior a receber foco.
--- @param focus_previous NodeUI.Control|nil Nó anterior a receber foco.
function Control:setFocusPrevious(focus_previous)
	self._focus_previous = focus_previous
end

--- Define o **Control** vizinho do **`NodeUI.Control.Side`** a receber foco.
--- @param side NodeUI.Control.Side
--- @param neighbor NodeUI.Control|nil
function Control:setNeighborFocus(side, neighbor)
	local neighbor_key = "_neighbor_" .. side:lower()
	self[neighbor_key] = neighbor
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

--- Retorna o comprimento base do **Control**. É o comprimento definido ao criar o **Control** e ao chamar
--- `Control:setWidth()`.
--- @nodiscard
--- @return number width Comprimento base.
function Control:getBaseWidth()
	return self._width
end

--- Retorna a altura base do **Control**. É a altura definida ao criar o **Control** e ao chamar
--- `Control:setHeight()`.
--- @nodiscard
--- @return number height Altura base.
function Control:getBaseHeight()
	return self._height
end

--- Retorna a dimensão base do **Control**. É a dimensão definida ao criar o **Control** e ao chamar
--- `Control:setDimensions()`.
--- @nodiscard
--- @return number width  Comprimento base.
--- @return number height Altura base.
function Control:getBaseDimensions()
	return self._width, self._height
end

--- Retorna o comprimento mínimo do **Control**.
--- @nodiscard
--- @return number width Comprimento mínimo do **Control**.
function Control:getMinimumWidth()
	return math.max(self._minimum_width, self:_calculateMinimumWidth())
end

--- Retorna a altura mínima do **Control**.
--- @nodiscard
--- @return number height Altura mínima do **Control**.
function Control:getMinimumHeight()
	return math.max(self._minimum_height, self:_calculateMinimumHeight())
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

--- Retorna o **`NodeUI.Control.Layout`** do **Control**.
--- @nodiscard
--- @return NodeUI.Control.Layout layout Layout do **Control**.
function Control:getLayout()
	return self._layout
end

--- Retorna se o recorte de conteúdo do **Control** está ativado.
--- @nodiscard
--- @return boolean clip_content Se o recorte de conteúdo está ativo.
function Control:getClipContent()
	return self._clip_content
end

--- Retorna o **`NodeUI.Control.MouseFilter`** do **Control**.
--- @nodiscard
--- @return NodeUI.Control.MouseFilter mouse_filter Filtro do mouse.
function Control:getMouseFilter()
	return self._mouse_filter
end

--- Retorna a **`NodeUI.Control.SizeFlags`** do `axis`. Ela afeta a maneira como o **Control**
--- se comporta em um **`Container`**.
--- @nodiscard
--- @param axis NodeUI.Control.Axis Eixo da size flags.
--- @return NodeUI.Control.SizeFlags size_flags Size flags aplicada ao `axis`.
function Control:getSizeFlags(axis)
	return self["_size_flags_" .. axis:lower()]
end

--- Retorna o **`NodeUI.Control.FocusMode`** real do **Control**, respeitando a herança do parent.
--- @nodiscard
--- @return NodeUI.Control.FocusMode focus_mode Modo de foco real.
function Control:getFocusModeWithOverride()
	if self._focus_behavior_recursive == "DISABLED" then
		return "NONE"
	elseif self._focus_behavior_recursive == "ENABLED" then
		return self._focus_mode
	end

	-- Se for INHERITED, sobe a árvore procurando quem quebra a herança.
	local current_parent = self._parent
	while current_parent do
		if current_parent._focus_behavior_recursive == "DISABLED" then
			return "NONE"
		elseif current_parent._focus_behavior_recursive == "ENABLED" then
			return self._focus_mode
		end
		current_parent = current_parent:getParent()
	end

	-- Se chegou na raiz e ninguém alterou, INHERITED age como ENABLED.
	return self._focus_mode
end

--- Retorna o **`NodeUI.Control.FocusMode`**.
--- @nodiscard
--- @return NodeUI.Control.FocusMode focus_mode Modo do foco.
function Control:getFocusMode()
	return self._focus_mode
end

--- Retorna o **`NodeUI.Control.FocusBehavior`**.
--- @nodiscard
--- @return NodeUI.Control.FocusBehavior focus_behavior Comportamento do foco.
function Control:getFocusBehaviorRecursive()
	return self._focus_behavior_recursive
end

--- Define o próximo **Control** a receber foco.
--- @return NodeUI.Control|nil focus_next Próximo nó a receber foco.
function Control:getFocusNext()
	return self._focus_next
end

--- Retorna **Control** anterior a receber foco.
--- @nodiscard
--- @return NodeUI.Control|nil focus_previous Nó anterior a receber foco.
function Control:getFocusPrevious()
	return self._focus_previous
end

--- Retorna o **Control** vizinho do **`NodeUI.Control.Side`** a receber foco.
--- @nodiscard
--- @param side NodeUI.Control.Side
--- @return NodeUI.Control|nil neighbor
function Control:getNeighborFocus(side)
	local neighbor_key = "_neighbor_" .. side:lower()
	return self[neighbor_key]
end

--#endregion


--#region Protected

--- Marca para atualizar o layout do **Control** no próximo `love.update()`.
--- @protected
function Control:_queueUpdateLayout()
	self._queued_for_update_layout = true
end

--- Retorna se o id do `event` corresponde a determinado **NodeUI.InputEvent.IDs**.
--- @nodiscard
--- @protected
--- @param event NodeUI.InputEvent
--- @param id NodeUI.InputEvent.IDs
--- @return boolean event_is Se o id corresponde ao event.
function Control:_eventIs(event, id)
	return event.id == id
end

--- Aceita um **InputEvent**. Caso seja passado um `conditional_id`, o evento só será aceito se o id corresponder.
--- @protected
--- @param event NodeUI.InputEvent
--- @param conditional_id? NodeUI.InputEvent.IDs
--- @return boolean accepted
function Control:_acceptEvent(event, conditional_id)
	local can_accept = true

	if conditional_id ~= nil and event.id ~= conditional_id then
		can_accept = false
	end

	event.accepted = can_accept
	return can_accept
end

--#endregion


--#region Protected Getter

--- Calcula dinamicamente o comprimento mínimo do **Control**.
--- @protected
--- @return number width
function Control:_calculateMinimumWidth()
	return 0
end

--- Calcula dinamicamente a altura mínima do **Control**.
--- @protected
--- @return number height
function Control:_calculateMinimumHeight()
	return 0
end

--#endregion


--#region Protected Callback

--- Chamado durante a atualização do **Control**.
--- @protected
--- @param dt number Tempo decorrido desde a última atualização.
--- @diagnostic disable-next-line: unused-local
function Control:_onUpdate(dt) end

--- Chamado durante o desenho do **Control**.
--- @protected
function Control:_onDraw() end

--- Chamado durante o desenho de um filho do **Control**.
--- @protected
--- @param child NodeUI.Control
function Control:_onDrawChild(child)
	child:_draw()
end

--- Chamado durante a depuração do **Control**.
---
--- Este método deve ser sobreescrito em cada classe de **Control**, pois
--- é responsável por desenhar a depuração dela.
--- @protected
function Control:_onDrawDebug()
	love.graphics.rectangle("line", self._layout_x, self._layout_y, self._layout_width, self._layout_height)
end

--- Lida com um **InputEvent**.
--- @protected
--- @param event NodeUI.InputEvent
--- @diagnostic disable-next-line: unused-local
function Control:_onInput(event) end

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
	local width = math.max(self._width, self:getMinimumWidth())
	local height = math.max(self._height, self:getMinimumHeight())

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
		layout_x = begin_x + x
		layout_y = begin_y + y

		layout_width = end_x - layout_x
		layout_height = height
	elseif layout == "VEXPAND" then
		layout_x = begin_x + x
		layout_y = begin_y + y

		layout_width = width
		layout_height = end_y - layout_y
	elseif layout == "EXPAND" then
		layout_x = begin_x + x
		layout_y = begin_y + y

		layout_width = end_x - layout_x
		layout_height = end_y - layout_y
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
function Control:_onChangedHover(focused) end

--#endregion


--#region Private

--- Desenha a depuração do **Control**.
--- @private
function Control:_drawDebug()
	if not self._visible then
		return
	end

	local r, g, b, a = love.graphics.getColor()
	local default_line_width = love.graphics.getLineWidth()
	love.graphics.setColor(self:isHovered() and { 1, 1, 0 } or { 0, 1, 0 })
	love.graphics.setLineWidth(self:hasFocus() and default_line_width * 6 or default_line_width)

	self:_onDrawDebug()

	-- Aplica o recorte de tela para área do Control.
	local prev_scissor_x, prev_scissor_y, prev_scissor_w, prev_scissor_h = love.graphics.getScissor()
	if self._clip_content then
		love.graphics.setScissor(self._layout_x, self._layout_y, self._layout_width, self._layout_height)
	end

	for _, child in ipairs(self._children) do
		child:_drawDebug()
	end

	love.graphics.setScissor(prev_scissor_x, prev_scissor_y, prev_scissor_w, prev_scissor_h)
	love.graphics.setLineWidth(default_line_width)
	love.graphics.setColor(r, g, b, a)
end

--- Atualiza a posição e dimensões do **Control** de acordo com suas âncoras e offsets.
--- @private
function Control:_updateLayout()
	if not self._visible then
		return
	end

	do
		local parent = self._parent

		if parent and type(parent.is) == "function" and parent:is("Container") then
			-- Se o Control tem suas propriedades base alteradas e é filho de um Container,
			-- ele avisa o Container para reorganizar o layout geral.
			--- @cast parent NodeUI.Container

			--- @diagnostic disable-next-line: invisible
			parent:_queueUpdateChildrenLayout()

			-- Interrompe a cascata aqui. O próprio Container atualizará os filhos quando processar o layout.
			return
		end
	end

	local old_x, old_y = self._layout_x, self._layout_y
	local old_width, old_height = self._layout_width, self._layout_height

	-- Atualiza o layout do Control livremente.
	self:_onUpdateLayout()

	-- Só propaga a atualização de layout para os filhos se a geometria final realmente mudou
	if old_x ~= self._layout_x or old_y ~= self._layout_y or old_width ~= self._layout_width or old_height ~= self._layout_height then
		for _, child in ipairs(self._children) do
			child:_queueUpdateLayout()
		end
	end
end

--- Recebe um **InputEvent** e repassa para seu parente caso ele não seja aceito.
--- @private
--- @param event NodeUI.InputEvent
function Control:_receiveEvent(event)
	self:_onInput(event)

	if not event.accepted and self._parent then
		self._parent:_receiveEvent(event)
	end
end

--#endregion


return Control
