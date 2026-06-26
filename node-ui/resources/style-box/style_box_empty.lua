local ROOT = (...):match("^(.*)%."):match("^(.*)%."):match("^(.*)%.") --- @type string

local StyleBox = require(ROOT .. ".resources.abstract.style_box")     --- @type NodeUI.StyleBox

--- Uma **StyleBox** vazia que não exibe nada.
--- @class NodeUI.StyleBoxEmpty: NodeUI.StyleBox
local StyleBoxEmpty = StyleBox:extend("StyleBoxEmpty")


--#region Public

--- Cria uma nova **StyleBoxEmpty**.
--- @nodiscard
--- @return NodeUI.StyleBoxEmpty StyleBoxEmpty Nova **StyleBoxEmpty**.
function StyleBoxEmpty:new()
    local obj = StyleBox.new(self) --- @cast obj NodeUI.StyleBoxEmpty
    return obj
end

--#endregion


return StyleBoxEmpty
