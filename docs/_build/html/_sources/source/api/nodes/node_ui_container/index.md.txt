(node_ui_container)=

# Container

**Inherits:** {ref}`NodeUI.Control <node_ui_control>`

**Inherited By:** {ref}`NodeUI.AspectRatioContainer <node_ui_aspect_ratio_container>` **→** {ref}`NodeUI.BoxContainer <node_ui_box_container>` **→** {ref}`NodeUI.CenterContainer <node_ui_center_container>` **→** {ref}`NodeUI.FlowContainer <node_ui_flow_container>` **→** {ref}`NodeUI.GridContainer <node_ui_grid_container>` **→** {ref}`NodeUI.MarginContainer <node_ui_margin_container>`

**Container** é um tipo de {ref}`Control <node_ui_control>` responsável por agrupar outros nós e gerenciar
o layout e atualização dos seus filhos dentro da hierarquia do **`NodeUI`**.

## Descrição

O **Container** estende {ref}`Control <node_ui_control>` adicionando suporte a organização de filhos e
controle de layout.

## Métodos

```{list-table}
:header-rows: 1
:widths: 10 100

* - Tipo
  - Nome
* - `nil`
  - {ref}`connect <container_connect>`
* - `nil`
  - {ref}`disconnect <container_disconnect>`
* - `NodeUI.Container`
  - {ref}`new <container_new>`
* - `nil`
  - {ref}`setHeight <container_set_height>`
* - `nil`
  - {ref}`setWidth <container_set_width>`
```

## Descrição dos Métodos

(container_connect)=
### **<span style='font-family: monospace;'>connect()</span>**

Cria uma conexão em determinado {ref}`NodeUI.Container.Signals <node_ui_container_signals>` do **Container**.

```lua
Container:connect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.Container.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table`
  - Objeto dono do método.
```

---

(container_disconnect)=
### **<span style='font-family: monospace;'>disconnect()</span>**

Remove a conexão de um {ref}`NodeUI.Container.Signals <node_ui_container_signals>` do **Container**.

```lua
Container:disconnect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.Container.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table?`
  - Objeto dono do método.
```

---

(container_new)=
### **<span style='font-family: monospace;'>new()</span>**

Cria um novo **Container**.

```lua
Container = Container:new(x, y, width, height)
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
* - Container
  - `NodeUI.Container`
  - Novo **Container**.
```

---

(container_set_height)=
### **<span style='font-family: monospace;'>setHeight()</span>**

Define a altura do **Container**.

```lua
Container:setHeight(height)
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

(container_set_width)=
### **<span style='font-family: monospace;'>setWidth()</span>**

Define o comprimento do **Container**.

```lua
Container:setWidth(width)
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

