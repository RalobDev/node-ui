import re
import shutil
from pathlib import Path

CLASS_NAME_PATTERN = r"---\s*@class\s+([A-Za-z_][\w\.]*)"

class DocsDetails:
    def __init__(self):
        self.brief_lines = []
        self.description_lines = []

class ClassField:
    name: str
    type: str
    description: str

    def __init__(self, name: str, type: str, description: str):
        self.name: str = name
        self.type: str = type
        self.description: str = description

class FunctionParameter:
    def __init__(self, name: str, type: str, brief: str):
        self.name: str = name
        self.type: str = type
        self.brief: str = brief

class FunctionReturn:
    def __init__(self, type: str, name: str, brief: str):
        self.type: str = type
        self.name: str = name
        self.brief: str = brief

class ClassFunction:
    def __init__(self):
        self.name: str = ""
        self.docs_details: DocsDetails = DocsDetails()
        self.parameters: list[FunctionParameter] = []
        self.returns: list[FunctionReturn] = []
        self.use_self: bool = True

class CodeClass:
    def __init__(self):
        self.name: str = ""
        self.base_name: str = ""
        self.docs_details: DocsDetails = DocsDetails()
        self.fields: list[ClassField] = []
        self.functions: list[ClassFunction] = []


def main() -> None:
    all_classes: dict[str, CodeClass] = {}
    for file in Path("node-ui/nodes").rglob("*.lua"):
        if file.is_file():
            classes = parse_file(file)
            for class_key in classes:
                all_classes[class_key] = classes[class_key]

    classes = parse_file(Path("node-ui/init.lua"))
    all_classes["NodeUI"] = classes["NodeUI"]

    create_docs_api(all_classes)
    create_api_index(all_classes)

def create_docs_api(classes: dict[str, CodeClass]) -> None:
    api_path = Path("docs/api")
    if api_path.exists():
        shutil.rmtree(api_path)
    api_path.mkdir(parents=True, exist_ok=True)

    for code_class in classes.values():
        class_path = Path(f"{api_path}/{to_snake(code_class.name)}")
        class_path.mkdir(parents=True, exist_ok=True)

        create_class_api(code_class, class_path, classes)
        create_function_api(code_class, class_path, classes)

def create_class_api(code_class: CodeClass, class_path: Path, classes: dict[str, CodeClass]) -> None:
    md_path: Path = Path(f"{class_path}/{to_snake(code_class.name)}.md")
    content_lines: list[str] = []

    content_lines.append(f"[<kbd>Voltar</kbd>](../class_reference.md)")
    content_lines.append("")

    content_lines.append(f"# {code_class.name}")
    content_lines.append("")

    for line in code_class.docs_details.brief_lines:
        content_lines.append(line)
    content_lines.append("")

    for line in code_class.docs_details.description_lines:
        content_lines.append(line)
    content_lines.append("")

    content_lines.append("## Métodos")
    content_lines.append("")

    content_lines.append("| Nome | Descrição | Retornos |")
    content_lines.append("| ---- | --------- | -------- |")

    for function in sorted(code_class.functions, key=lambda c: c.name):
        return_types: list[str] = []
        for _return in function.returns:
            return_types.append(f"`{_return.type}`")
        returns = ", ".join(return_types) or "`nil`"

        content_lines.append(f"[{function.name}]({to_snake(code_class.name)}_{to_snake(function.name)}.md) | {" ".join(function.docs_details.brief_lines)} | {returns}")
    content_lines.append("")

    create_class_types_api(code_class, content_lines)

    link_content_types(content_lines, classes, "..")
    content: str = "\n".join(content_lines)
    md_path.write_text(content, encoding="utf-8")

def create_function_api(code_class: CodeClass, class_path: Path, classes: dict[str, CodeClass]) -> None:
    for function in code_class.functions:
        md_path: Path = Path(f"{class_path}/{to_snake(code_class.name)}_{to_snake(function.name)}.md")
        content_lines: list[str] = []

        content_lines.append(f"[<kbd>Voltar</kbd>]({to_snake(code_class.name)}.md)")
        content_lines.append("")

        separator = ":" if function.use_self else "."

        content_lines.append(f"# {code_class.name}{separator}{function.name}()")
        content_lines.append("")

        for line in function.docs_details.brief_lines:
            content_lines.append(line)
        content_lines.append("")

        for line in function.docs_details.description_lines:
            content_lines.append(line)
        content_lines.append("")

        content_lines.append("## Sinopse")
        content_lines.append("")

        return_types: list[str] = []
        for _return in function.returns:
            return_types.append(_return.name)
        returns = ", ".join(return_types)
        if returns:
            returns += " = "

        param_names: list[str] = []
        for parameter in function.parameters:
            param_names.append(parameter.name)
        params = ", ".join(param_names)

        content_lines.append("```lua")
        content_lines.append(f"{returns}{code_class.name}:{function.name}({params})")
        content_lines.append("```")
        content_lines.append("")

        content_lines.append("## Argumentos")

        if len(param_names) == 0:
            content_lines.append("Nada.")
        else:
            for parameter in function.parameters:
                content_lines.append(f"- **`{parameter.type}` {parameter.name}** <br>")
                content_lines.append(f"{parameter.brief}")
        content_lines.append("")

        content_lines.append("## Retornos")

        if len(return_types) == 0:
            content_lines.append("Nenhum.")
        else:
            for _return in function.returns:
                content_lines.append(f"- `{_return.type}` **{_return.name}** <br>")
                content_lines.append(f"{_return.brief}")
        content_lines.append("")

        link_content_types(content_lines, classes, "..")
        content: str = "\n".join(content_lines)
        md_path.write_text(content, encoding="utf-8")

