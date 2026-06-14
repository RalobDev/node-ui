if arg[2] == "debug" then
	require("lldebugger").start()
end

local UI = require("node-ui")


--#region Engine Callback

--- Lida com a lógica de atualização.
--- @param dt number
function love.update(dt)
	UI.update(dt)
end

--- Lida com o desenho.
function love.draw()
	UI.draw()
	UI.drawDebug()
end

--- Lida com o pressionar de teclas.
--- @param key love.KeyConstant
--- @param scancode love.Scancode
--- @param isrepeat boolean
function love.keypressed(key, scancode, isrepeat)
	UI.keypressed(key, scancode, isrepeat)
end

--- Lida com o soltar de teclas.
--- @param key love.KeyConstant
--- @param scancode love.Scancode
function love.keyreleased(key, scancode)
	UI.keyreleased(key, scancode)
end

--- Lida com o pressionar do mouse.
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
function love.mousepressed(x, y, button, istouch, presses)
	UI.mousepressed(x, y, button, istouch, presses)
end

--- Lida com o soltar do mouse.
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
function love.mousereleased(x, y, button, istouch, presses)
	UI.mousereleased(x, y, button, istouch, presses)
end

--- Lida com o movimento do mouse.
--- @param x number
--- @param y number
--- @param dx number
--- @param dy number
--- @param istouch boolean
function love.mousemoved(x, y, dx, dy, istouch)
	UI.mousemoved(x, y, dx, dy, istouch)
end

--- Lida com o movimento da roda do mouse.
--- @param x number
--- @param y number
function love.wheelmoved(x, y)
	UI.wheelmoved(x, y)
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
