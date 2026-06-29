--- Representa os modos de layout disponíveis para posicionamento de um **`Control`**.
---
--- O layout define como o **Control** é posicionado e redimensionado dentro do
--- retângulo base do pai (ou da raiz quando não há pai).
--- @alias NodeUI.Control.Layout
--- | "TOP_LEFT"
--- | "TOP_RIGHT"
--- | "BOTTOM_LEFT"
--- | "BOTTOM_RIGHT"
--- | "CENTER_LEFT"
--- | "CENTER_RIGHT"
--- | "CENTER_TOP"
--- | "CENTER_BOTTOM"
--- | "CENTER"
--- | "LEFT_WIDE"
--- | "RIGHT_WIDE"
--- | "TOP_WIDE"
--- | "BOTTOM_WIDE"
--- | "VCENTER_WIDE"
--- | "HCENTER_WIDE"
--- | "HEXPAND"
--- | "VEXPAND"
--- | "EXPAND"
--- | "FULL_RECT"
--- | "CUSTOM"

--- Define como eventos de mouse são propagados para o **`Control`**.
--- @alias NodeUI.Control.MouseFilter
--- | "STOP"   Consome o evento e impede propagação.
--- | "PASS"   Permite propagação após processar o evento.
--- | "IGNORE" Ignora o evento completamente.

--- Lista de sinais emitidos por um **`Control`**.
--- @alias NodeUI.Control.Signals
--- | "MOUSE_PRESSED"  Emitido quando um botão do mouse é pressionado. | `fun(x: number, y: number, button: number, istouch: bool, presses: int)`
--- | "MOUSE_RELEASED" Emitido quando um botão do mouse é solto. | `fun(x: number, y: number, button: number, istouch: bool, presses: int)`
--- | "MOUSE_MOVED"    Emitido quando o mouse se move sobre o Control. | `fun(x: number, y: number, dx: number, dy: number, istouch: bool)`
--- | "WHEEL_MOVED"    Emitido quando o scroll do mouse é usado. | `fun(x: number, y: number)`
--- | "CHANGED_HOVER"  Emitido quando o o estado de estar sob o cursor muda. | `fun(hovered: bool)`
--- | "CHILD_ADDED"    Emitido quando um filho é adicionado. | `fun(child: NodeUI.Control)`
--- | "CHILD_REMOVED"  Emitido quando um filho é removido. | `fun(child: NodeUI.Control)`
--- | "FOCUS_ENTERED"  Emitido quando recebe o foco. | `fun()`
--- | "FOCUS_EXITED"  Emitido quando perde o foco. | `fun()`

--- @alias NodeUI.Control.FocusMode
--- | "NONE"  O nó não consegue agarrar o foco.
--- | "CLICK" O nó apenas agarra o foco com o clique do mouse.
--- | "ALL"   O nó consegue agarrar o foco com o clique do mouse, setas, e tab.

--- @alias NodeUI.Control.FocusBehavior
--- | "INHERITED" Herda do parent. Se não tiver, é o mesmo que `ENABLED`.
--- | "DISABLED"  Evita que o nó seja focado.
--- | "ENABLED"   Permite que o nó seja focado a depenser do **`NodeUI.Control.FocusMode`**.

--- Modo de alinhamento de algum elemento.
--- @alias NodeUI.Control.AlignmentMode
--- | "BEGIN"  Alinhado ao início.
--- | "CENTER" Alinhado ao meio.
--- | "END"    Alinhado ao fim.

--- Eixo horizontal ou vertical.
--- @alias NodeUI.Control.Axis
--- | "BOTH"
--- | "HORIZONTAL"
--- | "VERTICAL"

--- Define como o **`Control`** ocupa o espaço disponível em um **`Container`**.
--- @alias NodeUI.Control.SizeFlags
--- | "FILL"          Expande para preencher todo o espaço disponível.
--- | "EXPAND"        Expande para preencher o espaço disponíveis divido entre outros **Control** que também expandem.
--- | "SHRINK_BEGIN"  Mantém o tamanho mínimo e alinha no início.
--- | "SHRINK_CENTER" Mantém o tamanho mínimo e centraliza.
--- | "SHRINK_END"    Mantém o tamanho mínimo e alinha no fim.

--- Representa os lados de um retângulo.
--- @alias NodeUI.Control.Side
--- | "ALL"
--- | "LEFT"
--- | "RIGHT"
--- | "TOP"
--- | "BOTTOM"

--- Representa as principais direções.
--- @alias NodeUI.Control.Direction
--- | "ALL"
--- | "LEFT"
--- | "RIGHT"
--- | "UP"
--- | "DOWN"

--- Representa os cantos de um retângulo.
--- @alias NodeUI.Control.Corner
--- | "ALL"
--- | "TOP_LEFT"
--- | "TOP_RIGHT"
--- | "BOTTOM_LEFT"
--- | "BOTTOM_RIGHT"
