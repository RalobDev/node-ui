# NodeUI

NodeUI é uma biblioteca de UI inspirada na estrutura dos nós de controle da Godot, mas com diversas adaptações para atender melhor ao Love2D e aos objetivos do projeto.

> [!TIP]
> Visite a documentação completa: https://node-ui.readthedocs.io/pt-br/latest/

## Filosofia

O NodeUI é inspirado na arquitetura dos nós de controle da Godot, mas não busca reproduzir sua API exatamente. Algumas funcionalidades
foram simplificadas ou adaptadas para se encaixar melhor no Love2D e nos objetivos da biblioteca.

## Sumário

* [Instalação](#instalação)
* [Primeiros Passos](#primeiros-passos)
* [Modificando os Nós](#modificando-os-nós)
* [Sinais](#sinais)
* [Removendo Nós](#removendo-nós)

## Instalação

Copie a pasta **node-ui** para o seu projeto e carregue-a via código:

```text
project
└── libs
    └── node-ui
```

```lua
local NodeUI = require("libs.node-ui")
```

> [!TIP]
> A biblioteca possui um sistema de detecção de diretórios bastante competente, então fica a seu critério onde colocá-la.

## Primeiros Passos

Antes de tudo, é importante encaminhar os callbacks do Love2D para a biblioteca, pois ela depende deles para funcionar corretamente.

Não é necessário chamar `update()` ou `draw()` em cada nó criado. O próprio `NodeUI` gerencia a atualização, renderização e propagação de eventos para toda a árvore de nós.

```lua
function love.update(dt)
    NodeUI.update(dt)
end

function love.draw()
    NodeUI.draw()
    NodeUI.drawDebug() -- Opcional
end

function love.mousepressed(x, y, button, istouch, presses)
    NodeUI.mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    NodeUI.mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
    NodeUI.mousemoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
    NodeUI.wheelmoved(x, y)
end
```

Todos os nós disponíveis possuem uma referência no módulo principal:

```lua
local NodeUI.Control
local NodeUI.Container
...
```

Para criar uma árvore de nós, utilize o método `addChild()`, disponível em todos os nós.

```lua
local root_control = NodeUI.Control:new(0, 0, 800, 600)

local root_child = root_control:addChild(
    NodeUI.Control:new(0, 0, 200, 200)
)
```

O primeiro nó da árvore atua como nó raiz e responde diretamente à posição e às dimensões base definidas pelo `NodeUI`.

## Modificando os Nós

Cada nó possui uma série de propriedades que controlam sua aparência e comportamento.

Grande parte dessas propriedades é privada ou protegida, mas normalmente existe um **setter** e um **getter** para modificar e acessar seus valores de forma segura.

Propriedades e métodos privados/protegidos são prefixados com `_`. Além disso, a maioria dos LSPs para Lua consegue ocultá-los ou emitir avisos quando são acessados diretamente graças às anotações `---@private` e `---@protected`.

**Exemplo**

```lua
local control = NodeUI.Control:new(0, 0, 800, 600)

control:setLayout("CENTER")

local layout = control:getLayout()

print(layout) -- Output: "CENTER"
```

## Sinais

Os nós possuem um sistema de sinais simples, porém poderoso.

Quando um sinal é emitido, todos os callbacks conectados a ele são executados automaticamente. Os sinais disponíveis podem ser consultados na documentação de cada nó na [Referência de Classes](docs/api/class_reference.md).

Vamos supor que desejamos saber quando um nó ganha ou perde o foco do mouse. Para isso, conectamos um callback ao sinal `CHANGED_HOVER`.

### Callback sem dono

Quando o callback não utiliza `self`, basta passar a função diretamente como segundo argumento.

```lua
local control = NodeUI.Control:new(0, 0, 800, 600)

local callback = function(focused)
    print(focused)
end

control:connect("CHANGED_HOVER", callback)

-- Se control receber o foco do mouse:
-- Output: true

control:disconnect("CHANGED_HOVER", callback)
```

### Callback com dono

Quando o callback pertence a um objeto e utiliza `self`, passe o nome do método como uma string e informe também o objeto dono.

```lua
local control = NodeUI.Control:new(0, 0, 800, 600)

local owner = {
    name = "Anything",

    on_mouse_focus_changed = function(self, focused)
        print(self.name, focused)
    end
}

control:connect(
    "CHANGED_HOVER",
    "on_mouse_focus_changed",
    owner
)

-- Se control receber o foco do mouse:
-- Output: "Anything" true

control:disconnect(
    "CHANGED_HOVER",
    "on_mouse_focus_changed",
    owner
)
```

## Removendo Nós

Para remover um nó filho de um nó pai, utilize `removeChild()`.

Caso deseje destruir completamente um nó, utilize `queueFree()`. Isso garante que o `NodeUI` possa remover todas as referências internas associadas a ele de forma segura.

```lua
local root_control = NodeUI.Control:new(0, 0, 800, 600)

local root_child = root_control:addChild(
    NodeUI.Control:new(0, 0, 200, 200)
)

root_control:removeChild(root_child) -- Remove da árvore.
root_child:queueFree() -- Agenda a destruição do nó.
```
