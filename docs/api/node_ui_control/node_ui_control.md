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
[connect](node_ui_control_connect.md) | Cria uma conexão em determinado sinal do **Control**.   O `owner` é a tabela que possui o `method`, que deve ser uma `string`. Caso não seja passado um `owner`, o `method` deve ser uma `function`.   Quando é passado um `owner` o método é chamado desta forma: `owner.method(owner, ...)` para respeitar o padrão `self`. | `nil`
[disconnect](node_ui_control_disconnect.md) | Remove a conexão de um sinal do **Control**. | `nil`
[getBaseDimensions](node_ui_control_get_base_dimensions.md) | Retorna a dimensão base do **Control**. É a dimensão definida ao criar o **Control** e ao chamar `Control:setDimensions()`. | `number`, `number`
[getBaseHeight](node_ui_control_get_base_height.md) | Retorna a altura base do **Control**. É a altura definida ao criar o **Control** e ao chamar `Control:setHeight()`. | `number`
[getBaseWidth](node_ui_control_get_base_width.md) | Retorna o comprimento base do **Control**. É o comprimento definido ao criar o **Control** e ao chamar `Control:setWidth()`. | `number`
[getChildren](node_ui_control_get_children.md) | Retorna uma tabela com todos os filhos do **Control**. | `NodeUI.Control[]`
[getClipContent](node_ui_control_get_clip_content.md) | Retorna se o recorte de conteúdo do **Control** está ativado. | `boolean`
[getDimensions](node_ui_control_get_dimensions.md) | Retorna a dimensão do **Control**. | `number`, `number`
[getHeight](node_ui_control_get_height.md) | Retorna a altura do **Control**. | `number`
[getLayout](node_ui_control_get_layout.md) | Retorna o layout do **Control**. | `NodeUI.Control.Layout`
[getMinimumDimensions](node_ui_control_get_minimum_dimensions.md) | Retorna a dimensão mínima do **Control**. | `number`, `number`
[getMinimumHeight](node_ui_control_get_minimum_height.md) | Retorna a altura mínima do **Control**. | `number`
[getMinimumWidth](node_ui_control_get_minimum_width.md) | Retorna o comprimento mínimo do **Control**. | `number`
[getMouseFilter](node_ui_control_get_mouse_filter.md) | Retorna o filtro de mouse do **Control**. | `NodeUI.Control.MouseFilter`
[getParent](node_ui_control_get_parent.md) | Retorna o parente do **Control** ou `nil` caso ela não tenha um. | `NodeUI.Control?`
[getPosition](node_ui_control_get_position.md) | Retorna a posição do **Control**. | `number`, `number`
[getSizeFlags](node_ui_control_get_size_flags.md) | Retorna a size flags do `axis`. | `NodeUI.Control.SizeFlags`
[getWidth](node_ui_control_get_width.md) | Retorna o comprimento do **Control**. | `number`
[getX](node_ui_control_get_x.md) | Retorna a posição x do **Control**. | `number`
[getY](node_ui_control_get_y.md) | Retorna a posição y do **Control**. | `number`
[hasMouseFocus](node_ui_control_has_mouse_focus.md) | Retorna se o **Control** possui o foco do mouse. | `boolean`
[isQueuedForDeletion](node_ui_control_is_queued_for_deletion.md) | Retorna se o **Control** está na fila de deleção. | `boolean`
[isVisible](node_ui_control_is_visible.md) | Retorna se o **Control** está visível ou não. | `boolean`
[new](node_ui_control_new.md) | Cria um novo **Control**. | [`NodeUI.Control`](../node_ui_control/node_ui_control.md)
[queueFree](node_ui_control_queue_free.md) | Marca para deletar o **Control** no próximo `love.update()`.   Os nós não são coletados pelo coletor de lixo do **Lua** ao ser definido com `nil`, pois o próprio módulo [NodeUI](../node_ui/node_ui.md) armazena uma referência deles. Assim é necessário chamar `queueFree` quando quiser remover um nó da biblioteca.   Ao ser deletado o nó e seus filhos são removidos da raiz do **NodeUI**, mas quaisquer referências fora do módulo continuarão existindo. | `nil`
[removeChild](node_ui_control_remove_child.md) | Remove o `child` do **Control**. | `nil`
[setClipContent](node_ui_control_set_clip_content.md) | Define o recorte de conteúdo do **Control**. Se `true`, clipa o desenho dos filhos à área do **Control**. Por padrão ativa o recorte de conteúdo. | `nil`
[setDimensions](node_ui_control_set_dimensions.md) | Define a dimensão do **Control**. | `nil`
[setHeight](node_ui_control_set_height.md) | Define a altura do **Control**. | `nil`
[setLayout](node_ui_control_set_layout.md) | Define o layout do **Control**. | `nil`
[setMinimumDimensions](node_ui_control_set_minimum_dimensions.md) | Define a dimensão mínima do **Control**. | `nil`
[setMinimumHeight](node_ui_control_set_minimum_height.md) | Define a altura mínima do **Control**. | `nil`
[setMinimumWidth](node_ui_control_set_minimum_width.md) | Define o comprimento mínimo do **Control**. | `nil`
[setMouseFilter](node_ui_control_set_mouse_filter.md) | Define o filtro de mouse do **Control**. | `nil`
[setPosition](node_ui_control_set_position.md) | Define a posição do **Control** | `nil`
[setSizeFlags](node_ui_control_set_size_flags.md) | Define a size flags do `axis`. | `nil`
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
Quando um botão do mouse é pressionado. -> fun(x: number, y: number, button: number, istouch: bool, presses: int)
- `MOUSE_RELEASED`
Quando um botão do mouse é solto. -> fun(x: number, y: number, button: number, istouch: bool, presses: int)
- `MOUSE_MOVED`
Quando o mouse se move sobre o Control. -> fun(x: number, y: number, dx: number, dy: number, istouch: bool)
- `WHEEL_MOVED`
Quando o scroll do mouse é usado. -> fun(x: number, y: number)
- `MOUSE_FOCUS_CHANGED`
Quando o foco de mouse entra ou sai. -> fun(focused: bool)
- `CHILD_ADDED`
Quando um filho é adicionado. -> fun(child: NodeUI.Control)
- `CHILD_REMOVED`
Quando um filho é removido. -> fun(child: NodeUI.Control)

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
### SizeFlags

Define como o controle ocupa o espaço disponível.


- `FILL`
Expande para preencher todo o espaço disponível.
- `EXPAND`
Expande para preencher o espaço disponíveis divido entre outros Control que também expandem.
- `SHRINK_BEGIN`
Mantém o tamanho mínimo e alinha no início.
- `SHRINK_CENTER`
Mantém o tamanho mínimo e centraliza.
- `SHRINK_END`
Mantém o tamanho mínimo e alinha no fim.

---
### Edge

Representa os lados de um retângulo.


- `LEFT`
- `RIGHT`
- `TOP`
- `BOTTOM`

---
### Corner

Representa os cantos de um retângulo.


- `TOP_LEFT`
- `TOP_RIGHT`
- `BOTTOM_LEFT`
- `BOTTOM_RIGHT`

---