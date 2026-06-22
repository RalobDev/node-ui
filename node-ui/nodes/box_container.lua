local ROOT = (...):match("^(.*)%.")             --- @type string

local Container = require(ROOT .. ".container") --- @type NodeUI.Container

--- Organiza os filhos horizontalmente ou verticalmente.
--- @class NodeUI.BoxContainer: NodeUI.Container
--- @field private _alignment NodeUI.Control.AlignmentMode
--- @field private _vertical boolean
--- @field private _separation number
local BoxContainer = Container:extend("BoxContainer")

--#region Public

--- Cria um novo **BoxContainer**.
--- @param x number 			             Posição horizontal.
--- @param y number 			             Posição vertical.
--- @param width number 		             Comprimento em pixels.
--- @param height number 		             Altura em pixels.
--- @return NodeUI.BoxContainer BoxContainer Novo **BoxContainer**.
function BoxContainer:new(x, y, width, height)
    local obj = Container.new(self, x, y, width, height) --- @cast obj NodeUI.BoxContainer

    obj._alignment = "BEGIN"
    obj._vertical = false
    obj._separation = 8

    return obj
end

--#endregion


--#region Override

--- Cria uma conexão em determinado **`NodeUI.BoxContainer.Signals`** do **BoxContainer**.
--- @param signal NodeUI.BoxContainer.Signals Nome do sinal.
--- @param method string|function             Nome do método ou método chamado ao sinal ser emitido.
--- @param owner? table                       Objeto dono do método.
function BoxContainer:connect(signal, method, owner)
    return Container.connect(self, signal, method, owner)
end

--- Remove a conexão de um **`NodeUI.BoxContainer.Signals`** do **BoxContainer**.
--- @param signal NodeUI.BoxContainer.Signals Nome do sinal.
--- @param method string|function             Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                       Objeto dono do método.
function BoxContainer:disconnect(signal, method, owner)
    Container.disconnect(self, signal, method, owner)
end

--#endregion


--#region Setter

--- Define o **`NodeUI.Control.AlignmentMode`** aplicado aos filhos.
--- @param alignment NodeUI.Control.AlignmentMode Alinhamento dos filhos.
function BoxContainer:setAlignment(alignment)
    self._alignment = alignment
    self:_queueUpdateChildrenLayout()
end

--- Define se a organização dos filhos é vertical ou não. Por padrão `enabled` é `true`.
--- @param enabled? boolean Se é para organizar verticalmente.
function BoxContainer:setVertical(enabled)
    if enabled == nil then
        enabled = true
    end

    self._vertical = enabled
    self:_queueUpdateChildrenLayout()
end

--- Define a separação entre os filhos.
--- @param separation number Separação em pixels.
function BoxContainer:setSeparation(separation)
    self._separation = math.max(0, separation)
    self:_queueUpdateChildrenLayout()
end

--#endregion


--#region Getter

--- Retorna o **`NodeUI.Control.AlignmentMode`** aplicado aos filhos.
--- @nodiscard
--- @return NodeUI.Control.AlignmentMode alignment Alinhamento dos filhos.
function BoxContainer:getAlignment()
    return self._alignment
end

--- Retorna se a organização dos filhos é vertical ou não.
--- @nodiscard
--- @return boolean enabled Se é organizado verticalmente.
function BoxContainer:getVertical()
    return self._vertical
end

--- Retorna a separação entre os filhos.
--- @nodiscard
--- @return number separation Separação em pixels.
function BoxContainer:getSeparation()
    return self._separation
end

--#endregion


--#region Override Protected

