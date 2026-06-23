# FlowContainer

(node_ui_flow_container_last_wrap_alignment_mode)=
## NodeUI.FlowContainer.LastWrapAlignmentMode

Maneira como as linhas ou colunas do {ref}`FlowContainer <node_ui_flow_container>` se alinham.

```{list-table}
:header-rows: 1
:widths: 20 100
* - Valor
  - Descrição
* - `BEGIN`
  - Alinhado ao início.
* - `CENTER`
  - Alinhado ao meio.
* - `END`
  - Alinhado ao fim.
* - `INHERIT`
  - Usa o alinhamento da última linha ou coluna.
```

---

(node_ui_flow_container_signals)=
## NodeUI.FlowContainer.Signals

Lista de sinais emitidos por um {ref}`FlowContainer <node_ui_flow_container>`.

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

