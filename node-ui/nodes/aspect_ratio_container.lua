local ROOT = (...):match("^(.*)%.")

local Container = require(ROOT .. ".container") --- @type NodeUI.Container

--- **AspectRatioContainer** é um tipo de **`Container`** que ajusta seus filhos mantendo uma proporção de
--- aspecto (aspect ratio), aplicando diferentes modos de escala como `FIT` e `COVER`, além de controle de alinhamento.
---
--- ## Descrição
---
--- O **AspectRatioContainer** estende **`Container`** adicionando um sistema de
--- escala baseado em proporção. Ele calcula automaticamente um fator de
--- escala com base no tamanho do container e no tamanho dos filhos,
--- permitindo que o conteúdo seja ajustado sem distorção.
---
--- Ele suporta diferentes modos de escala através de `setStretchMode()`.
---
--- Também permite controle de alinhamento horizontal e vertical dos filhos através de `setAlignmentMode()`.
--- @class NodeUI.AspectRatioContainer: NodeUI.Container
--- @field private _stretch_mode NodeUI.AspectRatioContainer.StretchMode
--- @field private _horizontal_alignment_mode NodeUI.Control.AlignmentMode
--- @field private _vertical_alignment_mode NodeUI.Control.AlignmentMode
local AspectRatioContainer = Container:extend("AspectRatioContainer")

--#region Public

--- Cria um novo **AspectRatioContainer**.
--- @param x number 			                             Posição horizontal.
--- @param y number 			                             Posição vertical.
--- @param width number 		                             Comprimento em pixels.
--- @param height number 		                             Altura em pixels.
--- @return NodeUI.AspectRatioContainer AspectRatioContainer Novo **AspectRatioContainer**.
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
--- @param signal NodeUI.Control.Signals Nome do sinal.
--- @param method string|function        Nome do método ou método chamado ao sinal ser emitido.
--- @param owner? table                  Objeto dono do método.
function AspectRatioContainer:connect(signal, method, owner)
    return Container.connect(self, signal, method, owner)
end

--- Remove a conexão de um sinal do **`Control`**.
--- @param signal NodeUI.Control.Signals Nome do sinal.
--- @param method string|function        Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                  Objeto dono do método.
function AspectRatioContainer:disconnect(signal, method, owner)
    Container.disconnect(self, signal, method, owner)
end

--#endregion


--#region Setter

--- Define a maneira como escalona os filhos.
--- @param stretch_mode NodeUI.AspectRatioContainer.StretchMode Modo de escalonamento.
function AspectRatioContainer:setStretchMode(stretch_mode)
    self._stretch_mode = stretch_mode
    self:_queueUpdateChildrenLayout()
end

--- Define o `AlignmentMode` aplicado aos filhos.
--- @param axis NodeUI.Control.Axis                    Eixo do alinhamento.
--- @param alignment_mode NodeUI.Control.AlignmentMode Modo de alinhamento.
function AspectRatioContainer:setAlignmentMode(axis, alignment_mode)
    local alignment_axis = "_" .. axis:lower() .. "_alignment_mode"
    self[alignment_axis] = alignment_mode
    self:_queueUpdateChildrenLayout()
end

--#endregion


--#region Getter

--- Retorna a maneira como escalona os filhos.
--- @nodiscard
--- @return NodeUI.AspectRatioContainer.StretchMode stretch_mode Modo de escalonamento.
function AspectRatioContainer:getStretchMode()
    return self._stretch_mode
end

--- Retorna o `AlignmentMode` aplicado aos filhos.
--- @nodiscard
--- @param axis NodeUI.Control.Axis                     Eixo de alinhamento.
--- @return NodeUI.Control.AlignmentMode alignment_mode Modo de alinhamento.
function AspectRatioContainer:getAlignmentMode(axis)
    local alignment_axis = "_" .. axis:lower() .. "_alignment_mode"
    return self[alignment_axis]
end

--#endregion


--#region Protected

--- Atualiza o layout dos filhos.
--- @protected
function AspectRatioContainer:_updateChildrenLayout()
    for _, child in ipairs(self:getChildren(true)) do
        local base_width, base_height = self:getDimensions()
        local child_width, child_height = child:getBaseDimensions()

        if child_width <= 0 or child_height <= 0 then
            goto continue
        end

        -- Salva o layout anterior do filho.
        local old_x, old_y = child._layout_x, child._layout_y
        local old_w, old_h = child._layout_width, child._layout_height

        local scale

        if self._stretch_mode == "STRETCH_WIDTH" then
            scale = base_width / child_width
        elseif self._stretch_mode == "STRETCH_HEIGHT" then
            scale = base_height / child_height
        elseif self._stretch_mode == "FIT" then
            scale = math.min(
                base_width / child_width,
                base_height / child_height
            )
        elseif self._stretch_mode == "COVER" then
            scale = math.max(
                base_width / child_width,
                base_height / child_height
            )
        end

        local scaled_width = child_width * scale
        local scaled_height = child_height * scale

        if self._horizontal_alignment_mode == "BEGIN" then
            child._layout_x = self._layout_x
        elseif self._horizontal_alignment_mode == "CENTER" then
            child._layout_x = self._layout_x + (base_width - scaled_width) / 2
        elseif self._horizontal_alignment_mode == "END" then
            child._layout_x = self._layout_x + base_width - scaled_width
        end

        if self._vertical_alignment_mode == "BEGIN" then
            child._layout_y = self._layout_y
        elseif self._vertical_alignment_mode == "CENTER" then
            child._layout_y = self._layout_y + (base_height - scaled_height) / 2
        elseif self._vertical_alignment_mode == "END" then
            child._layout_y = self._layout_y + base_height - scaled_height
        end

        child._layout_width = scaled_width
        child._layout_height = scaled_height

        -- Dispara a cascata de layout apenas se a escala/posição mudou na prática
        if old_x ~= child._layout_x or old_y ~= child._layout_y or old_w ~= child._layout_width or old_h ~= child._layout_height then
            for _, grandchild in ipairs(child:getChildren(true)) do
                grandchild:_queueUpdateLayout()
            end
        end

        ::continue::
    end
end

--#endregion


return AspectRatioContainer
