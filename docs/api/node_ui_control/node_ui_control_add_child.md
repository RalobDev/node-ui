[<kbd>Voltar</kbd>](node_ui_control.md)

# NodeUI.Control:addChild()

Adiciona um filho ao **Control**. O filho adicionado é retornado, simplificando a criação e
referência de filhos.


## Sinopse

```lua
child = NodeUI.Control:addChild(child, is_internal?)
```

## Argumentos
- **`control` child**
**Control** filho.
- **`boolean` is_internal?**
Se `true`, o filho é marcado como interno do **Control**.

## Retornos
- `control` **child**
Filho que foi adicionado.
