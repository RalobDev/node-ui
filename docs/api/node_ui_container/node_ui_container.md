[<kbd>Voltar</kbd>](../class_reference.md)

# NodeUI.Container

**Container** é um tipo de [Control](../node_ui_control/node_ui_control.md) responsável por agrupar outros nós e gerenciar
o layout e atualização dos seus filhos dentro da hierarquia do [NodeUI](../node_ui/node_ui.md).
 
## Descrição
 
O **Container** estende **Control** adicionando suporte a organização de filhos e
controle de layout.
 
Classes derivadas podem sobrescrever `_updateChildrenLayout()` para implementar
comportamentos específicos de posicionamento e organização dos elementos filhos.


## Métodos

| Nome | Descrição | Retornos |
| ---- | --------- | -------- |
[connect](node_ui_container_connect.md) | Cria uma conexão em determinado sinal do [Control](../node_ui_control/node_ui_control.md). | `nil`
[disconnect](node_ui_container_disconnect.md) | Desconecta o `method` do `signal`. | `nil`
[new](node_ui_container_new.md) | Cria um novo **Container**. | [`NodeUI.Container`](../node_ui_container/node_ui_container.md)
[setHeight](node_ui_container_set_height.md) | Define a altura do **Control**. | `nil`
[setWidth](node_ui_container_set_width.md) | Define o comprimento do **Control**. | `nil`
