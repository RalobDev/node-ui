(node_ui_center_container)=

# CenterContainer

**Inherits:** {ref}`NodeUI.Container <node_ui_container>` **→** {ref}`NodeUI.Control <node_ui_control>`

O **CenterContainer** centraliza seus filhos.

## Descrição

A centralização dos filhos pode acontecer no centro do próprio **CenterContainer** ou no seu canto superior esquerdo.
Para alterar entre os dois modos use {ref}`NodeUI.CenterContainer:setUseTopLeft() <center_container_set_use_top_left>`.

## Métodos

```{list-table}
:header-rows: 1
:widths: 10 100

* - Tipo
  - Nome
* - `nil`
  - {ref}`connect <center_container_connect>`
* - `nil`
  - {ref}`disconnect <center_container_disconnect>`
* - `boolean`
  - {ref}`getUseTopLeft <center_container_get_use_top_left>`
* - `NodeUI.CenterContainer`
  - {ref}`new <center_container_new>`
* - `nil`
  - {ref}`setUseTopLeft <center_container_set_use_top_left>`
```

## Descrição dos Métodos

(center_container_connect)=
### **<span style='font-family: monospace;'>connect()</span>**

Cria uma conexão em determinado {ref}`NodeUI.CenterContainer.Signals <node_ui_center_container_signals>` do **CenterContainer**.

```lua
CenterContainer:connect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.CenterContainer.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table`
  - Objeto dono do método.
```

---

(center_container_disconnect)=
### **<span style='font-family: monospace;'>disconnect()</span>**

Remove a conexão de um {ref}`NodeUI.CenterContainer.Signals <node_ui_center_container_signals>` do **CenterContainer**.

```lua
CenterContainer:disconnect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.CenterContainer.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table?`
  - Objeto dono do método.
```

---

(center_container_get_use_top_left)=
### **<span style='font-family: monospace;'>getUseTopLeft()</span>**

Retorna se o **CenterContainer** centraliza os seus filhos no topo esquerdo ou não.

```lua
use_top_left = CenterContainer:getUseTopLeft()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - use_top_left
  - `boolean`
  - Se a centralização no topo esquerdo está ativada.
```

---

(center_container_new)=
### **<span style='font-family: monospace;'>new()</span>**

Cria um novo **CenterContainer**.

```lua
CenterContainer = CenterContainer:new(x, y, width, height)
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
* - CenterContainer
  - `NodeUI.CenterContainer`
  - Novo **CenterContainer**.
```

---

(center_container_set_use_top_left)=
### **<span style='font-family: monospace;'>setUseTopLeft()</span>**

Define se o **CenterContainer** deve centralizar os seus filhos no topo esquerdo ou não. Por padrão ativa a centralização
no topo esquerdo.

```lua
CenterContainer:setUseTopLeft(enabled)
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
  - Se é para ativar a centralização no topo esquerdo.
```

---

