[<kbd>Voltar</kbd>](node_ui_control.md)

# NodeUI.Control:connect()

Cria uma conexão em determinado sinal do **Control**.
 
O `owner` é a tabela que possui o `method`, que deve ser uma `string`. Caso não seja passado um `owner`, o `method`
deve ser uma `function`.
 
Quando é passado um `owner` o método é chamado desta forma: `owner.method(owner, ...)` para respeitar o padrão `self`.


## Sinopse

```lua
NodeUI.Control:connect(signal, method, owner)
```

## Argumentos
- **`NodeUI.Control.Signals` signal** <br>
Nome do sinal.
- **`string|function` method** <br>
Nome do método ou método chamado ao sinal ser emitido.
- **`table?` owner** <br>
Objeto dono do método.

## Retornos
Nenhum.
