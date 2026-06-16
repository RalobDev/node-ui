[<kbd>Voltar</kbd>](../class_reference.md)

# NodeUI.Control

O **Control** é a classe base de todos os elementos da interface do [NodeUI](../node_ui/node_ui.md). Ela fornece funcionalidades fundamentais
como hierarquia de nós, sistema de layout, renderização, processamento de eventos de entrada e gerenciamento de sinais.
 
## Descrição
 
O **Control** representa um elemento visual da interface e serve como base para todos os controles da biblioteca.
Cada controle pode possuir um pai e múltiplos filhos, formando uma árvore de UI organizada hierarquicamente.
 
A classe permite posicionar e dimensionar controles em relação ao seu pai ou à área base da interface. Além disso,
gerencia visibilidade, foco do mouse, renderização, atualização, clipping de conteúdo e propagação de eventos de entrada.


## Métodos

| Nome | Descrição | Retornos |
| ---- | --------- | -------- |
[addChild](node_ui_control_add_child.md) | Adiciona um filho ao **Control**. O filho adicionado é retornado, simplificando a criação e referência de filhos. | `control`
[connect](node_ui_control_connect.md) | Cria uma conexão em determinado sinal do **Control**. | `nil`
[disconnect](node_ui_control_disconnect.md) | Remove a conexão de um sinal do **Control**. | `nil`
[getChildren](node_ui_control_get_children.md) | Retorna uma tabela com todos os filhos do **Control**. | `NodeUI.Control[]`
[getDimensions](node_ui_control_get_dimensions.md) | Retorna a dimensão do **Control**. | `number`, `number`
[getHeight](node_ui_control_get_height.md) | Retorna a altura do **Control**. | `number`
[getLayout](node_ui_control_get_layout.md) | Retorna o layout do **Control**. | `NodeUI.Control.Layout`
[getMinimumDimensions](node_ui_control_get_minimum_dimensions.md) | Retorna a dimensão mínima do **Control**. | `number`, `number`
[getMinimumHeight](node_ui_control_get_minimum_height.md) | Retorna a altura mínima do **Control**. | `number`
[getMinimumWidth](node_ui_control_get_minimum_width.md) | Retorna o comprimento mínimo do **Control**. | `number`
[getMouseFilter](node_ui_control_get_mouse_filter.md) | Retorna o filtro de mouse do **Control**. | `NodeUI.Control.MouseFilter`
[getParent](node_ui_control_get_parent.md) | Retorna o parente do **Control** ou `nil` caso ela não tenha um. | `NodeUI.Control?`
[getPosition](node_ui_control_get_position.md) | Retorna a posição do **Control**. | `number`, `number`
[getWidth](node_ui_control_get_width.md) | Retorna o comprimento do **Control**. | `number`
[getX](node_ui_control_get_x.md) | Retorna a posição x do **Control**. | `number`
[getY](node_ui_control_get_y.md) | Retorna a posição y do **Control**. | `number`
[isQueuedForDeletion](node_ui_control_is_queued_for_deletion.md) | Retorna se o **Control** está na fila de deleção. | `boolean`
[isVisible](node_ui_control_is_visible.md) | Retorna se o **Control** está visível ou não. | `boolean`
[new](node_ui_control_new.md) | Cria um novo **Control**. | [`NodeUI.Control`](../node_ui_control/node_ui_control.md)
[queueFree](node_ui_control_queue_free.md) | Marca para deletar o **Control** no próximo `love.update()`.   Os nós não são coletados pelo coletor de lixo do **Lua** ao ser definido com `nil`, pois o próprio módulo [NodeUI](../node_ui/node_ui.md) armazena uma referência deles. Assim é necessário chamar `queueFree` quando quiser remover um nó da biblioteca.   Ao ser deletado o nó e seus filhos são removidos da raiz do **NodeUI**, mas quaisquer referências fora do módulo continuarão existindo. | `nil`
[removeChild](node_ui_control_remove_child.md) | Remove o `child` do **Control**. | `nil`
[setDimensions](node_ui_control_set_dimensions.md) | Define a dimensão do **Control**. | `nil`
[setHeight](node_ui_control_set_height.md) | Define a altura do **Control**. | `nil`
[setLayout](node_ui_control_set_layout.md) | Define o layout do **Control**. | `nil`
[setMinimumDimensions](node_ui_control_set_minimum_dimensions.md) | Define a dimensão mínima do **Control**. | `nil`
[setMinimumHeight](node_ui_control_set_minimum_height.md) | Define a altura mínima do **Control**. | `nil`
[setMinimumWidth](node_ui_control_set_minimum_width.md) | Define o comprimento mínimo do **Control**. | `nil`
[setMouseFilter](node_ui_control_set_mouse_filter.md) | Define o filtro de mouse do **Control**. | `nil`
[setPosition](node_ui_control_set_position.md) | Define a posição do **Control** | `nil`
[setVisible](node_ui_control_set_visible.md) | Define a visibilidade do **Control**. Por padrão ativa a visibilidade. | `nil`
[setWidth](node_ui_control_set_width.md) | Define o comprimento do **Control**. | `nil`
[setX](node_ui_control_set_x.md) | Define a posição horizontal do **Control** | `nil`
[setY](node_ui_control_set_y.md) | Define a posição vertical do **Control** | `nil`

## Tipos
### Layout

Representa os modos de layout disponíveis para posicionamento de um Control.
 
O layout define como o Control é posicionado e redimensionado dentro do
retângulo base do pai (ou da raiz quando não há pai).


- `TOP_LEFT`
- `TOP_RIGHT`
- `BOTTOM_LEFT`
- `BOTTOM_RIGHT`
- `CENTER_LEFT`
- `CENTER_RIGHT`
- `CENTER_TOP`
- `CENTER_BOTTOM`
- `CENTER`
- `LEFT_WIDE`
- `RIGHT_WIDE`
- `TOP_WIDE`
- `BOTTOM_WIDE`
- `VCENTER_WIDE`
- `HCENTER_WIDE`
- `HEXPAND`
- `VEXPAND`
- `EXPAND`
- `FULL_RECT`
- `CUSTOM`

---
### MouseFilter

Define como eventos de mouse são propagados entre Controls.


- `STOP`
Consome o evento e impede propagação.
- `PASS`
Permite propagação após processar o evento.
- `IGNORE`
Ignora o evento completamente.

---
### Signals

Lista de sinais emitidos por um Control.


- `MOUSE_PRESSED`
Quando um botão do mouse é pressionado.
- `MOUSE_RELEASED`
Quando um botão do mouse é solto.
- `MOUSE_MOVED`
Quando o mouse se move sobre o Control.
- `WHEEL_MOVED`
Quando o scroll do mouse é usado.
- `MOUSE_FOCUS_CHANGED`
Quando o foco de mouse entra ou sai.

---
### AlignmentMode

Modo de alinhamento de algum elemento.


- `BEGIN`
Alinhado ao início.
- `CENTER`
Alinhado ao meio.
- `END`
Alinhado ao fim.

---
### Axis

Eixo horizontal ou vertical.


- `HORIZONTAL`
- `VERTICAL`

---