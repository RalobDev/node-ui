local UI = require("node-ui")

--- @param key love.KeyConstant
--- @param scancode love.Scancode
--- @param isrepeat boolean
--- @diagnostic disable-next-line: unused-local
function love.keypressed(key, scancode, isrepeat)
	if key == "f8" then
		love.event.quit()
	end
end
