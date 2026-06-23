# AspectRatioContainer

(node_ui_aspect_ratio_container_signals)=
## NodeUI.AspectRatioContainer.Signals

Lista de sinais emitidos por um {ref}`AspectRatioContainer <node_ui_aspect_ratio_container>`.

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

(node_ui_aspect_ratio_container_stretch_mode)=
## NodeUI.AspectRatioContainer.StretchMode

Maneira como os filhos do {ref}`AspectRatioContainer <node_ui_aspect_ratio_container>` são escalonados.

```{list-table}
:header-rows: 1
:widths: 20 100
* - Valor
  - Descrição
* - `STRETCH_WIDTH`
  - Escala para o comprimento.
* - `STRETCH_HEIGHT`
  - Escala para a altura.
* - `FIT`
  - Escala usando o menor fator entre largura e altura (sem overflow).
* - `COVER`
  - Escala usando o maior fator entre largura e altura (cobre toda área).
```

---

