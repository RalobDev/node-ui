local ROOT = (...):match("^(.*)%.")

local Control = require(ROOT .. ".control") --- @type NodeUI.Control

--- @class NodeTemplate: NodeUI.Control
local NodeTemplate = Control:extend()


--#region Override

--- Cria uma conexão em determinado sinal do **`Control`**.
--- @param signal NodeUI.NodeTemplate.Signals
--- @param method function Método chamado ao sinal ser emitido.
--- @param owner? table Objeto dono do método da conexão que será passado como primeiro parâmetro do método.
--- @return function method Método da conexão.
function NodeTemplate:connect(signal, method, owner)
    return Control:connect(signal, method, owner)
end

--- Desconecta o `method` do `signal`.
--- @param signal NodeUI.NodeTemplate.Signals
--- @param method function Método chamado ao sinal ser emitido.
function NodeTemplate:disconnect(signal, method)
    Control.disconnect(self, signal, method)
end

--#endregion


--#region Protected Callback

--- Chamado durante o desenho do **`Control`**.
--- @protected
function NodeTemplate:_onDraw() end

--- Chamado durante a depuração do **`Control`**.
--- <br><br>
--- Este método deve ser sobreescrito em cada classe de **`Control`**, pois
--- é responsável por desenhar a depuração dela.
--- @protected
function NodeTemplate:_onDrawDebug()
    Control._onDrawDebug(self)

    -- Debug draw...
end

--- Chamado quando um botão do mouse é pressionado.
--- @protected
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
--- @diagnostic disable-next-line: unused-local
function NodeTemplate:_onMousepressed(x, y, button, istouch, presses) end

--- Chamado quando um botão do mouse é solto.
--- @protected
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
--- @diagnostic disable-next-line: unused-local
function NodeTemplate:_onMousereleased(x, y, button, istouch, presses) end

--- Chamado quando o mouse é movido.
--- @protected
--- @param x number
--- @param y number
--- @param dx number
--- @param dy number
--- @param istouch boolean
--- @diagnostic disable-next-line: unused-local
function NodeTemplate:_onMousemoved(x, y, dx, dy, istouch) end

--- Chamado quando a roda do mouse é movida.
--- @private
--- @param x number
--- @param y number
--- @diagnostic disable-next-line: unused-local
function NodeTemplate:_onWheelMoved(x, y) end

--- Chamado quando o foco do mouse do **`Control`** muda.
--- @protected
--- @param focused boolean Se está focado pelo mouse.
--- @diagnostic disable-next-line: unused-local
function NodeTemplate:_onMouseFocusChanged(focused) end

--#endregion


return NodeTemplate