def create_api_index(classes: dict[str, CodeClass]) -> None:
    md_path: Path = Path("docs/api/class_reference.md")
    content_lines: list[str] = []

    content_lines.append("# Referência de Classes")
    content_lines.append("")

    for code_class in sorted(classes.values(), key=lambda c: c.base_name):
        content_lines.append(f"- **`{code_class.base_name}`**")

    link_content_types(content_lines, classes, "")
    content: str = "\n".join(content_lines)
    md_path.write_text(content, encoding="utf-8")

def create_class_types_api(code_class: CodeClass, content_lines: list[str]) -> None:
    types_path = Path(f"node-ui/node-types/{to_snake(code_class.base_name)}_types.lua")
    if not types_path.exists():
        return

    content_lines.append("## Tipos")

    is_parsing_type: bool = False
    pending: list[str] = []
    lines: list[str] = types_path.read_text(encoding="utf-8").splitlines()

    for i in range(len(lines)):
        line = lines[i]

        if line.startswith("--- @alias"):
            type_name = line.split(".")[-1]
            pending = []

            pending.append(f"### {type_name}")
            pending.append("")

            docs_details = parse_docs_details(lines, i + 1)

            for l in docs_details.brief_lines:
                pending.append(l)
            pending.append("")

            for l in docs_details.description_lines:
                pending.append(l)
            pending.append("")

            is_parsing_type = True

        elif line.startswith("--- |") and is_parsing_type:
            match = re.match(r'---\s*\|\s*"([^"]+)"\s*(.*)', line)
            if match:
                value = match.group(1)
                description = match.group(2).strip()
                pending.append(f"- `{value}`")
                if description:
                    pending.append(description)
            else:
                pending = []
                is_parsing_type = False

        elif is_parsing_type:
            content_lines.extend(pending)
            content_lines.append("")
            content_lines.append("---")
            pending = []
            is_parsing_type = False

    # Fecha o último alias caso o arquivo termine sem linha em branco
    if is_parsing_type and pending:
        content_lines.extend(pending)
        content_lines.append("")
        content_lines.append("---")

def to_snake(name: str) -> str:
    # troca ponto por underscore primeiro
    name = name.replace(".", "_")

    # separa siglas + palavras normais
    name = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", name)
    name = re.sub(r"([A-Z]+)([A-Z][a-z])", r"\1_\2", name)

    return name.lower()

# Analísa um arquivo.
def parse_file(path: Path) -> dict[str, CodeClass]:
    classes: dict[str, CodeClass] = {}
    lines: list[str] = path.read_text(encoding="utf-8").splitlines()

    for line_number, line in enumerate(lines, start=1):

        if line.startswith("--- @class"):
            code_class: CodeClass = parse_class(lines, line_number)
            classes[code_class.name] = code_class
        elif line.startswith("function"):
            parse_function(lines, line_number, classes)

    return classes

# Analísa uma classe.
def parse_class(lines: list[str], start_line_number: int) -> CodeClass:
    code_class: CodeClass = CodeClass()

    for line_number, line in enumerate(lines[start_line_number - 1:], start_line_number):
        # Atribui o nome da classe e os detalhes de sua documentação.
        if line.startswith("--- @class"):
            match = re.match(CLASS_NAME_PATTERN, line)
            if match:
                code_class.name = match.group(1)
                code_class.base_name = code_class.name.split(".")[-1]
                code_class.docs_details = parse_docs_details(lines, line_number)
        elif line.startswith("--- @field"):
            if is_public_field(line):
                code_class.fields.append(parse_class_field(line))
        else:
            break

    return code_class

# Pega os detalhes de documentação acima de um linha.
def parse_docs_details(lines: list[str], start_line_number: int) -> DocsDetails:
    docs_details = DocsDetails()

    docs_lines = []

    for i in range(start_line_number - 2, -1, -1):
        line = lines[i]

        if not line.startswith("---"):
            break

        docs_lines.insert(0, line)

    text_lines = []

    for line in docs_lines:
        content = line[3:].strip()

        if content.startswith("@"):
            continue

        text_lines.append(content or " ")

    if not text_lines:
        return docs_details

    # ===== CORREÇÃO PRINCIPAL =====

    brief = []
    description = []

    is_brief = True

    for line in text_lines:
        if line == "":
            # só separa se já houver conteúdo no brief
            if brief:
                is_brief = False
            continue

        if is_brief:
            brief.append(line)
        else:
            description.append(line)

    docs_details.brief_lines = brief
    docs_details.description_lines = description

    return docs_details

