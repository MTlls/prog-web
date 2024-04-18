# Trabalho 2 (Ruby): Banco de Dados usando ActiveRecord

## Informações Gerais

O presente trabalho é um banco de dados pequeno criado para a matéria de Programação Web. Ele consiste em uma biblioteca no qual as pessoas emprestam e devolvem livros.

### Como popular o banco de dados

O seguinte comando cria as tabelas e o popula, é interessante usar o shell script `./criaDB.sh` pois caso exista o banco de dados da bibioteca, ele o exclui.

    ./removeDB.sh && ./criaDB.sh && ./popula.sh

### Tabelas
Para os comandos funcionarem precisamos saber quais são as tabelas. Portanto temos as tabelas:

`pessoas`,`livros`, `carteirinhas`, `autores`, `carteirinhasLivros`

Os campos de cada um são


    Pessoas: nome, cpf, email, telefone, endereco

    Livros:  titulo, ano, genero, quantidade, emprestados, autor

    Autores: nome, nacionalidade

    Carteirinhas: pessoa, podeEmprestar 

    CarteirinhasLivros: carteirinha, livro

## Utilização 
Os comandos funcionam da seguinte manteira

    ./alteraTabelas.sh <operação> <tabela> { atributo = valor }

No qual `./alteraTabelas.sh` é o arquivo pelo qual fazemos as alterações

E `<operacao>` pode ser `insere` `atualiza` `exclui` `lista`

E `<tabela>` pode ser `pessoas`,`livros`, `carteirinhas`, `autores`, `carteirinhasLivros`

### Exemplo 1
Aqui está o exemplo de um comando

    ./alteraTabelas.sh insere pessoas endereco="Rua das Flores, 123" cpf="12345673901" email="joao@example.com" telefone="5512345678" nome="João da Silva"

Após este comando a tabela `pessoas` fica assim

| nome         | cpf          | email            | telefone   | endereco              |
|--------------|--------------|------------------|------------|-----------------------|
| João da Silva| 12345673901  | joao@example.com | 5512345678 | Rua das Flores, 123   |

### Exemplo 2
Como a exclusão respeita as chaves estrangeiras (eu espero), temos casos como esse:

Suponha um banco de dados populado desta maneira(omitimos a tabela pessoa):

#### Tabela Livros

| ID | Título             | Ano | Gênero     | Quantidade | Emprestados | Autor       |
|----|--------------------|-----|------------|------------|-------------|-------------|
| 1  | Dom Casmurro        | 1899 | Romance    | 10         | 1           | Machado de Assis |
| 2  | Memórias Póstumas de Brás Cubas | 1881 | Romance | 8          | 1           | Machado de Assis |
| 3  | Grande Sertão: Veredas | 1956 | Romance | 5          | 1           | João Guimarães Rosa |
| 4  | Capitães da Areia  | 1937 | Romance | 7          | 0           | Jorge Amado |
| 5  | O Cortiço         | 1890 | Romance    | 6          | 4           | Aluísio Azevedo |

#### Tabela Carteirinhas
| ID | Pessoa           | Pode Emprestar | Livros Emprestados |
|----|------------------|----------------|--------------------|
| 1  | João da Silva    | Sim            | 3                  |
| 2  | Maria Souza      | Sim            | 1                  |
| 3  | Pedro Santos     | Não            | 0                  |

#### Tabela CarteirinhasLivros
| Carteirinha | Livro |
|-------------|-------|
| João da Silva | Dom Casmurro |
| João da Silva | Memórias Póstumas de Brás Cubas |
| João da Silva | Grande Sertão: Veredas |
| Maria Souza | Capitães da Areia |

Dada as tabelas, o seguinte comando é realizado

    ./alteraTabelas.sh exclui pessoas nome="João da Silva"

O que ocorre é a exclusão da carteirinha e dos empréstimos

