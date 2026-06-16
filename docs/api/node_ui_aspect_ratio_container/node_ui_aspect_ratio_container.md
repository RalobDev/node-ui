[<kbd>Voltar</kbd>](../class_reference.md)

# NodeUI.AspectRatioContainer

**AspectRatioContainer** é um tipo de [Container](../node_ui_container/node_ui_container.md) que ajusta seus filhos mantendo uma proporção de
aspecto (aspect ratio), aplicando diferentes modos de escala como `FIT` e `COVER`, além de controle de alinhamento.
 
## Descrição
 
O **AspectRatioContainer** estende [Container](../node_ui_container/node_ui_container.md) adicionando um sistema de
escala baseado em proporção. Ele calcula automaticamente um fator de
escala com base no tamanho do container e no tamanho dos filhos,
permitindo que o conteúdo seja ajustado sem distorção.
 
Ele suporta diferentes modos de escala através de `setStretchMode()`.
 
Também permite controle de alinhamento horizontal e vertical dos filhos através de `setAlignmentMode()`.


## Métodos

| Nome | Descrição | Retornos |
| ---- | --------- | -------- |
[connect](node_ui_aspect_ratio_container_connect.md) | Cria uma conexão em determinado sinal do [Control](../node_ui_control/node_ui_control.md). | `nil`
[disconnect](node_ui_aspect_ratio_container_disconnect.md) | Remove a conexão de um sinal do [Control](../node_ui_control/node_ui_control.md). | `nil`
[getAlignmentMode](node_ui_aspect_ratio_container_get_alignment_mode.md) | Retorna o `AlignmentMode` aplicado aos filhos. | `NodeUI.Control.AlignmentMode`
[getStretchMode](node_ui_aspect_ratio_container_get_stretch_mode.md) | Retorna a maneira como escalona os filhos. | `NodeUI.AspectRatioContainer.StretchMode`
[new](node_ui_aspect_ratio_container_new.md) | Cria um novo **AspectRatioContainer**. | [`NodeUI.AspectRatioContainer`](../node_ui_aspect_ratio_container/node_ui_aspect_ratio_container.md)
[setAlignmentMode](node_ui_aspect_ratio_container_set_alignment_mode.md) | Define o `AlignmentMode` aplicado aos filhos. | `nil`
[setStretchMode](node_ui_aspect_ratio_container_set_stretch_mode.md) | Define a maneira como escalona os filhos. | `nil`

## Tipos
### StretchMode



- `STRETCH_WIDTH`
Escala para o comprimento.
- `STRETCH_HEIGHT`
Escala para a altura.
- `FIT`
Escala usando o menor fator entre largura e altura (sem overflow).
- `COVER`
Escala usando o maior fator entre largura e altura (cobre toda área).

---