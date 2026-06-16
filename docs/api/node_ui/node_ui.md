[<kbd>Voltar</kbd>](../class_reference.md)

# NodeUI

O **NodeUI** é o módulo principal da biblioteca, responsável por gerenciar os controles da interface, processar eventos de entrada e
coordenar a atualização e renderização da UI.
 
### Descrição
 
O **NodeUI** atua como o ponto central da biblioteca. Ele mantém os controles que estão na raiz da interface, encaminha eventos do LÖVE para
os elementos da UI e fornece a área base utilizada como referência para o sistema de layout. Além disso, é responsável por atualizar,
desenhar e gerenciar o ciclo de vida dos controles.


## Métodos

| Nome | Descrição | Retornos |
| ---- | --------- | -------- |
[draw](node_ui_draw.md) | Desenha todos os [Control](../node_ui_control/node_ui_control.md). | `nil`
[drawDebug](node_ui_draw_debug.md) | Desenha a depuração de todos os [Control](../node_ui_control/node_ui_control.md) na raiz. | `nil`
[getBaseDimensions](node_ui_get_base_dimensions.md) | Retorna a dimensão base dos [Control](../node_ui_control/node_ui_control.md) na raiz. | `number`, `number`
[getBaseHeight](node_ui_get_base_height.md) | Retorna a altura base dos [Control](../node_ui_control/node_ui_control.md) na raiz. | `number`
[getBasePosition](node_ui_get_base_position.md) | Retorna a posição base dos [Control](../node_ui_control/node_ui_control.md) na raiz. | `number`, `number`
[getBaseWidth](node_ui_get_base_width.md) | Retorna o comprimento base dos [Control](../node_ui_control/node_ui_control.md) na raiz. | `number`
[getBaseX](node_ui_get_base_x.md) | Retorna a posição horizontal base dos [Control](../node_ui_control/node_ui_control.md) na raiz. | `number`
[getBaseY](node_ui_get_base_y.md) | Retorna a posição vertical base dos [Control](../node_ui_control/node_ui_control.md) na raiz. | `number`
[getRootChildCount](node_ui_get_root_child_count.md) | Retorna a quantidade de [Control](../node_ui_control/node_ui_control.md) na raiz. | `number`
[keypressed](node_ui_keypressed.md) | Lida com o pressionar de teclas. | `nil`
[keyreleased](node_ui_keyreleased.md) | Lida com o soltar de teclas. | `nil`
[mousemoved](node_ui_mousemoved.md) | Lida com o movimento do mouse. | `nil`
[mousepressed](node_ui_mousepressed.md) | Lida com o pressionar de um botão do mouse. | `nil`
[mousereleased](node_ui_mousereleased.md) | Lida com o soltar de um botão do mouse. | `nil`
[setBaseDimensions](node_ui_set_base_dimensions.md) | Define a dimensão base dos [Control](../node_ui_control/node_ui_control.md) na raiz. | `nil`
[setBaseHeight](node_ui_set_base_height.md) | Define a altura base dos [Control](../node_ui_control/node_ui_control.md) na raiz. | `nil`
[setBasePosition](node_ui_set_base_position.md) | Define a posição base dos [Control](../node_ui_control/node_ui_control.md). | `nil`
[setBaseWidth](node_ui_set_base_width.md) | Define o comprimento base dos [Control](../node_ui_control/node_ui_control.md) na raiz. | `nil`
[setBaseX](node_ui_set_base_x.md) | Define a posição x base dos [Control](../node_ui_control/node_ui_control.md) na raiz. | `nil`
[setBaseY](node_ui_set_base_y.md) | Define a posição y base dos [Control](../node_ui_control/node_ui_control.md) na raiz. | `nil`
[update](node_ui_update.md) | Atualiza todos os [Control](../node_ui_control/node_ui_control.md). | `nil`
[wheelmoved](node_ui_wheelmoved.md) | Lida com o movimento da roda do mouse. | `nil`
