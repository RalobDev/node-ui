local ROOT = ...

--- @class NodeUI
--- @field Control NodeUI.Control
--- @field Panel NodeUI.Panel
local NodeUI = {}

NodeUI.Control = require(ROOT .. ".nodes.control")
NodeUI.Panel = require(ROOT .. ".nodes.panel")

return NodeUI
