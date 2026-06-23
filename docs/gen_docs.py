import re
import shutil
from pathlib import Path
from enum import Enum, auto

_references_points: list[str] = []

#region Enums

# O tipo de uma CodeClass.
class CodeClassType(Enum):
    NODE = auto()
    RESOURCE = auto()
    ALIAS = auto()

#endregion


#region Classes

# Classe base para tudo que possui uma documentação.
class DocClass:
    def __init__(self):
        self.name: str = ""              # Nome da classe.
        self.brief: list[str] = []       # Breve descrição da classe.
        self.description: list[str] = [] # Descrição completa da classe.


# Representa o método de uma CodeClass.
class CodeClassMethod(DocClass):
    def __init__(self):
        super().__init__()

        self.caller: str = ""                # Classe que chama o método.
        self.parameters: list[DocClass] = [] # Parâmetros que o método recebe.
        self.returns: list[DocClass] = []    # Valores que o método retorna.


# Classe base para todas as pseudo classe de código.
class CodeClass(DocClass):
    def __init__(self, type: CodeClassType):
        super().__init__()

        self.type = type                         # Tipo da classe.
        self.base_name: str = ""                 # Nome base da classe.
        self.super_name: str = ""                # Nome do super.
        self.inherits: list[str] = []            # Linha de heranças de quem a classe herda.
        self.inherited_by: list[str] = []        # Quem herda da classe.
        self.is_public: bool = True              # Marca se á documentação da classe é pública.
        self.methods: list[CodeClassMethod] = [] # Todos os métodos de classe.
        self.fields: list[DocClass] = []         # Campos de uma classe, usado apenas pelos alias.
        self.type_owner: str = ""                # Nome da CodeClass dona do alias.
        self.is_abstract: bool = False           # Se for abstrata, a API é privada.


# Classe usada na criação de arquivos markdown.
class Markdown():
    def __init__(self, path: str):
        self.path = Path(path)             # Caminho do arquivo.
        self.content_lines: list[str] = [] # Linhas do conteúdo.

    # Altera o caminho do arquivo.
    def new(self, path: str) -> None:
        self.content_lines.clear()
        self.path = Path(path)

    # Escreve o arquivo em seu caminho.
    def write(self) -> None:
        if self.path.exists():
            with open(self.path, "a", encoding="utf-8") as file:
                file.writelines(f"{line}\n" for line in self.content_lines)
        else:
            content = "\n".join(self.content_lines) + "\n"
            self.path.write_text(content, encoding="utf-8")

    def exists(self) -> bool:
        return self.path.exists()

    # Adiciona uma linha ao arquivo.
    def line(self, line: str) -> None:
        self.content_lines.append(line)

    # Adiciona uma linha vazia no final do arquivo caso a última não seja vazia..
    def blank(self) -> None:
        if len(self.content_lines) > 0 and self.content_lines[-1] != "":
            self.content_lines.append("")

#endregion


#region Constants

LIBRARY_PATH: Path = Path("node-ui")
ABSTRACT_CLASSES_PATH: Path = Path(f"{LIBRARY_PATH}/abstract")
NODES_PATH: Path = Path(f"{LIBRARY_PATH}/nodes")
RESOURCES_PATH: Path = Path(f"{LIBRARY_PATH}/resources")
ALIAS_PATH: Path = Path(f"{LIBRARY_PATH}/types")

DOCS_SOURCE_PATH: Path = Path("docs/source")
DOCS_API_PATH: Path = Path(f"{DOCS_SOURCE_PATH}/api")

#endregion


#region Main

