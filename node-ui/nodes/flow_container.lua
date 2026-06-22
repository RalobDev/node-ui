local ROOT = (...):match("^(.*)%.")

local Container = require(ROOT .. ".container") --- @type NodeUI.Container

--- O **FlowContainer** Organiza os filhos horizontalmente e verticalmente em diferentes linhas ou colunas.
---
--- ## Descrição
---
--- O **FlowContainer** quebra as linhas ou colunas de filhos para fazé-los caber na dimensão do **FlowContainer**,
--- mas o número de linhas ou colunas pode ultrapassar o tamanho do mesmo.
--- @class NodeUI.FlowContainer: NodeUI.Container
--- @field private _alignment NodeUI.Control.AlignmentMode
--- @field private _vertical boolean
--- @field private _last_wrap_alignment NodeUI.FlowContainer.LastWrapAlignmentMode
--- @field private _horizontal_separation number
--- @field private _vertical_separation number
local FlowContainer = Container:extend("FlowContainer")


--#region Public

--- Cria um novo **FlowContainer**.
--- @param x number 			               Posição horizontal.
--- @param y number 			               Posição vertical.
--- @param width number 		               Comprimento em pixels.
--- @param height number 		               Altura em pixels.
--- @return NodeUI.FlowContainer FlowContainer Novo **FlowContainer**.
function FlowContainer:new(x, y, width, height)
    local obj = Container.new(self, x, y, width, height) --- @cast obj NodeUI.FlowContainer

    obj._alignment = "BEGIN"
    obj._vertical = false
    obj._last_wrap_alignment = "INHERIT"
    obj._horizontal_separation = 8
    obj._vertical_separation = 8

    return obj
end

--#endregion


--#region Override

--- Cria uma conexão em determinado **`NodeUI.FlowContainer.Signals`** do **FlowContainer**.
--- @param signal NodeUI.FlowContainer.Signals Nome do sinal.
--- @param method string|function              Nome do método ou método chamado ao sinal ser emitido.
--- @param owner? table                        Objeto dono do método.
function FlowContainer:connect(signal, method, owner)
    return Container.connect(self, signal, method, owner)
end

--- Remove a conexão de um **`NodeUI.FlowContainer.Signals`** do **FlowContainer**.
--- @param signal NodeUI.FlowContainer.Signals Nome do sinal.
--- @param method string|function              Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                        Objeto dono do método.
function FlowContainer:disconnect(signal, method, owner)
    Container.disconnect(self, signal, method, owner)
end

--#endregion


--#region Setter

--- Define o **`NodeUI.Control.AlignmentMode`** dos filhos.
--- @param alignment NodeUI.Control.AlignmentMode Alinhamento dos filhos.
function FlowContainer:setAlignment(alignment)
    self._alignment = alignment
    self:_queueUpdateChildrenLayout()
end

--- Define se a organização dos filhos é vertical ou não. Por padrão `enabled` é `true`.
--- @param enabled? boolean Se é para organizar verticalmente.
function FlowContainer:setVertical(enabled)
    if enabled == nil then
        enabled = true
    end

    self._vertical = enabled
    self:_queueUpdateChildrenLayout()
end

--- Define o **`NodeUI.FlowContainer.LastWrapAlignmentMode`** dos filhos da última linha ou coluna.
--- @param alignment NodeUI.FlowContainer.LastWrapAlignmentMode Alinhamento dos filhos.
function FlowContainer:setLastWrapAlignment(alignment)
    self._last_wrap_alignment = alignment
    self:_queueUpdateChildrenLayout()
end

--- Define a separação entre os filhos.
--- @param axis NodeUI.Control.Axis Eixo da separação.
--- @param separation number Separação em pixels.
function FlowContainer:setSeparation(axis, separation)
    self[string.format("_%s_separation", axis:lower())] = math.max(0, separation)
    self:_queueUpdateChildrenLayout()
end

--#endregion


--#region Getter

--- Retorna o **`NodeUI.Control.AlignmentMode`** dos filhos.
--- @nodiscard
--- @return NodeUI.Control.AlignmentMode alignment Alinhamento dos filhos.
function FlowContainer:getAlignment()
    return self._alignment
