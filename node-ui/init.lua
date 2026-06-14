local ROOT = ...

--- @class NodeUI
--- @field Control NodeUI.Control
local NodeUI = {}

--- Armazena todos os **`Control`** que estão na raiz do **`NodeUI`**.
local root_controls = {} --- @type NodeUI.Control[]
--- Posição horizonal base para os **`Control`** que estão na raiz do **`NodeUI`**.
local base_x = 0
--- Posição vertical base para os **`Control`** que estão na raiz do **`NodeUI`**.
local base_y = 0
--- Comprimento base para os **`Control`** que estão na raiz do **`NodeUI`**.
local base_width = love.graphics.getWidth()
--- Altura base para os **`Control`** que estão na raiz do **`NodeUI`**.
local base_height = love.graphics.getHeight()


--#region Local

--- Converte um caminho para nome de classe.
--- @param path string Caminho a ser transformado em nome de classe.
local function toClassName(path)
    -- pega só o nome do arquivo
    local filename = path:match("([^/]+)%.lua$")
    if not filename then return nil end

    -- converte snake_case → PascalCase
    local class_name = filename:gsub("_(%l)", function(letter)
        return letter:upper()
    end)

    -- capitaliza primeira letra
    class_name = class_name:gsub("^%l", string.upper)

    return class_name
end

--- Converte um caminho para caminho de módulo.
--- @param path string Caminho a ser transformado em nome de módulo.
local function toModulePath(path)
    -- remove extensão .lua
    local module = path:gsub("%.lua$", "")

    -- troca / por .
    module = module:gsub("/", ".")

    return module
end

--- Carrega todos os nós da biblioteca.
--- @param dir? string Caminho do diretório e subdiretórios com todos os nós.
local function requireNodes(dir)
    dir = dir or ROOT .. "/nodes/"

    for _, path in ipairs(love.filesystem.getDirectoryItems(dir)) do
        local full_path = dir .. path
        local type = love.filesystem.getInfo(full_path).type

        if type == "file" then
            local node_name = toClassName(full_path)
            --- @diagnostic disable-next-line: need-check-nil
            NodeUI[node_name] = require(toModulePath(full_path))
            NodeUI[node_name]._node_ui = NodeUI
        elseif type == "directory" then
            requireNodes(full_path)
        end
    end
end

--- Chama determinado método dos **`Control`** na raiz da UI.
--- @param method string Método a ser chamado.
--- @param ... any Parâmetros do método.
local function callRootControlMethod(method, ...)
    for _, root_control in ipairs(root_controls) do
        if type(root_control[method]) == "function" then
            root_control[method](root_control, ...)
        end
    end
end

--- Deleta todos os filhos de `root`. A deleção ocorre de maneira recursiva, de filho para filho.
--- @param root NodeUI.Control Raiz da árvore de **`Control`**.
local function deleteTree(root)
    local children = root:getChildren()

    for i = #children, 1, -1 do
        local child = children[i]

        root:removeChild(child)
        deleteTree(child) -- Remove os filhos do filho.
    end
end

--#endregion


requireNodes() -- Carrega todos os nós do módulo.


--#region Public

--- Retorna a quantidade de **`Control`** na raiz da UI.
--- @nodiscard
--- @return number
function NodeUI.getRootChildCount()
    return #root_controls
end

--- Desenha a depuração de todos os **`Control`** na raiz da UI.
function NodeUI.drawDebug()
    callRootControlMethod("_drawDebug")
end

--#endregion


--#region Engine Callback

--- Atualiza todos os **`Control`** que estão na raiz da UI.
--- @param dt number
function NodeUI.update(dt)
    for i = #root_controls, 1, -1 do
        local root_control = root_controls[i]

        if root_control:isQueuedForDeletion() then
            -- Remove os Control e seus filhos na fila de deleção.
            table.remove(root_controls, i)
            deleteTree(root_control)
        elseif root_control:getParent() then
            -- Remove os Control que possuem parente, pois todos os Control são adicionados
            -- automaticamente na raiz da UI, mas os que têm parente não devem fazer parte da raiz.
            table.remove(root_controls, i)
        end
    end

    callRootControlMethod("_update", dt)
end

--- Desenha todos os **`Control`** que estão na raiz da UI.
function NodeUI.draw()
    callRootControlMethod("_draw")
