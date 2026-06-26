local ROOT = (...):match("^(.*)%.")                                              --- @type string

local Control = require(ROOT .. ".control")                                      --- @type NodeUI.Control
local TextSettings = require(ROOT:match("(.+)%.") .. ".resources.text_settings") --- @type NodeUI.TextSettings

local utf8 = require("utf8")

--- Um **`Control`** capaz de exibir texto.
--- @class NodeUI.TextBlock: NodeUI.Control
--- @field private _text_canvas love.Canvas
--- @field private _text_settings NodeUI.TextSettings
--- @field private _text string
--- @field private _text_lines NodeUI.TextBlock.Line[]
--- @field private _clip_text boolean
--- @field private _horizontal_alignment NodeUI.TextBlock.AlignmentMode
--- @field private _vertical_alignment NodeUI.TextBlock.AlignmentMode
--- @field private _autowrap_mode NodeUI.TextBlock.AutowrapMode
--- @field private _queued_for_parse_text boolean
--- @field private _bbcode_enabled boolean
--- @field private _url_characters { char: NodeUI.TextBlock.Character, x: number, y: number, w: number, h: number }[]
--- @field private _image_cache table<string, love.Image>
--- @field private _visible_characters number
--- @field private _visible_characters_behavior NodeUI.TextBlock.VisibleCharactersBehavior
--- @field private _visible_ratio number
local TextBlock = Control:extend("TextBlock")


local OUTLINE_SHADOW_COLOR = love.graphics.newShader(ROOT:match("(.+)%.") .. "/shaders/outline_shadow.glsl")


--#region Public

--- Cria uma novo **TextBlock**.
--- @nodiscard
--- @param x number 		           Posição horizontal.
--- @param y number 		           Posição vertical.
--- @param width number 	           Comprimento em pixels.
--- @param height number 	           Altura em pixels.
--- @param is_minimum? boolean         Se a dimensão passada é a mínima.
--- @return NodeUI.TextBlock TextBlock Novo TextBlock.
function TextBlock:new(x, y, width, height, is_minimum)
    local obj = Control.new(self, x, y, width, height, is_minimum) --- @cast obj NodeUI.TextBlock

    obj:setTextSettings(TextSettings:new())
    obj._text = ""
    obj._clip_text = false
    obj._text_lines = {}
    obj._horizontal_alignment = "BEGIN"
    obj._vertical_alignment = "BEGIN"
    obj._autowrap_mode = "OFF"
    obj._queued_for_parse_text = false
    obj._bbcode_enabled = false
    obj._url_characters = {}
    obj._image_cache = {}
    obj._visible_characters = -1
    obj._visible_characters_behavior = "LEFT_TO_RIGHT"
    obj._visible_ratio = 1

    return obj
end

--#endregion


--#region Override

--- Cria uma conexão em determinado **`NodeUI.TextBlock.Signals`** do **TextBlock**.
--- @param signal NodeUI.TextBlock.Signals Nome do sinal.
--- @param method string|function          Nome do método ou método chamado ao sinal ser emitido.
--- @param owner? table                    Objeto dono do método.
function TextBlock:connect(signal, method, owner)
    Control.connect(self, signal, method, owner)
end

--- Remove a conexão de um **`NodeUI.TextBlock.Signals`** do **TextBlock**.
--- @param signal NodeUI.TextBlock.Signals Nome do sinal.
--- @param method string|function          Nome do método ou método chamado ao sinal ser emitido.
--- @param owner table?                    Objeto dono do método.
function TextBlock:disconnect(signal, method, owner)
    Control.disconnect(self, signal, method, owner)
end

--#endregion


--#region Setter

--- Define a **`TextSettings`** do **TextBlock**.
--- @param text_settings NodeUI.TextSettings **`TextSettings`** do **TextBlock**.
function TextBlock:setTextSettings(text_settings)
    local old = self._text_settings

    self._text_settings = text_settings

    if self._text_settings ~= old then
        self:_queueParseText()
        self._text_settings:connect("CHANGED", "_onTextSettingsChanged", self)

        if old then
            old:disconnect("CHANGED", "_onTextSettingsChanged", self)
        end
    end
end