# Executa a sequência lógica principal.
def main() -> None:
    code_classes: list[CodeClass] = []

    code_classes.extend(get_code_classes(ABSTRACT_CLASSES_PATH, CodeClassType.RESOURCE, True))
    code_classes.extend(get_code_classes(NODES_PATH, CodeClassType.NODE))
    code_classes.extend(get_code_classes(RESOURCES_PATH, CodeClassType.RESOURCE))
    code_classes.extend(get_code_classes(ALIAS_PATH, CodeClassType.ALIAS))

    code_classes.sort(key=lambda obj: obj.name) # Organiza as CodeClass por ordem alfabética.


    resolve_inheritance(code_classes)
    write_docs(code_classes)
    resolve_files_references()

    print("Documentation Generated!")


# Executa a sequência lógica principal de criação da documentação.
def write_docs(code_classes: list[CodeClass]) -> None:
    # Apaga todos os arquivos relacionados a API, pois são gerados automaticamente.
    if DOCS_API_PATH.exists():
        shutil.rmtree(DOCS_API_PATH)
    DOCS_API_PATH.mkdir(parents=True, exist_ok=True) # Cria o diretório da API.

    write_classes_reference(code_classes)
    write_code_classes(code_classes)


# Retorna todas as CodeClass dos arquivos em path. O parâmetro is_public marca se a documentação das classes é pública ou não.
def get_code_classes(path: Path, class_type: CodeClassType, abstract: bool = False) -> list[CodeClass]:
    code_classes: list[CodeClass] = []

    # Procura todos os arquivos em path.
    for file in path.rglob("*.lua"):
        if file.is_file():
            if class_type == CodeClassType.ALIAS:
                code_classes.extend(parse_code_alias_file(file, abstract))
            else:
                code_class: CodeClass = parse_code_class_file(file, class_type, abstract)
                if code_class:
                    code_classes.append(code_class)

    return code_classes


# Resolve as referências em todos os arquivo da API.
def resolve_files_references() -> str:
    for file in Path(DOCS_API_PATH).rglob("*.md"):
        lines = file.read_text(encoding="utf-8").splitlines(keepends=True)

        for i in range(len(lines)):
            lines[i] = resolve_text_references(lines[i])

        file.write_text("".join(lines), encoding="utf-8")

#endregion


#region Docs Writer

# Escreve o arquivo de referência de classes.
def write_classes_reference(code_classes: list[CodeClass]) -> None:
    node_classes: list[CodeClass] = []
    resource_classes: list[CodeClass] = []
    alias_classes: list[CodeClass] = []

    for code_class in code_classes:
        if code_class.type == CodeClassType.NODE:
            node_classes.append(code_class)
        elif code_class.type == CodeClassType.RESOURCE:
            resource_classes.append(code_class)
        elif code_class.type == CodeClassType.ALIAS:
            alias_classes.append(code_class)

    # Escreve uma toctree no file com as code_classes.
    def write_toctree(title: str, file: Markdown, code_classes: list[CodeClass]):
        file.line(f"## {title}")
        file.blank()

        file.line("```{toctree}")
        file.line(":maxdepth: 1")
        file.blank()

        written_alias_owner: list[str] = []

        for code_class in code_classes:
            if code_class.type_owner in written_alias_owner or code_class.is_abstract:
                continue

            dir: str = None
            if code_class.type == CodeClassType.NODE:
                dir = "nodes"
            elif code_class.type == CodeClassType.RESOURCE:
                dir = "resources"
            elif code_class.type == CodeClassType.ALIAS:
                dir = "types"

            doc_path: str = f"{dir}/{to_snake(code_class.name)}/index"
            if code_class.type == CodeClassType.ALIAS:
                doc_path = f"{dir}/{to_snake(code_class.type_owner)}_types"
                written_alias_owner.append(code_class.type_owner)

            file.line(doc_path)

        file.line("```")
        file.blank()

    file: Markdown = Markdown(f"{DOCS_API_PATH}/index.md")

    file.line("# Referência de Classes")
    file.blank()

    write_toctree("Nodes", file, node_classes)
    write_toctree("Resources", file, resource_classes)
    write_toctree("Types", file, alias_classes)

    file.write()


