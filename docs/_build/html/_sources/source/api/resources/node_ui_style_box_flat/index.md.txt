(node_ui_style_box_flat)=

# StyleBoxFlat

**Inherits:** {ref}`**NodeUI.StyleBox** <**node_ui_style_box**>` **→** {ref}`**NodeUI.Resource** <**node_ui_resource**>`

Uma **StyleBox** que exibe um retângulo altamente customizável.

## Métodos

```{list-table}
:header-rows: 1
:widths: 10 100

* - Tipo
  - Nome
* - `boolean`
  - {ref}`getBorderBlend <style_box_flat_get_border_blend>`
* - `[number, number, number, number?]`
  - {ref}`getBorderColor <style_box_flat_get_border_color>`
* - `number`
  - {ref}`getBorderSize <style_box_flat_get_border_size>`
* - `number`
  - {ref}`getCornerRadius <style_box_flat_get_corner_radius>`
* - `boolean`
  - {ref}`getDrawCenter <style_box_flat_get_draw_center>`
* - `number`
  - {ref}`getExpandMargin <style_box_flat_get_expand_margin>`
* - `[number, number, number, number?]`
  - {ref}`getFillColor <style_box_flat_get_fill_color>`
* - `number`
  - {ref}`getShadowBlur <style_box_flat_get_shadow_blur>`
* - `[number, number, number, number?]`
  - {ref}`getShadowColor <style_box_flat_get_shadow_color>`
* - `number`, `number`
  - {ref}`getShadowOffset <style_box_flat_get_shadow_offset>`
* - `number`
  - {ref}`getShadowOffsetX <style_box_flat_get_shadow_offset_x>`
* - `number`
  - {ref}`getShadowOffsetY <style_box_flat_get_shadow_offset_y>`
* - `number`
  - {ref}`getShadowSize <style_box_flat_get_shadow_size>`
* - `number`, `number`
  - {ref}`getSkew <style_box_flat_get_skew>`
* - `number`
  - {ref}`getSkewX <style_box_flat_get_skew_x>`
* - `number`
  - {ref}`getSkewX <style_box_flat_get_skew_x>`
* - `NodeUI.StyleBoxFlat`
  - {ref}`new <style_box_flat_new>`
* - `nil`
  - {ref}`setBorderBlend <style_box_flat_set_border_blend>`
* - `nil`
  - {ref}`setBorderColor <style_box_flat_set_border_color>`
* - `nil`
  - {ref}`setBorderSize <style_box_flat_set_border_size>`
* - `nil`
  - {ref}`setCornerRadius <style_box_flat_set_corner_radius>`
* - `nil`
  - {ref}`setDrawCenter <style_box_flat_set_draw_center>`
* - `nil`
  - {ref}`setExpandMargin <style_box_flat_set_expand_margin>`
* - `nil`
  - {ref}`setFillColor <style_box_flat_set_fill_color>`
* - `nil`
  - {ref}`setShadowBlur <style_box_flat_set_shadow_blur>`
* - `nil`
  - {ref}`setShadowColor <style_box_flat_set_shadow_color>`
* - `nil`
  - {ref}`setShadowOffset <style_box_flat_set_shadow_offset>`
* - `nil`
  - {ref}`setShadowOffsetX <style_box_flat_set_shadow_offset_x>`
* - `nil`
  - {ref}`setShadowOffsetY <style_box_flat_set_shadow_offset_y>`
* - `nil`
  - {ref}`setShadowSize <style_box_flat_set_shadow_size>`
* - `nil`
  - {ref}`setSkew <style_box_flat_set_skew>`
* - `nil`
  - {ref}`setSkewX <style_box_flat_set_skew_x>`
* - `nil`
  - {ref}`setSkewX <style_box_flat_set_skew_x>`
```

## Descrição dos Métodos

(style_box_flat_get_border_blend)=
### **<span style='font-family: monospace;'>getBorderBlend()</span>**

Retorna a mistura da borda. Se `true`, a cor da borda mescla com a cor de preenchimento.

```lua
enabled = StyleBoxFlat:getBorderBlend()
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
  - Se a mistura está ativa.
```

---

(style_box_flat_get_border_color)=
### **<span style='font-family: monospace;'>getBorderColor()</span>**

Retorna a cor da borda.

```lua
color = StyleBoxFlat:getBorderColor()
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
  - Cor da borda.
```