#### Tabela Carteirinhas
| ID | Pessoa           | Pode Emprestar | Livros Emprestados |
|----|------------------|----------------|--------------------|
| 2  | Maria Souza      | Sim            | 1                  |
| 3  | Pedro Santos     | Não            | 0                  |

#### Tabela CarteirinhaLivros após a exclusão
| Carteirinha | Livro |
|-------------|-------|
| Maria Souza | Capitães da Areia |


### Exemplo 3
Também é possível realizar comandos com a tabela ``carteirinhasLivros``. Pode-se interpretar como empréstimos e devoluções, além de verificar quais livros estão emprestados por carteirinha ou quais carteirinhas emprestaram determinado livro.
Por exemplo, usemos as mesmas tabelas [Tabela Livros](#tabela-livros), [Tabela CarteirinhasLivros](#tabela-carteirinhaslivros) e [Tabela Carteirinhas](#tabela-carteirinhas).

usando os comandos:

    ./alteraTabelas.sh insere carteirinhasLivros carteirinha_id="3" livro_id="1"
    
    ./alteraTabelas.sh insere carteirinhasLivros carteirinha_id="3" livro_id="5"

A tabela ``carteirinhasLivros`` agora estará assim:

#### Tabela CarteirinhaLivros após as inserções
| Carteirinha | Livro |
|-------------|-------|
| Maria Souza | Capitães da Areia |
| Pedro Santos | Dom Casmurro |
| Pedro Santos | O Cortiço |

Como é um relacionamento *belongs_to_many* entre as carteirinhas e os livros, haverá uma chave estrangeira em cada tabela. Mantendo a integridade do banco de dados.

## Relacionamentos
    Temos três relacionamentos aqui:

### Um para um
O caso 1 para 1 está presente no relacionamento entre as tabelas `pessoas` e `carteirinhas`.

Apenas uma **pessoa** pode ter apenas uma **carteirinha** e uma **carteirinha** pode ser de apenas uma **pessoa**. <ins>Foi criada uma restrição na qual é impossível criar uma carteirinha sem ser vinculada a uma pessoa (não faria sentido haver uma carteirinha de ninguém).</ins>

### Um para muitos
Este relacionamento está presente entre as tabelas `livros` e `autores`. 

Um **livro** pertence à apenas um **autor** e um **autor** têm vários **livros**.

### Muitos para muitos
Este relacionamento está presente entre as tabelas `livros` e `carteirinhas`, criando uma tabela `carteirinhasLivros`, no qual associa os empréstimos.

Um **livro** pode ser emprestado por várias pessoas com **carteirinha** (dependendo da quantidade dos livros desse título), e uma **carteirinha** pode emprestar vários **livros**

Podemos interpretar a tabela `carteirinhasLivros` como uma tabela de empréstimos, no qual nos informa quais livros foram emprestados. Cada instância na tabela ``livros`` pode se associar à várias carteirinhas e cada instância na tabela ``carteirinhas`` pode se associar à vários livros.

# Observações

## Inserir nova carteirinha
Para inserir uma nova carteirinha, você precisa apenas do "id" da pessoa. Por exemplo:

    ./alteraTabelas.sh insere carteirinhas pessoa_id="1"

Isso irá criar uma nova carteirinha associada à pessoa com "id" igual a 1.

## Realizar empréstimo / inserir na tabela CarteirinhasLivros
Para realizar um empréstimo, você precisa do "id" do livro e do "id" da carteirinha. Por exemplo:

    ./alteraTabelas.sh insere carteirinhasLivros carteirinha_id="1" livro_id="2"

Isso irá associar o livro com "id" igual a 2 à carteirinha com "id" igual a 1, indicando que o livro foi emprestado.

Lembre-se de substituir os valores "1" e "2" pelos "ids" corretos das pessoas e dos livros que você deseja utilizar.

## Listagem

Não foi realizada a listagem para um único elemento, ele sempre retorna toda a tabela (tirando no caso da tabela carteirinhasLivros).