# Escreve o arquivo de todas as CodeClass em code_classes.
def write_code_classes(code_classes: list[CodeClass]) -> None:
    nodes_path: Path = Path(f"{DOCS_API_PATH}/nodes")
    resources_path: Path = Path(f"{DOCS_API_PATH}/resources")
    types_path: Path = Path(f"{DOCS_API_PATH}/types")

    # Cria os diretórios para cada tipo de CodeClass.
    for path in [nodes_path, resources_path, types_path]:
        path.mkdir()

    for code_class in code_classes:
        path: Path = None
        if code_class.type == CodeClassType.NODE: path = nodes_path
        elif code_class.type == CodeClassType.RESOURCE: path = resources_path
        elif code_class.type == CodeClassType.ALIAS: path = types_path

        if not path:
            continue
        elif code_class.type != CodeClassType.ALIAS:
            path = Path(f"{path}/{to_snake(code_class.name)}")
            path.mkdir()

        if code_class.type == CodeClassType.NODE:
            write_code_class(code_class, path)
        elif code_class.type == CodeClassType.RESOURCE:
            write_code_class(code_class, path)
        elif code_class.type == CodeClassType.ALIAS:
            write_alias_class(code_class)


# Escreve o arquivo da code_class do tipo NODE em path.
def write_code_class(code_class: CodeClass, path: Path) -> None:
    # Escreve a linha de heranças.
    def write_inheritance(file: Markdown, title: str, inheritances: list[str]) -> None:
        if not inheritances:
            return None

        # Referencia cada herança.
        for i in range(len(inheritances)):
            inheritances[i] = create_link_reference(inheritances[i], to_snake(inheritances[i]))

        file.line(f"**{title}:** " + " **→** ".join(inheritances))
        file.blank()

    file: Markdown = Markdown(f"{path}/index.md")

    file.line(create_point_reference(to_snake(code_class.name)))
    file.blank()

    file.line(f"# {code_class.base_name}")
    file.blank()

    write_inheritance(file, "Inherits", code_class.inherits)
    write_inheritance(file, "Inherited By", code_class.inherited_by)
    write_doc_details(file, code_class.brief, code_class.description)
    write_methods_table(file, code_class.methods)
    write_methods(file, code_class.methods)

    file.write()


# Escreve o alias no arquivo referente a seu type_owner.
def write_alias_class(code_class: CodeClass) -> None:
    if code_class.is_abstract:
        return

    file: Markdown = Markdown(f"{DOCS_API_PATH}/types/{to_snake(code_class.type_owner)}_types.md")

    if not file.exists():
        file.line(f"# {code_class.type_owner.split(".", 1)[1]}")
        file.blank()

    file.line(create_point_reference(to_snake(code_class.name)))
    file.line(f"## {code_class.name}")
    file.blank()

    write_doc_details(file, code_class.brief, code_class.description)

    file.line("```{list-table}")
    file.line(":header-rows: 1")
    file.line(":widths: 20 100")

    file.line("* - Valor")
    file.line("  - Descrição")

    for field in code_class.fields:
        file.line(f"* - `{field.name}`")
        file.line(f"  - {field.brief[0]}")

    file.line("```")
    file.blank()

    file.line("---")
    file.blank()

    file.write()


