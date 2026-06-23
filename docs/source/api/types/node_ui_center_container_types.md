# CenterContainer

(node_ui_center_container_signals)=
## NodeUI.CenterContainer.Signals

Lista de sinais emitidos por um AspectRatioContainer.

```{list-table}
:header-rows: 1
:widths: 20 100
* - Valor
  - Descrição
* - `MOUSE_PRESSED`
  - Quando um botão do mouse é pressionado. | `fun(x: number, y: number, button: number, istouch: bool, presses: int)`
* - `MOUSE_RELEASED`
  - Quando um botão do mouse é solto. | `fun(x: number, y: number, button: number, istouch: bool, presses: int)`
* - `MOUSE_MOVED`
  - Quando o mouse se move sobre o Control. | `fun(x: number, y: number, dx: number, dy: number, istouch: bool)`
* - `WHEEL_MOVED`
  - Quando o scroll do mouse é usado. | `fun(x: number, y: number)`
* - `MOUSE_FOCUS_CHANGED`
  - Quando o foco de mouse entra ou sai. | `fun(focused: bool)`
* - `CHILD_ADDED`
  - Quando um filho é adicionado. | `fun(child: NodeUI.Control)`
* - `CHILD_REMOVED`
  - Quando um filho é removido. | `fun(child: NodeUI.Control)`
```

---

