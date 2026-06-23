(node_ui_margin_container)=

# MarginContainer

**Inherits:** {ref}`NodeUI.Container <node_ui_container>` **→** {ref}`NodeUI.Control <node_ui_control>`

O **MarginContainer** permite criar uma margem ao redor dos filhos.

## Métodos

```{list-table}
:header-rows: 1
:widths: 10 100

* - Tipo
  - Nome
* - `nil`
  - {ref}`connect <margin_container_connect>`
* - `nil`
  - {ref}`disconnect <margin_container_disconnect>`
* - `number`
  - {ref}`getMargin <margin_container_get_margin>`
* - `NodeUI.MarginContainer`
  - {ref}`new <margin_container_new>`
* - `nil`
  - {ref}`setMargin <margin_container_set_margin>`
```

## Descrição dos Métodos

(margin_container_connect)=
### **<span style='font-family: monospace;'>connect()</span>**

Cria uma conexão em determinado {ref}`NodeUI.MarginContainer.Signals <node_ui_margin_container_signals>` do **MarginContainer**.

```lua
MarginContainer:connect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.MarginContainer.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table`
  - Objeto dono do método.
```

---

(margin_container_disconnect)=
### **<span style='font-family: monospace;'>disconnect()</span>**

Remove a conexão de um {ref}`NodeUI.MarginContainer.Signals <node_ui_margin_container_signals>` do **MarginContainer**.

```lua
MarginContainer:disconnect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.MarginContainer.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table?`
  - Objeto dono do método.
```

---

(margin_container_get_margin)=
### **<span style='font-family: monospace;'>getMargin()</span>**

Define a margem de um lado do **MarginContainer**.

```lua
margin = MarginContainer:getMargin(side)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - side
  - `NodeUI.Control.Side`
  - Lado da margem.
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - margin
  - `number`
  - Margem do lado.
```

---

(margin_container_new)=
### **<span style='font-family: monospace;'>new()</span>**

Cria um novo **MarginContainer**.

```lua
MarginContainer = MarginContainer:new(x, y, width, height)
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
* - MarginContainer
  - `NodeUI.MarginContainer`
  - Novo **MarginContainer**.
```

---

(margin_container_set_margin)=
### **<span style='font-family: monospace;'>setMargin()</span>**

Define a margem de um lado do **MarginContainer**.

```lua
MarginContainer:setMargin(side, margin)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - side
  - `NodeUI.Control.Side`
  - Lado da margem.
* - margin
  - `number`
  - Margem do lado.
```

---

