(node_ui_style_box_texture)=

# StyleBoxTexture

**Inherits:** {ref}`**NodeUI.StyleBox** <**node_ui_style_box**>` **→** {ref}`**NodeUI.Resource** <**node_ui_resource**>`

Uma **StyleBox** que exibe uma textura.

## Métodos

```{list-table}
:header-rows: 1
:widths: 10 100

* - Tipo
  - Nome
* - `[number, number, number, number?]`
  - {ref}`getColor <style_box_texture_get_color>`
* - `boolean`
  - {ref}`getDrawCenter <style_box_texture_get_draw_center>`
* - `number`
  - {ref}`getExpandMargin <style_box_texture_get_expand_margin>`
* - `NodeUI.StyleBoxTexture.AxisStretchMode`
  - {ref}`getStretch <style_box_texture_get_stretch>`
* - `number`, `number`
  - {ref}`getSubRegionDimensions <style_box_texture_get_sub_region_dimensions>`
* - `number`
  - {ref}`getSubRegionHeight <style_box_texture_get_sub_region_height>`
* - `number`, `number`
  - {ref}`getSubRegionPosition <style_box_texture_get_sub_region_position>`
* - `number`
  - {ref}`getSubRegionWidth <style_box_texture_get_sub_region_width>`
* - `number`
  - {ref}`getSubRegionX <style_box_texture_get_sub_region_x>`
* - `number`
  - {ref}`getSubRegionY <style_box_texture_get_sub_region_y>`
* - `love.Image`
  - {ref}`getTexture <style_box_texture_get_texture>`
* - `number`
  - {ref}`getTextureMargin <style_box_texture_get_texture_margin>`
* - `NodeUI.StyleBoxTexture`
  - {ref}`new <style_box_texture_new>`
* - `nil`
  - {ref}`setColor <style_box_texture_set_color>`
* - `nil`
  - {ref}`setDrawCenter <style_box_texture_set_draw_center>`
* - `nil`
  - {ref}`setExpandMargin <style_box_texture_set_expand_margin>`
* - `nil`
  - {ref}`setStretch <style_box_texture_set_stretch>`
* - `nil`
  - {ref}`setSubRegionDimensions <style_box_texture_set_sub_region_dimensions>`
* - `nil`
  - {ref}`setSubRegionHeight <style_box_texture_set_sub_region_height>`
* - `nil`
  - {ref}`setSubRegionPosition <style_box_texture_set_sub_region_position>`
* - `nil`
  - {ref}`setSubRegionWidth <style_box_texture_set_sub_region_width>`
* - `nil`
  - {ref}`setSubRegionX <style_box_texture_set_sub_region_x>`
* - `nil`
  - {ref}`setSubRegionY <style_box_texture_set_sub_region_y>`
* - `nil`
  - {ref}`setTexture <style_box_texture_set_texture>`
* - `nil`
  - {ref}`setTextureMargin <style_box_texture_set_texture_margin>`
```

## Descrição dos Métodos

(style_box_texture_get_color)=
### **<span style='font-family: monospace;'>getColor()</span>**

Retorna a cor da textura.

```lua
color = StyleBoxTexture:getColor()
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
  - Cor da textura.
```

---

(style_box_texture_get_draw_center)=
### **<span style='font-family: monospace;'>getDrawCenter()</span>**

Retorna se o centro deve ser desenhado.

```lua
enabled = StyleBoxTexture:getDrawCenter()
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
  - Se o centro da **StyleBoxTexture** deve ser desenhado.
```

---

(style_box_texture_get_expand_margin)=
### **<span style='font-family: monospace;'>getExpandMargin()</span>**

Retorna a expanção de um lado.

```lua
expand = StyleBoxTexture:getExpandMargin(side)
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
  - Lado da expansão.
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - expand
  - `number`
  - Expansão do lado.
```

---

(style_box_texture_get_stretch)=
### **<span style='font-family: monospace;'>getStretch()</span>**

Retorna a {ref}`NodeUI.StyleBoxTexture.AxisStretchMode <node_ui_style_box_texture_axis_stretch_mode>`, que afeta a maneira como
a textura será exibida horizontal ou verticalmente.

```lua
stretch = StyleBoxTexture:getStretch(axis)
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
  - Eixo do stretch.
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - stretch
  - `NodeUI.StyleBoxTexture.AxisStretchMode`
  - Stretch do eixo.
```

---

(style_box_texture_get_sub_region_dimensions)=
### **<span style='font-family: monospace;'>getSubRegionDimensions()</span>**

Retorna a dimensão da sub região da textura.

```lua
width ,height = StyleBoxTexture:getSubRegionDimensions()
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
  - Comprimento.
* - height
  - `number`
  - Altura.
```

---

(style_box_texture_get_sub_region_height)=
### **<span style='font-family: monospace;'>getSubRegionHeight()</span>**

Retorna a altura da sub região da textura.

```lua
height = StyleBoxTexture:getSubRegionHeight()
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
  - Altura.
```

---

(style_box_texture_get_sub_region_position)=
### **<span style='font-family: monospace;'>getSubRegionPosition()</span>**

Retorna a posição da sub região da textura.

