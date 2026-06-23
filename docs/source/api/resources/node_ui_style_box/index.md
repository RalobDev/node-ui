(node_ui_style_box)=

# StyleBox

**Inherits:** {ref}`**NodeUI.Resource** <**node_ui_resource**>`

**Inherited By:** {ref}`NodeUI.StyleBoxEmpty <node_ui_style_box_empty>` **→** {ref}`NodeUI.StyleBoxFlat <node_ui_style_box_flat>` **→** {ref}`NodeUI.StyleBoxLine <node_ui_style_box_line>` **→** {ref}`NodeUI.StyleBoxTexture <node_ui_style_box_texture>`

Recurso base para todas as variantes da **StyleBox**.

## Métodos

```{list-table}
:header-rows: 1
:widths: 10 100

* - Tipo
  - Nome
* - `nil`
  - {ref}`draw <style_box_draw>`
* - `NodeUI.StyleBox`
  - {ref}`new <style_box_new>`
```

## Descrição dos Métodos

(style_box_draw)=
### **<span style='font-family: monospace;'>draw()</span>**

Desenha a **StyleBox** no retângulo dado.

```lua
StyleBox:draw(x, y, width, height)
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
  - Posição x da **StyleBox**.
* - y
  - `number`
  - Posição y da **StyleBox**.
* - width
  - `number`
  - Comprimento da **StyleBox**
* - height
  - `number`
  - Altura da **StyleBox**.
```

---

(style_box_new)=
### **<span style='font-family: monospace;'>new()</span>**

Cria uma nova **StyleBox**.

```lua
StyleBox = StyleBox:new()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - StyleBox
  - `NodeUI.StyleBox`
  - Nova **StyleBox**.
```

---