# Escreve os CodeClassMethod de methods em methods.
def write_methods(file: Markdown, methods: list[CodeClassMethod]) -> None:
    if not methods:
        return

    file.line("## Descrição dos Métodos")
    file.blank()

    for method in methods:
        return_names: list[str] = [method_return.name for method_return in method.returns]
        parameters_names: list[str] = [parameter.name.replace("?", "") for parameter in method.parameters]

        file.line(create_point_reference(f"{to_snake(method.caller)}_{to_snake(method.name)}"))

        file.line(f"### **<span style='font-family: monospace;'>{method.name}()</span>**")
        file.blank()

        write_doc_details(file, method.brief, method.description)

        file.line("```lua")
        file.line(f"{" ,".join(return_names)}{" = " if return_names else ""}{method.caller}:{method.name}({", ".join(parameters_names)})")
        file.line("```")
        file.blank()

        if method.parameters:
            file.line("**Argumentos**")
            file.blank()

            file.line("```{list-table}")
            file.line(":header-rows: 1")
            file.line(":widths: 30 30 100")
            file.blank()

            file.line("* - Nome")
            file.line("  - Tipo")
            file.line("  - Descrição")

            for parameter in method.parameters:
                file.line(f"* - {parameter.name.replace("?", "")}")
                file.line(f"  - `{parameter.brief[0]}`")
                file.line(f"  - {parameter.description[0]}")

            file.line("```")

        file.blank()

        if method.returns:
            file.line("**Retornos**")
            file.blank

            file.line("```{list-table}")
            file.line(":header-rows: 1")
            file.line(":widths: 30 30 100")
            file.blank()

            file.line("* - Nome")
            file.line("  - Tipo")
            file.line("  - Descrição")

            for method_return in method.returns:
                file.line(f"* - {method_return.name.replace("?", "")}")
                file.line(f"  - `{method_return.brief[0]}`")
                file.line(f"  - {method_return.description[0]}")

            file.line("```")

        file.blank()

        file.line("---")
        file.blank()

    file.blank()


# Escreve uma tabela dos methods no file.
def write_methods_table(file: Markdown, methods: list[CodeClassMethod]) -> None:
    file.line("## Métodos")
    file.blank()

    file.line("```{list-table}")
    file.line(":header-rows: 1")
    file.line(":widths: 10 100")
    file.blank()

    file.line("* - Tipo")
    file.line("  - Nome")

    for method in methods:
        return_types: list[str] = []
        for method_return in method.returns:
            return_types.append(f"`{method_return.brief[0]}`")

        file.line(f"* - {", ".join(return_types or ["`nil`"])}")
        file.line(f"  - {create_link_reference(method.name, f"{to_snake(method.caller)}_{to_snake(method.name)}")}")

    file.line("```")
    file.blank()


# Escreve a brief e description no file.
def write_doc_details(file: Markdown, brief: list[str], description: list[str]) -> None:
    # Escreve as linhas do brief.
    for line in brief:
        file.line(line)
    file.blank()

    # Escreve as linhas da descrição.
    for line in description:
        file.line(line)
    file.blank()

#endregion


#region File Parsers

# Analisa um arquivo de classe e retorna a CodeClass referente a ele.
def parse_code_class_file(file: Path, class_type: CodeClassType, abstract: bool = False) -> CodeClass:
    if class_type == CodeClassType.ALIAS:
        return None

    code_class: CodeClass = CodeClass(class_type)
    code_class.is_abstract = abstract

    lines: list[str] = file.read_text(encoding="utf-8").splitlines()

    # Analísa cada linha do file.
    for line_number, line in enumerate(lines):
        # Preenche os dados gerais da code_class.
        if line.startswith("--- @class"):
            code_class.name, code_class.super_name = extract_class_line(line)
            code_class.base_name = code_class.name.split(".")[-1]
            code_class.brief, code_class.description = parse_general_docs_details(lines, line_number)

        # Adiciona a CodeClassMethod da linha na code_class.
        elif line.startswith("function"):
            code_class_method: CodeClassMethod = parse_code_class_method(lines, line_number)
            if code_class_method:
                code_class.methods.append(code_class_method)

    code_class.methods.sort(key=lambda obj: obj.name)
    return None if code_class.name == "" else code_class