---

(style_box_flat_get_border_size)=
### **<span style='font-family: monospace;'>getBorderSize()</span>**

Retorna o tamanho da borda.

```lua
size = StyleBoxFlat:getBorderSize()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - size
  - `number`
  - Tamanho da borda.
```

---

(style_box_flat_get_corner_radius)=
### **<span style='font-family: monospace;'>getCornerRadius()</span>**

Retorna o raio de um canto.

```lua
radius = StyleBoxFlat:getCornerRadius(corner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - corner
  - `NodeUI.Control.Corner`
  - Canto do raio.
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - radius
  - `number`
  - Raio do canto.
```

---

(style_box_flat_get_draw_center)=
### **<span style='font-family: monospace;'>getDrawCenter()</span>**

Retorna se é para desenhar o centro.

```lua
enabled = StyleBoxFlat:getDrawCenter()
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
  - Se é para desenhar o centro.
```

---

(style_box_flat_get_expand_margin)=
### **<span style='font-family: monospace;'>getExpandMargin()</span>**

Retorna a expansão da margem de determinado lado.

```lua
expand = StyleBoxFlat:getExpandMargin(side)
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
  - Lado da expansão de margem.
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
  - Valor da expansão de margem.
```

---

(style_box_flat_get_fill_color)=
### **<span style='font-family: monospace;'>getFillColor()</span>**

Retorna a cor de preenchimento.

```lua
color = StyleBoxFlat:getFillColor()
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
  - Cor de preenchimento.
```

---

(style_box_flat_get_shadow_blur)=
### **<span style='font-family: monospace;'>getShadowBlur()</span>**

Retorna o blur da sombra.

```lua
blur = StyleBoxFlat:getShadowBlur()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - blur
  - `number`
  - Blur da sombra.
```

---

(style_box_flat_get_shadow_color)=
### **<span style='font-family: monospace;'>getShadowColor()</span>**

Retorna a cor da sombra.

```lua
color = StyleBoxFlat:getShadowColor()
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
  - Cor da sombra.
```

---

(style_box_flat_get_shadow_offset)=
### **<span style='font-family: monospace;'>getShadowOffset()</span>**

Retorna o offset da sombra.

```lua
x ,y = StyleBoxFlat:getShadowOffset()
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
  - Offset x da sombra.
* - y
  - `number`
  - Offset y da sombra.
```

---

(style_box_flat_get_shadow_offset_x)=
### **<span style='font-family: monospace;'>getShadowOffsetX()</span>**

Retorna o offset x da sombra.

```lua
x = StyleBoxFlat:getShadowOffsetX()
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
  - Offset x da sombra.
```

---

(style_box_flat_get_shadow_offset_y)=
### **<span style='font-family: monospace;'>getShadowOffsetY()</span>**

Retorna o offset y da sombra.

```lua
y = StyleBoxFlat:getShadowOffsetY()
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
  - Offset y da sombra.
```

---

(style_box_flat_get_shadow_size)=
### **<span style='font-family: monospace;'>getShadowSize()</span>**

Retorna o tamanho da sombra.

```lua
size = StyleBoxFlat:getShadowSize()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - size
  - `number`
  - Tamanho da sombra.
```

---

(style_box_flat_get_skew)=
### **<span style='font-family: monospace;'>getSkew()</span>**

Retorna o skew.

```lua
x ,y = StyleBoxFlat:getSkew()
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
  - Skew x.
* - y
  - `number`
  - Skew y.
```

---

(style_box_flat_get_skew_x)=
### **<span style='font-family: monospace;'>getSkewX()</span>**

Retorna o skew x.

```lua
x = StyleBoxFlat:getSkewX()
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
  - Skew x.
```

---

(style_box_flat_get_skew_x)=
### **<span style='font-family: monospace;'>getSkewX()</span>**

Retorna o skew y*.

```lua
y = StyleBoxFlat:getSkewX()
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
  - Skew y.
```

---

(style_box_flat_new)=
### **<span style='font-family: monospace;'>new()</span>**

Cria uma nova **StyleBoxFlat**.

```lua
StyleBoxFlat = StyleBoxFlat:new()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - StyleBoxFlat
  - `NodeUI.StyleBoxFlat`
  - Nova **StyleBoxFlat**.
```

---

(style_box_flat_set_border_blend)=
### **<span style='font-family: monospace;'>setBorderBlend()</span>**

