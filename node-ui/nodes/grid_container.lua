local ROOT = (...):match("^(.*)%.")

local Container = require(ROOT .. ".container") --- @type NodeUI.Container

--- O **GridContainer** organiza seus filhos em uma grade.
---
--- ## Descrição
---
--- O **GridContainer** organiza seus filhos em linhas e colunas de acordo com o seu número de colunas, que
--- pode ser definido através de `GridContainer:setColumns()`.
--- @class NodeUI.GridContainer: NodeUI.Container
--- @field private _columns number
--- @field private _horizontal_separation number
--- @field private _vertical_separation number
local GridContainer = Container:extend("GridContainer")

--#region Public

--- Cria um novo **GridContainer**.
--- @param x number 			               Posição horizontal.
--- @param y number 			               Posição vertical.
--- @param width number 		               Comprimento em pixels.
--- @param height number 		               Altura em pixels.
--- @return NodeUI.GridContainer GridContainer Novo **GridContainer**.
function GridContainer:new(x, y, width, height)
    local obj = Container.new(self, x, y, width, height) --- @cast obj NodeUI.GridContainer

    obj._columns = 1
    obj._horizontal_separation = 8
    obj._vertical_separation = 8

    return obj
end

--#endregion


--#region Override

--- Cria uma conexão em determinado sinal do **`Control`**.
--- @param signal NodeUI.GridContainer.Signals Nome do sinal.
--- @param method string|function              Nome do método ou método chamado ao sinal ser emitido.
--- @param owner? table                        Objeto dono do método.
function GridContainer:connect(signal, method, owner)
    return Container.connect(self, signal, method, owner)
end

--- Remove a conexão de um sinal do **`Control`**.
--- @param signal NodeUI.GridContainer.Signals Nome do sinal.
--- @param method string|function              Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                        Objeto dono do método.
function GridContainer:disconnect(signal, method, owner)
    Container.disconnect(self, signal, method, owner)
end

--#endregion


--#region Setter

--- Define a quantidade de colunas do grid.
--- @param columns number Quantidade de colunas.
function GridContainer:setColumns(columns)
    self._columns = math.max(columns, 1)
    self:_queueUpdateChildrenLayout()
end

--- Define a separação entre os filhos.
--- @param axis NodeUI.Control.Axis Eixo da separação.
--- @param separation number Separação em pixels.
function GridContainer:setSeparation(axis, separation)
    self[string.format("_%s_separation", axis:lower())] = math.max(0, separation)
    self:_queueUpdateChildrenLayout()
end

--#endregion


--#region Getter

--- Retorna a quantidade de colunas do grid.
--- @nodiscard
--- @return number columns Quantidade de colunas.
function GridContainer:getColumns()
    return self._columns
end

--- Retorna a separação entre os filhos.
--- @nodiscard
--- @param axis NodeUI.Control.Axis Eixo da separação.
--- @return number separation Separação em pixels.
function GridContainer:getSeparation(axis)
    return self[string.format("_%s_separation", axis:lower())]
end

--#endregion


--#region Override Protected

--- Calcula o comprimento mínimo empilhando os filhos horizontalmente ou pegando o maior verticalmente.
--- @protected
--- @return number width
function GridContainer:_calculateMinimumWidth()
    local min_width = 0
    if #self:getChildren(true) == 0 then return 0 end

    do
        local rows = self:_wrapChildren()

        for _, row in ipairs(rows) do
            local row_width = 0

            for child_index, child in ipairs(row) do
                local separation = child_index == #rows and 0 or self._horizontal_separation
                row_width = row_width + child._layout_width + separation
            end

            min_width = math.max(min_width, row_width)
        end
    end

    return min_width
end

--- Calcula a altura mínima empilhando os filhos verticalmente ou pegando a maior horizontalmente.
--- @protected
--- @return number height
function GridContainer:_calculateMinimumHeight()
    local min_height = 0
    if #self:getChildren(true) == 0 then return 0 end

    do
        local rows = self:_wrapChildren()
        local column_height = 0

        for row_index, row in ipairs(rows) do
            local highest_height = 0
            for _, child in ipairs(row) do
                highest_height = math.max(highest_height, child._layout_height)
            end

            local separation = row_index == #rows and 0 or self._vertical_separation
            column_height = column_height + highest_height + separation
        end

        min_height = math.max(min_height, column_height)
    end

    return min_height
end

--- Atualiza o layout dos filhos.
--- @protected
function GridContainer:_updateChildrenLayout()
    local rows = self:_wrapChildren()

    local used_height = 0

    for _, row in ipairs(rows) do
        --- @cast row NodeUI.Control[]

        -- Pega a maior altura entre os filhos da linha.
        local highest_height = 0
        for _, child in ipairs(row) do
            highest_height = math.max(highest_height, child:getMinimumHeight())
        end

        -- Define a posição e dimensão dos filhos de cada linha.
        do
            local used_width = 0
            for _, child in ipairs(row) do
                child._layout_x = self._layout_x + used_width
                child._layout_y = self._layout_y + used_height

                child._layout_width, child._layout_height = child:getMinimumDimensions()

                used_width = used_width + child._layout_width + self._horizontal_separation

                if child._layout_height == highest_height then
                    goto ignore_size_flags
                end


                local size_flags_v = child:getSizeFlags("VERTICAL")
                if size_flags_v == "FILL" or size_flags_v == "EXPAND" then
                    child._layout_height = highest_height
                elseif size_flags_v == "SHRINK_CENTER" then
                    child._layout_y = child._layout_y + highest_height / 2 - child._layout_height / 2
                elseif size_flags_v == "SHRINK_END" then
                    child._layout_y = child._layout_y + highest_height - child._layout_height
                end

                ::ignore_size_flags::
            end
        end

        used_height = used_height + highest_height + self._vertical_separation
    end
end

--#endregion


--#region Private

--- Retorna os filhos entrelaçados de acordo com a quantidade de colunas do **GridContainer**.
--- @private
--- @return table[] children_wrap Filhos entrelaçados.
function GridContainer:_wrapChildren()
    local rows = { {} } --- @type table[]

    for _, child in ipairs(self:getChildren(true)) do
        local row = rows[#rows]

        if #row < self._columns then
            row[#row + 1] = child
        else
            local new_row = {}

            new_row[#new_row + 1] = child
            rows[#rows + 1] = new_row
        end
    end

    return rows
end

--#endregion

return GridContainer
