# Template dos tutoriais

1. Realizar um fork do repositório
1. Clonar esse repositório
1. Instalar dependências 
1. Editar arquivo `docs-src/index.md`
1. Testar com mkdocs

## Instalar dependências 

O site da disciplina faz uso do mkdocs com o tema material, para instalar, execute no bash:

``` sh
pip install -r requirements.txt
```

## Exemplo

O arquivo `docs-src/index.md` possui exemplos de estruturas que podem ser utilizadas no tutorial, mais podem ser encontradas em:

- https://squidfunk.github.io/mkdocs-material/reference/formatting/

Para visualizar o exemplo, acesse:

- https://insper.github.io/Embarcados-Avancados-Template/

## Testando

Para testar abra o terminal na raiz desse repositório e digite:

``` sh
mkdocs serve
```

Agora você pode acessar a página: https://localhost:8000 para verificar o resultado.

## Deploy github