# Analisa um arquivo de alias e retorna a CodeClass de todas as alias referente a ele.
def parse_code_alias_file(file: Path, abstract: bool = False) -> list[CodeClass]:
    code_alias_classes: list[CodeClass] = []
    current_code_alias: CodeClass = None

    lines: list[str] = file.read_text(encoding="utf-8").splitlines()

    # Analísa cada linha do file.
    for line_number, line in enumerate(lines):
        # Preenche os dados gerais da alias.
        if line.startswith("--- @alias"):
            current_code_alias = CodeClass(CodeClassType.ALIAS)
            current_code_alias.is_abstract = abstract

            current_code_alias.name = line.replace("--- @alias ", "")
            current_code_alias.brief, current_code_alias.description = parse_general_docs_details(lines, line_number)
            current_code_alias.type_owner = current_code_alias.name.rsplit(".", 1)[0]

            code_alias_classes.append(current_code_alias)

        # Preenche os campos da alias.
        elif line.startswith("--- |"):
            match = re.match(r'---\s*\|\s*"([^"]+)"\s*(.*)', line)
            if match:
                alias_field: DocClass = DocClass()

                alias_field.name = match.group(1)
                alias_field.brief.append(match.group(2).strip())

                current_code_alias.fields.append(alias_field)

            elif current_code_alias.super_name == "":
                current_code_alias.super_name = line.replace("--- | ", "")

    return code_alias_classes


# Retorna o CodeClassMethod referente a start_line.
def parse_code_class_method(lines: list[str], start_line: int) -> CodeClassMethod:
    code_class_method: CodeClassMethod = CodeClassMethod()
    above_lines: list[str] = []

    # Adiciona todas as linhas acima de start_line em above_lines.
    for line_number in range(start_line - 1, -1, -1):
        line = lines[line_number]

        if line.startswith("--- @"):
            # Se tiver a anotação de protegido ou privado, retorna None, pois o método não deve ser documentado.
            if re.search(r"@(protected|private)", line):
                return None
            above_lines.insert(0, line)

        # Se começar apenas com ---, significa que começou os detalhes da documentação do método.
        elif line.startswith("---"):
            code_class_method.brief, code_class_method.description = parse_general_docs_details(lines, line_number)
            break

        # Se a linha for vazia, significa que a documentação do método acabou.
        elif line == "":
            break

    method_line: str = lines[start_line]
    caller_name, method_name = extract_method_line(method_line)

    code_class_method.name = method_name
    code_class_method.caller = caller_name

    # Se o caller_name não existir, este método não precisa ser documentado.
    if caller_name == "":
        return None

    # Percorre as linhas acima do método em busca de seus parâmetros e retornos.
    for line in above_lines:
        # Adiciona o parâmetro referente a linha.
        if line.startswith("--- @param"):
            parameter: DocClass = extract_parameter_line(line)
            if parameter:
                code_class_method.parameters.append(parameter)

        # Adiciona o retorno referente a linha.
        elif line.startswith("--- @return"):
            method_return: DocClass = extract_return_line(line)
            if method_return:
                code_class_method.returns.append(method_return)

    return code_class_method

#endregion


#region Docs Parsers

# Analisa e retorna os detalhes da documentação de uma classe, função ou alias.
# Retorna o brief e description, que são procurados a partir da start_line em lines.
def parse_general_docs_details(lines: list[str], start_line: int) -> tuple[list[str], list[str]]:
    docs_lines: list[str] = [] # Linhas com detalhes da documentação.

    # Percorre cada linha a partir de start_line em busca de linhas de documentação, as que começam com "---".
    for i in range(start_line, -1, -1):
        line = lines[i]

        # Se a linha começa com "--- @", deve ser ignorada, pois não representa uma documentação geral.
        if line.startswith("--- @"):
            continue

        # Se a linha não começa com "---" significa que acabou as linhas da documentação.
        elif not line.startswith("---"):
            break

        line_content: str = line[3:].strip() or "" # Extrai o conteúdo da linha, caso não haja, será uma string vazia.
        docs_lines.insert(0, line_content)         # Salva o conteúdo da linha.

    brief: list[str] = []  # Breve descrição.
    description: list = [] # Descrição detalhada.
    on_brief: bool = True  # Marca se está percorrendo o brief da documentação.

    # Percorre as linhas de documentação em busca de seu conteúdo e o salva em brief ou description.
    for line in docs_lines:
        # Verifica se ainda está no brief ou não. A primeira linha vazia marca o fim do brief.
        if line == "":
            if on_brief:
                on_brief = False
                continue

        if on_brief:
            brief.append(line)
        else:
            description.append(line)

    return brief, description

