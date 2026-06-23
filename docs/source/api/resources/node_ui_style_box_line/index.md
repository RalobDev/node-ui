(node_ui_style_box_line)=

# StyleBoxLine

**Inherits:** {ref}`**NodeUI.StyleBox** <**node_ui_style_box**>` **→** {ref}`**NodeUI.Resource** <**node_ui_resource**>`

Uma **StyleBox** que exibe uma única linha.

## Métodos

```{list-table}
:header-rows: 1
:widths: 10 100

* - Tipo
  - Nome
* - `NodeUI.StyleBoxLine.CapStyle`
  - {ref}`getCapBegin <style_box_line_get_cap_begin>`
* - `NodeUI.StyleBoxLine.CapStyle`
  - {ref}`getCapEnd <style_box_line_get_cap_end>`
* - `[number, number, number, number?]`
  - {ref}`getColor <style_box_line_get_color>`
* - `NodeUI.Control.Side`
  - {ref}`getEdge <style_box_line_get_edge>`
* - `number`
  - {ref}`getGrowBegin <style_box_line_get_grow_begin>`
* - `number`
  - {ref}`getGrowEnd <style_box_line_get_grow_end>`
* - `number`
  - {ref}`getThickness <style_box_line_get_thickness>`
* - `NodeUI.StyleBoxLine`
  - {ref}`new <style_box_line_new>`
* - `nil`
  - {ref}`setCapBegin <style_box_line_set_cap_begin>`
* - `nil`
  - {ref}`setCapEnd <style_box_line_set_cap_end>`
* - `nil`
  - {ref}`setColor <style_box_line_set_color>`
* - `nil`
  - {ref}`setEdge <style_box_line_set_edge>`
* - `nil`
  - {ref}`setGrowBegin <style_box_line_set_grow_begin>`
* - `nil`
  - {ref}`setGrowEnd <style_box_line_set_grow_end>`
* - `nil`
  - {ref}`setThickness <style_box_line_set_thickness>`
```

## Descrição dos Métodos

(style_box_line_get_cap_begin)=
### **<span style='font-family: monospace;'>getCapBegin()</span>**

Retorna o {ref}`NodeUI.StyleBoxLine.CapStyle <node_ui_style_box_line_cap_style>` do início da linha.

```lua
cap = StyleBoxLine:getCapBegin()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - cap
  - `NodeUI.StyleBoxLine.CapStyle`
  - Limite do início da linha.
```

---

(style_box_line_get_cap_end)=
### **<span style='font-family: monospace;'>getCapEnd()</span>**

Retorna o {ref}`NodeUI.StyleBoxLine.CapStyle <node_ui_style_box_line_cap_style>` do final da linha.

```lua
cap = StyleBoxLine:getCapEnd()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - cap
  - `NodeUI.StyleBoxLine.CapStyle`
  - Limite do final da linha.
```

---

(style_box_line_get_color)=
### **<span style='font-family: monospace;'>getColor()</span>**

Retorna a cor da linha.

```lua
color = StyleBoxLine:getColor()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - color
  - `[number, number, number, number?]`
  - Cor da linha.
```

---

(style_box_line_get_edge)=
### **<span style='font-family: monospace;'>getEdge()</span>**

Retorna o {ref}`NodeUI.Control.side <node_ui_control_side>` que a linha é desenhada.

```lua
side = StyleBoxLine:getEdge()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - side
  - `NodeUI.Control.Side`
  - Lado que é desenhada.
```

---

(style_box_line_get_grow_begin)=
### **<span style='font-family: monospace;'>getGrowBegin()</span>**

Retorna o crescimento inicial da linha.

```lua
grow = StyleBoxLine:getGrowBegin()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - grow
  - `number`
  - Crescimento inicial.
```

---

(style_box_line_get_grow_end)=
### **<span style='font-family: monospace;'>getGrowEnd()</span>**

Retorna o crescimento final da linha.

```lua
grow = StyleBoxLine:getGrowEnd()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - grow
  - `number`
  - Crescimento final.
```

---

(style_box_line_get_thickness)=
### **<span style='font-family: monospace;'>getThickness()</span>**

Retorna a espessura da linha.

```lua
thickness = StyleBoxLine:getThickness()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - thickness
  - `number`
  - Espessura da linha.
```

---

(style_box_line_new)=
### **<span style='font-family: monospace;'>new()</span>**

Cria uma nova **StyleBoxLine**.

```lua
StyleBoxLine = StyleBoxLine:new()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - StyleBoxLine
  - `NodeUI.StyleBoxLine`
  - Nova **StyleBoxLine**.
```

---

(style_box_line_set_cap_begin)=
### **<span style='font-family: monospace;'>setCapBegin()</span>**

Define o {ref}`NodeUI.StyleBoxLine.CapStyle <node_ui_style_box_line_cap_style>` do início da linha.

```lua
StyleBoxLine:setCapBegin(cap)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - cap
  - `NodeUI.StyleBoxLine.CapStyle`
  - Limite do início da linha.
```

---

(style_box_line_set_cap_end)=
### **<span style='font-family: monospace;'>setCapEnd()</span>**

Define o {ref}`NodeUI.StyleBoxLine.CapStyle <node_ui_style_box_line_cap_style>` do final da linha.

```lua
StyleBoxLine:setCapEnd(cap)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - cap
  - `NodeUI.StyleBoxLine.CapStyle`
  - Limite do final da linha.
```

---

(style_box_line_set_color)=
### **<span style='font-family: monospace;'>setColor()</span>**

Define a cor da linha.

```lua
StyleBoxLine:setColor(color)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - color
  - `[number, number, number, number?]`
  - Cor da linha.
```

---

(style_box_line_set_edge)=
### **<span style='font-family: monospace;'>setEdge()</span>**

Define o {ref}`NodeUI.Control.Side <node_ui_control_side>` que a linha é desenhada.

```lua
StyleBoxLine:setEdge(side)
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
  - Lado que é desenhada.
```

---

(style_box_line_set_grow_begin)=
### **<span style='font-family: monospace;'>setGrowBegin()</span>**

Define o crescimento inicial da linha.

```lua
StyleBoxLine:setGrowBegin(grow)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - grow
  - `number`
  - Crescimento inicial.
```

---

(style_box_line_set_grow_end)=
### **<span style='font-family: monospace;'>setGrowEnd()</span>**

Define o crescimento final da linha.

```lua
StyleBoxLine:setGrowEnd(grow)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - grow
  - `number`
  - Crescimento final.
```

---

(style_box_line_set_thickness)=
### **<span style='font-family: monospace;'>setThickness()</span>**

Define a espessura da linha.

```lua
StyleBoxLine:setThickness(thickness)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - thickness
  - `number`
  - Espessura da linha.
```

---

