--- Lista de IDs de todos os **InputEvent**.
--- @alias NodeUI.InputEvent.IDs
--- | "INPUT_EVENT_KEY"
--- | "INPUT_EVENT_MOUSE"
--- | "INPUT_EVENT_MOUSE_BUTTON"
--- | "INPUT_EVENT_MOUSE_MOTION"
--- | "INPUT_EVENT_WHEEL_MOVED"


--- Classe base para todos os eventos de input.
--- @class NodeUI.InputEvent
--- @field id NodeUI.InputEvent.IDs
--- @field pressed boolean
--- @field accepted boolean


--- Representa o input do teclado.
--- @class NodeUI.InputEventKey: NodeUI.InputEvent
--- @field key love.KeyConstant
--- @field scancode love.Scancode
--- @field isrepeat boolean


--- Classe base para os input do mouse.
--- @class NodeUI.InputEventMouse: NodeUI.InputEvent
--- @field x number
--- @field y number
--- @field istouch boolean


--- Representa o input dos botões do mouse.
--- @class NodeUI.InputEventMouseButton: NodeUI.InputEventMouse
--- @field button 1|2|3|4|5
--- @field presses number


--- Representa o movimento do mouse.
--- @class NodeUI.InputEventMouseMotion: NodeUI.InputEventMouse
--- @field dx number
--- @field dy number


--- Representa o movimento da roda do mouse.
--- @class NodeUI.InputEventWheelMoved: NodeUI.InputEvent
--- @field x number
--- @field y number
