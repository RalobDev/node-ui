local ROOT = ...

--- @class NodeUI
--- @field Control NodeUI.Control
--- @field Panel NodeUI.Panel
--- @field Label NodeUI.Label
local NodeUI = {}

NodeUI.Control = require(ROOT .. ".nodes.control")
NodeUI.Panel = require(ROOT .. ".nodes.panel")
NodeUI.Label = require(ROOT .. ".nodes.label")

return NodeUI
