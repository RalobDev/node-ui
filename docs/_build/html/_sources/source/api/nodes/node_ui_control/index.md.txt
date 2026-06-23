(node_ui_control)=

# Control

**Inherited By:** {ref}`NodeUI.AspectRatioContainer <node_ui_aspect_ratio_container>` **→** {ref}`NodeUI.BoxContainer <node_ui_box_container>` **→** {ref}`NodeUI.CenterContainer <node_ui_center_container>` **→** {ref}`NodeUI.Container <node_ui_container>` **→** {ref}`NodeUI.FlowContainer <node_ui_flow_container>` **→** {ref}`NodeUI.GridContainer <node_ui_grid_container>` **→** {ref}`NodeUI.MarginContainer <node_ui_margin_container>`

O **Control** é a classe base de todos os elementos da interface do **`NodeUI`**. Ela fornece funcionalidades fundamentais
como hierarquia de nós, sistema de layout, renderização, processamento de eventos de entrada e gerenciamento de sinais.

## Descrição

O **Control** representa um elemento visual da interface e serve como base para todos os controles da biblioteca.
Cada controle pode possuir um pai e múltiplos filhos, formando uma árvore de UI organizada hierarquicamente.

A classe permite posicionar e dimensionar controles em relação ao seu pai ou à área base da interface. Além disso,
gerencia visibilidade, foco do mouse, renderização, atualização, clipping de conteúdo e propagação de eventos de entrada.

## Métodos

```{list-table}
:header-rows: 1
:widths: 10 100

* - Tipo
  - Nome
* - `control`
  - {ref}`addChild <control_add_child>`
* - `nil`
  - {ref}`connect <control_connect>`
* - `nil`
  - {ref}`disconnect <control_disconnect>`
* - `number`, `number`
  - {ref}`getBaseDimensions <control_get_base_dimensions>`
* - `number`
  - {ref}`getBaseHeight <control_get_base_height>`
* - `number`
  - {ref}`getBaseWidth <control_get_base_width>`
* - `NodeUI.Control[]`
  - {ref}`getChildren <control_get_children>`
* - `boolean`
  - {ref}`getClipContent <control_get_clip_content>`
* - `number`, `number`
  - {ref}`getDimensions <control_get_dimensions>`
* - `number`
  - {ref}`getHeight <control_get_height>`
* - `NodeUI.Control.Layout`
  - {ref}`getLayout <control_get_layout>`
* - `number`, `number`
  - {ref}`getMinimumDimensions <control_get_minimum_dimensions>`
* - `number`
  - {ref}`getMinimumHeight <control_get_minimum_height>`
* - `number`
  - {ref}`getMinimumWidth <control_get_minimum_width>`
* - `NodeUI.Control.MouseFilter`
  - {ref}`getMouseFilter <control_get_mouse_filter>`
* - `NodeUI.Control?`
  - {ref}`getParent <control_get_parent>`
* - `number`, `number`
  - {ref}`getPosition <control_get_position>`
* - `NodeUI.Control.SizeFlags`
  - {ref}`getSizeFlags <control_get_size_flags>`
* - `number`
  - {ref}`getWidth <control_get_width>`
* - `number`
  - {ref}`getX <control_get_x>`
* - `number`
  - {ref}`getY <control_get_y>`
* - `boolean`
  - {ref}`hasMouseFocus <control_has_mouse_focus>`
* - `boolean`
  - {ref}`isQueuedForDeletion <control_is_queued_for_deletion>`
* - `boolean`
  - {ref}`isVisible <control_is_visible>`
* - `NodeUI.Control`
  - {ref}`new <control_new>`
* - `nil`
  - {ref}`queueFree <control_queue_free>`
* - `nil`
  - {ref}`removeChild <control_remove_child>`
* - `nil`
  - {ref}`setClipContent <control_set_clip_content>`
* - `nil`
  - {ref}`setDimensions <control_set_dimensions>`
* - `nil`
  - {ref}`setHeight <control_set_height>`
* - `nil`
  - {ref}`setLayout <control_set_layout>`
* - `nil`
  - {ref}`setMinimumDimensions <control_set_minimum_dimensions>`
* - `nil`
  - {ref}`setMinimumHeight <control_set_minimum_height>`
* - `nil`
  - {ref}`setMinimumWidth <control_set_minimum_width>`
* - `nil`
  - {ref}`setMouseFilter <control_set_mouse_filter>`
* - `nil`
  - {ref}`setPosition <control_set_position>`
* - `nil`
  - {ref}`setSizeFlags <control_set_size_flags>`
* - `nil`
  - {ref}`setVisible <control_set_visible>`
* - `nil`
  - {ref}`setWidth <control_set_width>`
* - `nil`
  - {ref}`setX <control_set_x>`
* - `nil`
  - {ref}`setY <control_set_y>`
```

