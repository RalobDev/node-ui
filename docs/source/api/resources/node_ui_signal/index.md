(node_ui_signal)=

# Signal

## Métodos

```{list-table}
:header-rows: 1
:widths: 10 100

* - Tipo
  - Nome
* - `nil`
  - {ref}`connect <signal_connect>`
* - `nil`
  - {ref}`disconnect <signal_disconnect>`
* - `nil`
  - {ref}`emit <signal_emit>`
* - `NodeUI.Signal`
  - {ref}`new <signal_new>`
```

## Descrição dos Métodos

(signal_connect)=
### **<span style='font-family: monospace;'>connect()</span>**

Cria uma conexão em determinado sinal.

O `owner` é a tabela que possui o `method`, que deve ser uma `string`. Caso não seja passado um `owner`, o `method`
deve ser uma `function`.

Quando é passado um `owner` o método é chamado desta forma: `owner.method(owner, ...)` para respeitar o padrão `self`.

```lua
Signal:connect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `string`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table?`
  - Objeto dono do método.
```

---

(signal_disconnect)=
### **<span style='font-family: monospace;'>disconnect()</span>**

Remove a conexão de um sinal.

```lua
Signal:disconnect(signal, method, owner)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `string`
  - Nome do sinal.
* - method
  - `string|function`
  - Nome do método ou método chamado ao sinal ser emitido.
* - owner
  - `table?`
  - Objeto dono do método.
```

---

(signal_emit)=
### **<span style='font-family: monospace;'>emit()</span>**

Emite o `signal`, chamando todos os seus métodos.

```lua
Signal:emit(signal, ...)
```

**Argumentos**

```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - signal
  - `string`
  - Nome do sinal.
* - ...
  - `any`
  - Retornos do sinal.
```

---

(signal_new)=
### **<span style='font-family: monospace;'>new()</span>**

Cria um no **Signal**.

```lua
Signal = Signal:new()
```

**Retornos**
```{list-table}
:header-rows: 1
:widths: 30 30 100

* - Nome
  - Tipo
  - Descrição
* - Signal
  - `NodeUI.Signal`
  - Novo **Signal**.
```

---

