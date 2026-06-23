(node_ui_box_container)=

# BoxContainer

**Inherits:** {ref}`NodeUI.Container <node_ui_container>` **→** {ref}`NodeUI.Control <node_ui_control>`

Organiza os filhos horizontalmente ou verticalmente.

## Métodos

```{list-table}
:header-rows: 1
:widths: 10 100

* - Tipo
  - Nome
* - `nil`
  - {ref}`connect <box_container_connect>`
* - `nil`
  - {ref}`disconnect <box_container_disconnect>`
* - `NodeUI.Control.AlignmentMode`
  - {ref}`getAlignment <box_container_get_alignment>`
* - `number`
  - {ref}`getSeparation <box_container_get_separation>`
* - `boolean`
  - {ref}`getVertical <box_container_get_vertical>`
* - `NodeUI.BoxContainer`
  - {ref}`new <box_container_new>`
* - `nil`
  - {ref}`setAlignment <box_container_set_alignment>`
* - `nil`
  - {ref}`setSeparation <box_container_set_separation>`
* - `nil`
  - {ref}`setVertical <box_container_set_vertical>`
```

## Descrição dos Métodos

(box_container_connect)=
### **<span style='font-family: monospace;'>connect()</span>**

Cria uma conexão em determinado {ref}`NodeUI.BoxContainer.Signals <node_ui_box_container_signals>` do **BoxContainer**.

```lua
BoxContainer:connect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.BoxContainer.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table`
  - Objeto dono do método.
```

---

(box_container_disconnect)=
### **<span style='font-family: monospace;'>disconnect()</span>**

Remove a conexão de um {ref}`NodeUI.BoxContainer.Signals <node_ui_box_container_signals>` do **BoxContainer**.

```lua
BoxContainer:disconnect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.BoxContainer.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table?`
  - Objeto dono do método.
```

---

(box_container_get_alignment)=
### **<span style='font-family: monospace;'>getAlignment()</span>**

Retorna o {ref}`NodeUI.Control.AlignmentMode <node_ui_control_alignment_mode>` aplicado aos filhos.

```lua
alignment = BoxContainer:getAlignment()
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

(box_container_get_separation)=
### **<span style='font-family: monospace;'>getSeparation()</span>**

Retorna a separação entre os filhos.

```lua
separation = BoxContainer:getSeparation()
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

(box_container_get_vertical)=
### **<span style='font-family: monospace;'>getVertical()</span>**

Retorna se a organização dos filhos é vertical ou não.

```lua
enabled = BoxContainer:getVertical()
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

(box_container_new)=
### **<span style='font-family: monospace;'>new()</span>**

Cria um novo **BoxContainer**.

```lua
BoxContainer = BoxContainer:new(x, y, width, height)
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
* - BoxContainer
  - `NodeUI.BoxContainer`
  - Novo **BoxContainer**.
```

---

(box_container_set_alignment)=
### **<span style='font-family: monospace;'>setAlignment()</span>**

Define o {ref}`NodeUI.Control.AlignmentMode <node_ui_control_alignment_mode>` aplicado aos filhos.

```lua
BoxContainer:setAlignment(alignment)
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

(box_container_set_separation)=
### **<span style='font-family: monospace;'>setSeparation()</span>**

Define a separação entre os filhos.

```lua
BoxContainer:setSeparation(separation)
```

**Argumentos**

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

(box_container_set_vertical)=
### **<span style='font-family: monospace;'>setVertical()</span>**

Define se a organização dos filhos é vertical ou não. Por padrão `enabled` é `true`.

```lua
BoxContainer:setVertical(enabled)
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