#endregion


#region Line Extractors

# Em uma linha começada com "--- @class", extrai o nome da classe e seu super.
def extract_class_line(line: str) -> tuple[str, str]:
    pattern: str = r"---\s*@class\s+([A-Za-z_][\w\.]*)\s*:\s*([A-Za-z_][\w\.]*)"
    match = re.search(pattern, line)

    if match:
        class_name = match.group(1) or ""
        super_name = match.group(2) or ""

        # Ignora o super com nome "Class", pois é uma classe interna da biblioteca e não deve estar visível na documentação.
        if super_name == "Class": super_name = ""

        return class_name, super_name

    return "", ""


# Em uma linha começada com "function", extrai o caller e o nome do método.
def extract_method_line(line: str) -> tuple[str, str]:
    match = re.match(r"^function\s+([\w\.]+)(?::|\.)(\w+)\s*\(", line)
    if not match:
        return "", ""

    caller_name: str = match.group(1)
    method_name: str = match.group(2)

    return caller_name, method_name


# Em uma linha começada com "--- @param", extrai o nome, tipo e brief do parâmetro e os retorna em uma DocClass.
def extract_parameter_line(line: str) -> DocClass:
    line = line.strip()

    match = re.match(r"---\s*@param\s+(.+)", line)
    if not match:
        return None

    text: str = match.group(1).strip()
    name, type, brief = split_type_and_brief(text)
    parameter: DocClass = DocClass()

    # O tipo é salvo no campo brief e o brief é salvo no campo description para evitar criar uma nova classe dedicada.
    parameter.name = name
    parameter.brief.append(type)
    parameter.description.append(brief)

    return parameter


# Em uma linha começada com "--- @return", extrai o tipo, nome e brief do retorno e os retorna em uma DocClass.
def extract_return_line(line: str) -> DocClass:
    line = line.strip()

    match = re.match(r"---\s*@return\s+(.+)", line)
    if not match:
        return None

    text: str = match.group(1).strip()
    type, name, brief = split_type_and_brief(text)
    method_return: DocClass = DocClass()


    # O tipo é salvo no campo brief e o brief é salvo no campo description para evitar criar uma nova classe dedicada.
    method_return.name = name
    method_return.brief.append(type)
    method_return.description.append(brief)

    return method_return


# Extrai tudo entre **``**.
def extract_backticked_bold(text: str) -> list[str]:
    return re.findall(r"\*\*`([^`]+)`\*\*", text)


# Extrai tudo entre ``.
def extract_backticked(text: str) -> list[str]:
    return re.findall(r"`([^`]+)`", text)

#endregion


#region Helpers