end

--- Retorna se a organização dos filhos é vertical ou não.
--- @nodiscard
--- @return boolean enabled Se é organizado verticalmente.
function FlowContainer:getVertical()
    return self._vertical
end

--- Define o **`NodeUI.FlowContainer.LastWrapAlignmentMode`** dos filhos da última linha ou coluna.
--- @return NodeUI.FlowContainer.LastWrapAlignmentMode alignment Alinhamento dos filhos.
function FlowContainer:getLastWrapAlignment()
    return self._last_wrap_alignment
end

--- Retorna a separação entre os filhos.
--- @nodiscard
--- @param axis NodeUI.Control.Axis Eixo da separação.
--- @return number separation Separação em pixels.
function FlowContainer:getSeparation(axis)
    return self[string.format("_%s_separation", axis:lower())]
end

--#endregion


--#region Override Protected

--- Atualiza o layout dos filhos.
--- @protected
function FlowContainer:_updateChildrenLayout()
    local position_axis_key = "_layout_x"
    local size_axis_key = "_layout_width"
    if self._vertical then
        position_axis_key = "_layout_y"
        size_axis_key = "_layout_height"
    end

    local children_wraps = self:_wrapChildren()
    local separation = self._vertical and self._vertical_separation or self._horizontal_separation

    local used_wrap_size = 0

    for wrap_index, children_wrap in ipairs(children_wraps) do
        --- @cast children_wrap NodeUI.Control[]

        local expand_child_sizes = {} --- @type number[]
        local largest_child_size = 0

        -- Calcula o tamanho dos filhos expandidos em cada wrap.
        do
            local expand_child_count = 0
            local used_separation_size = math.max(0, #children_wrap - 1) * separation
            local available_expand_size = self[size_axis_key] - used_separation_size
            local axis = self._vertical and "VERTICAL" or "HORIZONTAL"

            for _, wrapped_child in ipairs(children_wrap) do
                if wrapped_child:getSizeFlags(axis) == "EXPAND" then
                    expand_child_count = expand_child_count + 1
                else
                    local child_size = self._vertical and wrapped_child:getMinimumHeight() or
                        wrapped_child:getMinimumWidth()
                    available_expand_size = available_expand_size - child_size
                end
            end

            if expand_child_count > 0 then
                local expand_size = available_expand_size / expand_child_count
                expand_child_sizes[#expand_child_sizes + 1] = expand_size
            end
        end

        -- Calcula qual o tamanho do maior filho.
        for _, wrapped_child in ipairs(children_wrap) do
            local child_size = self._vertical and wrapped_child:getMinimumWidth() or wrapped_child:getMinimumHeight()
            largest_child_size = math.max(largest_child_size, child_size)
        end

        -- Captura o layout antigo dos filhos antes de mexer.
        local old_layouts = {}
        for _, wrapped_child in ipairs(children_wrap) do
            old_layouts[wrapped_child] = {
                x = wrapped_child._layout_x,
                y = wrapped_child._layout_y,
                w = wrapped_child._layout_width,
                h = wrapped_child._layout_height
            }
        end

        -- Altera a posição e dimensão dos filhos.
        do
            local used_size = 0
            local expand_child_size = expand_child_sizes[wrap_index]

            for _, wrapped_child in ipairs(children_wrap) do
                -- Alinha o eixo que não é alvo do FlowContainer com o eixo do FlowContainer.
                if position_axis_key == "_layout_x" then
                    wrapped_child._layout_y = self._layout_y + used_wrap_size
                else
                    wrapped_child._layout_x = self._layout_x + used_wrap_size
                end

                wrapped_child[position_axis_key] = self[position_axis_key] + used_size
                wrapped_child._layout_width, wrapped_child._layout_height = wrapped_child:getMinimumDimensions()

                -- Checa se é necessário ignorar as size_flags do filho.
                do
                    local opposite_child_size = (
                        self._vertical and wrapped_child._layout_width or wrapped_child._layout_height
                    )

                    if opposite_child_size == largest_child_size then
                        goto ignore_size_flags
                    end

                    local size_flags_h = wrapped_child:getSizeFlags("HORIZONTAL")
                    local size_flags_v = wrapped_child:getSizeFlags("VERTICAL")

                    if self._vertical then
                        if size_flags_v == "EXPAND" then
                            wrapped_child._layout_height = math.max(wrapped_child:getMinimumHeight(), expand_child_size)
                        end
                    else
                        if size_flags_v == "FILL" or size_flags_v == "EXPAND" then
                            wrapped_child._layout_height = largest_child_size
                        elseif size_flags_v == "SHRINK_CENTER" then
                            wrapped_child._layout_y = (
                                wrapped_child._layout_y + largest_child_size / 2 - opposite_child_size / 2
                            )
                        elseif size_flags_v == "SHRINK_END" then
                            wrapped_child._layout_y = wrapped_child._layout_y + largest_child_size - opposite_child_size
                        end

                        if size_flags_h == "EXPAND" then
                            wrapped_child._width = math.max(wrapped_child:getMinimumWidth(), expand_child_size)
                        end
                    end

                    ::ignore_size_flags::
                end

                used_size = used_size + wrapped_child[size_axis_key] + separation
            end

            local alignment = wrap_index == #children_wraps and self._last_wrap_alignment or self._alignment
            if alignment == "INHERIT" then
                alignment = self._alignment
            end

            -- Realiza o alinhamento (CENTER ou END) se necessário.
            if alignment ~= "BEGIN" then
                local base_end = self[position_axis_key] + self[size_axis_key]
                local initial_position_axis = 0

                if alignment == "CENTER" then
                    initial_position_axis = base_end - self[size_axis_key] / 2 - used_size / 2 + separation / 2
                elseif alignment == "END" then
                    initial_position_axis = base_end - used_size + separation
                end

                used_size = 0

                for _, child in ipairs(children_wrap) do
                    child[position_axis_key] = initial_position_axis + used_size
                    local child_size = self._vertical and child._layout_height or child._layout_width
                    used_size = used_size + child_size + separation
                end
            end

            -- Agora que tudo foi calculado e alinhado, verificamos as diferenças.
            for _, wrapped_child in ipairs(children_wrap) do
                local old = old_layouts[wrapped_child]

                if old.x ~= wrapped_child._layout_x or old.y ~= wrapped_child._layout_y or old.w ~= wrapped_child._layout_width or old.h ~= wrapped_child._layout_height then
                    for _, grandchild in ipairs(wrapped_child:getChildren(true)) do
                        grandchild:_queueUpdateLayout()
                    end
                end
            end
        end

        local wrap_separation = self._vertical and self._horizontal_separation or self._vertical_separation
        used_wrap_size = used_wrap_size + largest_child_size + wrap_separation
    end
end

--#endregion


--#region Private

--- Retorna os filhos entrelaçados de acordo com a dimensão do **FlowContainer**.
--- @private
--- @return table[] children_wrap Filhos entrelaçados.
function FlowContainer:_wrapChildren()
    local children_wraps = { {} } --- @type table[]
    local size_axis_key = self._vertical and "_layout_height" or "_layout_width"
    local separation = self._vertical and self._vertical_separation or self._horizontal_separation

    local max_wrap_size = self[size_axis_key]
    for _, child in ipairs(self:getChildren(true)) do
        local wrap = children_wraps[#children_wraps] --- @type NodeUI.Control[]
        local wrap_size = 0

        -- Calcula o tamanho do wrap.
        for _, wrapped_child in ipairs(wrap) do
            wrap_size = wrap_size + wrapped_child[size_axis_key] + separation
        end

        -- Calcula se o filho cabe no wrap.
        if #wrap == 0 or wrap_size + child[size_axis_key] <= max_wrap_size then
            wrap[#wrap + 1] = child
        else
            -- Caso não caiba, adiciona um novo wrap.
            local new_wrap = {}
            new_wrap[#new_wrap + 1] = child

            children_wraps[#children_wraps + 1] = new_wrap
        end
    end

    return children_wraps
end

--#endregion


return FlowContainer
