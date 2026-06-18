if arg[2] == "debug" then
	require("lldebugger").start()
end

NodeUI = require("node-ui")

--#region Engine Callback

--- Lida com a lógica de atualização.
--- @param dt number
function love.update(dt)
	NodeUI.update(dt)
end

--- Lida com o desenho.
function love.draw()
	NodeUI.draw()
	NodeUI.drawDebug()
end

--- Lida com o pressionar do mouse.
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
function love.mousepressed(x, y, button, istouch, presses)
	NodeUI.mousepressed(x, y, button, istouch, presses)
end

--- Lida com o soltar do mouse.
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
function love.mousereleased(x, y, button, istouch, presses)
	NodeUI.mousereleased(x, y, button, istouch, presses)
end

--- Lida com o movimento do mouse.
--- @param x number
--- @param y number
--- @param dx number
--- @param dy number
--- @param istouch boolean
function love.mousemoved(x, y, dx, dy, istouch)
	NodeUI.mousemoved(x, y, dx, dy, istouch)
end

--- Lida com o movimento da roda do mouse.
--- @param x number
--- @param y number
function love.wheelmoved(x, y)
	NodeUI.wheelmoved(x, y)
end

--#endregion


local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
	--- @diagnostic disable-next-line: undefined-global
	if lldebugger then
		error(msg, 2)
	else
		return love_errorhandler(msg)
	end
end
