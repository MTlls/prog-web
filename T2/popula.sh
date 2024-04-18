#!/bin/bash

# Populando a tabela pessoas
./alteraTabelas.sh insere pessoas nome="João da Silva" cpf="12345673901" email="joao@example.com" telefone="5512345678" endereco="Rua das Flores, 123"
./alteraTabelas.sh insere pessoas nome="Maria Souza" cpf="12345673902" email="maria@example.com" telefone="5512345679" endereco="Rua das Rosas, 456"
./alteraTabelas.sh insere pessoas nome="Pedro Santos" cpf="12345673903" email="pedro@example.com" telefone="5512345670" endereco="Rua das Margaridas, 789"

echo

# Imprime a tabela pessoas
./alteraTabelas.sh lista pessoas

# Populando a tabela autores
./alteraTabelas.sh insere autores nome="Machado de Assis" nacionalidade="Brasileiro"
./alteraTabelas.sh insere autores nome="João Guimarães Rosa" nacionalidade="Brasileiro"
./alteraTabelas.sh insere autores nome="Jorge Amado" nacionalidade="Brasileiro"
./alteraTabelas.sh insere autores nome="Aluísio Azevedo" nacionalidade="Brasileiro"

echo

# Imrpime a tabela autores
./alteraTabelas.sh lista autores

echo

# Populando a tabela livros
./alteraTabelas.sh insere livros id=1 titulo="Dom Casmurro" ano=1899 genero="Romance" quantidade=10 autor="Machado de Assis"
./alteraTabelas.sh insere livros id=2 titulo="Memórias Póstumas de Brás Cubas" ano=1881 genero="Romance" quantidade=8 autor="Machado de Assis"
./alteraTabelas.sh insere livros id=3 titulo="Grande Sertão: Veredas" ano=1956 genero="Romance" quantidade=5 autor="João Guimarães Rosa"
./alteraTabelas.sh insere livros id=4 titulo="Capitães da Areia" ano=1937 genero="Romance" quantidade=7 autor="Jorge Amado"
./alteraTabelas.sh insere livros id=5 titulo="O Cortiço" ano=1890 genero="Romance" quantidade=6 autor="Aluísio Azevedo"

echo

# Imprime a tabela livros
./alteraTabelas.sh lista livros

echo

# Populando a tabela carteirinhas
./alteraTabelas.sh insere carteirinhas id=1 pessoa="João da Silva" "pode emprestar"=sim "livros emprestados"=3
./alteraTabelas.sh insere carteirinhas id=2 pessoa="Maria Souza" "pode emprestar"=sim "livros emprestados"=1
./alteraTabelas.sh insere carteirinhas id=3 pessoa="Pedro Santos" "pode emprestar"=nao "livros emprestados"=0

echo

# Imprime a tabela carteirinhas
./alteraTabelas.sh lista carteirinhas

echo

# Populando a tabela carteirinhasLivros
./alteraTabelas.sh insere carteirinhasLivros carteirinha_id=1 livro_id=1
./alteraTabelas.sh insere carteirinhasLivros carteirinha_id=1 livro_id=2
./alteraTabelas.sh insere carteirinhasLivros carteirinha_id=1 livro_id=3
./alteraTabelas.sh insere carteirinhasLivros carteirinha_id=2 livro_id=4

echo

# Imprime a tabela carteirinhasLivros
./alteraTabelas.sh lista carteirinhasLivros