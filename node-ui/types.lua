-- =====================================
--              General
-- =====================================

--- @class NodeUI.Rectangle
--- @field left number
--- @field right number
--- @field top number
--- @field bottom number

--- @class NodeUI.RectangleCorners
--- @field top_left number
--- @field top_right number
--- @field bottom_left number
--- @field bottom_right number

-- =====================================
--              Control
-- =====================================

--- @class NodeUI.Control.DebugSettings
--- @field line_width? number

--- @class NodeUI.Control.Settings
--- @field layout_mode NodeUI.Control.LayoutMode
--- @field mouse_focus_mode NodeUI.Control.MouseFocusMode
--- @field clip_children boolean

--- @class NodeUI.Control.SettingsParameter
--- @field layout_mode? NodeUI.Control.LayoutMode
--- @field mouse_focus_mode? NodeUI.Control.MouseFocusMode
--- @field clip_children? boolean

--- @alias NodeUI.Control.LayoutMode
--- | "absolute"
--- | "top_left"
--- | "top_right"
--- | "bottom_left"
--- | "bottom_right"
--- | "center"
--- | "center_left"
--- | "center_right"
--- | "center_top"
--- | "center_bottom"
--- | "full_rect"
--- | "left_wide"
--- | "right_wide"
--- | "top_wide"
--- | "bottom_wide"
--- | "h_center_wide"
--- | "v_center_wide"

--- @alias NodeUI.Control.MouseFocusMode
--- | "stop" Recebe o evento e impede que outros recebam
--- | "pass" Recebe o evento e permite que filhos/outros processem
--- | "ignore" Ignora eventos de mouse

-- =====================================
--                Panel
-- =====================================

--- @class NodeUI.Panel.Settings: NodeUI.Control.Settings
--- @field color number[]
--- @field edge_color number[]
--- @field edge_width number
--- @field corner_radius NodeUI.RectangleCorners
--- @field corner_segments number
--- @field expand_margin NodeUI.Rectangle

--- @class NodeUI.Panel.SettingsParameter: NodeUI.Control.SettingsParameter
--- @field color? number[]
--- @field edge_color? number[]
--- @field edge_width? number
--- @field corner_radius? NodeUI.RectangleCorners
--- @field corner_segments? number
--- @field expand_margin? NodeUI.Rectangle
