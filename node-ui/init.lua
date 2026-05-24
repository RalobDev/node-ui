local ROOT = ...

--- @class NodeUI
--- @field Control NodeUI.Control
--- @field Panel NodeUI.Panel
--- @field Label NodeUI.Label
--- @field Container NodeUI.Container
--- @field VContainer NodeUI.VContainer
--- @field HContainer NodeUI.HContainer
local NodeUI = {}

NodeUI.Control = require(ROOT .. ".nodes.control")
NodeUI.Panel = require(ROOT .. ".nodes.panel")
NodeUI.Label = require(ROOT .. ".nodes.label")
NodeUI.Container = require(ROOT .. ".nodes.container")
NodeUI.VContainer = require(ROOT .. ".nodes.v_container")
NodeUI.HContainer = require(ROOT .. ".nodes.h_container")

return NodeUI
