[<kbd>Voltar</kbd>](../class_reference.md)

# NodeUI.FlowContainer

O **FlowContainer** Organiza os filhos horizontalmente e verticalmente em diferentes linhas ou colunas.
 
## Descrição
 
O **FlowContainer** quebra as linhas ou colunas de filhos para fazé-los caber na dimensão do **FlowContainer**,
mas o número de linhas ou colunas pode ultrapassar o tamanho do mesmo.


## Métodos

| Nome | Descrição | Retornos |
| ---- | --------- | -------- |
[connect](node_ui_flow_container_connect.md) | Cria uma conexão em determinado sinal do [Control](../node_ui_control/node_ui_control.md). | `nil`
[disconnect](node_ui_flow_container_disconnect.md) | Remove a conexão de um sinal do [Control](../node_ui_control/node_ui_control.md). | `nil`
[getAlignment](node_ui_flow_container_get_alignment.md) | Retorna o alinhamento dos filhos. | `NodeUI.Control.AlignmentMode`
[getLastWrapAlignment](node_ui_flow_container_get_last_wrap_alignment.md) | Define o alinhamento dos filhos da última linha ou coluna. | `NodeUI.FlowContainer.LastWrapAlignmentMode`
[getSeparation](node_ui_flow_container_get_separation.md) | Retorna a separação entre os filhos. | `number`
[getVertical](node_ui_flow_container_get_vertical.md) | Retorna se a organização dos filhos é vertical ou não. | `boolean`
[new](node_ui_flow_container_new.md) | Cria um novo **FlowContainer**. | [`NodeUI.FlowContainer`](../node_ui_flow_container/node_ui_flow_container.md)
[setAlignment](node_ui_flow_container_set_alignment.md) | Define o alinhamento dos filhos. | `nil`
[setLastWrapAlignment](node_ui_flow_container_set_last_wrap_alignment.md) | Define o alinhamento dos filhos da última linha ou coluna. | `nil`
[setSeparation](node_ui_flow_container_set_separation.md) | Define a separação entre os filhos. | `nil`
[setVertical](node_ui_flow_container_set_vertical.md) | Define se a organização dos filhos é vertical ou não. Por padrão `enabled` é `true`. | `nil`