--- Define o texto exibido pela **Label**.
--- @param text string Texto exibido.
function TextBlock:setText(text)
    local old = self._text

    self._text = text

    if self._text ~= old then
        self:_queueParseText()
    end
end

--- Define se é para clipar o texto exibido.
--- @param enabled? boolean Se é para clipar o texto.
function TextBlock:setClipText(enabled)
    if enabled == nil then
        enabled = true
    end

    local old = self._clip_text

    self._clip_text = enabled

    if self._clip_text ~= old then
        self:_queueParseText()
    end
end

--- Define o **`NodeUI.TextBlock.AlignmentMode`** das linhas.
--- @param axis NodeUI.Control.Axis                 Eixo do alinhamento.
--- @param alignment NodeUI.TextBlock.AlignmentMode Alinhamento das linhas.
function TextBlock:setAlignment(axis, alignment)
    local alignment_key = "_" .. axis:lower() .. "_alignment"
    self[alignment_key] = alignment
end

--- Define o **`NodeUI.TextBlock.AutowrapMode`** das linhas.
--- @param autowrap_mode NodeUI.TextBlock.AutowrapMode Autowrap das linhas.
function TextBlock:setAutowrapMode(autowrap_mode)
    local old = self._autowrap_mode

    self._autowrap_mode = autowrap_mode

    if self._autowrap_mode ~= old then
        self:_queueParseText()
    end
end