# Analisa e retorna o ClassField de uma linha.
def parse_class_field(line: str) -> ClassField:
    line = line.strip()

    m = re.match(r"---\s*@field\s+(.+)", line)
    if not m:
        return None

    rest = m.group(1).strip()
    name, type, brief = split_type_and_brief(rest)

    return ClassField(name, type, brief)

# Retorna se o "--- @field" de uma linha é público.
def is_public_field(line: str) -> bool:
    match = re.match(r"---\s*@field(?:\s+(private|protected))?\s+(\w+)", line)
    if not match:
        return False

    return match.group(1) is None

# Analisa uma função e armazena seu ClassFunction na classe correspondente.
def parse_function(lines: str, start_line_number: int, classes: dict[str, CodeClass]) -> None:
    class_function: ClassFunction = ClassFunction()
    above_lines: list[str] = []

    for i in range(start_line_number - 2, -1, -1):
        line = lines[i]

        if line.startswith("--- @"):
            above_lines.insert(0, line)
            if line.startswith("--- @private") or line.startswith("--- @protected"):
                return
        elif line.startswith("---"):
            class_function.docs_details = parse_docs_details(lines, start_line_number)
            break
        elif line == "":
            break

    function_line = lines[start_line_number - 1]
    class_name, func_name = parse_function_line(function_line)
    if class_name == "":
        return

    if not ":" in function_line:
        class_function.use_self = False

    class_function.name = func_name

    for line in above_lines:
        if line.startswith("--- @param"):
            function_param = parse_param(line)
            class_function.parameters.append(function_param)
        elif line.startswith("--- @return"):
            function_return = parse_return(line)
            class_function.returns.append(function_return)

    for code_class in classes.values():
        if code_class.base_name == class_name:
            code_class.functions.append(class_function)
            break

def parse_function_line(line: str) -> tuple[str, str]:
    match = re.match(r"^function\s+([\w\.]+)(?::|\.)(\w+)\s*\(", line)
    if not match:
        return "", ""

    class_name = match.group(1)
    func_name = match.group(2)

    return class_name, func_name

def parse_param(line: str) -> FunctionParameter:
    line = line.strip()

    m = re.match(r"---\s*@param\s+(.+)", line)
    if not m:
        return None

    rest = m.group(1).strip()
    name, type, brief = split_type_and_brief(rest)

    return FunctionParameter(name, type, brief)

def parse_return(line: str) -> FunctionReturn:
    line = line.strip()

    m = re.match(r"---\s*@return\s+(.+)", line)
    if not m:
        return None

    rest = m.group(1).strip()
    type, name, brief = split_type_and_brief(rest)

    return FunctionReturn(type, name, brief)

def split_type_and_brief(text: str) -> tuple[str, str, str]:
    tokens = text.split()

    name = tokens[0]

    type_tokens = []
    depth_angle = 0  # < >
    depth_paren = 0   # ( )
    depth_brace = 0   # { }

    i = 1
    for i in range(1, len(tokens)):
        t = tokens[i]

        # atualiza profundidade ANTES de decidir
        depth_angle += t.count("<") - t.count(">")
        depth_paren += t.count("(") - t.count(")")
        depth_brace += t.count("{") - t.count("}")

        type_tokens.append(t)

        # só termina type se tudo estiver fechado
        if depth_angle <= 0 and depth_paren <= 0 and depth_brace <= 0:
            # próxima palavra provavelmente é brief se não parecer tipo
            if i + 1 < len(tokens):
                break

    type_str = " ".join(type_tokens)

    brief = " ".join(tokens[i+1:]) if i + 1 < len(tokens) else ""

    return name, type_str, brief

def link_content_types(content_lines: list[str], classes: dict[str, CodeClass], relative_path: str) -> None:
    if relative_path:
        relative_path += "/"

    for i in range(len(content_lines)):
        line = content_lines[i]
        for type_base_name in extract_backticked_bold(line):
            for code_class in classes.values():
                if code_class.base_name == type_base_name:
                    snake_name = to_snake(code_class.name)
                    type_md_path = f"{relative_path}{snake_name}/{snake_name}.md"
                    line = line.replace(
                        f"**`{type_base_name}`**",
                        f"[{type_base_name}]({type_md_path})"
                    )

        for name in extract_backticked(line):
            for code_class in classes.values():
                if code_class.name == name:
                    snake_name = to_snake(code_class.name)
                    type_md_path = f"{relative_path}{snake_name}/{snake_name}.md"
                    line = line.replace(
                        f"`{name}`",
                        f"[`{name}`]({type_md_path})"
                    )

        content_lines[i] = line

def extract_backticked_bold(text: str) -> list[str]:
    return re.findall(r"\*\*`([^`]+)`\*\*", text)

def extract_backticked(text: str) -> list[str]:
    return re.findall(r"`([^`]+)`", text)

main()
