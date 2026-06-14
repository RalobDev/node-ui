local ROOT = (...):match("^(.*)%.")

local Container = require(ROOT .. ".container") --- @type NodeUI.Container

--- @class NodeUI.AspectRatioContainer: NodeUI.Container
--- @field private _stretch_mode NodeUI.AspectRatioContainer.StretchMode
--- @field private _horizontal_alignment_mode NodeUI.Control.AlignmentMode
--- @field private _vertical_alignment_mode NodeUI.Control.AlignmentMode
local AspectRatioContainer = Container:extend("AspectRatioContainer")

--#region Public

--- Cria um novo **`AspectRatioContainer`**.
--- @param x number Posição horizontal
--- @param y number Posição vertical
--- @param width number Comprimento em pixels
--- @param height number Altura em pixels
--- @return NodeUI.AspectRatioContainer AspectRatioContainer
function AspectRatioContainer:new(x, y, width, height)
    local obj = Container.new(self, x, y, width, height) --- @cast obj NodeUI.AspectRatioContainer

    obj._stretch_mode = "FIT"
    obj._horizontal_alignment_mode = "CENTER"
    obj._vertical_alignment_mode = "CENTER"

    return obj
end

--#endregion


--#region Override

--- Cria uma conexão em determinado sinal do **`Control`**.
--- @param signal NodeUI.AspectRatioContainer.Signals
--- @param owner table Objeto dono do método da conexão que será passado como primeiro parâmetro do método.
--- @param method string Método chamado ao sinal ser emitido.
function AspectRatioContainer:connect(signal, method, owner)
    return Container.connect(self, signal, owner, method)
end

--- Desconecta o `method` do `signal`.
--- @param signal NodeUI.AspectRatioContainer.Signals
--- @param method string Método chamado ao sinal ser emitido.
function AspectRatioContainer:disconnect(signal, method)
    Container.disconnect(self, signal, method)
end

--#endregion


--#region Setter

--- Define a maneira como escalona os filhos.
--- @param stretch_mode NodeUI.AspectRatioContainer.StretchMode
function AspectRatioContainer:setStretchMode(stretch_mode)
    self._stretch_mode = stretch_mode
    self:_queueUpdateChildrenLayout()
end

--- Define o AlignmentMode aplicado aos filhos.
--- @param axis NodeUI.Control.Axis
--- @param alignment_mode NodeUI.Control.AlignmentMode
function AspectRatioContainer:setAlignmentMode(axis, alignment_mode)
    local alignment_axis = "_" .. axis:lower() .. "_alignment_mode"
    self[alignment_axis] = alignment_mode
    self:_queueUpdateChildrenLayout()
end

--#endregion


--#region Getter

--- Retorna a maneira como escalona os filhos.
--- @nodiscard
--- @return NodeUI.AspectRatioContainer.StretchMode
function AspectRatioContainer:getStretchMode()
    return self._stretch_mode
end

--- Retorna o AlignmentMode aplicado aos filhos.
--- @nodiscard
--- @param axis NodeUI.Control.Axis
--- @return NodeUI.Control.AlignmentMode alignment_mode
function AspectRatioContainer:getAlignmentMode(axis)
    local alignment_axis = "_" .. axis:lower() .. "alignment_mode"
    return self[alignment_axis]
end

--#endregion


--#region Protected

--- Atualiza o layout dos filhos.
--- @protected
function AspectRatioContainer:_updateChildrenLayout()
    for _, child in ipairs(self:getChildren(true)) do
        local base_width, base_height = self:getDimensions()
        local child_width, child_height = child:getDimensions()
        local scale

        if self._stretch_mode == "STRETCH_WIDTH" then
            scale = base_width / child_width
        elseif self._stretch_mode == "STRETCH_HEIGHT" then
            scale = base_height / child_height
        elseif self._stretch_mode == "FIT" then
            scale = math.min(base_width / child_width, base_height / child_height)
        elseif self._stretch_mode == "COVER" then
            scale = math.max(base_width / child_width, base_height / child_height)
        end

        local scaled_x, scaled_y = self._layout_x / scale, self._layout_y / scale
        local scaled_base_width, scaled_base_height = base_width / scale, base_height / scale

        if self._horizontal_alignment_mode == "BEGIN" then
            child._layout_x = scaled_x
        elseif self._horizontal_alignment_mode == "CENTER" then
            child._layout_x = scaled_x + (scaled_base_width / 2) - (child_width / 2)
        elseif self._horizontal_alignment_mode == "END" then
            child._layout_x = scaled_x + (scaled_base_width / 2) - child_width
        end

        if self._vertical_alignment_mode == "BEGIN" then
            child._layout_y = scaled_y
        elseif self._vertical_alignment_mode == "CENTER" then
            child._layout_y = scaled_y + (scaled_base_height / 2) - (child_height / 2)
        elseif self._vertical_alignment_mode == "END" then
            child._layout_y = scaled_y + (scaled_base_height / 2) - child_height
        end

        child._graphics_push_method = function()
            love.graphics.scale(scale)
        end
    end
end

--#endregion


return AspectRatioContainer
