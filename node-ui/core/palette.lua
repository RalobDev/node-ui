--- Cores do **`NodeUI`**.
--- @class NodeUI.Palette
--- @field private _colors table<NodeUI.Palette.Colors, string>
local Palette = {
    _colors = {}
}

do
    Palette._colors["BACKGROUND"]    = "#1D171A"
    Palette._colors["SURFACE"]       = "#513948"
    Palette._colors["BORDER"]        = "#41343C"
    Palette._colors["SHADOW"]        = "#0A0507"
    Palette._colors["TEXT"]          = "#F9FAFB"
    Palette._colors["SUBTEXT"]       = "#A99BA6"
    Palette._colors["DISABLED_TEXT"] = "#6E5D67"
    Palette._colors["TEXT_OUTLINE"]  = "#120D10"
    Palette._colors["ACCENT"]        = "#D83177"
    Palette._colors["HOVER"]         = "#5c4752"
    Palette._colors["HOVER_PRESSED"] = "#7D3155"
    Palette._colors["PRESSED"]       = "#452b3a"
    Palette._colors["HIGHLIGHT"]     = "#FFD7A6"
    Palette._colors["DISABLED"]      = "#70616D"
end

--#region Public

--- Converte um código hexadecimal em RGBA.
--- @nodiscard
--- @param hex string
--- @return number r Red.
--- @return number g Green.
--- @return number b Blue.
--- @return number a Alpha.
function Palette:hexToRGBA(hex)
    if type(hex) ~= "string" then
        return 1, 1, 1, 1
    end

    hex = hex:gsub("^#", "")

    if not hex:match("^[%x]+$") then
        return 1, 1, 1, 1
    end

    if #hex ~= 6 and #hex ~= 8 then
        return 1, 1, 1, 1
    end

    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    local a = #hex == 8 and tonumber(hex:sub(7, 8), 16) or 255

    return r / 255, g / 255, b / 255, a / 255
end

--#endregion


--#region Getter

--- Retorna uma tabela com os componentes RGBA da **`NodeUI.Palette.Colors`**.
--- @nodiscard
--- @param color_key NodeUI.Palette.Colors Chave da cor.
--- @return number[] color                 Tabela com os valores da cor.
function Palette:get(color_key)
    return { self:hexToRGBA(self._colors[color_key]) }
end

--#endregion


return Palette