## Descrição dos Métodos

(control_add_child)=
### **<span style='font-family: monospace;'>addChild()</span>**

Adiciona um filho ao **Control**. O filho adicionado é retornado, simplificando a criação e
referência de filhos.

```lua
child = Control:addChild(child, is_internal)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - child
  - `control`
  - **Control** filho.
* - is_internal
  - `boolean`
  - Se `true`, o filho é marcado como interno do **Control**.
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - child
  - `control`
  - Filho que foi adicionado.
```

---

(control_connect)=
### **<span style='font-family: monospace;'>connect()</span>**

Cria uma conexão em determinado **`NodeUI.Control.Signals** do **Control**.

O `owner` é a tabela que possui o `method`, que deve ser uma `string`. Caso não seja passado um `owner`, o `method`
deve ser uma `function`.

Quando é passado um `owner` o método é chamado desta forma: `owner.method(owner, ...)` para respeitar o padrão `self`.

```lua
Control:connect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.Control.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table?`
  - Objeto dono do método.
```

---

(control_disconnect)=
### **<span style='font-family: monospace;'>disconnect()</span>**

Remove a conexão de um {ref}`NodeUI.Control.Signals <node_ui_control_signals>` do **Control**.

```lua
Control:disconnect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.Control.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table?`
  - Objeto dono do método.
```

---

(control_get_base_dimensions)=
### **<span style='font-family: monospace;'>getBaseDimensions()</span>**

Retorna a dimensão base do **Control**. É a dimensão definida ao criar o **Control** e ao chamar
{ref}`Control:setDimensions() <control_set_dimensions>`.

```lua
width ,height = Control:getBaseDimensions()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - width
  - `number`
  - Comprimento base.
* - height
  - `number`
  - Altura base.
```

---

(control_get_base_height)=
### **<span style='font-family: monospace;'>getBaseHeight()</span>**

Retorna a altura base do **Control**. É a altura definida ao criar o **Control** e ao chamar
{ref}`Control:setHeight() <control_set_height>`.

```lua
height = Control:getBaseHeight()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - height
  - `number`
  - Altura base.
```

---

(control_get_base_width)=
### **<span style='font-family: monospace;'>getBaseWidth()</span>**

Retorna o comprimento base do **Control**. É o comprimento definido ao criar o **Control** e ao chamar
{ref}`Control:setWidth() <control_set_width>`.

```lua
width = Control:getBaseWidth()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - width
  - `number`
  - Comprimento base.
```

---

(control_get_children)=
### **<span style='font-family: monospace;'>getChildren()</span>**

Retorna uma tabela com todos os filhos do **Control**.

```lua
children = Control:getChildren(include_internal)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - include_internal
  - `boolean`
  - Se `true`, retorna os filhos internos também.
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - children
  - `NodeUI.Control[]`
  - Filhos do **Control**.
```

---

(control_get_clip_content)=
### **<span style='font-family: monospace;'>getClipContent()</span>**

Retorna se o recorte de conteúdo do **Control** está ativado.

```lua
clip_content = Control:getClipContent()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - clip_content
  - `boolean`
  - Se o recorte de conteúdo está ativo.
```

---

(control_get_dimensions)=
### **<span style='font-family: monospace;'>getDimensions()</span>**

Retorna a dimensão do **Control**.

```lua
width ,height = Control:getDimensions()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - width
  - `number`
  - Comprimento do **Control**.
* - height
  - `number`
  - Altura do **Control**.
```

---

(control_get_height)=
### **<span style='font-family: monospace;'>getHeight()</span>**

Retorna a altura do **Control**.

```lua
height = Control:getHeight()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - height
  - `number`
  - Altura do **Control**.
```

---

(control_get_layout)=
### **<span style='font-family: monospace;'>getLayout()</span>**

Retorna o {ref}`NodeUI.Control.Layout <node_ui_control_layout>` do **Control**.

```lua
layout = Control:getLayout()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - layout
  - `NodeUI.Control.Layout`
  - Layout do **Control**.
```

---

(control_get_minimum_dimensions)=
### **<span style='font-family: monospace;'>getMinimumDimensions()</span>**

Retorna a dimensão mínima do **Control**.

```lua
width ,height = Control:getMinimumDimensions()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - width
  - `number`
  - Comprimento mínimo do **Control**.