--- Calcula o comprimento mínimo empilhando os filhos horizontalmente ou pegando o maior verticalmente.
--- @protected
--- @return number width
function BoxContainer:_calculateMinimumWidth()
    local min_width = 0
    local children = self:getChildren(true)
    if #children == 0 then return 0 end

    if self._vertical then
        for _, child in ipairs(children) do
            min_width = math.max(min_width, child:getMinimumWidth())
        end
    else
        for _, child in ipairs(children) do
            min_width = min_width + child:getMinimumWidth()
        end
        min_width = min_width + self._separation * (#children - 1)
    end

    return min_width
end

--- Calcula a altura mínima empilhando os filhos verticalmente ou pegando a maior horizontalmente.
--- @protected
--- @return number height
function BoxContainer:_calculateMinimumHeight()
    local min_height = 0
    local children = self:getChildren(true)
    if #children == 0 then return 0 end

    if self._vertical then
        for _, child in ipairs(children) do
            min_height = min_height + child:getMinimumHeight()
        end
        min_height = min_height + self._separation * (#children - 1)
    else
        for _, child in ipairs(children) do
            min_height = math.max(min_height, child:getMinimumHeight())
        end
    end

    return min_height
end

--- Atualiza o layout dos filhos.
--- @protected
function BoxContainer:_updateChildrenLayout()
    local children = self:getChildren(true)

    -- Captura o layout antigo de todos os filhos antes de mexer.
    local old_layouts = {}
    for _, child in ipairs(children) do
        old_layouts[child] = {
            x = child._layout_x,
            y = child._layout_y,
            w = child._layout_width,
            h = child._layout_height
        }
    end

    local used_size = 0
    local target_axis = self._vertical and "_layout_y" or "_layout_x"
    local expand_child_size = 0

    do
        local expand_child_count = 0
        local used_separation_size = math.max(0, #children - 1) * self._separation
        local available_expand_size = (
            (self._vertical and self._layout_height or self._layout_width) - used_separation_size
        )
        local axis = self._vertical and "VERTICAL" or "HORIZONTAL"

        for _, child in ipairs(children) do
            if child:getSizeFlags(axis) == "EXPAND" then
                expand_child_count = expand_child_count + 1
            else
                local child_size = self._vertical and child:getMinimumHeight() or child:getMinimumWidth()
                available_expand_size = available_expand_size - child_size
            end
        end

        if expand_child_count > 0 then
            expand_child_size = available_expand_size / expand_child_count
        end
    end

    local largest_size = 0
    for _, child in ipairs(children) do
        local child_size = self._vertical and child:getMinimumWidth() or child:getMinimumHeight()
        largest_size = math.max(largest_size, child_size)
    end

    for _, child in ipairs(children) do
        -- Alinha o eixo que não é alvo do BoxContainer com o eixo do BoxContainer.
        if target_axis == "_layout_x" then
            child._layout_y = self._layout_y
        else
            child._layout_x = self._layout_x
        end

        child[target_axis] = self[target_axis] + used_size
        child._layout_width, child._layout_height = child:getMinimumDimensions()

        local opposite_child_size = self._vertical and "_layout_width" or "_layout_height"
        if child[opposite_child_size] == largest_size then
            goto ignore_size_flags
        end

        do
            local size_flags_h = child:getSizeFlags("HORIZONTAL")
            local size_flags_v = child:getSizeFlags("VERTICAL")

            if self._vertical then
                if size_flags_h == "FILL" or size_flags_h == "EXPAND" then
                    child._layout_width = largest_size
                elseif size_flags_h == "SHRINK_CENTER" then
                    child._layout_x = self._layout_x + largest_size / 2 - child._layout_width / 2
                elseif size_flags_h == "SHRINK_END" then
                    child._layout_x = self._layout_x + largest_size - child._layout_width
                end

                if size_flags_v == "EXPAND" then
                    child._layout_height = math.max(child:getMinimumHeight(), expand_child_size)
                end
            else
                if size_flags_v == "FILL" or size_flags_v == "EXPAND" then
                    child._layout_height = largest_size
                elseif size_flags_v == "SHRINK_CENTER" then
                    child._layout_y = self._layout_y + largest_size / 2 - child._layout_height / 2
                elseif size_flags_v == "SHRINK_END" then
                    child._layout_y = self._layout_y + largest_size - child._layout_height
                end

                if size_flags_h == "EXPAND" then
                    child._layout_width = math.max(child:getMinimumWidth(), expand_child_size)
                end
            end
        end

        ::ignore_size_flags::

        local child_size = self._vertical and child._layout_height or child._layout_width
        used_size = used_size + child_size + self._separation
    end

    -- Realiza o alinhamento (CENTER ou END) se necessário
    if self._alignment ~= "BEGIN" then
        local position_axis_key = self._vertical and "_layout_y" or "_layout_x"
        local size_axis_key = self._vertical and "_layout_height" or "_layout_width"

        local base_end = self[position_axis_key] + self[size_axis_key]
        local initial_position_axis = 0

        if self._alignment == "CENTER" then
            initial_position_axis = base_end - self[size_axis_key] / 2 - used_size / 2 + self._separation / 2
        elseif self._alignment == "END" then
            initial_position_axis = base_end - used_size + self._separation
        end

        used_size = 0

        for _, child in ipairs(children) do
            child[position_axis_key] = initial_position_axis + used_size
            local child_size = self._vertical and child._layout_height or child._layout_width
            used_size = used_size + child_size + self._separation
        end
    end

    -- Agora que tudo foi calculado e alinhado, verificamos as diferenças
    for _, child in ipairs(children) do
        local old = old_layouts[child]

        if old.x ~= child._layout_x or old.y ~= child._layout_y or old.w ~= child._layout_width or old.h ~= child._layout_height then
            for _, grandchild in ipairs(child:getChildren(true)) do
                grandchild:_queueUpdateLayout()
            end
        end
    end
end

--#endregion


return BoxContainer