--- Define o uso de [BBCode](https://en.wikipedia.org/wiki/BBCode).
--- @param enabled? boolean Se é para usar BBCode.
function TextBlock:setBBCode(enabled)
    if enabled == nil then
        enabled = true
    end

    local old = self._bbcode_enabled

    self._bbcode_enabled = enabled

    if self._bbcode_enabled ~= old then
        self:_queueParseText()
    end
end

--- Define a quantidade de caracteres visíveis. Caso seja -1, todos estarão visíveis.
--- @param amount number Quantidade de caracteres visíveis.
function TextBlock:setVisibleCharacters(amount)
    local old = self._visible_characters

    self._visible_characters = math.max(amount, -1)

    if self._visible_characters ~= old then
        self:_queueParseText()
    end
end

--- Define o comportamento dos caracteres visíveis.
--- @param behavior NodeUI.TextBlock.VisibleCharactersBehavior Comportamento dos caracteres visíveis.
function TextBlock:setVisibleCharactersBehavior(behavior)
    local old = self._visible_characters_behavior

    self._visible_characters_behavior = behavior

    if self._visible_characters_behavior ~= old then
        self:_queueParseText()
    end
end

--- Define o ratio dos caracteres visíveis, que deve ser um número de 0 a 1.
--- @param ratio number Ratio dos caracteres visíveis.
function TextBlock:setVisibleRatio(ratio)
    local old = self._visible_ratio

    self._visible_ratio = math.max(0, math.min(1, ratio))

    if self._visible_ratio ~= old then
        self:_queueParseText()
    end
end

--#endregion


--#region Getter

--- Retorna a **`TextSettings`** do **TextBlock**.
--- @nodiscard
--- @return NodeUI.TextSettings text_settings **`TextSettings`** do **TextBlock**.
function TextBlock:getTextSettings()
    return self._text_settings
end

--- Retorna o texto exibido pela **TextBlock**.
--- @nodiscard
--- @return string text Texto exibido.
function TextBlock:getText()
    return self._text
end

--- Retorna se é para clipar o texto exibido.
--- @nodiscard
--- @return boolean enabled Se o clip de texto está ativado.
function TextBlock:getClipText()
    return self._clip_text
end

--- Retorna o **`NodeUI.TextBlock.AlignmentMode`** das linhas.
--- @nodiscard
--- @param axis NodeUI.Control.Axis                  Eixo do alinhamento.
--- @return NodeUI.TextBlock.AlignmentMode alignment Alinhamento das linhas.
function TextBlock:getAlignment(axis)
    local alignment_key = "_" .. axis:lower() .. "_alignment"
    return self[alignment_key]
end

--- Retorna o **`NodeUI.TextBlock.AutowrapMode`** das linhas.
--- @nodiscard
--- @return NodeUI.TextBlock.AutowrapMode autowrap_mode Autowrap das linhas.
function TextBlock:getAutowrapMode()
    return self._autowrap_mode
end

--- Retorna o uso de [BBCode](https://en.wikipedia.org/wiki/BBCode).
--- @nodiscard
--- @return boolean enabled Se é para usar BBCode.
function TextBlock:getBBCode()
    return self._bbcode_enabled
end

--- Retorna a quantidade de caracteres visíveis. Caso seja -1, todos estarão visíveis.
--- @nodiscard
--- @return number amount Quantidade de caracteres visíveis.
function TextBlock:getVisibleCharacters()
    return self._visible_characters
end

--- Retorna o comportamento dos caracteres visíveis.
--- @nodiscard
--- @return NodeUI.TextBlock.VisibleCharactersBehavior behavior Comportamento dos caracteres visíveis.
function TextBlock:getVisibleCharactersBehavior()
    return self._visible_characters_behavior
end

--- Retorna o ratio dos caracteres visíveis, que deve ser um número de 0 a 1.
--- @nodiscard
--- @return number ratio Ratio dos caracteres visíveis.
function TextBlock:getVisibleRatio()
    return self._visible_ratio
end

--#endregion


--#region Protected Getter

--- Calcula dinamicamente o comprimento mínimo do **Control**.
--- @protected
--- @return number width
function TextBlock:_calculateMinimumWidth()
    if self._clip_text or not self._text_lines or self._autowrap_mode ~= "OFF" then
        return 0
    end

    local max_width = 0
    for _, line in ipairs(self._text_lines) do
        max_width = math.max(max_width, self:_getLineWidth(line))
    end

    return max_width
end

--- Calcula dinamicamente a altura mínima do **Control**.
--- @protected
--- @return number height
function TextBlock:_calculateMinimumHeight()
    if not self._text_lines then
        return 0
    end

    local height = 0
    for _, line in ipairs(self._text_lines) do
        height = height + self:_getLineHeight(line)
    end

    return height
end

--#endregion


--#region Protected Callback

--- Chamado durante a atualização do **Control**.
--- @protected
--- @param dt number Tempo decorrido desde a última atualização.
--- @diagnostic disable-next-line: unused-local
function TextBlock:_onUpdate(dt)
    if self._queued_for_parse_text then
        self._queued_for_parse_text = false
        self:_parseText()
        self:_queueUpdateLayout()
    end

    self:_updateTextCanvas()

    local canvas_x, canvas_y = self:_getTextCanvasPosition()

    if #self._url_characters > 0 then
        local mouse_x, mouse_y = self._node_ui:getBaseMousePosition()
        local is_inside_urls = {} --- @type table<string, boolean>
        local has_inside = false

        for _, url_character in ipairs(self._url_characters) do
            local char_x = canvas_x + url_character.x
            local char_y = canvas_y + url_character.y

            local is_inside = (
                mouse_x >= char_x
                and mouse_y >= char_y
                and mouse_x <= char_x + url_character.w
                and mouse_y <= char_y + url_character.h
            )

            if is_inside then
                is_inside_urls[url_character.char.url] = true
                has_inside = true
            end

            url_character.char.underline = false
        end

        if has_inside then
            for _, url_character in ipairs(self._url_characters) do
                if is_inside_urls[url_character.char.url] then
                    url_character.char.underline = true
                end
            end
        end
    end
end

--- Chamado durante o desenho do **Control**.
--- @protected
function TextBlock:_onDraw()
    self._url_characters = {} -- Limpa os caracteres de url.

    local safe_size = self:_getSafeSize()
    local start_y = safe_size / 2 + (#self._text_lines > 0 and self:_getLineImageHeight(self._text_lines[1]) or 0)
    local used_height = 0
    local v_separation = 0 -- Variável para guardar o espaçamento extra entre linhas.

    -- Alinhamento Vertical.
    do
        local lines_height = 0

        for _, line in ipairs(self._text_lines) do
            lines_height = lines_height + self:_getLineHeight(line)
        end

        local v_alignment = self._vertical_alignment

        if v_alignment == "CENTER" then
            start_y = start_y + self._layout_height / 2 - lines_height / 2
        elseif v_alignment == "END" then
            start_y = start_y + self._layout_height - lines_height
        elseif v_alignment == "FILL" then
            -- Calcula a separação vertical apenas se houver mais de uma linha.
            if #self._text_lines > 1 then
                v_separation = (self._layout_height - lines_height) / (#self._text_lines - 1)
            end
        end
    end

    local default_canvas = love.graphics.getCanvas()
    love.graphics.setCanvas(self._text_canvas)
    love.graphics.clear()

    -- Renderização das Linhas.
    for _, line in ipairs(self._text_lines) do
        local used_width = 0
        local line_width = self:_getLineWidth(line)

        local start_x = safe_size / 2
        local h_alignment = self._horizontal_alignment

        -- Conta os espaços caso o alinhamento seja FILL.
        local num_spaces = 0
        local space_separation = 0

        if h_alignment == "FILL" then
            for _, char in ipairs(line.characters) do
                if char.text == " " then
                    num_spaces = num_spaces + 1
                end
            end

            -- Só calcula a separação se houver mais de um espaço.
            if num_spaces > 0 then
                space_separation = (self._layout_width - line_width) / num_spaces
            end
        end

        -- Alinhamento Horizontal (CENTER e END).
        do
            if h_alignment == "CENTER" then
                start_x = start_x + self._layout_width / 2 - line_width / 2
            elseif h_alignment == "END" then
                start_x = start_x + self._layout_width - line_width
            end
        end

        local prev_line_width = love.graphics.getLineWidth()
        love.graphics.setLineWidth(2)

        -- Desenha cada caracter da linha.
        for _, character in ipairs(line.characters) do
            -- Clipa a área de desenho.
            if self._clip_text then
                love.graphics.setScissor(self._layout_x, self._layout_y, self._layout_width, self._layout_height)
            end

            if character.visible then
                self:_drawCharacter(
                    character,
                    start_x + used_width,
                    start_y + used_height
                )
            end

            -- Aplica a separação apenas se for FILL e o caractere atual for um espaço.
            local current_separation = 0
            if h_alignment == "FILL" and character.text == " " then
                current_separation = space_separation
            end

            used_width = used_width + self:_getCharacterWidth(character) + current_separation
        end

        love.graphics.setLineWidth(prev_line_width)

        -- Incrementa a altura usada adicionando também a separação vertical do FILL.
        used_height = used_height + self:_getLineHeight(line) + v_separation
    end

    love.graphics.setCanvas(default_canvas)

    love.graphics.push("all")
    love.graphics.setColor(self._text_settings:getFontColor())
    love.graphics.setShader(OUTLINE_SHADOW_COLOR)

    local text_settings = self._text_settings

    OUTLINE_SHADOW_COLOR:send("outlineColor", text_settings:getOutlineColor())
    OUTLINE_SHADOW_COLOR:send("outlineWidth", text_settings:getOutlineSize())
    OUTLINE_SHADOW_COLOR:send("shadowColor", text_settings:getShadowColor())
    OUTLINE_SHADOW_COLOR:send("shadowOffset", { text_settings:getShadowOffset() })
    OUTLINE_SHADOW_COLOR:send("shadowOutlineWidth", text_settings:getShadowOutlineSize())
    OUTLINE_SHADOW_COLOR:send("textureSize", { self._text_canvas:getDimensions() })

    love.graphics.draw(self._text_canvas, self:_getTextCanvasPosition())

    love.graphics.pop()
end

--- Chamado quando um botão do mouse é pressionado.
--- @protected
--- @param x number        Posição x do mouse, em pixels.
--- @param y number        Posição y do mouse, em pixels.
--- @param button number   O index do botão que foi pressionado.
--- @param istouch boolean `true` se o pressionar do botão do mouse é originado de uma touchscreen.
--- @param presses number  O número de pressionamentos.
--- @diagnostic disable-next-line: unused-local
function TextBlock:_onMousepressed(x, y, button, istouch, presses)
    for _, url_character in ipairs(self._url_characters) do
        local canvas_x, canvas_y = self:_getTextCanvasPosition()
        local char_x = canvas_x + url_character.x
        local char_y = canvas_y + url_character.y

        local is_inside = (
            x >= char_x
            and y >= char_y
            and x <= char_x + url_character.w
            and y <= char_y + url_character.h
        )

        if is_inside then
            love.system.openURL(url_character.char.url)
        end
    end
end

--- Chamado durante a atualização do layout do **Control**.
--- @protected
function TextBlock:_onUpdateLayout()
    Control._onUpdateLayout(self)
    self:_queueParseText()
end

--#endregion


--#region Private

--- Desenha um **NodeUI.TextBlock.Character**.
--- @private
--- @param character NodeUI.TextBlock.Character
--- @param x number
--- @param y number
function TextBlock:_drawCharacter(character, x, y)
    local text_settings = self._text_settings
    local variant = character.variant
    local font = text_settings:getFont(variant)
    local char_width = self:_getCharacterWidth(character)
    local char_height = self:_getCharacterHeight(character)
    local char_baseline = font:getBaseline()

    local prev_color = { love.graphics.getColor() }

    -- Desenha o background.
    if character.bgcolor then
        love.graphics.setColor(character.bgcolor)
        love.graphics.rectangle("fill", x, y, char_width, char_height)
        love.graphics.setColor(prev_color)
    end

    -- Define a cor do caractere.
    do
        local color = character.url ~= nil and { 0.25, 0.55, 1.0, 1 } or character.color
        if color then
            love.graphics.setColor(
                color[1] or 1,
                color[2] or 1,
                color[3] or 1,
                color[4] or 1
            )
        end
    end

    if character.image == nil then
        -- Desenha o underline.
        if character.underline then
            love.graphics.line(
                x,
                y + char_baseline + 2,
                x + char_width,
                y + char_baseline + 2
            )
        end

        -- Desenha o strikethrough.
        if character.strikethrough then
            love.graphics.line(
                x,
                y + font:getHeight() - font:getBaseline() / 2,
                x + char_width,
                y + font:getHeight() - font:getBaseline() / 2
            )
        end
    end

    local image = character.image
    if image then -- Desenha a imagem de um caracter.
        love.graphics.draw(
            image,
            x,
            y - image:getHeight() / 2 + font:getHeight() / 2
        )
    else -- Desenha um caracter.
        local prev_font = love.graphics.getFont()
        love.graphics.setFont(font)

        love.graphics.print(character.text, x, y)

        love.graphics.setFont(prev_font)
    end

    -- Desenha o plano frontal.
    if character.fgcolor then
        love.graphics.setColor(character.fgcolor)
        love.graphics.rectangle("fill", x, y, char_width, char_height)
    end

    love.graphics.setColor(prev_color)

    if character.url ~= nil then
        local height = image and image:getHeight() or font:getHeight()
        local url_y = image and y - image:getHeight() / 2 + font:getHeight() / 2 or y

        self._url_characters[#self._url_characters + 1] = {
            char = character,
            x = x,
            y = url_y,
            w = char_width,
            h = height
        }

        love.graphics.rectangle("line", x, url_y, char_width, height)
    end
end

--- Marca o **TextBlock** para analisar o seu texto.
--- @private
function TextBlock:_queueParseText()
    self._queued_for_parse_text = true
end

--- Analisa o texto do **TextBlock** e armazena as **NodeUI.TextBlock.Line** em `_text_lines`.
--- @private
function TextBlock:_parseText()
    local max_width = self._layout_width
    local wrap_mode = self._autowrap_mode

    local raw_chars = {}
    for _, c in utf8.codes(self._text) do
        table.insert(raw_chars, utf8.char(c))
    end

    local all_characters = {} --- @type NodeUI.TextBlock.Character[]
    local i = 1

    local visible_amount = (self._visible_characters == -1 and #raw_chars or self._visible_characters)
    visible_amount = math.floor(visible_amount * self._visible_ratio)

    while i <= #raw_chars do
        local char = raw_chars[i]
        local is_visible = false
        if self._visible_characters_behavior == "LEFT_TO_RIGHT" and i <= visible_amount then
            is_visible = true
        elseif self._visible_characters_behavior == "RIGHT_TO_LEFT" and #raw_chars - i < visible_amount then
            is_visible = true
        end

        if char == "\n" then
            table.insert(all_characters, { text = "\n", variant = "NORMAL", visible = is_visible })
            i = i + 2
        else
            table.insert(all_characters, { text = char, variant = "NORMAL", visible = is_visible })
            i = i + 1
        end
    end

    if self._bbcode_enabled then
        all_characters = self:_parseBBCode(all_characters)
    end

    local lines = {}       --- @type NodeUI.TextBlock.Line[]
    local current_line = { --- @type NodeUI.TextBlock.Line
        characters = {}
    }

    local current_word = {} --- @type NodeUI.TextBlock.Character[]
    local current_line_width = 0
    local current_word_width = 0

    --- Função auxiliar para processar palavras agrupadas (modo WORD).
    local function flushWord()
        if #current_word == 0 then return end

        if wrap_mode == "WORD" then
            if (current_line_width + current_word_width > max_width) and (#current_line.characters > 0) then
                lines[#lines + 1] = current_line
                current_line = { characters = {} }
                current_line_width = 0
            end
        end

        for _, word_char in ipairs(current_word) do
            current_line.characters[#current_line.characters + 1] = word_char
        end
        current_line_width = current_line_width + current_word_width

        current_word = {}
        current_word_width = 0
    end

    for _, character in ipairs(all_characters) do
        local char_text = character.text

        if char_text == "\n" then
            -- Quebra de linha manual.
            flushWord()
            lines[#lines + 1] = current_line
            current_line = { characters = {} }
            current_line_width = 0
        elseif char_text == " " then
            -- Espaços.
            if wrap_mode == "WORD" then
                flushWord()
            end

            -- Calcula a largura baseada no objeto.
            local space_width = self:_getCharacterWidth(character)

            if wrap_mode == "ARBITRARY" and (current_line_width + space_width > max_width) and (#current_line.characters > 0) then
                lines[#lines + 1] = current_line
                current_line = { characters = {} }
                current_line_width = 0
            end

            current_line.characters[#current_line.characters + 1] = character
            current_line_width = current_line_width + space_width
        else
            -- Letras e símbolos comuns.
            local char_width = self:_getCharacterWidth(character)

            if wrap_mode == "WORD" then
                current_word[#current_word + 1] = character
                current_word_width = current_word_width + char_width
            else
                if wrap_mode == "ARBITRARY" and (current_line_width + char_width > max_width) and (#current_line.characters > 0) then
                    lines[#lines + 1] = current_line
                    current_line = { characters = {} }
                    current_line_width = 0
                end

                current_line.characters[#current_line.characters + 1] = character
                current_line_width = current_line_width + char_width
            end
        end
    end

    -- Processa qualquer palavra que tenha ficado presa no buffer.
    flushWord()
    lines[#lines + 1] = current_line

    self._text_lines = lines
end

--- Analisa todos os caracteres em `characters` e os modifica para atender a formatação do BBCode. Retorna
--- uma tabela com todos os caracteres formatados.
--- @private
--- @param characters NodeUI.TextBlock.Character[]
--- @return NodeUI.TextBlock.Character[]
function TextBlock:_parseBBCode(characters)
    --- Retorna a tag do colchete "[", se está aberta e o final delay.
    --- @nodiscard
    --- @return string tag
    --- @return boolean opened
    --- @return number tag_end
    --- @return string tag_value
    local function getTag(start_char)
        local tag = ""
        local opened = true

        local i = start_char + 1
        while i <= #characters do
            local char = characters[i].text

            if char == " " then
                break
            elseif i == start_char + 1 and char == "/" then
                opened = false
            elseif char == "]" then
                local tag_key, tag_value = tag:match("^([^%s=]+)=([^%s]+)$")
                return tag_key or tag, opened, i, tag_value or ""
            else
                tag = tag .. char
            end

            i = i + 1
        end

        return "", false, 0, ""
    end

    --- Retorna `true` se o point de unicode for válido.
    --- @nodiscard
    --- @param codepoint number
    --- @return boolean is_valid
    local function isValidUnicode(codepoint)
        return codepoint >= 0
            and codepoint <= 0x10FFFF
            and not (codepoint >= 0xD800 and codepoint <= 0xDFFF)
    end

    --- Retorna se o arquivo em path é uma imagem.
    --- @nodiscard
    --- @param path string
    --- @return boolean is_image
    local function isImage(path)
        return pcall(love.image.newImageData, path)
    end

    --- Converte um código hexadecimal em RGBA.
    --- @nodiscard
    --- @param hex string
    --- @return number? r, number? g, number? b, number? a
    local function hexToRGBA(hex)
        if type(hex) ~= "string" then
            return nil, nil, nil, nil
        end

        hex = hex:gsub("^#", "")

        if not hex:match("^[%x]+$") then
            return nil, nil, nil, nil
        end

        if #hex ~= 6 and #hex ~= 8 then
            return nil, nil, nil, nil
        end

        local r = tonumber(hex:sub(1, 2), 16)
        local g = tonumber(hex:sub(3, 4), 16)
        local b = tonumber(hex:sub(5, 6), 16)
        local a = #hex == 8 and tonumber(hex:sub(7, 8), 16) or 255

        return r / 255, g / 255, b / 255, a / 255
    end

    local parsed_characters = {} --- @type NodeUI.TextBlock.Character[]

    -- STATES
    local is_bold = false
    local is_italic = false
    local is_underline = false
    local is_strikethrough = false
    local is_code = false
    local active_url         --- @type string?
    local active_colors = {} --- @type {color: number[]?, bgcolor: number[]?, fgcolor: number[]?}
    local used_images = {}   --- @type table<string, love.Image>

    local i = 1
    while i <= #characters do
        local char = characters[i]

        if char.text == "[" then
            local tag, opened, tag_end, tag_value = getTag(i)
            local valid = false

            if tag == "b" then
                is_bold = opened
                valid = true
            elseif tag == "i" then
                is_italic = opened
                valid = true
            elseif tag == "u" then
                is_underline = opened
                valid = true
            elseif tag == "s" then
                is_strikethrough = opened
                valid = true
            elseif tag == "code" then
                is_code = opened
                valid = true
            elseif tag == "char" then
                local point = tonumber(tag_value)
                if point and isValidUnicode(point) then
                    char.text = utf8.char(point)
                    parsed_characters[#parsed_characters + 1] = char
                end
                valid = true
            elseif tag == "br" then
                parsed_characters[#parsed_characters + 1] = {
                    text = "",
                    variant = "NORMAL",
                    visible = char.visible
                }
                parsed_characters[#parsed_characters + 1] = {
                    text = "\n",
                    variant = "NORMAL",
                    visible = char.visible
                }
                valid = true
            elseif tag == "url" then
                if opened then
                    active_url = tag_value
                else
                    active_url = nil
                end
                valid = true
            elseif tag == "img" then
                if opened then
                    if isImage(tag_value) then
                        self._image_cache[tag_value] = self._image_cache[tag_value] or love.graphics.newImage(tag_value)
                        local image = self._image_cache[tag_value]

                        used_images[tag_value] = image

                        parsed_characters[#parsed_characters + 1] = {
                            text = "",
                            variant = "NORMAL",
                            visible = char.visible,
                            image = image,
                            url = active_url,
                            color = active_colors.color,
                            bgcolor = active_colors.bgcolor,
                            fgcolor = active_colors.fgcolor,
                        }
                    end
                end
                valid = true
            elseif tag == "color" or tag == "bgcolor" or tag == "fgcolor" then
                if opened then
                    local r, g, b, a = hexToRGBA(tag_value)
                    if r then
                        active_colors[tag] = { r, g, b, a }
                    end
                else
                    active_colors[tag] = nil
                end
                valid = true
            end

            if valid then
                i = tag_end + 1
                goto continue
            end
        end

        if is_code then
            char.variant = "MONO"
        elseif is_bold and is_italic then
            char.variant = "BOLD_ITALIC"
        elseif is_bold then
            char.variant = "BOLD"
        elseif is_italic then
            char.variant = "ITALIC"
        end

        char.underline = is_underline
        char.strikethrough = is_strikethrough
        char.url = active_url
        char.color = active_colors.color
        char.bgcolor = active_colors.bgcolor
        char.fgcolor = active_colors.fgcolor

        parsed_characters[#parsed_characters + 1] = char
        i = i + 1

        ::continue::
    end

    self._image_cache = used_images

    return parsed_characters
end

--- Atualiza o canvas do texto para corresponder ao tamanho do texto.
--- @private
function TextBlock:_updateTextCanvas()
    local text_width = 0
    local text_height = 0

    for _, line in ipairs(self._text_lines) do
        text_width = math.max(text_width, self:_getLineWidth(line))
        text_height = text_height + self:_getLineHeight(line)
    end

    local safe_size = self:_getSafeSize()
    text_width = text_width + safe_size
    text_height = text_height + safe_size

    if (
            not self._text_canvas
            or self._text_canvas:getWidth() < text_width
            or self._text_canvas:getHeight() < text_height
        ) then
        self._text_canvas = love.graphics.newCanvas(
            self._layout_width + safe_size,
            self._layout_height + safe_size
        )
    end
end

--#endregion


--#region Private Getter

--- Retorna o comprimento de um **NodeUI.TextBlock.Character**.
--- @nodiscard
--- @private
--- @param character NodeUI.TextBlock.Character
--- @return number width
function TextBlock:_getCharacterWidth(character)
    if character.image then
        return character.image:getWidth()
    else
        return self._text_settings:getFont(character.variant):getWidth(character.text)
    end
end

--- Retorna a altura de um **NodeUI.TextBlock.Character**.
--- @nodiscard
--- @private
--- @param character NodeUI.TextBlock.Character
--- @param ignore_image? boolean
--- @param ignore_separation? boolean
--- @return number height
function TextBlock:_getCharacterHeight(character, ignore_image, ignore_separation)
    local line_separation = ignore_separation and 0 or self._text_settings:getLineSeparation()

    if character.image and not ignore_image then
        return character.image:getHeight() / 2 + line_separation
    else
        return self._text_settings:getFont(character.variant):getHeight() + line_separation
    end
end

--- Retorna o comprimento de uma **NodeUI.TextBlock.Line**.
--- @nodiscard
--- @private
--- @param line NodeUI.TextBlock.Line
--- @return number width
function TextBlock:_getLineWidth(line)
    local width = 0

    for _, charater in ipairs(line.characters) do
        width = width + self:_getCharacterWidth(charater)
    end

    return width
end

--- Retorna a altura de uma **NodeUI.TextBlock.Line**.
--- @nodiscard
--- @private
--- @param line NodeUI.TextBlock.Line
--- @param ignore_images? boolean
--- @param ignore_separation? boolean
--- @return number height
function TextBlock:_getLineHeight(line, ignore_images, ignore_separation)
    local max_height = 0

    for _, character in ipairs(line.characters) do
        max_height = math.max(max_height, self:_getCharacterHeight(character, ignore_images, ignore_separation))
    end

    return max_height
end

--- Retorna a área segura do texto.
--- @nodiscard
--- @private
--- @return number
function TextBlock:_getSafeSize()
    local max_image_size = 0
    for _, image in pairs(self._image_cache) do
        max_image_size = math.max(max_image_size, image:getDimensions())
    end

    return math.max(
        max_image_size,
        self._text_settings:getFontSize("NORMAL"),
        self._text_settings:getFontSize("BOLD"),
        self._text_settings:getFontSize("ITALIC"),
        self._text_settings:getFontSize("BOLD_ITALIC")
    ) * 2
end

--- Retorna a posição de desenho do `_text_canvas`.
--- @nodiscard
--- @private
--- @return number x
--- @return number y
function TextBlock:_getTextCanvasPosition()
    local safe_size = self:_getSafeSize()
    return math.floor(self._layout_x - safe_size / 2), math.floor(self._layout_y - safe_size / 2)
end

--- Retorna a altura de imagem da `line`.
--- @nodiscard
--- @private
--- @param line NodeUI.TextBlock.Line
--- @return number height
function TextBlock:_getLineImageHeight(line)
    local line_height = self:_getLineHeight(line, true, true)
    local height = 0

    if #self._text_lines > 0 then
        for _, character in ipairs(self._text_lines[1].characters) do
            if character.image then
                height = math.max(height, self:_getCharacterHeight(character, false, true))
            end
        end
    end

    return height < line_height and 0 or height
end

--#endregion


--#region Signal Callback

--- Chamado quando a `_text_settings` é alterada.
--- @private
function TextBlock:_onTextSettingsChanged()
    self:_queueParseText()
end

--#endregion


return TextBlock
