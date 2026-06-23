(node_ui_resource)=

# Resource

**Inherited By:** {ref}`NodeUI.StyleBox <node_ui_style_box>` **→** {ref}`NodeUI.StyleBoxEmpty <node_ui_style_box_empty>` **→** {ref}`NodeUI.StyleBoxFlat <node_ui_style_box_flat>` **→** {ref}`NodeUI.StyleBoxLine <node_ui_style_box_line>` **→** {ref}`NodeUI.StyleBoxTexture <node_ui_style_box_texture>`

Classe base para todos os recursos dos nós.

## Descrição

Os recursos funcionam unicamente como portadores de dados e não devem ter conhecimento a que
nó pertencem.

## Métodos

```{list-table}
:header-rows: 1
:widths: 10 100

* - Tipo
  - Nome
* - `nil`
  - {ref}`connect <resource_connect>`
* - `NodeUI.Resource`
  - {ref}`new <resource_new>`
```

## Descrição dos Métodos

(resource_connect)=
### **<span style='font-family: monospace;'>connect()</span>**

Cria uma conexão em determinado sinal do **Resource**.

O `owner` é a tabela que possui o `method`, que deve ser uma `string`. Caso não seja passado um `owner`, o `method`
deve ser uma `function`.

Quando é passado um `owner` o método é chamado desta forma: `owner.method(owner, ...)` para respeitar o padrão `self`.

```lua
Resource:connect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `NodeUI.Resource.Signals`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table?`
  - Objeto dono do método.
```

---

(resource_new)=
### **<span style='font-family: monospace;'>new()</span>**

Cria um novo **Resource**.

```lua
Resource = Resource:new()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - Resource
  - `NodeUI.Resource`
  - Novo **Resource**.
```

---

