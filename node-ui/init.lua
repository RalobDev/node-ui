local ROOT = ... --- @type string

--- O **NodeUI** é o módulo principal da biblioteca, responsável por gerenciar os controles da interface, processar eventos de entrada e
--- coordenar a atualização e renderização da UI.
---
--- ### Descrição
---
--- O **NodeUI** atua como o ponto central da biblioteca. Ele mantém os controles que estão na raiz da interface, encaminha eventos do LÖVE para
--- os elementos da UI e fornece a área base utilizada como referência para o sistema de layout. Além disso, é responsável por atualizar,
--- desenhar e gerenciar o ciclo de vida dos controles.
--- @class NodeUI
--- @field AspectRatioContainer NodeUI.AspectRatioContainer Referência ao **NodeUI.AspectRatioContainer**.
--- @field BoxContainer NodeUI.BoxContainer                 Referência ao **NodeUI.BoxContainer**.
--- @field CenterContainer NodeUI.CenterContainer           Referência ao **NodeUI.CenterContainer**.
--- @field ColorRect NodeUI.ColorRect                       Referência ao **NodeUI.ColorRect**.
--- @field Container NodeUI.Container                       Referência ao **NodeUI.Container**.
--- @field Control NodeUI.Control                           Referência ao **NodeUI.Control**.
--- @field FlowContainer NodeUI.FlowContainer               Referência ao **NodeUI.FlowContainer**.
--- @field GridContainer NodeUI.GridContainer               Referência ao **NodeUI.GridContainer**.
--- @field MarginContainer NodeUI.MarginContainer           Referência ao **NodeUI.MarginContainer**.
--- @field Panel NodeUI.Panel                               Referência ao **NodeUI.Panel**.
--- @field TextBlock NodeUI.TextBlock                       Referência ao **NodeUI.TextBlock**.
--- @field Resources NodeUI.Resources                       Referência a todos os recursos.
local NodeUI = {}

local root_controls = {} --- @type NodeUI.Control[]
local base_x = 0
local base_y = 0
local base_width = love.graphics.getWidth()
local base_height = love.graphics.getHeight()
local base_mouse_x = 0
local base_mouse_y = 0
local base_mouse_position_sended = false
local base_mouse_position_sended_loops = 0
local control_mouse_focus   --- @type NodeUI.Control|nil
local control_mouse_pressed --- @type NodeUI.Control|nil

--#region Local

--- Converte um caminho para nome de classe.
--- @param path string Caminho a ser transformado em nome de classe.
local function toClassName(path)
    -- Pega só o nome do arquivo.
    local filename = path:match("([^/]+)%.lua$")
    if not filename then return nil end

    -- Converte snake_case → PascalCase.
    local class_name = filename:gsub("_(%l)", function(letter)
        return letter:upper()
    end)

    -- Capitaliza primeira letra.
    class_name = class_name:gsub("^%l", string.upper)

    return class_name
end

--- Converte um caminho para caminho de módulo.
--- @param path string Caminho a ser transformado em nome de módulo.
local function toModulePath(path)
    -- Remove extensão .lua
    local module = path:gsub("%.lua$", "")

    -- Troca "/" por ".".
    module = module:gsub("/", ".")

    return module
end

