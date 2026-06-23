# Control

(node_ui_control_alignment_mode)=
## NodeUI.Control.AlignmentMode

Modo de alinhamento de algum elemento.

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
```

---

(node_ui_control_axis)=
## NodeUI.Control.Axis

Eixo horizontal ou vertical.

```{list-table}
:header-rows: 1
:widths: 20 100
* - Valor
  - Descrição
* - `HORIZONTAL`
  - 
* - `VERTICAL`
  - 
```

---

(node_ui_control_corner)=
## NodeUI.Control.Corner

Representa os cantos de um retângulo.

```{list-table}
:header-rows: 1
:widths: 20 100
* - Valor
  - Descrição
* - `TOP_LEFT`
  - 
* - `TOP_RIGHT`
  - 
* - `BOTTOM_LEFT`
  - 
* - `BOTTOM_RIGHT`
  - 
```

---

(node_ui_control_direction)=
## NodeUI.Control.Direction

Representa as principais direções.

```{list-table}
:header-rows: 1
:widths: 20 100
* - Valor
  - Descrição
* - `LEFT`
  - 
* - `RIGHT`
  - 
* - `UP`
  - 
* - `DOWN`
  - 
```

---

(node_ui_control_layout)=
## NodeUI.Control.Layout

Representa os modos de layout disponíveis para posicionamento de um {ref}`Control <node_ui_control>`.

O layout define como o **Control** é posicionado e redimensionado dentro do
retângulo base do pai (ou da raiz quando não há pai).

```{list-table}
:header-rows: 1
:widths: 20 100
* - Valor
  - Descrição
* - `TOP_LEFT`
  - 
* - `TOP_RIGHT`
  - 
* - `BOTTOM_LEFT`
  - 
* - `BOTTOM_RIGHT`
  - 
* - `CENTER_LEFT`
  - 
* - `CENTER_RIGHT`
  - 
* - `CENTER_TOP`
  - 
* - `CENTER_BOTTOM`
  - 
* - `CENTER`
  - 
* - `LEFT_WIDE`
  - 
* - `RIGHT_WIDE`
  - 
* - `TOP_WIDE`
  - 
* - `BOTTOM_WIDE`
  - 
* - `VCENTER_WIDE`
  - 
* - `HCENTER_WIDE`
  - 
* - `HEXPAND`
  - 
* - `VEXPAND`
  - 
* - `EXPAND`
  - 
* - `FULL_RECT`
  - 
* - `CUSTOM`
  - 
```

---

(node_ui_control_mouse_filter)=
## NodeUI.Control.MouseFilter

Define como eventos de mouse são propagados para o {ref}`Control <node_ui_control>`.

```{list-table}
:header-rows: 1
:widths: 20 100
* - Valor
  - Descrição
* - `STOP`
  - Consome o evento e impede propagação.
* - `PASS`
  - Permite propagação após processar o evento.
* - `IGNORE`
  - Ignora o evento completamente.
```

---

(node_ui_control_side)=
## NodeUI.Control.Side

Representa os lados de um retângulo.

```{list-table}
:header-rows: 1
:widths: 20 100
* - Valor
  - Descrição
* - `LEFT`
  - 
* - `RIGHT`
  - 
* - `TOP`
  - 
* - `BOTTOM`
  - 
```

---

(node_ui_control_signals)=
## NodeUI.Control.Signals

Lista de sinais emitidos por um {ref}`Control <node_ui_control>`.

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

(node_ui_control_size_flags)=
## NodeUI.Control.SizeFlags

Define como o {ref}`Control <node_ui_control>` ocupa o espaço disponível em um {ref}`Container <node_ui_container>`.

```{list-table}
:header-rows: 1
:widths: 20 100
* - Valor
  - Descrição
* - `FILL`
  - Expande para preencher todo o espaço disponível.
* - `EXPAND`
  - Expande para preencher o espaço disponíveis divido entre outros **Control** que também expandem.
* - `SHRINK_BEGIN`
  - Mantém o tamanho mínimo e alinha no início.
* - `SHRINK_CENTER`
  - Mantém o tamanho mínimo e centraliza.
* - `SHRINK_END`
  - Mantém o tamanho mínimo e alinha no fim.
```

---

