(node_ui_grid_container)=

# GridContainer

**Inherits:** {ref}`NodeUI.Container <node_ui_container>` **→** {ref}`NodeUI.Control <node_ui_control>`

O **GridContainer** organiza seus filhos em uma grade.

## Descrição

O **GridContainer** organiza seus filhos em linhas e colunas de acordo com o seu número de colunas, que
pode ser definido através de {ref}`NodeUI.GridContainer:setColumns() <grid_container_set_columns>`.

## Métodos

```{list-table}
:header-rows: 1
:widths: 10 100

* - Tipo
  - Nome
* - `nil`
  - {ref}`connect <grid_container_connect>`
* - `nil`
  - {ref}`disconnect <grid_container_disconnect>`
* - `number`
  - {ref}`getColumns <grid_container_get_columns>`
* - `number`
  - {ref}`getSeparation <grid_container_get_separation>`
* - `NodeUI.GridContainer`
  - {ref}`new <grid_container_new>`
* - `nil`
  - {ref}`setColumns <grid_container_set_columns>`
* - `nil`
  - {ref}`setSeparation <grid_container_set_separation>`
```

## Descrição dos Métodos

(grid_container_connect)=
### **<span style='font-family: monospace;'>connect()</span>**

Cria uma conexão em determinado {ref}`NodeUI.GridContainer.Signals <node_ui_grid_container_signals>` do **GridContainer**.

```lua
GridContainer:connect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.GridContainer.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table`
  - Objeto dono do método.
```

---

(grid_container_disconnect)=
### **<span style='font-family: monospace;'>disconnect()</span>**

Remove a conexão de um {ref}`NodeUI.GridContainer.Signals <node_ui_grid_container_signals>` do **GridContainer**.

```lua
GridContainer:disconnect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.GridContainer.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table?`
  - Objeto dono do método.
```

---

(grid_container_get_columns)=
### **<span style='font-family: monospace;'>getColumns()</span>**

Retorna a quantidade de colunas do grid.

```lua
columns = GridContainer:getColumns()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - columns
  - `number`
  - Quantidade de colunas.
```

---

(grid_container_get_separation)=
### **<span style='font-family: monospace;'>getSeparation()</span>**

Retorna a separação entre os filhos.

```lua
separation = GridContainer:getSeparation(axis)
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

(grid_container_new)=
### **<span style='font-family: monospace;'>new()</span>**

Cria um novo **GridContainer**.

```lua
GridContainer = GridContainer:new(x, y, width, height)
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
* - GridContainer
  - `NodeUI.GridContainer`
  - Novo **GridContainer**.
```

---

(grid_container_set_columns)=
### **<span style='font-family: monospace;'>setColumns()</span>**

Define a quantidade de colunas do grid.

```lua
GridContainer:setColumns(columns)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - columns
  - `number`
  - Quantidade de colunas.
```

---

(grid_container_set_separation)=
### **<span style='font-family: monospace;'>setSeparation()</span>**

Define a separação entre os filhos.

```lua
GridContainer:setSeparation(axis, separation)
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