* - height
  - `number`
  - Altura mínima do **Control**.
```

---

(control_get_minimum_height)=
### **<span style='font-family: monospace;'>getMinimumHeight()</span>**

Retorna a altura mínima do **Control**.

```lua
height = Control:getMinimumHeight()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - height
  - `number`
  - Altura mínima do **Control**.
```

---

(control_get_minimum_width)=
### **<span style='font-family: monospace;'>getMinimumWidth()</span>**

Retorna o comprimento mínimo do **Control**.

```lua
width = Control:getMinimumWidth()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - width
  - `number`
  - Comprimento mínimo do **Control**.
```

---

(control_get_mouse_filter)=
### **<span style='font-family: monospace;'>getMouseFilter()</span>**

Retorna o {ref}`NodeUI.Control.MouseFilter <node_ui_control_mouse_filter>` do **Control**.

```lua
mouse_filter = Control:getMouseFilter()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - mouse_filter
  - `NodeUI.Control.MouseFilter`
  - Filtro do mouse.
```

---

(control_get_parent)=
### **<span style='font-family: monospace;'>getParent()</span>**

Retorna o parente do **Control** ou `nil` caso ela não tenha um.

```lua
parent = Control:getParent()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - parent
  - `NodeUI.Control?`
  - Parente do **Control**.
```

---

(control_get_position)=
### **<span style='font-family: monospace;'>getPosition()</span>**

Retorna a posição do **Control**.

```lua
x ,y = Control:getPosition()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - x
  - `number`
  - Posição x.
* - y
  - `number`
  - Posição y.
```

---

(control_get_size_flags)=
### **<span style='font-family: monospace;'>getSizeFlags()</span>**

Retorna a {ref}`NodeUI.Control.SizeFlags <node_ui_control_size_flags>` do `axis`. Ela afeta a maneira como o **Control**
se comporta em um {ref}`Container <node_ui_container>`.

```lua
size_flags = Control:getSizeFlags(axis)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - axis
  - `NodeUI.Control.Axis`
  - Eixo da size flags.
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - size_flags
  - `NodeUI.Control.SizeFlags`
  - Size flags aplicada ao `axis`.
```

---

(control_get_width)=
### **<span style='font-family: monospace;'>getWidth()</span>**

Retorna o comprimento do **Control**.

```lua
width = Control:getWidth()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - width
  - `number`
  - Comprimento do **Control**.
```

---

(control_get_x)=
### **<span style='font-family: monospace;'>getX()</span>**

Retorna a posição x do **Control**.

```lua
x = Control:getX()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - x
  - `number`
  - Posição x.
```

---

(control_get_y)=
### **<span style='font-family: monospace;'>getY()</span>**

Retorna a posição y do **Control**.

```lua
y = Control:getY()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - y
  - `number`
  - Posição y.
```

---

(control_has_mouse_focus)=
### **<span style='font-family: monospace;'>hasMouseFocus()</span>**

Retorna se o **Control** possui o foco do mouse.

```lua
focused = Control:hasMouseFocus()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - focused
  - `boolean`
  - Se o **Control** possui o foco do mouse.
```

---

(control_is_queued_for_deletion)=
### **<span style='font-family: monospace;'>isQueuedForDeletion()</span>**

Retorna se o **Control** está na fila de deleção.

```lua
deletion = Control:isQueuedForDeletion()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - deletion
  - `boolean`
  - Se `true`, o **Control** está na fila de deleção.
```

---

(control_is_visible)=
### **<span style='font-family: monospace;'>isVisible()</span>**

Retorna se o **Control** está visível ou não.

```lua
visible = Control:isVisible()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - visible
  - `boolean`
  - Visibilidade do **Control**.
```

---

(control_new)=
### **<span style='font-family: monospace;'>new()</span>**

Cria um novo **Control**.

```lua
Control = Control:new(x, y, width, height)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - x
  - `number`
  - Posição horizontal.
* - y
  - `number`
  - Posição vertical.
* - width
  - `number`
  - Comprimento em pixels.
* - height
  - `number`
  - Altura em pixels.
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - Control
  - `NodeUI.Control`
  - Novo Control.
```

---

(control_queue_free)=
### **<span style='font-family: monospace;'>queueFree()</span>**

Marca para deletar o **Control** no próximo `love.update()`.

Os nós não são coletados pelo coletor de lixo do **Lua** ao ser definido com `nil`, pois
o próprio módulo **`NodeUI`** armazena uma referência deles. Assim é necessário chamar
`queueFree` quando quiser remover um nó da biblioteca.

Ao ser deletado o nó e seus filhos são removidos da raiz do **`NodeUI`**, mas quaisquer
referências fora do módulo continuarão existindo.

```lua
Control:queueFree()
```

---

(control_remove_child)=
### **<span style='font-family: monospace;'>removeChild()</span>**

Remove o `child` do **Control**.

```lua
Control:removeChild(child)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - child
  - `NodeUI.Control`
  - Filho a ser removido.