```lua
x ,y = StyleBoxTexture:getSubRegionPosition()
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

(style_box_texture_get_sub_region_width)=
### **<span style='font-family: monospace;'>getSubRegionWidth()</span>**

Retorna o comprimento da sub região da textura.

```lua
width = StyleBoxTexture:getSubRegionWidth()
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
  - Comprimento.
```

---

(style_box_texture_get_sub_region_x)=
### **<span style='font-family: monospace;'>getSubRegionX()</span>**

Retorna a posição x da sub região da textura.

```lua
x = StyleBoxTexture:getSubRegionX()
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

(style_box_texture_get_sub_region_y)=
### **<span style='font-family: monospace;'>getSubRegionY()</span>**

Retorna a posição y da sub região da textura.

```lua
y = StyleBoxTexture:getSubRegionY()
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

(style_box_texture_get_texture)=
### **<span style='font-family: monospace;'>getTexture()</span>**

Retorna a textura.

```lua
texture = StyleBoxTexture:getTexture()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - texture
  - `love.Image`
  - Textura da **StyleBoxTexture**.
```

---

(style_box_texture_get_texture_margin)=
### **<span style='font-family: monospace;'>getTextureMargin()</span>**

Retorna a margem de um lado da textura.

```lua
margin = StyleBoxTexture:getTextureMargin(side)
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

(style_box_texture_new)=
### **<span style='font-family: monospace;'>new()</span>**

Cria uma nova **StyleBoxTexture**.

```lua
StyleBoxTexture = StyleBoxTexture:new(texture)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - texture
  - `love.Image`
  - Textura da **StyleBoxTexture**.
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - StyleBoxTexture
  - `NodeUI.StyleBoxTexture`
  - Nova **StyleBoxTexture**.
```

---

(style_box_texture_set_color)=
### **<span style='font-family: monospace;'>setColor()</span>**

Define a cor da textura.

```lua
StyleBoxTexture:setColor(color)
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
  - Cor da textura.
```

---

(style_box_texture_set_draw_center)=
### **<span style='font-family: monospace;'>setDrawCenter()</span>**

Define se o centro deve ser desenhado.

```lua
StyleBoxTexture:setDrawCenter(enabled)
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
  - Se o centro da **StyleBoxTexture** deve ser desenhado.
```

---

(style_box_texture_set_expand_margin)=
### **<span style='font-family: monospace;'>setExpandMargin()</span>**

Define a expanção de um lado.

```lua
StyleBoxTexture:setExpandMargin(side, expand)
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
  - Lado da expansão.
* - expand
  - `number`
  - Expansão do lado.
```

---

(style_box_texture_set_stretch)=
### **<span style='font-family: monospace;'>setStretch()</span>**

Define a {ref}`NodeUI.StyleBoxTexture.AxisStretchMode <node_ui_style_box_texture_axis_stretch_mode>`, que afeta a maneira como
a textura será exibida horizontal ou verticalmente.

```lua
StyleBoxTexture:setStretch(axis, stretch)
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
  - Eixo do stretch.
* - stretch
  - `NodeUI.StyleBoxTexture.AxisStretchMode`
  - Stretch do eixo.
```

---

(style_box_texture_set_sub_region_dimensions)=
### **<span style='font-family: monospace;'>setSubRegionDimensions()</span>**

Define a dimensão da sub região da textura.

```lua
StyleBoxTexture:setSubRegionDimensions(width, height)
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
  - Comprimento.
* - height
  - `number`
  - Altura.
```

---

(style_box_texture_set_sub_region_height)=
### **<span style='font-family: monospace;'>setSubRegionHeight()</span>**

Define a altura da sub região da textura.

```lua
StyleBoxTexture:setSubRegionHeight(height)
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
  - Altura.
```

---

(style_box_texture_set_sub_region_position)=
### **<span style='font-family: monospace;'>setSubRegionPosition()</span>**

Define a posição da sub região da textura.

```lua
StyleBoxTexture:setSubRegionPosition(x, y)
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
  - Posição x.
* - y
  - `number`
  - Posição y.
```

---

(style_box_texture_set_sub_region_width)=
### **<span style='font-family: monospace;'>setSubRegionWidth()</span>**

Define o comprimento da sub região da textura.

```lua
StyleBoxTexture:setSubRegionWidth(width)
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
  - Comprimento.
```

---

(style_box_texture_set_sub_region_x)=
### **<span style='font-family: monospace;'>setSubRegionX()</span>**

Define a posição x da sub região da textura.

```lua
StyleBoxTexture:setSubRegionX(x)
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
  - Posição x.
```

---

(style_box_texture_set_sub_region_y)=
### **<span style='font-family: monospace;'>setSubRegionY()</span>**

Define a posição y da sub região da textura.

```lua
StyleBoxTexture:setSubRegionY(y)
```

**Argumentos**

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

(style_box_texture_set_texture)=
### **<span style='font-family: monospace;'>setTexture()</span>**

Define a textura.

```lua
StyleBoxTexture:setTexture(texture)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - texture
  - `love.Image`
  - Textura da **StyleBoxTexture**.
```

---

(style_box_texture_set_texture_margin)=
### **<span style='font-family: monospace;'>setTextureMargin()</span>**

Define a margem de um lado da textura.

```lua
StyleBoxTexture:setTextureMargin(side, margin)
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

