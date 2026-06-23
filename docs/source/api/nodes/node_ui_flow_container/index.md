(node_ui_flow_container)=

# FlowContainer

**Inherits:** {ref}`NodeUI.Container <node_ui_container>` **→** {ref}`NodeUI.Control <node_ui_control>`

O **FlowContainer** Organiza os filhos horizontalmente e verticalmente em diferentes linhas ou colunas.

## Descrição

O **FlowContainer** quebra as linhas ou colunas de filhos para fazé-los caber na dimensão do **FlowContainer**,
mas o número de linhas ou colunas pode ultrapassar o tamanho do mesmo.

## Métodos

```{list-table}
:header-rows: 1
:widths: 10 100

* - Tipo
  - Nome
* - `nil`
  - {ref}`connect <flow_container_connect>`
* - `nil`
  - {ref}`disconnect <flow_container_disconnect>`
* - `NodeUI.Control.AlignmentMode`
  - {ref}`getAlignment <flow_container_get_alignment>`
* - `NodeUI.FlowContainer.LastWrapAlignmentMode`
  - {ref}`getLastWrapAlignment <flow_container_get_last_wrap_alignment>`
* - `number`
  - {ref}`getSeparation <flow_container_get_separation>`
* - `boolean`
  - {ref}`getVertical <flow_container_get_vertical>`
* - `NodeUI.FlowContainer`
  - {ref}`new <flow_container_new>`
* - `nil`
  - {ref}`setAlignment <flow_container_set_alignment>`
* - `nil`
  - {ref}`setLastWrapAlignment <flow_container_set_last_wrap_alignment>`
* - `nil`
  - {ref}`setSeparation <flow_container_set_separation>`
* - `nil`
  - {ref}`setVertical <flow_container_set_vertical>`
```

## Descrição dos Métodos

(flow_container_connect)=
### **<span style='font-family: monospace;'>connect()</span>**

Cria uma conexão em determinado {ref}`NodeUI.FlowContainer.Signals <node_ui_flow_container_signals>` do **FlowContainer**.

```lua
FlowContainer:connect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.FlowContainer.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table`
  - Objeto dono do método.
```

---

(flow_container_disconnect)=
### **<span style='font-family: monospace;'>disconnect()</span>**

Remove a conexão de um {ref}`NodeUI.FlowContainer.Signals <node_ui_flow_container_signals>` do **FlowContainer**.

```lua
FlowContainer:disconnect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.FlowContainer.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table?`
  - Objeto dono do método.
```

---

(flow_container_get_alignment)=
### **<span style='font-family: monospace;'>getAlignment()</span>**

Retorna o {ref}`NodeUI.Control.AlignmentMode <node_ui_control_alignment_mode>` dos filhos.

```lua
alignment = FlowContainer:getAlignment()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - alignment
  - `NodeUI.Control.AlignmentMode`
  - Alinhamento dos filhos.
```

---

(flow_container_get_last_wrap_alignment)=
### **<span style='font-family: monospace;'>getLastWrapAlignment()</span>**

Define o {ref}`NodeUI.FlowContainer.LastWrapAlignmentMode <node_ui_flow_container_last_wrap_alignment_mode>` dos filhos da última linha ou coluna.

```lua
alignment = FlowContainer:getLastWrapAlignment()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - alignment
  - `NodeUI.FlowContainer.LastWrapAlignmentMode`
  - Alinhamento dos filhos.
```

---

(flow_container_get_separation)=
### **<span style='font-family: monospace;'>getSeparation()</span>**

Retorna a separação entre os filhos.

```lua
separation = FlowContainer:getSeparation(axis)
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
  - Eixo da separação.
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - separation
  - `number`
  - Separação em pixels.
```

---

(flow_container_get_vertical)=
### **<span style='font-family: monospace;'>getVertical()</span>**

Retorna se a organização dos filhos é vertical ou não.

```lua
enabled = FlowContainer:getVertical()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - enabled
  - `boolean`
  - Se é organizado verticalmente.
```

---

(flow_container_new)=
### **<span style='font-family: monospace;'>new()</span>**

Cria um novo **FlowContainer**.

```lua
FlowContainer = FlowContainer:new(x, y, width, height)
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
* - FlowContainer
  - `NodeUI.FlowContainer`
  - Novo **FlowContainer**.
```

---

(flow_container_set_alignment)=
### **<span style='font-family: monospace;'>setAlignment()</span>**

Define o {ref}`NodeUI.Control.AlignmentMode <node_ui_control_alignment_mode>` dos filhos.

```lua
FlowContainer:setAlignment(alignment)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - alignment
  - `NodeUI.Control.AlignmentMode`
  - Alinhamento dos filhos.
```

---

(flow_container_set_last_wrap_alignment)=
### **<span style='font-family: monospace;'>setLastWrapAlignment()</span>**

Define o {ref}`NodeUI.FlowContainer.LastWrapAlignmentMode <node_ui_flow_container_last_wrap_alignment_mode>` dos filhos da última linha ou coluna.

```lua
FlowContainer:setLastWrapAlignment(alignment)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - alignment
  - `NodeUI.FlowContainer.LastWrapAlignmentMode`
  - Alinhamento dos filhos.
```

---

(flow_container_set_separation)=
### **<span style='font-family: monospace;'>setSeparation()</span>**

Define a separação entre os filhos.

```lua
FlowContainer:setSeparation(axis, separation)
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
  - Eixo da separação.
* - separation
  - `number`
  - Separação em pixels.
```

---

(flow_container_set_vertical)=
### **<span style='font-family: monospace;'>setVertical()</span>**

Define se a organização dos filhos é vertical ou não. Por padrão `enabled` é `true`.

```lua
FlowContainer:setVertical(enabled)
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
  - Se é para organizar verticalmente.
```

---

