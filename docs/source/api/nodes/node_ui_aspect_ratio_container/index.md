(node_ui_aspect_ratio_container)=

# AspectRatioContainer

**Inherits:** {ref}`NodeUI.Container <node_ui_container>` **→** {ref}`NodeUI.Control <node_ui_control>`

**AspectRatioContainer** é um tipo de {ref}`Container <node_ui_container>` que ajusta seus filhos mantendo uma proporção de
aspecto (aspect ratio), aplicando diferentes {ref}`NodeUI.AspectRatioContainer.StretchMode <node_ui_aspect_ratio_container_stretch_mode>` como `FIT` e `COVER`, além de controle de alinhamento.

## Descrição

O **AspectRatioContainer** estende {ref}`Container <node_ui_container>` adicionando um sistema de
escala baseado em proporção. Ele calcula automaticamente um fator de
escala com base no tamanho do container e no tamanho dos filhos,
permitindo que o conteúdo seja ajustado sem distorção.

Ele suporta diferentes modos de escala através de {ref}`NodeUI.AspectRatioContainer:setStretchMode() <aspect_ratio_container_set_stretch_mode>`.

Também permite controle de alinhamento horizontal e vertical dos filhos através de `NodeUI.AspectRationContainer:setAlignmentMode()`.

## Métodos

```{list-table}
:header-rows: 1
:widths: 10 100

* - Tipo
  - Nome
* - `nil`
  - {ref}`connect <aspect_ratio_container_connect>`
* - `nil`
  - {ref}`disconnect <aspect_ratio_container_disconnect>`
* - `NodeUI.Control.AlignmentMode`
  - {ref}`getAlignmentMode <aspect_ratio_container_get_alignment_mode>`
* - `NodeUI.AspectRatioContainer.StretchMode`
  - {ref}`getStretchMode <aspect_ratio_container_get_stretch_mode>`
* - `NodeUI.AspectRatioContainer`
  - {ref}`new <aspect_ratio_container_new>`
* - `nil`
  - {ref}`setAlignmentMode <aspect_ratio_container_set_alignment_mode>`
* - `nil`
  - {ref}`setStretchMode <aspect_ratio_container_set_stretch_mode>`
```

## Descrição dos Métodos

(aspect_ratio_container_connect)=
### **<span style='font-family: monospace;'>connect()</span>**

Cria uma conexão em determinado {ref}`NodeUI.AspectRatioContainer.Signals <node_ui_aspect_ratio_container_signals>` do **AspectRatioContainer**.

```lua
AspectRatioContainer:connect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.AspectRatioContainer.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table`
  - Objeto dono do método.
```

---

(aspect_ratio_container_disconnect)=
### **<span style='font-family: monospace;'>disconnect()</span>**

Remove a conexão de um {ref}`NodeUI.AspectRatioContainer.Signals <node_ui_aspect_ratio_container_signals>` do **AspectRatioContainer**.

```lua
AspectRatioContainer:disconnect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.AspectRatioContainer.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table?`
  - Objeto dono do método.
```

---

(aspect_ratio_container_get_alignment_mode)=
### **<span style='font-family: monospace;'>getAlignmentMode()</span>**

Retorna o {ref}`NodeUI.Control.AlignmentMode <node_ui_control_alignment_mode>` aplicado aos filhos.

```lua
alignment_mode = AspectRatioContainer:getAlignmentMode(axis)
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
  - Eixo de alinhamento.
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - alignment_mode
  - `NodeUI.Control.AlignmentMode`
  - Modo de alinhamento.
```

---

(aspect_ratio_container_get_stretch_mode)=
### **<span style='font-family: monospace;'>getStretchMode()</span>**

Retorna o {ref}`NodeUI.AspectRatioContainer.StretchMode <node_ui_aspect_ratio_container_stretch_mode>`, que é a maneira como os filhos são escalonados.

```lua
stretch_mode = AspectRatioContainer:getStretchMode()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - stretch_mode
  - `NodeUI.AspectRatioContainer.StretchMode`
  - Modo de escalonamento.
```

---

(aspect_ratio_container_new)=
### **<span style='font-family: monospace;'>new()</span>**

Cria um novo **AspectRatioContainer**.

```lua
AspectRatioContainer = AspectRatioContainer:new(x, y, width, height)
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
* - AspectRatioContainer
  - `NodeUI.AspectRatioContainer`
  - Novo **AspectRatioContainer**.
```

---

(aspect_ratio_container_set_alignment_mode)=
### **<span style='font-family: monospace;'>setAlignmentMode()</span>**

Define o {ref}`NodeUI.Control.AlignmentMode <node_ui_control_alignment_mode>` aplicado aos filhos.

```lua
AspectRatioContainer:setAlignmentMode(axis, alignment_mode)
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
  - Eixo do alinhamento.
* - alignment_mode
  - `NodeUI.Control.AlignmentMode`
  - Modo de alinhamento.
```

---

(aspect_ratio_container_set_stretch_mode)=
### **<span style='font-family: monospace;'>setStretchMode()</span>**

Define o {ref}`NodeUI.AspectRatioContainer.StretchMode <node_ui_aspect_ratio_container_stretch_mode>`, que é a maneira como os filhos são escalonados.

```lua
AspectRatioContainer:setStretchMode(stretch_mode)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - stretch_mode
  - `NodeUI.AspectRatioContainer.StretchMode`
  - Modo de escalonamento.
```

---

