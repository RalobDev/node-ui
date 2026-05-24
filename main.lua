local UI = require("node-ui")

local main_control = UI.VContainer:new(0, 0, 1280, 720, {
	separation = 8,
})

local function addControl()
	local control = main_control:addChild(UI.HContainer:new(0, 0, 0, 100))

	local label = control:addChild(UI.Label:new(0, 0, 100, 0, "0", {
		container_expand = true,
		h_align_mode = "center",
		v_align_mode = "center",
	}))
	control:addChild(UI.Button:new(0, 0, 100, 0, {
		pressed_callback = function()
			label.text = tostring(tonumber(label.text) + 1)
		end,
	}))
end

--- @param dt number
function love.update(dt)
	main_control:update(dt)
end

function love.draw()
	main_control:draw()
	main_control:recursiveDebug()
end

--- @param x number
--- @param y number
--- @param istouch boolean
--- @param presses number
function love.mousepressed(x, y, button, istouch, presses)
	main_control:mousepressed(x, y, button, istouch, presses)
end

--- @param x number
--- @param y number
--- @param istouch boolean
--- @param presses number
function love.mousereleased(x, y, button, istouch, presses)
	main_control:mousereleased(x, y, button, istouch, presses)
end

--- @param x number
--- @param y number
--- @param dx number
--- @param dy number
--- @param istouch boolean
function love.mousemoved(x, y, dx, dy, istouch)
	main_control:mousemoved(x, y, dx, dy, istouch)
end

--- @param key love.KeyConstant
--- @param scancode love.Scancode
--- @param isrepeat boolean
--- @diagnostic disable-next-line: unused-local
function love.keypressed(key, scancode, isrepeat)
	if key == "f8" then
		love.event.quit()
	elseif key == "f" then
		addControl()
	end
end
