# Sistema de Biblioteca

## Descrição

Este projeto foi desenvolvido como trabalho final da disciplina de Programação Web. O sistema foi implementado em Ruby on Rails e possui funcionalidades de login, com diferentes permissões para administradores e usuários comuns.

## Funcionalidades

- **Login**: Permite o login de usuários e administradores.
- **Gerenciamento pelo Administrador**: O administrador pode realizar o CRUD (criar, ler, atualizar e deletar) para:
  - **Carteirinhas**
  - **Pessoas**
  - **Autores**
  - **Livros**
- **Relações**: Implementa relações 1:1, 1:N e N:N entre as entidades.

## Instruções para Execução

Para rodar os testes:

```bash
rake test
```

Para rodar o servidor localmente:
```
rails server
```