--- Retorna recursivamente todos os arquivos em um diretório.
--- @param dir string Diretório dos arquivos.
--- @return string[] files Caminho de todos os arquivos.
local function getFilesAt(dir)
    local files = {} --- @type string[]

    for _, path in ipairs(love.filesystem.getDirectoryItems(dir)) do
        local full_path = dir .. path
        local info = love.filesystem.getInfo(full_path)
        local type = info and info.type or ""

        if type == "file" then
            files[#files + 1] = full_path
        elseif type == "directory" then
            for _, file in ipairs(getFilesAt(full_path)) do
                files[#files + 1] = file
            end
        end
    end

    return files
end

--- Carrega todos os nós da biblioteca.
--- @param dir? string Caminho do diretório e subdiretórios com todos os nós.
local function requireNodes(dir)
    dir = dir or ROOT .. "/nodes/"

    for _, file in ipairs(getFilesAt(dir)) do
        local node_name = toClassName(file)
        --- @diagnostic disable-next-line: need-check-nil
        NodeUI[node_name] = require(toModulePath(file))
        NodeUI[node_name]._node_ui = NodeUI
    end
end

--- Carrega todos os recursos da biblioteca.
--- @param dir? string Caminho do diretório e subdiretórios com todos os recursos.
local function requireResources(dir)
    dir = dir or ROOT .. "/resources/"

    NodeUI.Resources = {} --- @diagnostic disable-line: missing-fields

    for _, file in ipairs(getFilesAt(dir)) do
        local resource_name = toClassName(file)
        --- @diagnostic disable-next-line: need-check-nil
        NodeUI.Resources[resource_name] = require(toModulePath(file))
    end
end

--- Chama determinado método dos **Control** na raiz da UI.
--- @param method string Método a ser chamado.
--- @param ... any       Parâmetros do método.
local function callRootControlMethod(method, ...)
    for _, root_control in ipairs(root_controls) do
        if type(root_control[method]) == "function" then
            root_control[method](root_control, ...)
        end
    end
end

--- Deleta todos os **Control** na `root`. A deleção ocorre de maneira recursiva, de filho para filho.
--- @param root NodeUI.Control Raiz da árvore de **Control**.
local function deleteTree(root)
    local children = root:getChildren()

    for i = #children, 1, -1 do
        local child = children[i]

        root:removeChild(child)
        deleteTree(child) -- Remove os filhos do filho.
    end
end

--- Define o foco do mouse do **Control**.
--- @param control NodeUI.Control
--- @param enabled boolean Se `true`, ativa o foco do mouse.
local function setControlMouseFocus(control, enabled)
    local had_focus = control_mouse_focus == control

    if enabled then
        control_mouse_focus = control
    elseif had_focus then
        control_mouse_focus = nil
    end

    local has_focus = control_mouse_focus == control

    if had_focus ~= has_focus then
        control:_emit("MOUSE_FOCUS_CHANGED", has_focus) --- @diagnostic disable-line: invisible
    end
end

--- Limpa o foco do mouse da árvore de nós.
--- @param root NodeUI.Control     Raiz da árvore de **Control**.
--- @param exclude? NodeUI.Control **Control** que será excluido da limpeza.
local function clearTreeMouseFocus(root, exclude)
    if root ~= exclude then
        setControlMouseFocus(root, false)
    end

    for _, child in ipairs(root:getChildren(true)) do
        clearTreeMouseFocus(child, exclude)
    end
end


--- Encontra o foco do mouse na árvore de nós. Caso não exista retorna `nil`.
--- @param root NodeUI.Control      Raiz da árvore de **Control**.
--- @return NodeUI.Control? focused **Control** com o foco do mouse.
local function findTreeMouseFocus(root)
    if not root:isVisible() then
        return nil
    end

    local filter = root:getMouseFilter()

    if filter == "IGNORE" then
        return nil
    end

    -- Verifica se o mouse está sobre a root.
    do
        local mouse_x, mouse_y = NodeUI.getBaseMousePosition()
        local root_x, root_y = root:getPosition()
        local root_width, root_height = root:getDimensions()

        if not (mouse_x >= root_x
                and mouse_y >= root_y
                and mouse_x <= root_x + root_width
                and mouse_y <= root_y + root_height) then
            return nil
        end
    end

    if filter == "STOP" then
        return root
    end

    if filter == "PASS" then
        local children = root:getChildren(true)
        for i = #children, 1, -1 do
            local child = children[i]
            local focused = findTreeMouseFocus(child)

            if focused then
                return focused
            end
        end

        return root
    end

    return nil
end

--- Atualiza o foco do mouse na árvore de nós. Se existir, retorna o **Control** com o foco do mouse.
--- @param root NodeUI.Control      Raiz da árvore de **Control**.
--- @return NodeUI.Control? focused **Control** com o foco do mouse.
local function updateTreeMouseFocus(root)
    local focused = findTreeMouseFocus(root)

    clearTreeMouseFocus(root, focused)

    if focused then
        setControlMouseFocus(focused, true)
    end

    return focused
end

--#endregion


requireNodes()     -- Carrega todos os nós.
requireResources() -- Carrega todos os recursos.


--#region Public

--- Desenha a depuração de todos os **`Control`** na raiz.
function NodeUI.drawDebug()
    callRootControlMethod("_drawDebug")
end

--- Envia para o **NodeUI** qual deve ser a posição do mouse usada pelos nós.
--- @param x number Posição x do mouse.
--- @param y number Posição y do mouse.
function NodeUI.sendBaseMousePosition(x, y)
    base_mouse_x, base_mouse_y = x, y
    base_mouse_position_sended = true
end

--#endregion


--#region Engine Callback

--- Atualiza todos os **`Control`**.
function NodeUI.update(dt)
    -- Calcula a quantos loops a posição base do mouse foi enviada.
    -- Isso é necessário porque "_sendBaseMousePosition()" deve ser chamado todo frame para manter suas alterações.
    if base_mouse_position_sended then
        base_mouse_position_sended_loops = base_mouse_position_sended_loops + 1

        if base_mouse_position_sended_loops >= 2 then
            base_mouse_position_sended_loops = 0
            base_mouse_position_sended = false
        end
    end

    for i = #root_controls, 1, -1 do
        local root_control = root_controls[i]

        -- Apaga o "root_control" se estiver marcado para deleção.
        -- Cada Control é responsável por deletar seus filhos marcados para deleção.
        if root_control:isQueuedForDeletion() then
            table.remove(root_controls, i)
            deleteTree(root_control)
        end

        -- Remove o "root_control" da raiz se ele ter um parente, pois controls na raiz não devem ter parente e
        -- todos os controls criados são adicionados a raiz por padrão.
        if root_control:getParent() then
            table.remove(root_controls, i)
        end
    end

    callRootControlMethod("_update", dt) -- Atualiza os controls na raiz.

    -- Rotina de foco do mouse.
    do
        local focus_caught = false

        -- Varre de trás pra frente (o último desenhado é o que está por cima).
        for i = #root_controls, 1, -1 do
            local root_control = root_controls[i]

            if not focus_caught then
                local focused = updateTreeMouseFocus(root_control)
                if focused then
                    focus_caught = true
                end
            else
                -- Se um root acima já pegou o mouse, limpa os que estão embaixo.
                clearTreeMouseFocus(root_control)
            end
        end
    end
end

--- Desenha todos os **`Control`**.
function NodeUI.draw()
    callRootControlMethod("_draw")
end

--- Lida com o pressionar de um botão do mouse.
--- @param x number        Posição x do mouse, em pixels.
--- @param y number        Posição y do mouse, em pixels.
--- @param button number   O index do botão que foi pressionado.
--- @param istouch boolean `true` se o pressionar do botão do mouse é originado de uma touchscreen.
--- @param presses number  O número de pressionamentos.
function NodeUI.mousepressed(x, y, button, istouch, presses)
    if control_mouse_focus then
        control_mouse_focus:_emit("MOUSE_PRESSED", x, y, button, istouch, presses) --- @diagnostic disable-line: invisible
        control_mouse_pressed = control_mouse_focus
    end
end

--- Lida com o soltar de um botão do mouse.
--- @param x number        Posição x do mouse, em pixels.
--- @param y number        Posição y do mouse, em pixels.
--- @param button number   O index do botão que foi solto.
--- @param istouch boolean `true` se o soltar do botão do mouse é originado de uma touchscreen.
--- @param presses number  O número de pressionamentos.
function NodeUI.mousereleased(x, y, button, istouch, presses)
    if control_mouse_pressed then
        control_mouse_pressed:_emit("MOUSE_RELEASED", x, y, button, istouch, presses) --- @diagnostic disable-line: invisible
    end
end

--- Lida com o movimento do mouse.
--- @param x number        Posição x do mouse, em pixels.
--- @param y number        Posição y do mouse, em pixels.
--- @param dx number       Quanto se moveu ao longo do eixo-x.
--- @param dy number       Quanto se moveu ao longo do eixo-y.
--- @param istouch boolean `true` se o movimento do mouse é originado de uma touchscreen.
function NodeUI.mousemoved(x, y, dx, dy, istouch)
    if control_mouse_focus then
        control_mouse_focus:_emit("MOUSE_MOVED", x, y, dx, dy, istouch) --- @diagnostic disable-line: invisible
    end
end

--- Lida com o movimento da roda do mouse.
--- @param x number Quanto se moveu ao longo do eixo-x.
--- @param y number Quanto se moveu ao longo do eixo-y.
function NodeUI.wheelmoved(x, y)
    if control_mouse_focus then
        control_mouse_focus:_emit("WHEEL_MOVED", x, y) --- @diagnostic disable-line: invisible
    end
end

--#endregion


--#region Setter

--- Define a posição x base dos **`Control`** na raiz.
--- @param value number Nova posição x.
function NodeUI.setBaseX(value)
    base_x = value
    callRootControlMethod("_queueUpdateLayout")
end

--- Define a posição y base dos **`Control`** na raiz.
--- @param value number Nova posição no y.
function NodeUI.setBaseY(value)
    base_y = value
    callRootControlMethod("_queueUpdateLayout")
end

--- Define a posição base dos **`Control`**.
--- @param x number Nova posição x.
--- @param y number Nova posição y.
function NodeUI.setBasePosition(x, y)
    base_x, base_y = x, y
    callRootControlMethod("_queueUpdateLayout")
end

--- Define o comprimento base dos **`Control`** na raiz.
--- @param value number Novo comprimento.
function NodeUI.setBaseWidth(value)
    base_width = value
    callRootControlMethod("_queueUpdateLayout")
end

--- Define a altura base dos **`Control`** na raiz.
--- @param value number Nova altura.
function NodeUI.setBaseHeight(value)
    base_height = value
    callRootControlMethod("_queueUpdateLayout")
end

--- Define a dimensão base dos **`Control`** na raiz.
--- @param width number  Novo comprimento.
--- @param height number Nova altura.
function NodeUI.setBaseDimensions(width, height)
    local old_width, old_height = base_width, base_height

    base_width, base_height = width, height

    if base_width ~= old_width or base_height ~= old_height then
        callRootControlMethod("_queueUpdateLayout")
    end
end

--#endregion


--#region Getter

--- Retorna a quantidade de **`Control`** na raiz.
--- @nodiscard
--- @return number count Quantidade de filhos.
function NodeUI.getRootChildCount()
    return #root_controls
end

--- Retorna o **`Control`** que possui o foco do mouse. Se nenhum possuir, retorna `nil`.
--- @nodiscard
--- @return NodeUI.Control? mouse_focus_control **Control** que possui o foco do mouse.
function NodeUI.getControlMouseFocus()
    return control_mouse_focus
end

--- Retorna a posição horizontal base dos **`Control`** na raiz.
--- @nodiscard
--- @return number x Posição base x.
function NodeUI.getBaseX()
    return base_x
end

--- Retorna a posição vertical base dos **`Control`** na raiz.
--- @nodiscard
--- @return number y Posição base y.
function NodeUI.getBaseY()
    return base_y
end

--- Retorna a posição base dos **`Control`** na raiz.
--- @nodiscard
--- @return number x Posição base x.
--- @return number y Posição base y.
function NodeUI.getBasePosition()
    return base_x, base_y
end

--- Retorna o comprimento base dos **`Control`** na raiz.
--- @nodiscard
--- @return number width Comprimento base.
function NodeUI.getBaseWidth()
    return base_width
end

--- Retorna a altura base dos **`Control`** na raiz.
--- @nodiscard
--- @return number height Altura base.
function NodeUI.getBaseHeight()
    return base_height
end

--- Retorna a dimensão base dos **`Control`** na raiz.
--- @nodiscard
--- @return number width  Comprimento base.
--- @return number height Altura base.
function NodeUI.getBaseDimensions()
    return base_width, base_height
end

--- Retorna a posição x base do mouse.
--- @nodiscard
--- @return number x Posição x do mouse.
function NodeUI.getBaseMouseX()
    return base_mouse_position_sended and base_mouse_x or love.mouse.getX()
end

--- Retorna a posição y base do mouse.
--- @nodiscard
--- @return number y Posição y do mouse.
function NodeUI.getBaseMouseY()
    return base_mouse_position_sended and base_mouse_y or love.mouse.getY()
end

--- Retorna a posição base do mouse.
--- @nodiscard
--- @return number x Posição x do mouse.
--- @return number y Posição y do mouse.
function NodeUI.getBaseMousePosition()
    return NodeUI.getBaseMouseX(), NodeUI.getBaseMouseY()
end

--#endregion


--#region Private

--- Adiciona um **`Control`** na raiz da UI.
--- @private
--- @param control NodeUI.Control Control a ser adicionado.
function NodeUI._addRootControl(control)
    root_controls[#root_controls + 1] = control
end

--#endregion


return NodeUI