Define a mistura da borda. Se `true`, a cor da borda mescla com a cor de preenchimento.

```lua
StyleBoxFlat:setBorderBlend(enabled)
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
  - Se a mistura está ativa.
```

---

(style_box_flat_set_border_color)=
### **<span style='font-family: monospace;'>setBorderColor()</span>**

Define a cor da borda.

```lua
StyleBoxFlat:setBorderColor(color)
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
  - Cor da borda.
```

---

(style_box_flat_set_border_size)=
### **<span style='font-family: monospace;'>setBorderSize()</span>**

Define o tamanho da borda.

```lua
StyleBoxFlat:setBorderSize(size)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - size
  - `number`
  - Tamanho da borda.
```

---

(style_box_flat_set_corner_radius)=
### **<span style='font-family: monospace;'>setCornerRadius()</span>**

Define o raio de um canto.

```lua
StyleBoxFlat:setCornerRadius(corner, radius)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - corner
  - `NodeUI.Control.Corner`
  - Canto do raio.
* - radius
  - `number`
  - Raio do canto.
```

---

(style_box_flat_set_draw_center)=
### **<span style='font-family: monospace;'>setDrawCenter()</span>**

Define se é para desenhar o centro.

```lua
StyleBoxFlat:setDrawCenter(enabled)
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
  - Se é para desenhar o centro.
```

---

(style_box_flat_set_expand_margin)=
### **<span style='font-family: monospace;'>setExpandMargin()</span>**

Define a expansão da margem de determinado lado.

```lua
StyleBoxFlat:setExpandMargin(side, expand)
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
  - Lado da expansão de margem.
* - expand
  - `number`
  - Valor da expansão de margem.
```

---

(style_box_flat_set_fill_color)=
### **<span style='font-family: monospace;'>setFillColor()</span>**

Define a cor de preenchimento.

```lua
StyleBoxFlat:setFillColor(color)
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
  - Cor de preenchimento.
```

---

(style_box_flat_set_shadow_blur)=
### **<span style='font-family: monospace;'>setShadowBlur()</span>**

Define o blur da sombra.

```lua
StyleBoxFlat:setShadowBlur(blur)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - blur
  - `number`
  - Blur da sombra.
```

---

(style_box_flat_set_shadow_color)=
### **<span style='font-family: monospace;'>setShadowColor()</span>**

Define a cor da sombra.

```lua
StyleBoxFlat:setShadowColor(color)
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
  - Cor da sombra.
```

---

(style_box_flat_set_shadow_offset)=
### **<span style='font-family: monospace;'>setShadowOffset()</span>**

Define o offset da sombra.

```lua
StyleBoxFlat:setShadowOffset(x, y)
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
  - Offset x da sombra.
* - y
  - `number`
  - Offset y da sombra.
```

---

(style_box_flat_set_shadow_offset_x)=
### **<span style='font-family: monospace;'>setShadowOffsetX()</span>**

Define o offset x da sombra.

```lua
StyleBoxFlat:setShadowOffsetX(x)
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
  - Offset x da sombra.
```

---

(style_box_flat_set_shadow_offset_y)=
### **<span style='font-family: monospace;'>setShadowOffsetY()</span>**

Define o offset y da sombra.

```lua
StyleBoxFlat:setShadowOffsetY(y)
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
  - Offset y da sombra.
```

---

(style_box_flat_set_shadow_size)=
### **<span style='font-family: monospace;'>setShadowSize()</span>**

Define o tamanho da sombra.

```lua
StyleBoxFlat:setShadowSize(size)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - size
  - `number`
  - Tamanho da sombra.
```

---

(style_box_flat_set_skew)=
### **<span style='font-family: monospace;'>setSkew()</span>**

Define o skew.

```lua
StyleBoxFlat:setSkew(x, y)
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
  - Skew x.
* - y
  - `number`
  - Skew y.
```

---

(style_box_flat_set_skew_x)=
### **<span style='font-family: monospace;'>setSkewX()</span>**

Define o skew x.

```lua
StyleBoxFlat:setSkewX(x)
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
  - Skew x.
```

---

(style_box_flat_set_skew_x)=
### **<span style='font-family: monospace;'>setSkewX()</span>**

Define o skew y.

```lua
StyleBoxFlat:setSkewX(y)
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
  - Skew y.
```

---

