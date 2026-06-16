[<kbd>Voltar</kbd>](node_ui_control.md)

# NodeUI.Control:queueFree()

Marca para deletar o **Control** no próximo `love.update()`.
 
Os nós não são coletados pelo coletor de lixo do **Lua** ao ser definido com `nil`, pois
o próprio módulo [NodeUI](../node_ui/node_ui.md) armazena uma referência deles. Assim é necessário chamar
`queueFree` quando quiser remover um nó da biblioteca.
 
Ao ser deletado o nó e seus filhos são removidos da raiz do **NodeUI**, mas quaisquer
referências fora do módulo continuarão existindo.


## Sinopse

```lua
NodeUI.Control:queueFree()
```

## Argumentos
Nada.

## Retornos
Nenhum.