end

--- Lida com o pressionar de teclas.
--- @param key love.KeyConstant
--- @param scancode love.Scancode
--- @param isrepeat boolean
function NodeUI.keypressed(key, scancode, isrepeat)
    callRootControlMethod("_keypressed", key, scancode, isrepeat)
end

--- Lida com o soltar de teclas.
--- @param key love.KeyConstant
--- @param scancode love.Scancode
function NodeUI.keyreleased(key, scancode)
    callRootControlMethod("_keyreleased", key, scancode)
end

--- Lida com o pressionar do mouse.
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
function NodeUI.mousepressed(x, y, button, istouch, presses)
    callRootControlMethod("_mousepressed", x, y, button, istouch, presses)
end

--- Lida com o soltar do mouse.
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
function NodeUI.mousereleased(x, y, button, istouch, presses)
    callRootControlMethod("_mousereleased", x, y, button, istouch, presses)
end

--- Lida com o movimento do mouse.
--- @param x number
--- @param y number
--- @param dx number
--- @param dy number
--- @param istouch boolean
function NodeUI.mousemoved(x, y, dx, dy, istouch)
    callRootControlMethod("_mousemoved", x, y, dx, dy, istouch)
end

--- Lida com o movimento da roda do mouse.
--- @param x number
--- @param y number
function NodeUI.wheelmoved(x, y)
    callRootControlMethod("_wheelmoved", x, y)
end

--#endregion


--#region Setter

--- Define a posição horizontal base dos **`Control`** na raiz da UI.
--- @param value number Nova posição horizontal.
function NodeUI.setBaseX(value)
    base_x = value
    callRootControlMethod("_queueUpdateLayout")
end

--- Define a posição vertical base dos **`Control`** na raiz da UI.
--- @param value number Nova posição vertical.
function NodeUI.setBaseY(value)
    base_y = value
    callRootControlMethod("_queueUpdateLayout")
end

--- Define a posição base dos **`Control`** na raiz da UI.
--- @param x number Nova posição horizontal.
--- @param y number Nova posição vertical.
function NodeUI.setBasePosition(x, y)
    base_x, base_y = x, y
    callRootControlMethod("_queueUpdateLayout")
end

--- Define o comprimento base dos **`Control`** na raiz da UI.
--- @param value number Novo comprimento.
function NodeUI.setBaseWidth(value)
    base_width = value
    callRootControlMethod("_queueUpdateLayout")
end

--- Define a altura base dos **`Control`** na raiz da UI.
--- @param value number Nova altura.
function NodeUI.setBaseHeight(value)
    base_height = value
    callRootControlMethod("_queueUpdateLayout")
end

--- Define a dimensão base dos **`Control`** na raiz da UI.
--- @param width number Novo comprimento.
--- @param height number Nova altura.
function NodeUI.setBaseDimensions(width, height)
    base_width, base_height = width, height
    callRootControlMethod("_queueUpdateLayout")
end

--#endregion


--#region Getter

--- Retorna a posição horizontal base dos **`Control`** na raiz da UI.
--- @nodiscard
--- @return number
function NodeUI.getBaseX()
    return base_x
end

--- Retorna a posição vertical base dos **`Control`** na raiz da UI.
--- @nodiscard
--- @return number
function NodeUI.getBaseY()
    return base_y
end

--- Retorna a posição base dos **`Control`** na raiz da UI.
--- @nodiscard
--- @return number x, number y
function NodeUI.getBasePosition()
    return base_x, base_y
end

--- Retorna o comprimento base dos **`Control`** na raiz da UI.
--- @nodiscard
--- @return number
function NodeUI.getBaseWidth()
    return base_width
end

--- Retorna a altura base dos **`Control`** na raiz da UI.
--- @nodiscard
--- @return number
function NodeUI.getBaseHeight()
    return base_height
end

--- Retorna a dimensão base dos **`Control`** na raiz da UI.
--- @nodiscard
--- @return number width, number height
function NodeUI.getBaseDimensions()
    return base_width, base_height
end

--#endregion


--#region Private

--- Adiciona um **`Control`** na raiz da UI.
--- @private
--- @param control NodeUI.Control **`Control`** a ser adicionado.
function NodeUI._addRootControl(control)
    root_controls[#root_controls + 1] = control
end

--#endregion


return NodeUI