```

---

(control_set_clip_content)=
### **<span style='font-family: monospace;'>setClipContent()</span>**

Define o recorte de conteúdo do **Control**. Se `true`, clipa o desenho dos filhos à área do **Control**.
Por padrão ativa o recorte de conteúdo.

```lua
Control:setClipContent()
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - 
  - ``
  - enabled? boolean
```

---

(control_set_dimensions)=
### **<span style='font-family: monospace;'>setDimensions()</span>**

Define a dimensão do **Control**.

```lua
Control:setDimensions(width, height)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - width
  - `number`
  - Novo comprimento.
* - height
  - `number`
  - Nova altura.
```

---

(control_set_height)=
### **<span style='font-family: monospace;'>setHeight()</span>**

Define a altura do **Control**.

```lua
Control:setHeight(height)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - height
  - `number`
  - Nova altura.
```

---

(control_set_layout)=
### **<span style='font-family: monospace;'>setLayout()</span>**

Define o {ref}`NodeUI.Control.Layout <node_ui_control_layout>` do **Control**.

```lua
Control:setLayout(layout)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - layout
  - `NodeUI.Control.Layout`
  - Novo layout.
```

---

(control_set_minimum_dimensions)=
### **<span style='font-family: monospace;'>setMinimumDimensions()</span>**

Define a dimensão mínima do **Control**.

```lua
Control:setMinimumDimensions(width, height)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - width
  - `number`
  - Novo comprimento mínimo.
* - height
  - `number`
  - Nova altura mínima.
```

---

(control_set_minimum_height)=
### **<span style='font-family: monospace;'>setMinimumHeight()</span>**

Define a altura mínima do **Control**.

```lua
Control:setMinimumHeight(height)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - height
  - `number`
  - Nova altura mínima.
```

---

(control_set_minimum_width)=
### **<span style='font-family: monospace;'>setMinimumWidth()</span>**

Define o comprimento mínimo do **Control**.

```lua
Control:setMinimumWidth(width)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - width
  - `number`
  - Novo comprimento mínimo.
```

---

(control_set_mouse_filter)=
### **<span style='font-family: monospace;'>setMouseFilter()</span>**

Define o {ref}`NodeUI.Control.MouseFilter <node_ui_control_mouse_filter>` do **Control**.

```lua
Control:setMouseFilter(filter)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - filter
  - `NodeUI.Control.MouseFilter`
  - Filtro do mouse.
```

---

(control_set_position)=
### **<span style='font-family: monospace;'>setPosition()</span>**

Define a posição do **Control**

```lua
Control:setPosition(x, y)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - x
  - `number`
  - Nova posição x.
* - y
  - `number`
  - Nova posição y.
```

---

(control_set_size_flags)=
### **<span style='font-family: monospace;'>setSizeFlags()</span>**

Define a {ref}`NodeUI.Control.SizeFlags <node_ui_control_size_flags>` do `axis`. Ela afeta a maneira como o **Control**
se comporta em um {ref}`Container <node_ui_container>`.

```lua
Control:setSizeFlags(axis, size_flags)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - axis
  - `NodeUI.Control.Axis`
  - Eixo da size flags.
* - size_flags
  - `NodeUI.Control.SizeFlags`
  - Size flags aplicada ao `axis`.
```

---

(control_set_visible)=
### **<span style='font-family: monospace;'>setVisible()</span>**

Define a visibilidade do **Control**. Por padrão ativa a visibilidade.

```lua
Control:setVisible(enabled)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - enabled
  - `boolean`
  - Se `true`, ativa a visibilidade.
```

---

(control_set_width)=
### **<span style='font-family: monospace;'>setWidth()</span>**

Define o comprimento do **Control**.

```lua
Control:setWidth(width)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - width
  - `number`
  - Novo comprimento.
```

---

(control_set_x)=
### **<span style='font-family: monospace;'>setX()</span>**

Define a posição horizontal do **Control**

```lua
Control:setX(value)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - value
  - `number`
  - Nova posição x.
```

---

(control_set_y)=
### **<span style='font-family: monospace;'>setY()</span>**

Define a posição vertical do **Control**

```lua
Control:setY(value)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - value
  - `number`
  - Nova posição y.
```

---