# Define as heranças das CodeClass em code_classes. São preenchidos os campos inherits e inherited_by de cada classe.
# Se o nome de uma CodeClass nas heranças estiver entre **, significa que sua documentação não é pública.
def resolve_inheritance(code_classes: list[CodeClass]) -> None:
    class_map: dict[str, CodeClass] = {
        code_class.name: code_class
        for code_class in code_classes
    }

    visiting: set[str] = set()

    # Resolve as heranças de uma CodeClass, com exceção das alias.
    def resolve(code_class: CodeClass) -> None:
        if code_class.name in visiting:
            raise RuntimeError(
                f"Herança circular detectada: {code_class.name}"
            )

        if code_class.inherits:
            return

        if code_class.super_name == "":
            return

        parent = class_map.get(code_class.super_name)

        if parent is None:
            return

        visiting.add(code_class.name)

        resolve(parent)


        # NOTE: Nome de CodeClass que não são abstratas, ficam entre **.
        code_class.inherits.append(parent.name if not parent.is_abstract else f"**{parent.name}**")
        code_class.inherits.extend(parent.inherits)

        visiting.remove(code_class.name)

    # Resolve as heranças de uma alias.
    def resolve_alias(code_class: CodeClass) -> None:
        if code_class.name in visiting:
            raise RuntimeError(
                f"Herança circular detectada: {code_class.name}"
            )

        if code_class.super_name == "":
            return

        parent = class_map.get(code_class.super_name)

        if parent is None:
            return

        visiting.add(code_class.name)

        resolve_alias(parent)

        code_class.fields[:0] = parent.fields
        code_class.super_name = ""

        visiting.remove(code_class.name)

    # Resolve ancestrais.
    for code_class in code_classes:
        if code_class.type == CodeClassType.ALIAS:
            resolve_alias(code_class)
        else:
            resolve(code_class)

    # Resolve descendentes.
    for code_class in code_classes:
        for ancestor_name in code_class.inherits:
            # Remove os asteriscos de formatação para encontrar a classe real no mapa
            clean_ancestor_name = ancestor_name.strip("*")

            ancestor = class_map.get(clean_ancestor_name)

            if ancestor is not None:
                ancestor.inherited_by.append(code_class.name)


# Resolve as referências de um texto e o retorna resolvido.
def resolve_text_references(text: str) -> str:
    for name in extract_backticked_bold(text):
        point: str = to_snake(name)
        if point != "node_ui" and not "node_ui" in point:
            point = f"node_ui_{point}"

        if point in _references_points:
            text = text.replace(
                f"**`{name}`**",
                create_link_reference(name, point)
            )

    for name in extract_backticked(text):
        clean_name: str = name.replace(":", "_")
        clean_name = clean_name.replace("()", "")
        clean_name = clean_name.replace("NodeUI.", "")

        point: str = to_snake(clean_name)

        if point in _references_points:
            text = text.replace(
                f"`{name}`",
                create_link_reference(name, point)
            )

    return text


# Separa o identificador (nome) do tipo, o tipo e o brief do tipo.
def split_type_and_brief(text: str) -> tuple[str, str, str]:
    complex_base = r"(?:\.\.\.|\[[^\]]+\]|\w+\([^)]*\)(?:\s*:\s*[\w\.<>\[\]]+)?|\w+(?:\.\w+)*(?:<[^>]+>)?(?:\[\])*)\??"
    simple_base = r"\w+\??"

    complex_type_pattern = rf"{complex_base}(?:\s*\|\s*{complex_base})*"
    simple_type_pattern = rf"{simple_base}(?:\s*\|\s*{simple_base})*"

    pattern_A = rf"^({simple_type_pattern})\s+({complex_type_pattern})\s+(.*)$"
    pattern_B = rf"^({complex_type_pattern})\s+({simple_type_pattern})\s+(.*)$"

    match_A = re.match(pattern_A, text)
    if match_A:
        tipo = match_A.group(1)
        nome = match_A.group(2)
        brief = match_A.group(3)
        return tipo, nome, brief

    match_B = re.match(pattern_B, text)
    if match_B:
        tipo = match_B.group(1)
        nome = match_B.group(2)
        brief = match_B.group(3)
        return tipo, nome, brief

    return "", "", text


# Converte o nome de uma CodeClass para snake_case.
def to_snake(name: str) -> str:
    # troca ponto por underscore primeiro
    name = name.replace(".", "_")

    # separa siglas + palavras normais
    name = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", name)
    name = re.sub(r"([A-Z]+)([A-Z][a-z])", r"\1_\2", name)

    return name.lower()


# Cria um link a uma referência no estilo "{ref}`text <link>`".
def create_link_reference(text: str, link: str) -> str:
    return "{0}`{1} <{2}>`".format("{ref}", text, link)


# Cria um ponto de referência.
def create_point_reference(point: str) -> str:
    _references_points.append(point)
    return f"({point})="

#endregion


main()
