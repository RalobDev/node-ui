--- Lista de sinais emitidos por uma **`Label`**.
--- @alias NodeUI.TextBlock.Signals
--- | NodeUI.Control.Signals


--- Maneira com as linhas se alinham.
--- @alias NodeUI.TextBlock.AlignmentMode
--- | NodeUI.Control.AlignmentMode
--- | "FILL" Expande as linhas para caber no comprimento ou altura.


--- Maneira com o texto do **`TextBlock`** é quebrado.
--- @alias NodeUI.TextBlock.AutowrapMode
--- | "OFF"       Quebra de texto desativada.
--- | "ARBITRARY" Quebra de texto por letra.
--- | "WORD"      Quebra de texto por palavra.


--- Maneira como os caracteres visíveis são exibidos.
--- @alias NodeUI.TextBlock.VisibleCharactersBehavior
--- | "LEFT_TO_RIGHT"
--- | "RIGHT_TO_LEFT"


--- Representa a linha de um texto.
--- @class NodeUI.TextBlock.Line
--- @field characters NodeUI.TextBlock.Character[]


--- Representa o caractere de um texto.
--- @class NodeUI.TextBlock.Character
--- @field text string
--- @field variant NodeUI.TextSettings.FontVariant
--- @field visible? boolean
--- @field underline? boolean
--- @field strikethrough? boolean
--- @field url? string
--- @field color? number[]
--- @field bgcolor? number[]
--- @field fgcolor? number[]
--- @field image? love.Image
